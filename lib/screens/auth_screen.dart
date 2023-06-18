import 'package:child_io/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../widgets/input_widget.dart';

class AuthHome extends StatefulWidget {
  @override
  _AuthHomeState createState() => _AuthHomeState();
}

class _AuthHomeState extends State<AuthHome> {
  bool _isLoading = false;
  final _authHomeKey = GlobalKey<FormState>();

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String userEmail = "";
  String userPass = "";
  String firstName = "";
  String lastName = "";
  bool wantSignup = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _passwordController.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    void validate() async {
      if (!_authHomeKey.currentState!.validate()) {
        return;
      }
      _authHomeKey.currentState!.save();
      if (!wantSignup) {
        setState(() {
          _isLoading = true;
        });
        await context.read<AuthProvider>().login(
              ctx: context,
              email: userEmail,
              password: userPass,
            );
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = true;
        });
        await context.read<AuthProvider>().register(
              ctx: context,
              firstName: firstName,
              lastName: lastName,
              email: userEmail,
              password: userPass,
            );
        _firstNameController.clear();
        _lastNameController.clear();
        _emailController.clear();
        _passwordController.clear();
        setState(() {
          _isLoading = false;
        });
      }
    }

    return _isLoading
        ? Scaffold(
            backgroundColor: secondaryColor,
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
              body: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/login.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          !wantSignup ? "Welcome Back!" : "Get Started",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 28,
                            color: textColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          !wantSignup
                              ? "Resume your journey of monitoring through will"
                              : "Begin your journey of monitoring through will",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: textColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                      Form(
                        key: _authHomeKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            wantSignup
                                ? SizedBox(
                                    height: mediaQuery.height * 0.02,
                                  )
                                : Container(),
                            wantSignup
                                ? Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: TextFormField(
                                      controller: _firstNameController,
                                      decoration: inpDec(
                                        "First Name",
                                        "First Name",
                                      ),
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return "Required";
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (String value) {
                                        firstName = value;
                                      },
                                      onSaved: (newValue) {
                                        setState(() {
                                          firstName = newValue!;
                                        });
                                      },
                                    ),
                                  )
                                : Container(),
                            wantSignup
                                ? SizedBox(
                                    height: mediaQuery.height * 0.02,
                                  )
                                : Container(),
                            wantSignup
                                ? Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: TextFormField(
                                      controller: _lastNameController,
                                      decoration: inpDec(
                                        "Last Name",
                                        "Last Name",
                                      ),
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return "Required";
                                        }
                                        return null;
                                      },
                                      onFieldSubmitted: (String value) {
                                        lastName = value;
                                      },
                                      onSaved: (newValue) {
                                        setState(() {
                                          lastName = newValue!;
                                        });
                                      },
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: mediaQuery.height * 0.02,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: TextFormField(
                                controller: _emailController,
                                decoration: inpDec(
                                  "Enter Email ID",
                                  "Email",
                                ),
                                validator: (value) {
                                  print(value);
                                  if (value!.isEmpty) {
                                    return "Please Enter Email";
                                  } else if (!RegExp(r'\S+@\S+\.\S+')
                                      .hasMatch(value)) {
                                    return "Please Enter a Valid Email";
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (String value) {
                                  userEmail = value;
                                },
                                onSaved: (newValue) {
                                  setState(() {
                                    userEmail = newValue!;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: mediaQuery.height * 0.02,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: TextFormField(
                                controller: _passwordController,
                                decoration: inpDec(
                                  "Enter Password",
                                  "Password",
                                ),
                                obscureText: true,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return "Required";
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (String value) {
                                  userPass = value;
                                },
                                onSaved: (newValue) {
                                  setState(() {
                                    userPass = newValue!;
                                  });
                                },
                              ),
                            ),
                            GestureDetector(
                              onTap: validate,
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 8,
                                ),
                                margin: EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: secondaryColor,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      !wantSignup ? "Login" : "Create",
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      !wantSignup
                                          ? Icons.login_rounded
                                          : Icons.app_registration,
                                      color: textColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  wantSignup = !wantSignup;
                                });
                              },
                              child: !wantSignup
                                  ? Text(
                                      "New User? Sign Up Here!",
                                      style: TextStyle(
                                        color: textColor.withOpacity(0.7),
                                        fontSize: 16,
                                      ),
                                    )
                                  : Text(
                                      "Already a member? Login Here!",
                                      style: TextStyle(
                                        color: textColor.withOpacity(0.7),
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
