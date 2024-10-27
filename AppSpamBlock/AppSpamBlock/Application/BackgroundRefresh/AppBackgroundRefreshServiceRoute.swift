import NetworkKit

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
