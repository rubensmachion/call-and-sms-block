//
//  MessageFilterExtension.swift
//  MessageFilter
//
//  Created by Rubens Machion on 22/08/24.
//

import IdentityLookup
import CoreML

final class MessageFilterExtension: ILMessageFilterExtension {}

extension MessageFilterExtension: ILMessageFilterQueryHandling, ILMessageFilterCapabilitiesQueryHandling {
    func handle(_ capabilitiesQueryRequest: ILMessageFilterCapabilitiesQueryRequest,
                context: ILMessageFilterExtensionContext,
                completion: @escaping (ILMessageFilterCapabilitiesQueryResponse) -> Void) {
        let response = ILMessageFilterCapabilitiesQueryResponse()

        // TODO: Update subActions from ILMessageFilterSubAction enum
        // response.transactionalSubActions = [...]
        // response.promotionalSubActions   = [...]

        completion(response)
    }

    func handle(_ queryRequest: ILMessageFilterQueryRequest,
                context: ILMessageFilterExtensionContext,
                completion: @escaping (ILMessageFilterQueryResponse) -> Void) {

        let response = ILMessageFilterQueryResponse()

        // Verifique se a mensagem é spam
        //        if let messageBody = queryRequest.messageBody?.lowercased() {
        //            if messageBody.contains("promoção") || messageBody.contains("ganhou") || messageBody.contains("clique aqui") {
        //                // Se a mensagem for identificada como SPAM
        //                response.action = ILMessageFilterAction.junk
        //            } else {
        //                // Permitir a mensagem
        //                response.action = .allow
        //            }
        //        } else {
        //            // Se não houver mensagem (ex.: MMS sem corpo de texto)
        //            response.action = .allow
        //        }
        //
        //        // Retorne a resposta ao sistema
        //        completion(response)

        //        // First, check whether to filter using offline data (if possible).
        let (offlineAction, offlineSubAction) = self.offlineAction(for: queryRequest)

        switch offlineAction {
        case .allow, .junk, .promotion, .transaction:

            let response = ILMessageFilterQueryResponse()
            response.action = offlineAction
            response.subAction = offlineSubAction

            completion(response)

        case .none:
            context.deferQueryRequestToNetwork() { (networkResponse, error) in
                let response = ILMessageFilterQueryResponse()
                response.action = .none
                response.subAction = .none

                if let networkResponse = networkResponse {
                    // If we received a network response, parse it to determine an action to return in our response.
                    (response.action, response.subAction) = self.networkAction(for: networkResponse)
                } else {
                    NSLog("Error deferring query request to network: \(String(describing: error))")
                }

                completion(response)
            }

        @unknown default:
            break
        }
    }

    private func offlineAction(for queryRequest: ILMessageFilterQueryRequest) -> (ILMessageFilterAction, ILMessageFilterSubAction) {
        // TODO: Replace with logic to perform offline check whether to filter first (if possible).
        guard let text = queryRequest.messageBody else { return (.none, .none) }
        do {
            let model = try SMS_classification(configuration: MLModelConfiguration())

            let input = SMS_classificationInput(text: text)
            let prediction = try model.prediction(input: input)

            let predictedLabel = prediction.label

            if predictedLabel == "spam" {
                return (.junk, .none)
            }

            return (.none, .none)
        } catch {
            print(error)
            return (.none, .none)
        }
    }

    private func networkAction(for networkResponse: ILNetworkResponse) -> (ILMessageFilterAction, ILMessageFilterSubAction) {
        // TODO: Replace with logic to parse the HTTP response and data payload of `networkResponse` to return an action.
        return (.none, .none)
    }

}
