import 'package:flutter/material.dart';

class DonationQRCodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 36, color: Colors.black),
                ),
              ),
              SizedBox(height: 30),

              //  Heading
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: "Please scan the "),
                      TextSpan(
                        text: "QR code",
                        style: TextStyle(color: Colors.red),
                      ),
                      TextSpan(text: " to donate"),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 80),

              //  QR code image
              Transform.scale(
                scale: 0.9,
                child: Image.asset(
                  'images/nets_qr.png',
                  height: 280,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: 50),

              //timer
              Text(
                "05:00",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),

              //  guide image
              Image.asset('images/nets_guide.png', fit: BoxFit.contain),
            ],
          ),
        ),
      ),
    );
  }
}
