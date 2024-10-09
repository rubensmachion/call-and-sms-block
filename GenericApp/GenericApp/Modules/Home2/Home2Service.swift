import Foundation

protocol Home2ServiceProcotol {
    func fetch(result: @escaping (_ response: Bool) -> Void)
}

final class Home2Service: Home2ServiceProcotol {

    func fetch(result: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            result(true)
        }
    }
}
