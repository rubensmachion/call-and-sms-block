import Foundation
import BackgroundTasks

final class AppBackgroundTaskManager {

    enum Tasks {
        case refreshBlackList
        case refreshReportedList
    }

    private let task: Tasks

    private var taskIdentifier: String? {
        return Bundle.main.infoDictionary?["BGTaskSchedulerPermittedIdentifiers"] as? String
    }

    init(task: Tasks) {
        self.task = task
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

    private func handleTask(_ task: BGTask) {
        print(task)

        scheduleTask(identifier: task.identifier)

        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }

        DispatchQueue.global().asyncAfter(deadline: .now() + 5.0) {
            
            task.setTaskCompleted(success: true)
        }
    }
}
