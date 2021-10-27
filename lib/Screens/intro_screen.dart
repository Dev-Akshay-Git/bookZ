import 'package:bookz/Screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnboardingPages();
  }
}

class OnboardingPages extends StatelessWidget {
  const OnboardingPages({Key? key}) : super(key: key);
  List<PageViewModel> getPages(BuildContext context) {
    return [
      PageViewModel(
        titleWidget: Text(
          "BookZ",
          style: GoogleFonts.lobster(
              textStyle: TextStyle(
                  color: Color.fromRGBO(237, 128, 38, 1),
                  fontSize: 32,
                  fontWeight: FontWeight.bold)),
        ),
        bodyWidget: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              "This is book repository and online reading application",
              style: GoogleFonts.poppins(fontSize: 21),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
          ],
        )),
      ),
      PageViewModel(
        image: Center(
            child: Image.asset(
          'assets/images/43122.jpg',
          fit: BoxFit.cover,
        )),
        titleWidget: Text(
          "About the Application",
          style: GoogleFonts.poppins(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        bodyWidget: RichText(
          text: TextSpan(
            text:
                """This is a Demo Application where you can read, buy and review the books. Therefore there is no sign up option and please sign in using email:""",
            style: GoogleFonts.poppins(fontSize: 18, color: Colors.black38),
            children: const <TextSpan>[
              TextSpan(
                  text: ' hpe@hpe.com',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ' and password:'),
              TextSpan(
                  text: ' hpe1234"',
                  style: TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
        ),
        /*Text(
            """This is a Demo Application where you can read, buy and review the books. Therefore there is no sign up option and please sign in using email: hpe@hpe.com and password: hpe1234""",
            style: GoogleFonts.poppins(fontSize: 18)),*/
        footer: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
            child: Text(
              'Get Started',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'CircularStd',
              ),
            ),
          ),
          style: TextButton.styleFrom(
              backgroundColor: Color.fromRGBO(237, 128, 38, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              )),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: getPages(context),
        showNextButton: true,
        next: Text(
          "Next",
        ),
        showDoneButton: false,
        globalBackgroundColor: Colors.white,
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          activeColor: Color.fromRGBO(237, 128, 38, 1),
          color: Color.fromRGBO(237, 128, 38, 0.3),
          activeSize: Size(30.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
      ),
    );
  }
}
