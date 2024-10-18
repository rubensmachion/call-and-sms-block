import Foundation

protocol SettingsServiceProcotol {
    func fetch(result: @escaping (_ response: Bool) -> Void)
}

final class SettingsService: SettingsServiceProcotol {

    func fetch(result: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            result(true)
        }
    }
}
