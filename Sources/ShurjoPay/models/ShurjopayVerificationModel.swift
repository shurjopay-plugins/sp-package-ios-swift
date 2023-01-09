//
//  ShurjopayVerificationModel.swift
//  
//
//  Created by Shajedul Islam on 16/12/22.
//

import Foundation

public struct VerificationDataDev:Codable{
    public let id : Int?
    public let order_id : String?
    public let currency : String?
    public let amount : Int?
    public let payable_amount : Int?
    public let discount_amount : Int?
    public let usd_amt : Int?
    public let disc_percent : Int?
    public let received_amount : String?
    public let usd_rate : Int?
    public let card_holder_name : String?
    public let card_number : String?
    public let phone_no : String?
    public let bank_trx_id : String?
    public let invoice_no : String?
    public let bank_status : String?
    public let customer_order_id : String?
    public let sp_code : Int?
    public let sp_message : String?
    public let name : String?
    public let email : String?
    public let address : String?
    public let city : String?
    public let value1 : String?
    public let value2 : String?
    public let value3: String?
    public let value4 : String?
    public let transaction_status : String?
    public let method : String?
    public let date_time : String?
    public let message : String?
}

public struct VerificationDataLive:Codable{
    public let id : Int?
    public let order_id : String?
    public let currency : String?
    public let amount : String?
    public let payable_amount : String?
    public let discount_amount : String?
    public let usd_amt : String?
    public let disc_percent : Int?
    public let received_amount : String?
    public let usd_rate : Int?
    public let card_holder_name : String?
    public let card_number : String?
    public let phone_no : String?
    public let bank_trx_id : String?
    public let invoice_no : String?
    public let bank_status : String?
    public let customer_order_id : String?
    public let sp_code : String?
    public let sp_message : String?
    public let name : String?
    public let email : String?
    public let address : String?
    public let city : String?
    public let value1 : String?
    public let value2 : String?
    public let value3: String?
    public let value4 : String?
    public let transaction_status : String?
    public let method : String?
    public let date_time : String?
    public let message : String?
}



public struct ShurjopayVerificationModel{
    public let id : Int?
    public let order_id : String?
    public let customer_order_id : String?
    public let amount : String?
    public let payable_amount : String?
    public let received_amount : String?
    public let discount_amount : String?
    public let disc_percent : Int?
    public let usd_amt : String?
    public let name : String?
    public let email : String?
    public let phone_no : String?
    public let city : String?
    public let address : String?
    public let card_holder_name : String?
    public let card_number : String?
    public let bank_trx_id : String?
    public let bank_status : String?
    public let transaction_status : String?
    public let method : String?
    public let invoice_no : String?
    public let date_time : String?
    public let value1 : String?
    public let value2 : String?
    public let value3: String?
    public let value4 : String?
    public let sp_code : String?
    public let sp_message : String?
    public let error : Bool
    init(id: Int?, order_id: String?, customer_order_id: String?, amount: String?, payable_amount: String?, received_amount: String?, discount_amount: String?, disc_percent: Int?, usd_amt: String?, name: String?, email: String?, phone_no: String?, city: String?, address: String?, card_holder_name: String?, card_number: String?, bank_trx_id: String?, bank_status: String?, transaction_status: String?, method: String?, invoice_no: String?, date_time: String?, value1: String?, value2: String?, value3: String?, value4: String?, sp_code: String?, sp_message: String?, error: Bool) {
        self.id = id
        self.order_id = order_id
        self.customer_order_id = customer_order_id
        self.amount = amount
        self.payable_amount = payable_amount
        self.received_amount = received_amount
        self.discount_amount = discount_amount
        self.disc_percent = disc_percent
        self.usd_amt = usd_amt
        self.name = name
        self.email = email
        self.phone_no = phone_no
        self.city = city
        self.address = address
        self.card_holder_name = card_holder_name
        self.card_number = card_number
        self.bank_trx_id = bank_trx_id
        self.bank_status = bank_status
        self.transaction_status = transaction_status
        self.method = method
        self.invoice_no = invoice_no
        self.date_time = date_time
        self.value1 = value1
        self.value2 = value2
        self.value3 = value3
        self.value4 = value4
        self.sp_code = sp_code
        self.sp_message = sp_message
        self.error = error
    }
    

}


