import 'package:etors/Service/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            LineAwesomeIcons.angle_left,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "FAQ",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: CustomText(
                text: "What is Etors?",
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: FaqText(
                text:
                    "Etors is an ecommerce app that allows users to buy and sell products conveniently through their mobile devices. It provides a platform for individuals and businesses to connect and engage in online commerce.",
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: CustomText(
                text: "How do I get started with Etors?",
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: FaqText(
                text:
                    "To get started with Etors, simply download the app from the App Store or Google Play Store, create an account, and start exploring products or listing your own for sale.",
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: CustomText(
                text: "Is it free to use Etors?",
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: FaqText(
                text:
                    "Yes, downloading and using Etors is free. However, there may be fees associated with certain features or services, such as listing enhancements or promotional options. These fees will be clearly indicated within the app.",
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: CustomText(
                text: "How can I buy a product on Etors?",
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: FaqText(
                text:
                    "To buy a product on Etors, search for the item you're interested in, browse the available listings, and select the one that suits your needs. Once you've found the desired product, simply proceed to the checkout process and follow the prompts to complete your purchase.",
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: CustomText(
                text: "How can I sell a product on Etors?",
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: FaqText(
                text:
                    "To sell a product on Etors, go to your account dashboard, select the option to <List a Product> and provide all the necessary details such as title, description, category, price, and images. Once your listing is complete, it will be visible to potential buyers.",
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: CustomText(
                text: "How are payments handled on Etors?",
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: FaqText(
                text:
                    "Etors supports secure payment methods, including credit cards, debit cards, and digital wallets. The app integrates with trusted third-party payment gateways to ensure the safety of transactions. Payments are processed securely, and sellers receive their funds directly to their designated account.",
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: CustomText(
                text: "Can I negotiate the price with sellers?",
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: FaqText(
                text:
                    "Etors encourages communication between buyers and sellers. You can use the in-app messaging feature to discuss product details, negotiate prices, and ask questions before making a purchase. However, the final decision on price adjustments lies with the seller.",
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: CustomText(
                text: "How are disputes or issues with purchases resolved?",
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: FaqText(
                text:
                    "Etors provides a resolution center to help resolve any disputes or issues that may arise between buyers and sellers. If you encounter a problem with your purchase, you can open a dispute and provide relevant information. Our support team will review the case and work towards a fair resolution.",
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: CustomText(
                text: "How are disputes or issues with purchases resolved?",
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: FaqText(
                text:
                    "Etors provides a resolution center to help resolve any disputes or issues that may arise between buyers and sellers. If you encounter a problem with your purchase, you can open a dispute and provide relevant information. Our support team will review the case and work towards a fair resolution.",
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: CustomText(
                text: "Is shipping available on Etors?",
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: FaqText(
                text:
                    "Yes, Etors supports shipping for products. Sellers can choose to offer shipping services themselves or opt for integrated shipping providers. The available shipping options and costs will be displayed during the checkout process.",
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: CustomText(
                text: "Is there a rating system for sellers?",
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: FaqText(
                text:
                    "Yes, Etors incorporates a rating and review system. After completing a purchase, buyers have the opportunity to rate and provide feedback on their experience with the seller. This helps build a reliable community and provides valuable information to other users.",
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: CustomText(
                text: "How can I contact Etors customer support?",
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: FaqText(
                text:
                    "If you have any questions, issues, or need assistance, you can reach Etors customer support through the app's Help Center or by emailing support@etorsapp.com. Our support team is dedicated to providing prompt and helpful assistance.",
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
