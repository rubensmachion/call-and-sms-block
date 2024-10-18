import Foundation

public struct EmptyResponse: Decodable { }

public enum MapperResult<T> where T: Decodable {
    case success(data: T?)
    case failure(error: MapperResultError)
}

public enum MapperResultError: Error {
    case defaultError(error: Error)
    case invalidDataResponse
    case errorWith(message: String)
    case error(error: RequestError)
}

public extension NetworkRequest {

    private func defaultMapper<T>(data: Data, to type: T.Type) -> MapperResult<T> {
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]

            guard let data = jsonData?["data"] else {
                guard let errorMessage = jsonData?["message"] as? String else {
                    return .failure(error: .invalidDataResponse)
                }

                return .failure(error: .errorWith(message: errorMessage))
            }

            let responseData = try JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed)
            let result = try JSONDecoder().decode(type, from: responseData)

            return .success(data: result)
        } catch {
            return .failure(error: .defaultError(error: error))
        }
    }

    func decodeRequest<T>(config: IRequestConfig,
                          type: T.Type,
                          completion: @escaping (MapperResult<T>) -> Void) where T: Decodable {

        request(with: config) { result in
            switch result {
            case .success(let data):
                if !data.isEmpty {
                    let decodeResult = self.defaultMapper(data: data, to: T.self)
                    switch decodeResult {
                    case .success(let response):
                        completion(.success(data: response))
                        
                    case .failure(let error):
                        completion(.failure(error: .errorWith(message: error.localizedDescription)))

                    }
                } else {
                    completion(.success(data: EmptyResponse() as? T))
                }
            case .failure(let error):
                completion(.failure(error: .errorWith(message: error.localizedDescription)))
            }
        }
    }
}
