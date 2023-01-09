#if canImport(UIKit)
import UIKit
#endif
import WebKit

public class Shurjopay: UIViewController{
    private static var screen = UIStoryboard(name: "ShurjoPay", bundle: Bundle.module).instantiateInitialViewController()! as? Shurjopay
    private var baseURL : String = ""
    private var environment : String = ""
    private var token : String = ""
    private var tokenType : String = ""
    private var webView : WKWebView?
    private var paymentUrl = ""
    private var returnUrl : String = ""
    private var cancelUrl : String = ""
    private var spOrderID : String = ""
    private var paymentCompletation: ((ShurjopayResponseModel) -> Void)?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view?.addSubview(webView!)
        guard let url = URL(string: paymentUrl) else {
            return
        }
        webView!.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        webView!.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView!.load(URLRequest(url: url))
    }
    
    override open func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        webView?.frame = view.bounds
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let _ = change?[NSKeyValueChangeKey.newKey] {
            let vc = Shurjopay.screen
            if(webView != nil && webView?.url != nil && webView?.url!.absoluteString != nil)
            {
                if(webView!.url!.absoluteString.contains(returnUrl) && webView!.url!.absoluteString.contains("order_id")){
                    paymentCompletation!(ShurjopayResponseModel(status: true, message: "Please call verifyPayment()", shurjopayOrderID: spOrderID))
                    vc?.dismiss(animated: true,completion: {
                        Shurjopay.screen = nil;
                        self.webView?.removeFromSuperview();
                        self.webView = nil;
                    })
                }
                else if(webView!.url!.absoluteString.contains(cancelUrl)){
                    paymentCompletation!(ShurjopayResponseModel(status: true, message: "Please call verifyPayment()", shurjopayOrderID: spOrderID))
                    vc?.dismiss(animated: true,completion: {
                        Shurjopay.screen = nil;
                        self.webView?.removeFromSuperview();
                        self.webView = nil;
                    })
                }
            }
        }
    }
    
    
    public func makePayment(parentUIViewController: UIViewController ,shurjopayRequestModel: ShurjopayRequestModel, completion: @escaping (ShurjopayResponseModel) -> Void){
        
        if(shurjopayRequestModel.configs.environment == "sandbox")
        {
            baseURL = "https://sandbox.shurjopayment.com/api"
            environment = "sandbox"
        }
        else if(shurjopayRequestModel.configs.environment == "live")
        {
            baseURL = "https://engine.shurjopayment.com/api"
            environment = "live"
        }
        else if(shurjopayRequestModel.configs.environment == "ipn-sandbox")
        {
            baseURL = "http://ipn.shurjotest.com"
            environment = "sandbox"
        }
        else if(shurjopayRequestModel.configs.environment == "ipn-live")
        {
            baseURL = "http://ipn.shurjopay.com"
            environment = "live"
        }
        
        let loader = parentUIViewController.loader()
        getToken(){ tokenModel in
            if(tokenModel.error != true)
            {
                self.checkout(tokenModel: tokenModel.shurjopayTokenModel!, shurjopayRequestModel: shurjopayRequestModel){ checkoutModel in
                    if(checkoutModel?.error != true)
                    {
                        self.paymentUrl = checkoutModel!.shurjopayCheckoutResponseModel!.checkout_url!
                        DispatchQueue.main.async {
                            //loader.dismiss(animated: true)
                            parentUIViewController.dismiss(animated: true, completion: {
                                Shurjopay.screen = UIStoryboard(name: "ShurjoPay", bundle: Bundle.module).instantiateInitialViewController()! as? Shurjopay
                                Shurjopay.screen?.paymentUrl = self.paymentUrl
                                Shurjopay.screen?.spOrderID = checkoutModel!.shurjopayCheckoutResponseModel!.sp_order_id!
                                Shurjopay.screen?.returnUrl = shurjopayRequestModel.returnURL
                                Shurjopay.screen?.cancelUrl = shurjopayRequestModel.cancelURL
                                Shurjopay.screen?.webView = WKWebView()
                                let navigationController = UINavigationController.init(rootViewController: Shurjopay.screen!)
                                Shurjopay.screen?.paymentCompletation = completion
                                navigationController.modalPresentationStyle = .fullScreen
                                parentUIViewController.present(navigationController, animated: true)
                            })
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            loader.dismiss(animated: true)
                        }
                        completion(ShurjopayResponseModel(status: false, message: checkoutModel?.message ?? "Something went wrong.", shurjopayOrderID: nil))
                    }
                    
                }
            }
            else
            {
                DispatchQueue.main.async {
                    loader.dismiss(animated: true)
                }
                completion(ShurjopayResponseModel(status: false, message: tokenModel.message ?? "Something went wrong.", shurjopayOrderID: nil))
            }
        }
    }
    
    
    func getToken(completion: @escaping (ShurjopayTokenModelExtended) -> Void){
        
        var request = URLRequest(url: URL(string: "\(baseURL)/get_token")!)
        let payload : [String: Any] = ["username": "sp_sandbox", "password": "pyyk97hu&6u6"]
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            let decoder = JSONDecoder()
            
            if error != nil{
                completion(ShurjopayTokenModelExtended(shurjopayTokenModel: nil, error: true, message: "Something went wrong."))
            }
            if let data = data{
                do {
                    let tokenModel = try decoder.decode(ShurjopayTokenModel.self, from: data)
                    if(tokenModel.token != nil && tokenModel.store_id != nil && tokenModel.sp_code == "200")
                    {
                        self.token = tokenModel.token!
                        self.tokenType = tokenModel.token_type!
                        completion(ShurjopayTokenModelExtended(shurjopayTokenModel: tokenModel, error: false, message: tokenModel.message))
                    }
                    else
                    {
                        completion(ShurjopayTokenModelExtended(shurjopayTokenModel: nil, error: true, message: tokenModel.message ?? "Something went wrong."))
                    }
                } catch{
                    completion(ShurjopayTokenModelExtended(shurjopayTokenModel: nil, error: true, message: "Something went wrong."))
                }
            }
        }
        task.resume();
    }
    
    func checkout(tokenModel: ShurjopayTokenModel, shurjopayRequestModel: ShurjopayRequestModel, completion: @escaping (ShurjopayCheckoutResponseModelExtended?) -> Void){
        
        var request = URLRequest(url: URL(string: "\(baseURL)/secret-pay")!)
        
        let payload : [String: AnyHashable] = [
            "token": tokenModel.token!,
            "store_id": String(tokenModel.store_id!),
            "prefix": shurjopayRequestModel.configs.prefix,
            "currency": shurjopayRequestModel.currency,
            "amount": shurjopayRequestModel.amount,
            "order_id": shurjopayRequestModel.orderID,
            "discsount_amount": shurjopayRequestModel.discountAmount,
            "disc_percent": shurjopayRequestModel.discountPercentage,
            "client_ip": shurjopayRequestModel.configs.clientIP,
            "customer_name": shurjopayRequestModel.customerName,
            "customer_phone": shurjopayRequestModel.customerPhoneNumber,
            "customer_email": shurjopayRequestModel.customerEmail,
            "customer_address": shurjopayRequestModel.customerAddress,
            "customer_city": shurjopayRequestModel.customerCity,
            "customer_state": shurjopayRequestModel.customerState,
            "customer_postcode": shurjopayRequestModel.customerPostcode,
            "customer_country": shurjopayRequestModel.customerCountry,
            "return_url": shurjopayRequestModel.returnURL,
            "cancel_url": shurjopayRequestModel.cancelURL,
            "value1": shurjopayRequestModel.value1,
            "value2": shurjopayRequestModel.value2,
            "value3": shurjopayRequestModel.value3,
            "value4": shurjopayRequestModel.value4,
        ]
        

        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload, options: .fragmentsAllowed)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            let decoder = JSONDecoder()
            
            if error != nil{
                completion(ShurjopayCheckoutResponseModelExtended(shurjopayCheckoutResponseModel: nil, error: true, message: "Something went wrong."))
            }
            if let data = data{
                do {
                    let checkoutModel = try decoder.decode(ShurjopayCheckoutResponseModel.self, from: data)
                    if(checkoutModel.checkout_url != nil && checkoutModel.sp_order_id != nil)
                    {
                        completion(ShurjopayCheckoutResponseModelExtended(shurjopayCheckoutResponseModel: checkoutModel, error: false, message: nil))
                    }
                    else
                    {
                        completion(ShurjopayCheckoutResponseModelExtended(shurjopayCheckoutResponseModel: nil, error: true, message: "Something went wrong."))
                    }
                } catch{
                    completion(ShurjopayCheckoutResponseModelExtended(shurjopayCheckoutResponseModel: nil, error: true, message: "Something went wrong."))
                }
            }
        }
        task.resume();
        
    }
    
    public func verify(shurjopayOrderID: String, completion: @escaping (ShurjopayVerificationModel) -> Void){
        var request = URLRequest(url: URL(string: "\(baseURL)/verification")!)
        let payload : [String: Any] = ["order_id": shurjopayOrderID]
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(tokenType) \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        
        print(token)
        print(shurjopayOrderID)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            let decoder = JSONDecoder()
            
            if error != nil{
                completion(ShurjopayVerificationModel(id: nil, order_id: nil, customer_order_id: nil, amount: nil, payable_amount: nil, received_amount: nil, discount_amount: nil, disc_percent: nil, usd_amt: nil, name: nil, email: nil, phone_no: nil, city: nil, address: nil, card_holder_name: nil, card_number: nil, bank_trx_id: nil, bank_status: nil, transaction_status: nil, method: nil, invoice_no: nil, date_time: nil, value1: nil, value2: nil, value3: nil, value4: nil, sp_code: nil, sp_message: "Something went wrong.", error: true))
            }
            if let data = data{
                do {
                    if(self.environment == "live")
                    {
                        var verificationData = try decoder.decode([VerificationDataLive].self, from: data)
                        if(verificationData != nil && verificationData.first != nil)
                        {
                            completion(ShurjopayVerificationModel(id: verificationData.first?.id, order_id: verificationData.first?.order_id, customer_order_id: verificationData.first?.customer_order_id, amount: verificationData.first?.amount, payable_amount: verificationData.first?.payable_amount, received_amount: verificationData.first?.received_amount, discount_amount: verificationData.first?.discount_amount, disc_percent: verificationData.first?.disc_percent, usd_amt: verificationData.first?.usd_amt, name: verificationData.first?.name, email: verificationData.first?.email, phone_no: verificationData.first?.phone_no, city: verificationData.first?.city, address: verificationData.first?.address, card_holder_name: verificationData.first?.card_holder_name, card_number: verificationData.first?.card_number, bank_trx_id: verificationData.first?.bank_trx_id, bank_status: verificationData.first?.bank_status, transaction_status: verificationData.first?.transaction_status, method: verificationData.first?.method, invoice_no: verificationData.first?.invoice_no, date_time: verificationData.first?.date_time, value1: verificationData.first?.value1, value2: verificationData.first?.value2, value3: verificationData.first?.value3, value4: verificationData.first?.value4, sp_code: verificationData.first?.sp_code, sp_message: verificationData.first?.sp_message, error: false))
                        }
                        else
                        {
                            completion(ShurjopayVerificationModel(id: nil, order_id: nil, customer_order_id: nil, amount: nil, payable_amount: nil, received_amount: nil, discount_amount: nil, disc_percent: nil, usd_amt: nil, name: nil, email: nil, phone_no: nil, city: nil, address: nil, card_holder_name: nil, card_number: nil, bank_trx_id: nil, bank_status: nil, transaction_status: nil, method: nil, invoice_no: nil, date_time: nil, value1: nil, value2: nil, value3: nil, value4: nil, sp_code: nil, sp_message: "Something went wrong.", error: true))
                        }
                    }
                    else
                    {
                        var verificationData = try decoder.decode([VerificationDataDev].self, from: data)
                        if(verificationData != nil && verificationData.first != nil)
                        {
                            var amount = verificationData.first?.amount != nil ? String(verificationData.first!.amount!) : "0"
                            var payableAmount = verificationData.first?.payable_amount != nil ? String(verificationData.first!.payable_amount!) : "0"
                            var discountAmount = verificationData.first?.discount_amount != nil ? String(verificationData.first!.discount_amount!) : "0"
                            var usdAmount = verificationData.first?.usd_amt != nil ? String(verificationData.first!.usd_amt!) : "0"
                            var spCode = verificationData.first?.sp_code != nil ? String(verificationData.first!.sp_code!) : nil
                            completion(ShurjopayVerificationModel(id: verificationData.first?.id, order_id: verificationData.first?.order_id, customer_order_id: verificationData.first?.customer_order_id, amount: amount, payable_amount: payableAmount, received_amount: verificationData.first?.received_amount, discount_amount: discountAmount, disc_percent: verificationData.first?.disc_percent, usd_amt: usdAmount, name: verificationData.first?.name, email: verificationData.first?.email, phone_no: verificationData.first?.phone_no, city: verificationData.first?.city, address: verificationData.first?.address, card_holder_name: verificationData.first?.card_holder_name, card_number: verificationData.first?.card_number, bank_trx_id: verificationData.first?.bank_trx_id, bank_status: verificationData.first?.bank_status, transaction_status: verificationData.first?.transaction_status, method: verificationData.first?.method, invoice_no: verificationData.first?.invoice_no, date_time: verificationData.first?.date_time, value1: verificationData.first?.value1, value2: verificationData.first?.value2, value3: verificationData.first?.value3, value4: verificationData.first?.value4, sp_code: spCode, sp_message: verificationData.first?.sp_message, error: false))
                        }
                        else
                        {
                            completion(ShurjopayVerificationModel(id: nil, order_id: nil, customer_order_id: nil, amount: nil, payable_amount: nil, received_amount: nil, discount_amount: nil, disc_percent: nil, usd_amt: nil, name: nil, email: nil, phone_no: nil, city: nil, address: nil, card_holder_name: nil, card_number: nil, bank_trx_id: nil, bank_status: nil, transaction_status: nil, method: nil, invoice_no: nil, date_time: nil, value1: nil, value2: nil, value3: nil, value4: nil, sp_code: nil, sp_message: "Something went wrong.", error: true))
                        }
                        
                    }
                } catch{
                    completion(ShurjopayVerificationModel(id: nil, order_id: nil, customer_order_id: nil, amount: nil, payable_amount: nil, received_amount: nil, discount_amount: nil, disc_percent: nil, usd_amt: nil, name: nil, email: nil, phone_no: nil, city: nil, address: nil, card_holder_name: nil, card_number: nil, bank_trx_id: nil, bank_status: nil, transaction_status: nil, method: nil, invoice_no: nil, date_time: nil, value1: nil, value2: nil, value3: nil, value4: nil, sp_code: nil, sp_message: "Something went wrong.", error: true))
                }
            }
        }
        task.resume();
    }
}

extension UIViewController{
    func loader()-> UIAlertController{
        let alert = UIAlertController(title: nil, message:  "Please wait..." , preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true)
        return alert
    }
    
    func stopLoader(loader:UIAlertController){
       loader.dismiss(animated: true)
    }
}
