# ![image](https://user-images.githubusercontent.com/57352037/155895117-523cfb9e-d895-47bf-a962-2bcdda49ad66.png) iOS swift package

Official shurjoPay iOS swift package for merchants or service providers to connect with [**_shurjoPay_**](https://shurjopay.com.bd) Payment Gateway developed and maintained by [_**ShurjoMukhi Limited**_](https://shurjomukhi.com.bd).

**Shurjopay** swift package makes the payment system easier for you with just two method calls:

- `makePayment()`
- `verify()`

And that's all! To know more about its usage please check the details below.

## How to add in your Xcode project?

1. Navigate the File tab within the macOS bar, and click on “Add Packages”.
2. On the search bar enter the github repository link of the Shurjopay swift package.
3. Click on Add Package button.

Thats it! Now we are ready to use the package.

## Usage

- First create an object of Shurjopay.

```swift
  let shurjopay : Shurjopay = Shurjopay()
```

- Then prepare payment request model.

```swift
  let requestModel : ShurjopayRequestModel = ShurjopayRequestModel(
            configs: ShurjopayConfigs(
                environment: "sandbox",
                userName: "sp_sandbox",
                password: "pyyk97hu&6u6",
                prefix: "sp",
                clientIP: "127.0.0.1"
            ),
            orderID: "sp1ab2c3d5",
            currency: "BDT",
            amount: 20,
            discountAmount: 0,
            discountPercentage: 0,
            customerName: "Shajedul Islam",
            customerPhoneNumber: "01628734916",
            customerAddress: "30/4 Darus Salam Road",
            customerCity: "Dhaka",
            customerPostcode: "1216",
            returnURL: "https://www.sandbox.shurjopayment.com/return_url",
            cancelURL: "https://www.sandbox.shurjopayment.com/cancel_url"
        )
```

- Now we can call makePayment method to initiate the payment.

```swift
  shurjopay.makePayment(parentUIViewController: self,  shurjopayRequestModel: requestModel)
  { 
    shurjopayResponse in
    YOUR_CODE
  }
```

- To verify payment we have to call verify().

```swift
  if(shurjopayResponse.status == true && shurjopayResponse.shurjopayOrderID != nil)
      shurjopay.verify(shurjopayOrderID: spOrderID!)
      { 
        shurjopayVerificationModel in
        YOUR_CODE
      }
  }
```

<br>
That's all! Now you are ready to use our shurjoPay swift package to make your payment system easy and smooth.
