//
//  ShurjopayConfigs.swift
//  
//
//  Created by Shajedul Islam on 3/12/22.
//

import Foundation

public struct ShurjopayConfigs{
    /// sandbox, live, ipn-sandbox, ipn-live
    var environment : String
    /// shurjoPay merchant user name
    var userName : String
    ///shurjoPay merchant password
    var password : String
    /// Any string not more than 5 characters. It distinguishes the stores of a merchant.
    var prefix : String
    var clientIP : String
    public init(environment: String, userName: String, password: String, prefix: String, clientIP: String) {
        self.environment = environment
        self.userName = userName
        self.password = password
        self.prefix = prefix
        self.clientIP = clientIP
    }

}
