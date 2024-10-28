import UIKit
import BackgroundTasks

protocol IAppBackgroundTaskManager {
    func forceUpdateBlackList()
    func forceUpdateQuarantine()
    func forceUpdateAll()
}

final class AppBackgroundTaskManager: IAppBackgroundTaskManager {

    // MARK: - Properties

    private var taskIdentifier: String? {
        if let list = Bundle.main.infoDictionary?["BGTaskSchedulerPermittedIdentifiers"] as? [String] {
            return list.first
        }
        return nil
    }

    private let service: AppBackgroundRefreshServiceProcotol
    private let dataStore = DataStore()
    private var isInForeground = false
    private var limitOffSet: Int {
        return isInForeground ? 500 : 100
    }

    private let notificationsName: [Notification.Name] = [
        UIApplication.didEnterBackgroundNotification,
        UIApplication.willTerminateNotification,
        UIApplication.didBecomeActiveNotification
    ]

    // MARK: - Init

    init(service: AppBackgroundRefreshServiceProcotol) {
        self.service = service
        guard let taskIdentifier = taskIdentifier else {
            return
        }
        print("Registering: \(taskIdentifier)")
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskIdentifier,
                                        using: nil) { [weak self] bgTask in
            self?.handleTask(bgTask)
        }

        scheduleTask(identifier: taskIdentifier)
        createNotification()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func createNotification() {
        notificationsName.forEach { name in
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(receiveNotification(_:)),
                                                   name: name,
                                                   object: nil)
        }
    }

    @objc private func receiveNotification(_ notif: Notification) {
        print("Received:", notif.name)
        isInForeground = notif.name == UIApplication.didBecomeActiveNotification

        switch notif.name {
        case UIApplication.didEnterBackgroundNotification, 
            UIApplication.willTerminateNotification,
            UIApplication.didBecomeActiveNotification:
            forceUpdateAll()
        default:
            break
        }
    }

    private func scheduleTask(identifier: String) {
        let taskRequest = BGAppRefreshTaskRequest(identifier: identifier)
#if DEBUG
        taskRequest.earliestBeginDate = Date(timeIntervalSinceNow: 60)
#else
        taskRequest.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
#endif

        do {
            try BGTaskScheduler.shared.submit(taskRequest)
        } catch let error as BGTaskScheduler.Error {
            switch error.code {
            case .notPermitted:
                print("notPermitted")
            case .unavailable:
                print("unavailable")
            case .tooManyPendingTaskRequests:
                print("tooManyPendingTaskRequests")
            @unknown default:
                print("Desconhecido")
            }

        } catch {
            print(error.localizedDescription)
        }
    }

    func forceUpdateBlackList() {
        updateBlackList { success in
            if success { AppCallDirectoryProvider.shared.reloadCallDirectory() }
        }
    }

    func forceUpdateQuarantine() {
        updateQuarantine { success in
            if success { AppCallDirectoryProvider.shared.reloadCallDirectory() }
        }
    }

    func forceUpdateAll() {
        updateAll { success in
            if success { AppCallDirectoryProvider.shared.reloadCallDirectory() }
        }
    }

    // MARK: - Private

    private func handleTask(_ task: BGTask) {
        print(task)

        scheduleTask(identifier: task.identifier)

        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }

        updateAll { success in
            task.setTaskCompleted(success: success)
        }
    }

    private func updateAll(completion: ((Bool) -> Void)? = nil) {
        let operationQueue = OperationQueue()
        let dispatchGroup = DispatchGroup()

        var result: Bool?
        let blockResult: (Bool) -> Void = { success in
            guard let oldResult = result else {
                result = success
                return
            }
            result = success || oldResult
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        operationQueue.addOperation { [weak self] in
            self?.updateBlackList { success in
                blockResult(success)
            }
        }

        dispatchGroup.enter()
        operationQueue.addOperation { [weak self] in
            self?.updateQuarantine { success in
                blockResult(success)
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion?(result ?? false)
        }
    }

    private func updateBlackList(completion: ((Bool) -> Void)? = nil) {
        Task {
            do {
                let result: [BlackListData]? = try await dataStore.fetch(sortDescriptors: BlackListData.ascendingdateSortDescriptor(),
                                                                         context: dataStore.backgroundContext)

                let lastIndex = result?.last?.id ?? .zero

                service.fetchBlackList(lastIndex: lastIndex,
                                       limit: limitOffSet) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let list):
                        let response = self.persistBlackList(list: list)
                        completion?(response)

                    case .failure:
                        completion?(false)
                    }
                }
            }
        }
    }

    private func persistBlackList(list: [BlackListAndReportResponse]) -> Bool {
        if list.isEmpty { return false }

        _ = list.map { [weak self] item in
            guard let self = self else { return }
            let quarantine = BlackListData(context: self.dataStore.backgroundContext)
            quarantine.id = Int64(item.id)
            quarantine.date = Date()
            quarantine.number = Int64(item.number) ?? .zero
        }
        do {
            try self.dataStore.save(context: dataStore.backgroundContext)

            return true
        } catch {
            return false
        }
    }

    private func updateQuarantine(completion: ((Bool) -> Void)? = nil) {
        Task {
            do {
                let result: [QuarantineData]? = try await dataStore.fetch(sortDescriptors: QuarantineData.ascendingdateSortDescriptor(),
                                                                          context: dataStore.backgroundContext)

                let lastIndex = result?.last?.id ?? .zero

                service.fetchQuarantine(lastIndex: lastIndex,
                                        limit: limitOffSet) { [weak self] result in
                    switch result {
                    case .success(let list):
                        let response = self?.persistQuarantine(list: list) ?? false
                        completion?(response)

                    case .failure:
                        completion?(false)
                    }
                }
            }
        }
    }

    private func persistQuarantine(list: [BlackListAndReportResponse]) -> Bool {
        if list.isEmpty { return false }

        _ = list.map { [weak self] item in
            guard let self = self else { return }
            let quarantine = QuarantineData(context: self.dataStore.backgroundContext)
            quarantine.id = Int64(item.id)
            quarantine.date = Date()
            quarantine.descrip = item.description ?? "-"
            quarantine.number = Int64(item.number) ?? .zero
        }
        do {
            try self.dataStore.save(context: dataStore.backgroundContext)

            return true
        } catch {
            return false
        }
    }
}
