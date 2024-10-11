import Foundation

public enum RequestResult {
    case success(Data)
    case failure(RequestError)
}

public enum RequestError: Error {
    case invalidData
    case invalidRequest
    case error(error: Error)
    case error(message: String)
}

public final class NetworkRequest {

    private let session: URLSession

    public init(configuration: URLSessionConfiguration = .default) {
        configuration.protocolClasses?.insert(PrintProtocol.self, at: 0)
        self.session = .init(configuration: configuration, delegate: nil, delegateQueue: nil)
    }

    public func request(with config: IRequestConfig, completion: @escaping (RequestResult) -> Void) {
        guard let urlRequest = config.createURLRequest() else {
            completion(.failure(.invalidRequest))
            return
        }

        let task = session.dataTask(with: urlRequest) { data, urlResponse, error in

            if config.debugMode {
                PrintProtocol.printDebugData(scope: "DataResult", url: urlRequest.url?.absoluteString, data: data)
            }

            if let error = error {
                completion(.failure(.error(error: error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            completion(.success(data))
        }

        task.resume()
    }
}


