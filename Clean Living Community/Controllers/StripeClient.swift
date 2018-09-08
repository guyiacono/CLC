//
//  StripeClient.swift
//  Clean Living Community
//
//  Created by Michael Karolewicz on 9/5/18.
//  Copyright © 2018 Clean Living Community LLC. All rights reserved.
//

import Foundation
import Alamofire
import Stripe

// see stripe's official documentation for more about this
enum Result {
    case success
    case failure(Error)
}

final class StripeClient {
    
    static let shared = StripeClient()
    
    private init() {
        // private
    }
    
    private lazy var baseURL: URL = {
        guard let url = URL(string: StripeConstants.baseURLString) else {
            fatalError("Invalid URL")
        }
        return url
    }()
    
    func completeCharge(with token: STPToken, amount: Int, completion: @escaping (Result) -> Void) {
        // 1
        let url = baseURL.appendingPathComponent("charge")
        // 2
        let params: [String: Any] = [
            "token": token.tokenId,
            "amount": amount,
            "currency": StripeConstants.defaultCurrency,
            "description": StripeConstants.defaultDescription
        ]
        // 3
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success:
                    completion(Result.success)
                case .failure(let error):
                    completion(Result.failure(error))
                }
        }
    }
    
}
