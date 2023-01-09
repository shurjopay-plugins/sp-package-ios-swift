//
//  ShurjopayCheckoutResponseModel.swift
//  
//
//  Created by Shajedul Islam on 10/12/22.
//

import Foundation

public struct ShurjopayCheckoutResponseModel:Codable{
    let checkout_url : String?
    let amount : Int?
    let currency : String?
    let sp_order_id : String?
    let customer_order_id : String?
    let customer_name : String?
    let customer_address : String?
    let customer_city : String?
    let customer_phone : String?
    let customer_email : String?
    let client_ip : String?
    let intent : String?
    let transactionStatus : String?
}

public struct ShurjopayCheckoutResponseModelExtended:Codable{
    let shurjopayCheckoutResponseModel : ShurjopayCheckoutResponseModel?
    let error : Bool
    let message : String?
}
