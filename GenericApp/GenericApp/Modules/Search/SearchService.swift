import Foundation

protocol SearchServiceProcotol {
    func fetch(result: @escaping (_ response: Bool) -> Void)
}

final class SearchService: SearchServiceProcotol {

    func fetch(result: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            result(true)
        }
    }
}
