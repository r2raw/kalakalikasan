import 'package:flutter/material.dart';

class TermsAndCondition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Terms and condition'),
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
                      'Terms & Condition',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Welcome to KalaKalikasan! These Terms and Conditions govern your use of the KalaKalikasan Mobile Application, operated by Barangay Batasan Hills. By downloading, accessing, or using the App, you agree to comply with and be bound by these Terms. If you do not agree, please refrain from using the App.",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "User Eligibility",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "The App is available to users who:\n- Are at least 18 years old or have the consent of a parent or guardian. \n- Agree to use the App in compliance with applicable laws and regulations.",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Account Registration",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "To access certain features of the App, you may need to create an account. By creating an account, you agree to:\n- Provide accurate and up-to-date information.\n- Maintain the confidentiality of your login credentials.\n- Notify us immediately of any unauthorized use of your account.",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "We reserve the right to suspend or terminate accounts that violate these Terms.",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Acceptable Use",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "You agree to use the App only for its intended purpose of promoting sustainable waste management. Prohibited activities include, but are not limited to:\n- Uploading or sharing false, misleading, or inappropriate content.\n- Interfering with the App’s functionality or attempting unauthorized access.\n- Using the App for illegal or unethical purposes.",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Data Collection and Privacy",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "Your use of the App is subject to our Privacy Policy, which explains how we collect, use, and protect your personal information. By using the App, you consent to the practices described in the Privacy Policy.",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Intellectual Property",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "All content, trademarks, logos, and other intellectual property in the App are owned by us or our licensors. You may not use, reproduce, or distribute any part of the App without our prior written permission.",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Third-Party Services",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "The App may integrate or link to third-party services. We are not responsible for the content, policies, or practices of these third-party services. Use them at your own risk.",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Rewards and Incentives",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "The App may offer rewards or incentives for participation in waste management activities. These rewards are subject to:\n- Availability and conditions outlined in the App.\n- Modification or discontinuation at our discretion.",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Disclaimer of Warranties",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "The App is provided on an 'as is' and 'as available' basis. We do not guarantee that the App will be error-free, secure, or uninterrupted. Your use of the App is at your own risk.",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Limitation of Liability",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "To the fullest extent permitted by law, we are not liable for any direct, indirect, incidental, or consequential damage arising from your use of the App.",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Termination",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "We reserve the right to suspend or terminate your access to the App at any time, with or without notice, for any reason, including violation of these Terms.",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Amendments",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "We may update these Terms from time to time. Changes will be effective upon posting in the App. Continued use of the App signifies your acceptance of the updated Terms.",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Governing Law",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "These Terms are governed by and construed in accordance with the laws of the Republic of the Philippines. Any disputes shall be resolved in the courts of Quezon City.",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Contact Us",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "For questions or concerns about these Terms, please contact us at: \n\nEmail: kalakalikasan.mail@gmail.com",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 80,
                ),
                Text(
                  "Thank you for supporting sustainable waste management through KalaKalikasan!",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
