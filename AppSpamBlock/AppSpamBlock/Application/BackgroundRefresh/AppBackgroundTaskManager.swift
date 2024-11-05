import UIKit
import CoreData
import BackgroundTasks

protocol IAppBackgroundTaskManager {
    func forceUpdateAll()
}

extension Notification.Name {
    static let didStartDatabaseRefreshing = Notification.Name("AppBackgroundTaskManager.didStartDatabaseRefreshing")
    static let didStopDatabaseRefreshing = Notification.Name("AppBackgroundTaskManager.didStopDatabaseRefreshing")
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
    private let dataStore: IDataStore
    private let _24hoursSecond = TimeInterval(60 * 60 * 240)

    private var isInForeground = false
    private var isRefreshing = false {
        didSet {
            guard isRefreshing else {
                NotificationCenter.default.post(name: .didStopDatabaseRefreshing, object: nil)
                return
            }
            NotificationCenter.default.post(name: .didStartDatabaseRefreshing, object: nil)
        }
    }
    private var limitOffSet: Int {
        return isInForeground ? 1500 : 100
    }

    private let notificationsName: [Notification.Name] = [
        UIApplication.didEnterBackgroundNotification,
        UIApplication.willTerminateNotification,
        UIApplication.didBecomeActiveNotification
    ]

    // MARK: - Init

    init(service: AppBackgroundRefreshServiceProcotol, dataStore: IDataStore) {
        self.dataStore = dataStore
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
        taskRequest.earliestBeginDate = Date(timeIntervalSinceNow: _24hoursSecond)

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


    func forceUpdateAll() {
        updateAll { [weak self] success in
            self?.reloadCallDirectoriesIfNeeded(isIncrementalAPIData: success)
        }
    }

    private func reloadCallDirectoriesIfNeeded(isIncrementalAPIData: Bool) {
        Task {
            let appSystem = try await AppData.fetchData(dataStore: dataStore)
            let currentDate = Date()
            let lastUpdateQuarantine = appSystem?.lastUpdateQuarantine ?? currentDate
            let nextUpdateDate = lastUpdateQuarantine == currentDate
            ? currentDate : lastUpdateQuarantine.addingTimeInterval(TimeInterval(_24hoursSecond))
            print("Data Atual: \(currentDate): próxima atualizacao: \(nextUpdateDate)")

            guard currentDate >= nextUpdateDate else {
                return
            }

            let shouldUpdateCall = await shouldUpdateCallDirectory()

            if !isIncrementalAPIData && !shouldUpdateCall {
                return
            }

            AppCallDirectoryProvider.shared.reloadCallDirectory()
        }
    }

    private func shouldUpdateCallDirectory() async ->  Bool {
        let result = try? await ContactQuarantineData.fetchPendingSyncData(dataStore: dataStore,
                                                                           context: dataStore.backgroundContext,
                                                                           fetchLimit: 1)

        return (result?.count ?? .zero) > .zero
    }

    // MARK: - Private

    private func handleTask(_ task: BGTask) {
        scheduleTask(identifier: task.identifier)

        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }

        updateAll { success in
            task.setTaskCompleted(success: success)
        }
    }

    private func updateAll(completion: ((Bool) -> Void)? = nil) {
        guard !isRefreshing else {
            return
        }
        isRefreshing = true
        let operationQueue = OperationQueue()
        let dispatchGroup = DispatchGroup()

        var result: Bool?
        let blockResult: (Bool) -> Void = { success in
            guard let oldResult = result else {
                result = success
                dispatchGroup.leave()
                return
            }
            result = success || oldResult
            dispatchGroup.leave()
        }

        dispatchGroup.enter()
        operationQueue.addOperation { [weak self] in
            self?.updateQuarantine { success in
                blockResult(success)
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.isRefreshing = false
            completion?(result ?? false)
        }
    }


    private func updateQuarantine(completion: ((Bool) -> Void)? = nil) {
        Task {
            do {
                let result = try await ContactQuarantineData.fetchLastItem(dataStore: dataStore,
                                                                           context: dataStore.backgroundContext)

                let lastIndex = result?.id ?? .zero

                service.fetchQuarantine(lastIndex: lastIndex,
                                        limit: limitOffSet) { [weak self] result in
                    switch result {
                    case .success(let list):
                        self?.persistQuarantine(list: list, completion: { success in
                            completion?(success)
                        })

                    case .failure:
                        completion?(false)
                    }
                }
            }
        }
    }

    private func persistQuarantine(list: [BlackListAndReportResponse], completion: @escaping (Bool) -> Void) {
        if list.isEmpty {
            completion(false)
            return
        }

        saveList(list)
        print("##### Quarantine saved")
        completion(true)
    }

    private func saveList(_ list: [BlackListAndReportResponse]) {
        do {
            for item in list {
                var quarantine = try ContactQuarantineData.create(dataStore: dataStore, context: dataStore.backgroundContext)
                quarantine.id = Int64(item.id)
                quarantine.date = Date()
                quarantine.descrip = item.description ?? "-"
                quarantine.number = Int64(item.number) ?? .zero
            }

            try self.dataStore.save(context: dataStore.backgroundContext)
        } catch {
            print(error.localizedDescription)
        }
    }
}
