//
//  ConnectionTest.swift
//  CallSMSBlock
//
//  Created by Rubens Machion on 25/09/24.
//

import Foundation

class MySessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            // Permitir qualquer certificado SSL (não recomendado para produção)
            completionHandler(.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}


class ConnectionTest {

    func sendResponse() {
//        let sessionDelegate = MySessionDelegate()
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)

        let url = URL(string: "https://api-dev.callspam.org/call-report")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data,
               let strData = String(data: data, encoding: .utf8) {
                print(strData)
            } else {
                print(error)
            }
        }
        task.resume()
    }

    func sendPostResponse() {
        let sessionDelegate = MySessionDelegate()
        let session = URLSession(configuration: .default, delegate: sessionDelegate, delegateQueue: nil)

        let url = URL(string: "https://api-dev.callspam.org/call-report")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

//        let body: [String: Any] = [
//            "client_id": "83995b1f-5438-42e3-b3b6-c35748d58130",
//            "redirect_uri": "https://padigital.com.br",
//            "extraInfo": [
//                "cpf": "23331802425",
//                "contract_id": "26aafed1-c8d2-47a8-963e-28e7e2d16397"
//            ]
//        ]
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let task = session.dataTask(with: url) { data, response, error in
            if let data = data,
               let strData = String(data: data, encoding: .utf8) {
                print(strData)
            } else {
                print(error)
            }
        }
        task.resume()
    }
}
