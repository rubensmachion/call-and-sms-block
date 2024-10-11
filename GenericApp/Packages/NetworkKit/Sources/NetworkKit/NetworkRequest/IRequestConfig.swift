import Foundation

public struct Constants {
    public static var host: String = "api-dev.callspam.org"
}

public enum HTTPMethod: String {
    case connect = "CONNECT"
    case delete = "DELETE"
    case get = "GET"
    case head = "HEAD"
    case options = "OPTIONS"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
    case trace = "TRACE"
}

public enum ParameterEncoding {
    case body
    case url
    case urlOnBody
    case listOnBody(paramList: [Any]) // When used parameters: [String: Any] will ignored
}

public protocol IRequestConfig {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any] { get set }
    var headers: [String: String] { get }
    var parametersEncoding: ParameterEncoding { get }
    var debugMode: Bool { get }
}

extension IRequestConfig {
    func createURLRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path

        guard let url = urlComponents.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        request.setValue("application/json", forHTTPHeaderField: "Accept")

        var httpBody: Data?

        if !parameters.isEmpty {
            switch parametersEncoding {
            case .url:
                urlComponents.setQueryItems(with: parameters)
                request.url = urlComponents.url
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

            case .body:
                httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            case .urlOnBody:
                httpBody = Data(parameters.toQueryItems().utf8)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            default:
                break
            }
        } else if case .listOnBody(let list) = parametersEncoding {
            httpBody = try? JSONSerialization.data(withJSONObject: list, options: [])
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        if let body = httpBody {
            request.httpBody = body
        }

        request.allHTTPHeaderFields = headers

        return request
    }
}


public struct RequestConfig: IRequestConfig {
    public var scheme: String
    public var host: String
    public var path: String
    public var method: HTTPMethod
    public var parameters: [String : Any]
    public var headers: [String : String]
    public var parametersEncoding: ParameterEncoding
    public var debugMode: Bool

    public init(scheme: String = "https",
                host: String = Constants.host,
                path: String,
                method: HTTPMethod = .get,
                parameters: [String : Any] = [:],
                headers: [String : String] = [:],
                parametersEncoding: ParameterEncoding = .url,
                debugMode: Bool = false) {
        self.scheme = scheme
        self.host = host
        self.path = path
        self.method = method
        self.parameters = parameters
        self.headers = headers
        self.parametersEncoding = parametersEncoding
        self.debugMode = debugMode
    }
}
