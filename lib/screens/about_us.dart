import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('About Us'),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 72, 114, 50),
                Color.fromARGB(255, 32, 77, 44)
              ],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/basura_bot_text.png',
                      width: 80,
                      height: 80,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'MORE ABOUT US',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'KalaKalikasan is your partner in sustainable waste management, designed to make recycling easy, rewarding, and impactful.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Our app empowers local governments and residents to participate in eco-friendly practices through a Coin-Based incentive system with an IOT and Mobile Application for sustainable Waste Management.',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'With features like QR code transactions and IOT, we’re creating a culture of environmental stewardship that supports local government waste management goals.',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'KalaKalikasan is more than an app—it’s a movement for a cleaner, greener future. Join us in making a positive impact on our planet, one recyclable at a time.',
                  style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 25),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
