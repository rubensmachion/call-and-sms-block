import Foundation
import NetworkKit

enum BlackListResult {
    case success([BlackListModel])
    case failure(Error)
}

struct BlackListModel: Decodable {
    let id: Int
    let number: String
    let description: String?
}

protocol AppBackgroundRefreshServiceProcotol {
    func fetchBlackList(lastIndex: Int64, limit: Int?, completion: @escaping (BlackListResult) -> Void)
    func fetchQuarantine(lastIndex: Int64, limit: Int?, completion: @escaping (BlackListResult) -> Void)
}

// MARK: - Routes

enum AppBackgroundRefreshServiceRoute {
    case getBlackList(lastIndex: Int64, limit: Int?)
    case getQuarantine(lastIndex: Int64, limit: Int?)

    var config: IRequestConfig {
        switch self {
        case .getBlackList(let index, let limit):
            return setupGetBlackList(lastIndex: index, limit: limit)
        case .getQuarantine(let index, let limit):
            return setupGetQuarantine(lastIndex: index, limit: limit)
        }
    }

    private func setupGetBlackList(lastIndex: Int64, limit: Int?) -> IRequestConfig {
        var params: [String: Any] = ["index": lastIndex]
        if let limit = limit, limit > .zero {
            params["limit"] = limit
        }
        return RequestConfig(path: "/blacklist",
                             parameters: params,
                             debugMode: true)
    }

    private func setupGetQuarantine(lastIndex: Int64, limit: Int?) -> IRequestConfig {
        var params: [String: Any] = ["index": lastIndex, "quarantine": 1]
        if let limit = limit, limit > .zero {
            params["limit"] = limit
        }
        return RequestConfig(path: "/reports",
                             parameters: params,
                             debugMode: true)
    }
}

// MARK: - AppBackgroundRefreshService

final class AppBackgroundRefreshService: AppBackgroundRefreshServiceProcotol {

    private let network: INetworkRequest

    init(network: INetworkRequest) {
        self.network = network
    }

    func fetchBlackList(lastIndex: Int64, limit: Int?, completion: @escaping (BlackListResult) -> Void) {
        let route = AppBackgroundRefreshServiceRoute.getBlackList(lastIndex: lastIndex, limit: limit)

        network.decodeRequest(config: route.config,
                              type: [BlackListModel].self) { response in
            switch response {
            case .success(let list):
                completion(.success(list ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchQuarantine(lastIndex: Int64, limit: Int?, completion: @escaping (BlackListResult) -> Void) {
        let route = AppBackgroundRefreshServiceRoute.getQuarantine(lastIndex: lastIndex, limit: limit)

        network.decodeRequest(config: route.config,
                              type: [BlackListModel].self) { response in
            switch response {
            case .success(let list):
                completion(.success(list ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
