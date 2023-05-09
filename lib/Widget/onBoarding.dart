import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 100, 136, 238),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _pageIndex = index;
                    });
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, index) => OnBoardContent(
                        image: pages[index].image,
                        title: pages[index].title,
                        description: pages[index].description,
                      )),
            ),
            Row(
              children: [
                ...List.generate(
                    pages.length,
                    (index) => Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: DotIndicator(
                            isActive: index == _pageIndex,
                          ),
                        )),
                const Spacer(),
                SizedBox(
                  height: 60,
                  width: 60,
                  child: ElevatedButton(
                      onPressed: () {
                        _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease);
                        if (_pageIndex == 2) {
                          Navigator.of(context).pushReplacementNamed('Login');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Colors.white70),
                      child: Icon(
                        FontAwesomeIcons.arrowRight,
                        color: Colors.black,
                      )),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
  });

  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(microseconds: 300),
      height: isActive ? 12 : 4,
      width: 4,
      decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white.withOpacity(0.4),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }
}

class onBoard {
  final String image, title, description;

  onBoard(this.image, this.title, this.description);
}

final List<onBoard> pages = [
  onBoard(
    "assets/1.png",
    "VISIT OUR \nONLINE SHOP",
    "We have millions of one-of-a-kind items, so you can find whatever you need for you or anyone you love",
  ),
  onBoard(
    "assets/2.png",
    "CHOOSE WHAT \nYOU WANT",
    "Buy directly from our sellers who put their heart and soul into making something special",
  ),
  onBoard(
    "assets/3.png",
    "PLACE YOUR \nORDER",
    "We use the best-in-class technology to protect any of your transaction on our website",
  )
];

class OnBoardContent extends StatelessWidget {
  const OnBoardContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image, title, description;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Image.asset(
          image,
          height: 400,
          width: 400,
        ),
        const Spacer(),
        Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 25,
                fontFamily: 'CodecWarm')),
        const SizedBox(
          height: 16,
        ),
        Text(
          description,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const Spacer(
          flex: 5,
        ),
      ],
    );
  }
}
