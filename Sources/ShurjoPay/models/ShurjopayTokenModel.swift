//
//  File.swift
//  
//
//  Created by Shajedul Islam on 3/12/22.
//

import Foundation

public struct ShurjopayTokenModel:Codable{
    let token : String?
    let store_id : Int?
    let execute_url : String?
    let token_type : String?
    let sp_code : String?
    let message : String?
    let token_create_time : String?
    let expires_in : Int?
}

public struct ShurjopayTokenModelExtended{
    let shurjopayTokenModel : ShurjopayTokenModel?
    let error : Bool
    let message : String?
}
