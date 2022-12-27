import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_app/controllers/authentication_controller.dart';
import 'package:flutter_app/controllers/providers/connection_provider.dart';
import 'package:flutter_app/controllers/providers/user_provider.dart';
import 'package:flutter_app/controllers/user_controller.dart';
import 'package:flutter_app/screens/authentication/otp_screen.dart';
import 'package:flutter_app/screens/common/components/modal_progress_hud.dart';
import 'package:flutter_app/screens/home_screen/screens/main_page.dart';
import 'package:flutter_app/utils/SizeConfig.dart';
import 'package:flutter_app/utils/my_print.dart';
import 'package:flutter_app/utils/snakbar.dart';
import 'package:flutter_app/utils/styles.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/LoginScreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isFirst = true, isLoading = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController? mobileController;

  void signInWithGoogle() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    User? user = await AuthenticationController().signInWithGoogle(context);

    if (user != null) {
      onSuccess(user);
    }
    else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> onSuccess(User user) async {
    MyPrint.printOnConsole("Login Screen OnSuccess called");

    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.userid = user.uid;
    userProvider.firebaseUser = user;

    MyPrint.printOnConsole("Email:${user.email}");
    MyPrint.printOnConsole("Mobile:${user.phoneNumber}");

    bool isExist = await UserController().isUserExist(context, userProvider.userid);

    setState(() {
      isLoading = false;
    });

    print("User Exist");
    Navigator.pushNamedAndRemoveUntil(context, MainPage.routeName, (route) => false);
  }

  void sendOtp() {
    ConnectionProvider connectionProvider = Provider.of<ConnectionProvider>(context, listen: false);

    if (connectionProvider.isInternet) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        // if all are valid then go to success screens
        Navigator.pushNamed(context, OtpScreen.routeName, arguments: "+91" + mobileController!.text);
      }
    }
    else {
      Snakbar().showErrorSnakbar(context: context, error_message: "No Internet");
    }

  }

  @override
  void initState() {
    mobileController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    MyPrint.printOnConsole("LoginScreen called");

    MySize().init(context);

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      color: Colors.black,
      progressIndicator: Container(
        padding: EdgeInsets.all(MySize.size100!),
        child: Center(
          child: Container(
            height: MySize.size90,
            width: MySize.size90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(MySize.size10!),
              color: Colors.white,
            ),
            child: SpinKitFadingCircle(color: Styles.primaryColor,),
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.only(top: 0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          getLogo(),
                          getLoginText(),
                          getLoginText2(),
                          getMobileTextField(),
                          getContinueButton(),
                          getOrText(),
                          getLoginWithGoogleButton(),
                          //getTermsAndConditionsLink(),
                        ],
                      ),
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

  Widget getLogo() {
    return Container(
      margin: EdgeInsets.only(bottom: MySize.size34!),
      width: MySize.size100!,
      height: MySize.size100!,
      child: Image.asset("assets/logo.png"),
    );
  }

  Widget getLoginText() {
    return InkWell(
      onTap: ()async{

      },
      child: Container(
        margin: EdgeInsets.only(left: MySize.size16!, right: MySize.size16!),
        child: Center(
          child: Text(
            "Log In",
            style: TextStyle(
              fontSize: MySize.size26!,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget getLoginText2() {
    return Container(
      margin: EdgeInsets.only(left: MySize.size48!, right: MySize.size48!, top: MySize.size40!),
      child: Text(
        "Enter your login details to access your account",
        softWrap: true,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            height: 1.2,
            color: Styles.onBackground.withAlpha(200)),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget getMobileTextField() {
    return Container(
      margin: EdgeInsets.only(left: MySize.size24!, right: MySize.size24!, top: MySize.size36!),
      child: Container(
        decoration: BoxDecoration(
          color: Styles.background.withAlpha(100),
          borderRadius: BorderRadius.all(Radius.circular(MySize.size16!)),
          boxShadow: [
            BoxShadow(
                blurRadius: 8.0,
                color: Colors.black.withOpacity(0.4).withAlpha(25),
                offset: Offset(0, 3)),
          ],
        ),
        child: TextFormField(
          controller: mobileController,
          style: const TextStyle(
            letterSpacing: 0.1,
            color: Styles.onBackground,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: "Enter Mobile Number",
            hintStyle: TextStyle(
              letterSpacing: 0.1,
              color: Styles.onBackground.withAlpha(180),
              fontWeight: FontWeight.w500,
            ),
            prefixText: "+91 ",
            prefixStyle: TextStyle(
              letterSpacing: 0.1,
              color: Styles.onBackground.withAlpha(180),
              fontWeight: FontWeight.w500,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              borderSide: BorderSide(color: Styles.onBackground),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0),),
              borderSide: BorderSide(color: Styles.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              borderSide: BorderSide(color: Styles.grey),
            ),
            filled: true,
            fillColor: Styles.background,
            prefixIcon: Icon(
              Icons.phone,
              size: 22,
              color: Styles.onBackground.withAlpha(200),
            ),
            isDense: true,
            contentPadding: EdgeInsets.all(0),
          ),
          keyboardType: TextInputType.number,
          autofocus: false,
          textCapitalization: TextCapitalization.sentences,
          inputFormatters: [
            LengthLimitingTextInputFormatter(10),
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (val) {
            if(val == null || val.isEmpty) {
              return "Mobile Number Cannot be empty";
            }
            else {
              if (RegExp(r"^[0-9]{10}").hasMatch(val)) {
                return null;
              }
              else {
                return "Invalid Mobile Number";
              }
            }
          },
        ),
      ),
    );
  }

  Widget getTermsAndConditionsLink() {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        margin: EdgeInsets.only(top: MySize.size16!),
        child: Center(
          child: Text(
            "Terms and Conditions",
            style: TextStyle(
                decoration: TextDecoration.underline),
          ),
        ),
      ),
    );
  }

  Widget getContinueButton() {
    return Container(
      margin: EdgeInsets.only(left: MySize.size24!, right: MySize.size24!, top: MySize.size36!),
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.all(Radius.circular(MySize.size48!)),
      ),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(MySize.size16!)),
        color: Styles.primaryColor,
        highlightColor: Styles.primaryColor,
        splashColor: Colors.white.withAlpha(100),
        padding: EdgeInsets.only(top: MySize.size16!, bottom: MySize.size16!),
        onPressed: sendOtp,
        child: Stack(
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          children: <Widget>[
            const Align(
              alignment: Alignment.center,
              child: Text(
                "CONTINUE",
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Positioned(
              right: 16,
              child: ClipOval(
                child: Container(
                  color: Colors.white,
                  // button color
                  child: SizedBox(
                      width: MySize.size30,
                      height: MySize.size30,
                      child: Icon(
                        Icons.arrow_forward,
                        color: Styles.primaryColor,
                        size: MySize.size18,
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getOrText() {
    return Container(
      margin: EdgeInsets.only(left: MySize.size48!, right: MySize.size48!, top: MySize.size40!),
      child: Text(
        "Or",
        softWrap: true,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            height: 1.2,
            color: Styles.onBackground.withAlpha(200)),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget getLoginWithGoogleButton() {
    return InkWell(
      onTap: signInWithGoogle,
      child: Container(
        margin: EdgeInsets.only(left: MySize.size24!, right: MySize.size24!, top: MySize.size36!),
        decoration: BoxDecoration(
          color: Styles.primaryColor,
          borderRadius: BorderRadius.circular(MySize.size10!),
          boxShadow: [
            BoxShadow(
              color: Styles.primaryColor.withAlpha(100),
              blurRadius: 5,
              offset: Offset(
                  0, 5), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(MySize.size8!),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(MySize.size10!,),
                color: Colors.white,
              ),
              child: Image.asset("assets/google logo.png", width: MySize.size30, height: MySize.size30,),
            ),
            Expanded(
              child: Text(
                "Sign in With Google",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
