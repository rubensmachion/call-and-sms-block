import Foundation
import NetworkKit

enum BlackListAndReportResult {
    case success([BlackListAndReportResponse])
    case failure(Error)
}

struct BlackListAndReportResponse: Decodable {
    let id: Int
    let number: String
    let description: String?
}

protocol AppBackgroundRefreshServiceProcotol {
    func fetchBlackList(lastIndex: Int64, limit: Int?, completion: @escaping (BlackListAndReportResult) -> Void)
    func fetchQuarantine(lastIndex: Int64, limit: Int?, completion: @escaping (BlackListAndReportResult) -> Void)
}

// MARK: - AppBackgroundRefreshService

final class AppBackgroundRefreshService: AppBackgroundRefreshServiceProcotol {

    private let network: INetworkRequest

    init(network: INetworkRequest) {
        self.network = network
    }

    func fetchBlackList(lastIndex: Int64, limit: Int?, completion: @escaping (BlackListAndReportResult) -> Void) {
        let route = AppBackgroundRefreshServiceRoute.getBlackList(lastIndex: lastIndex, limit: limit)

        network.decodeRequest(config: route.config,
                              type: [BlackListAndReportResponse].self) { response in
            switch response {
            case .success(let list):
                completion(.success(list ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchQuarantine(lastIndex: Int64, limit: Int?, completion: @escaping (BlackListAndReportResult) -> Void) {
        let route = AppBackgroundRefreshServiceRoute.getQuarantine(lastIndex: lastIndex, limit: limit)

        network.decodeRequest(config: route.config,
                              type: [BlackListAndReportResponse].self) { response in
            switch response {
            case .success(let list):
                completion(.success(list ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
