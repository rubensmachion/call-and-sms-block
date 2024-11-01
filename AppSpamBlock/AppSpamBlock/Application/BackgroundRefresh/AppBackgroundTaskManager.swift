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
    private let dataStore = DataStore()
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


    func forceUpdateAll() {
        updateAll { [weak self] success in
            if success {
                self?.reloadCallDirectoriesIfNeeded()
            }
        }
    }

    private func reloadCallDirectoriesIfNeeded() {
        Task {
            let appSystem: AppData? = try await dataStore.fetchSingle(context: dataStore.backgroundContext)
            let currentDate = Date()
            let lastUpdateQuarantine = appSystem?.lastUpdateQuarantine ?? currentDate
            let limit = 60 * 60 * 24
            let nextUpdateDate = lastUpdateQuarantine == currentDate
            ? currentDate : lastUpdateQuarantine.addingTimeInterval(TimeInterval(limit))
            print("Data Atual: \(currentDate): data de atualizacao: \(nextUpdateDate)")

            guard currentDate >= nextUpdateDate else {
                return
            }

            AppCallDirectoryProvider.shared.reloadCallDirectory()
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
                let result: [ContactQuarantineData]? = try await dataStore.fetch(
                    sortDescriptors: ContactQuarantineData.ascendingdateSortDescriptor(),
                    predicate: ContactQuarantineData.quarantineListPredicate(),
                    context: dataStore.backgroundContext
                )

                let lastIndex = result?.last?.id ?? .zero

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
        for item in list {
            let quarantine: ContactQuarantineData = dataStore.create(context: dataStore.backgroundContext)
//            let quarantine = ContactQuarantineData.createEntity(context: dataStore.backgroundContext)
//            let quarantine = ContactQuarantineData(entity: entity, insertInto: dataStore.backgroundContext)
//            let quarantine = ContactQuarantineData(context: dataStore.backgroundContext)
            quarantine.id = Int64(item.id)
            quarantine.date = Date()
            quarantine.descrip = item.description ?? "-"
            quarantine.number = Int64(item.number) ?? .zero
            quarantine.contactType = ContactType.quarantine.rawValue
            quarantine.formattedNumber = nil
//            quarantine.formattedNumber = quarantine.number.toFormattedPhoneNumber()
        }

        do {
            try self.dataStore.save(context: dataStore.backgroundContext)
        } catch {
            print(error.localizedDescription)
        }
    }
}
