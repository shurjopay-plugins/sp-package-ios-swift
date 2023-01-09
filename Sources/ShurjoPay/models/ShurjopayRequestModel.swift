//
//  ShurjopayRequestModel.swift
//  
//
//  Created by Shajedul Islam on 3/12/22.
//

import Foundation

public struct ShurjopayRequestModel{
    /// Pass prefix, user name, password and client ip as configs here
    var configs : ShurjopayConfigs
    /// ISO format,(only BDT and USD are allowed)
    /// Unique Order Id from merchant store.
    var orderID : String
    var currency : String
    /// Transaction amount
    var amount : Double
    var discountAmount : Double
    var discountPercentage : Double
    var customerName : String
    var customerPhoneNumber : String
    var customerEmail : String?
    var customerAddress : String
    var customerCity : String
    var customerState : String?
    var customerPostcode : String
    var customerCountry : String?
    var returnURL : String
    var cancelURL : String
    /// Additional field
    var value1 : String?
    /// Additional field
    var value2 : String?
    /// Additional field
    var value3 : String?
    /// Additional field
    var value4 : String?
    public init(configs: ShurjopayConfigs, orderID: String, currency: String, amount: Double, discountAmount: Double, discountPercentage: Double, customerName: String, customerPhoneNumber: String, customerEmail: String? = nil, customerAddress: String, customerCity: String, customerState: String? = nil, customerPostcode: String, customerCountry: String? = nil, returnURL: String, cancelURL: String, value1: String? = nil, value2: String? = nil, value3: String? = nil, value4: String? = nil) {
        self.configs = configs
        self.orderID = orderID
        self.currency = currency
        self.amount = amount
        self.discountAmount = discountAmount
        self.discountPercentage = discountPercentage
        self.customerName = customerName
        self.customerPhoneNumber = customerPhoneNumber
        self.customerEmail = customerEmail
        self.customerAddress = customerAddress
        self.customerCity = customerCity
        self.customerState = customerState
        self.customerPostcode = customerPostcode
        self.customerCountry = customerCountry
        self.returnURL = returnURL
        self.cancelURL = cancelURL
        self.value1 = value1
        self.value2 = value2
        self.value3 = value3
        self.value4 = value4
    }
}
