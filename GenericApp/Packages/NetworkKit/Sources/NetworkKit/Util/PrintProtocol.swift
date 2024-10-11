import Foundation

final class PrintProtocol: URLProtocol {

    override public class func canInit(with request: URLRequest) -> Bool {
        request.curl(scope: "Debug Network")

        return false
    }
}

private extension URLRequest {
    func curl(scope: String) {
        print("---------------------------------------------------------------")
        print("---------------------------------------------------------------")
        print("DEBUG FOR: \(scope)")
        guard let url = self.url else { return }
        var baseCommand = #"curl "\#(url.absoluteString)""#
        if self.httpMethod == "HEAD" {
            baseCommand += " --head"
        }

        var command = [baseCommand]
        if let method = self.httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }

        if let headers = self.allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }

        if let data = self.httpBody, let body = String(data: data, encoding: .utf8) {
            command.append("-d '\(body)'")
        }

        print(command.joined(separator: " \\\n\t"))
    }
}

extension PrintProtocol {
    class func printDebugData(scope: String, url: String?, data: Data?) {
        guard let data = data else {
            print("Invalid Data")
            return
        }
        print("---------------------------------------------------------------")
        print("🔬 - DEBUG MODE ON FOR: \(scope) - 🔬")
        print("📡 URL: \(url ?? "No URL passed")")
        print(String(data: data, encoding: .utf8) ?? "No Data passed")
        print("---------------------------------------------------------------")
    }
}
