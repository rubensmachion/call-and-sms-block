import Foundation

protocol SpamHomeServiceProcotol {
    func fetch(result: @escaping (_ response: Bool) -> Void)
}

final class SpamHomeService: SpamHomeServiceProcotol {

    func fetch(result: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            result(true)
        }
    }
}
