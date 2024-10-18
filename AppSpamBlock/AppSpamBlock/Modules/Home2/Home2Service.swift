import Foundation
import NetworkKit

protocol Home2ServiceProcotol {
    func fetch(lastIndex: Int, limit: Int?, result: @escaping (Bool) -> Void)
}

enum Home2ServiceRoute {
    case getBlackList(lastIndex: Int, limit: Int?)

    var config: IRequestConfig {
        switch self {
        case .getBlackList(let index, let limit):
            return setupGetBlackList(lastIndex: index, limit: limit)
        }
    }

    private func setupGetBlackList(lastIndex: Int, limit: Int?) -> IRequestConfig {
        var params = ["index": lastIndex]
        if let limit = limit, limit > .zero {
            params["limit"] = limit
        }
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

    func fetch(lastIndex: Int, limit: Int?, result: @escaping (Bool) -> Void) {
        let route = Home2ServiceRoute.getBlackList(lastIndex: lastIndex, limit: limit)

        network.decodeRequest(config: route.config,
                              type: [BlackListMode].self) { response in
            switch response {
            case .success(let list):
                result(true)
            case .failure(let error):
                print(error)
            }
        }
    }
}
