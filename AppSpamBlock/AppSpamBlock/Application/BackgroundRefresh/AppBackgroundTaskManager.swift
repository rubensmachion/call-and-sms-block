import Foundation
import BackgroundTasks

protocol IAppBackgroundTaskManager {
    func forceUpdateBlackList()
    func forceUpdateQuarantine()
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

    private static var LIMIT = 500

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

    // MARK: - Private

    private func handleTask(_ task: BGTask) {
        print(task)
        scheduleTask(identifier: task.identifier)
        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }

//        let operationBlackList = OperationQueue()
//
//        operationBlackList.addOperation {
//            updateBlackList { [weak self ] success1 in
//
//            }
//        }

        updateQuarantine { result in
            task.setTaskCompleted(success: result)
        }
    }

    private func updateBlackList(completion: ((Bool) -> Void)? = nil) {
        Task {
            do {
                let result: [BlackListData]? = try await dataStore.fetch(sortDescriptors: BlackListData.ascendingdateSortDescriptor())

                let lastIndex = result?.last?.id ?? .zero

                service.fetchBlackList(lastIndex: lastIndex, limit: AppBackgroundTaskManager.LIMIT) { [weak self] result in
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

    private func persistBlackList(list: [BlackListModel]) -> Bool {
        _ = list.map { [weak self] item in
            guard let self = self else { return }
            let quarantine = BlackListData(context: self.dataStore.context)
            quarantine.id = Int64(item.id)
            quarantine.date = Date()
            quarantine.number = Int64(item.number) ?? .zero
        }
        do {
            try self.dataStore.save(context: self.dataStore.context)

            return true
        } catch {
            return false
        }
    }

    private func updateQuarantine(completion: ((Bool) -> Void)? = nil) {
        Task {
            do {
                let result: [QuarantineData]? = try await dataStore.fetch(sortDescriptors: QuarantineData.ascendingdateSortDescriptor())

                let lastIndex = result?.last?.id ?? .zero

                service.fetchQuarantine(lastIndex: lastIndex, limit: AppBackgroundTaskManager.LIMIT) { [weak self] result in
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

    private func persistQuarantine(list: [BlackListModel]) -> Bool {
        _ = list.map { [weak self] item in
            guard let self = self else { return }
            let quarantine = QuarantineData(context: self.dataStore.context)
            quarantine.id = Int64(item.id)
            quarantine.date = Date()
            quarantine.descrip = item.description ?? "-"
            quarantine.number = Int64(item.number) ?? .zero
        }
        do {
            try self.dataStore.save(context: self.dataStore.persistentContainer.viewContext)

            return true
        } catch {
            return false
        }
    }
}
