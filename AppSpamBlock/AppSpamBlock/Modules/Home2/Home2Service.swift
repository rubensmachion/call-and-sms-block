import Foundation
import NetworkKit

protocol Home2ServiceProcotol {
    func fetch(result: @escaping (_ response: Bool) -> Void)
}

enum Home2ServiceRoute {
    case getBlackList(lastIndex: Int)

    var config: IRequestConfig {
        switch self {
        case .getBlackList(let index):
            return setupGetBlackList(lastIndex: index)
        }
    }

    private func setupGetBlackList(lastIndex: Int) -> IRequestConfig {
        let params = ["index": lastIndex]
        return RequestConfig(path: "/blacklist",
                             parameters: params,
                             debugMode: true)
    }
}

struct BlackListMode: Decodable {
    let id: Int
    let number: String
}

final class Home2Service: Home2ServiceProcotol {

    private let network = NetworkRequest(configuration: .default)

    func fetch(result: @escaping (Bool) -> Void) {
        let route = Home2ServiceRoute.getBlackList(lastIndex: 0)

        network.decodeRequest(config: route.config,
                              type: [BlackListMode].self) { response in
            switch response {
            case .success(let list):
                print(list)
                result(true)
            case .failure(let error):
                print(error)
            }
        }
    }
}
