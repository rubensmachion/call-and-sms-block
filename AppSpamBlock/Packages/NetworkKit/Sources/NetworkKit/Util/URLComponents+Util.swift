import Foundation

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: Any]) {
        var queries: [URLQueryItem] = []

        parameters.forEach { key, value in
            if let list = value as? [String] {
                queries.append(contentsOf: list.map { URLQueryItem(name: key, value: $0) })
            } else {
                queries.append(URLQueryItem(name: key, value: "\(value)"))
            }
        }
        self.queryItems = queries
    }
}
