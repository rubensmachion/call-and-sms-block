import Foundation

protocol TutorialScreenServiceProcotol {
    func fetch(result: @escaping (_ response: Bool) -> Void)
}

final class TutorialScreenService: TutorialScreenServiceProcotol {

    func fetch(result: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            result(true)
        }
    }
}
