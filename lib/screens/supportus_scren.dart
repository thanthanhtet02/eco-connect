import 'package:flutter/material.dart';

class SupportUsScreen extends StatefulWidget {
  @override
  _SupportUsScreenState createState() => _SupportUsScreenState();
}

class _SupportUsScreenState extends State<SupportUsScreen> {
  final Color greenColor = Color(0xFF57DE45);
  String? selectedAmount;
  final TextEditingController customAmountController =
      TextEditingController(); //to see the texted amount in the box

  void selectAmount(String amount) {
    //select preset amount and clear the custom amount
    setState(() {
      selectedAmount = amount;
      customAmountController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, size: 35, color: Colors.black),
                  ),
                  SizedBox(width: 40),
                ],
              ),
              SizedBox(height: 30),

              //header thank you message
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(text: "Thanks for Keeping "),
                    TextSpan(text: "Eco", style: TextStyle(color: greenColor)),
                    TextSpan(text: "Connect \nRunning !!!"),
                  ],
                ),
              ),
              SizedBox(height: 80),

              // Instruction message to donate
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(text: "Choose amount to "),
                    TextSpan(
                      text: "donate",
                      style: TextStyle(color: Colors.red),
                    ),
                    TextSpan(text: " us\nVia "),
                    TextSpan(text: "N", style: TextStyle(color: Colors.red)),
                    TextSpan(
                      text: "E",
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 92, 167),
                      ),
                    ),
                    TextSpan(text: "TS", style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),

              SizedBox(height: 40),

              // presetted amount of donation
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _amountBox("5\$"),
                  SizedBox(width: 40),
                  _amountBox("10\$"),
                  SizedBox(width: 40),
                  _amountBox("20\$"),
                ],
              ),

              SizedBox(height: 45),

              // Custom amount input
              Container(
                alignment: Alignment.centerLeft,

                width: 250,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF57DE45), width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: customAmountController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Enter Custom Amount",
                    hintStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 30),

              // Proceed Button
              Container(
                width: 170,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    final amount =
                        selectedAmount ?? customAmountController.text;
                    if (amount.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Please select or enter an amount"),
                        ),
                      );
                      return;
                    }
                    Navigator.pushNamed(context, '/qr'); //  Go to QR screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Proceed",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //widget to diaply amount box
  Widget _amountBox(String amountText) {
    final isSelected = selectedAmount == amountText;
    return GestureDetector(
      onTap: () => selectAmount(amountText),
      child: Container(
        width: 80,
        height: 35,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? greenColor.withOpacity(0.1) : null,
          border: Border.all(color: greenColor, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          amountText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isSelected ? greenColor : Colors.black,
          ),
        ),
      ),
    );
  }
}
