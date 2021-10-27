import 'package:bookz/bloc/login_bloc.dart';
import 'package:bookz/widgets/custom_text_widget.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(create: (_) => loginBloc(), child: LoginScreenData());
  }
}

class LoginScreenData extends StatelessWidget {
  bool isPressed = false, inValid = false;
  //store user input number
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<loginBloc>(context);
    return Provider<loginBloc>(
        create: (_) => loginBloc(),
        builder: (BuildContext context, identifier) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "BookZ",
                style: GoogleFonts.lobster(
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold)),
              ),
              backgroundColor: Color.fromRGBO(237, 128, 38, 1),
            ),
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.only(left: 20, top: 40, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //logo from local assets folder
                    const SizedBox(
                      height: 50,
                    ),
                    CustomText(
                      text: "Welcome",
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(237, 128, 38, 1),
                    ),
                    CustomText(
                      text: "Sign in to continue to your Account",
                      fontSize: 21,
                      fontWeight: FontWeight.w400,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    //Text Field
                    userNameField(bloc),
                    const SizedBox(
                      height: 30,
                    ),
                    passwordsField(bloc),
                    const SizedBox(
                      height: 30,
                    ),
                    Visibility(
                        visible: inValid,
                        child: CustomText(
                          color: Colors.red,
                          text: "User not found",
                        )),
                    SignInButton(bloc),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: CustomText(
                        text: "Don't You have an Account?",
                        fontSize: 18,
                      ),
                    ),
                    Center(
                      child: InkWell(
                          child: CustomText(
                            text: "Sign Up",
                            fontSize: 16,
                          ),
                          //navigate to Sign Up page
                          onTap:
                              () {} /*Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()),*/
                          ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget userNameField(loginBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.userEmail,
        builder: (context, snapshot) {
          return TextField(
            onChanged: bloc.changeUserName,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              errorText: (snapshot.error.toString() == 'null')
                  ? null
                  : snapshot.error.toString(),
              prefixIcon: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.person),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(116, 169, 56, 0.7),
                ),
              ),
              contentPadding: EdgeInsets.all(10),
              hintText: 'User Name',
              hintStyle: const TextStyle(
                color: Color.fromRGBO(179, 179, 179, 1),
                fontSize: 16,
              ),
            ),
          );
        });
  }

  Widget passwordsField(loginBloc bloc) {
    return StreamBuilder<String>(
        stream: bloc.password,
        builder: (context, snapshot) {
          return TextField(
            obscureText: true,
            onChanged: bloc.changePassword,
            maxLength: 15,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              errorText: (snapshot.error.toString() == 'null')
                  ? null
                  : snapshot.error.toString(),
              prefixIcon: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.password),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(116, 169, 56, 0.7),
                ),
              ),
              contentPadding: EdgeInsets.all(10),
              hintText: 'Password',
              hintStyle: const TextStyle(
                color: Color.fromRGBO(179, 179, 179, 1),
                fontSize: 16,
              ),
            ),
          );
        });
  }

  Widget SignInButton(loginBloc bloc) {
    return StreamBuilder<bool>(
        stream: bloc.fieldsValid,
        builder: (context, snapshot) {
          return ElevatedButton(
            onPressed: !snapshot.hasData
                ? null
                : () {
                    isPressed = true;
                    _checkConnectivity(context);
                    try {
                      bloc.SubmitButton(context);
                    } catch (e) {
                      print(e);
                    }
                  }, //To be implemented sign in bloc
            child: snapshot.connectionState == ConnectionState.waiting &&
                    snapshot.hasData
                ? (isPressed ? const CircularProgressIndicator() : SignInText())
                : SignInText(),
            style: ElevatedButton.styleFrom(
              primary: Color.fromRGBO(237, 128, 38, 1),
              minimumSize: Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          );
        });
  }

  Widget SignInText() {
    return CustomText(
      text: "Login",
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
  }

  _checkConnectivity(BuildContext context) async {
    var con = await Connectivity().checkConnectivity();
    if (con == ConnectivityResult.none) {
      _showDialog("No Internet Connection",
          "Please Connect to the internet and then login", context);
    }
  }

  _showDialog(title, text, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: CustomText(
              text: title,
              fontWeight: FontWeight.bold,
            ),
            content: CustomText(
              text: text,
              fontSize: 18,
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: CustomText(text: "OK"),
              )
            ],
          );
        });
  }
}
