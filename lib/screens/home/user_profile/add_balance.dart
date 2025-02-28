import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:zesty/utils/constants/zesty_money.dart';

class AddBalance extends StatefulWidget {
  const AddBalance({super.key});

  @override
  State<AddBalance> createState() => _AddBalanceState();
}

class _AddBalanceState extends State<AddBalance> {
  final TextEditingController _amountController = TextEditingController();
  int? _selectedAmount;
  late Razorpay _razorpay;

  void _updatedAmount(int amount){
    setState(() {
      _selectedAmount = amount;
      _amountController.text = amount.toString();
    });
  }

  void openCheckout(amount) async {
    amount = amount * 100;
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': amount,
      'name': 'Zesty',
      'prefill': {'contact': '1234567890', 'email': 'test@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> handlePaymentSuccess(PaymentSuccessResponse res) async {
    // ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
    //   content: new Text("Payment Successfull"),
    // ));
    setState(() {
      ZestyMoney.walletAmount += int.parse(_amountController.text);
    });
    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ZestyMoney.walletAmount.toString())));
  }

  void handlePaymentFailure(PaymentFailureResponse res) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text("Payment Fail, Something went to wrong!" ),
    ));
  }

  void handleExternalWallet(ExternalWalletResponse res) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text("External Wallet, Something went to wrong!"),
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedAmount = 250;
    _updatedAmount(250);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Add Balance",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Text("Available balance: ₹${ZestyMoney.walletAmount}",style: TextStyle(color: TColors.darkerGrey,fontSize: 14),),
              SizedBox(height: 13,),
              Card(
                color: TColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
                ),
                elevation: 2,
                child: Padding(padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Enter Amount :",style: TextStyle(color: TColors.black,fontSize: 14),),
                      SizedBox(height: 8,),
                      TextField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          prefixText: "₹ ",
                          prefixStyle: TextStyle(fontSize: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _amountButton(250),
                          _amountButton(500),
                          _amountButton(2000),
                          _amountButton(5000),
                        ],
                      ),
                      SizedBox(height: 12,),
                    ],
                  ),
                ),
              ),
        
              SizedBox(height: 16,),
              Card(
                color: TColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Note:",style: TextStyle(color: TColors.darkGreen,fontWeight: FontWeight.bold),),
                      SizedBox(height: 8,),
                      _noteItem("Zesty Money balances are valid for 1 year from credit on Zesty."),
                      _noteItem("Zesty Money cannot be transferred to your bank account as per RBI fuidelines."),
                      _noteItem("Zesty Money can be used for food deliveries and Zestymart."),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 170,),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(onPressed: (){
                  int amount = int.parse(_amountController.text);
                  openCheckout(amount);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.darkGreen,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                    child: Text("Proceed to Add Balance",style: TextStyle(fontSize: 16,color: Colors.white),)),
              ),
              SizedBox(height: 16,),
            ],
          ),
        ),
      ),
    );
  }

  Widget _amountButton(int amount){
    return GestureDetector(
      onTap: () => _updatedAmount(amount),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12,horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _selectedAmount == amount ? TColors.darkGreen : Colors.grey.shade300),
          color: _selectedAmount == amount ? Color(0xffcae97c).withOpacity(0.2) : Colors.white
        ),
        child: Column(
          children: [
            Text("₹$amount",style: TextStyle(fontSize: 13,color: _selectedAmount == amount ? TColors.darkGreen : Colors.black),),
            // if(amount == 500)
            //   Padding(padding: EdgeInsets.only(top: 2),
            //     child: Container(
            //       decoration: BoxDecoration(
            //         color: Colors.red,
            //         borderRadius: BorderRadius.circular(6),
            //       ),
            //       child: Text("Most Popular",style: TextStyle(color: Colors.white,fontSize: 10),),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
  
  Widget _noteItem(String text){
    return Padding(padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(Icons.circle,size: 8,color: Colors.black,),
          ),
          SizedBox(width: 8,),
          Expanded(child: Text(text,style: TextStyle(fontSize: 14,color: TColors.darkerGrey),)),
        ],
      ),
    );
  }
}
