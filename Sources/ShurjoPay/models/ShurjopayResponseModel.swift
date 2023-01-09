//
//  File.swift
//  
//
//  Created by Shajedul Islam on 3/12/22.
//

import Foundation

public struct ShurjopayResponseModel{
    public var status : Bool
    public var message : String?
    public var shurjopayOrderID : String?
    public init(status: Bool, message: String? = nil, shurjopayOrderID: String? = nil) {
        self.status = status
        self.message = message
        self.shurjopayOrderID = shurjopayOrderID
    }
}
