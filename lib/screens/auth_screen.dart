import 'package:child_io/color.dart';
import 'package:child_io/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

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

  late FocusNode _email;
  late FocusNode _password;
  late FocusNode _firstName;
  late FocusNode _lastName;
  late FocusNode _create;

  @override
  void initState() {
    super.initState();
    _email = FocusNode();
    _password = FocusNode();
    _firstName = FocusNode();
    _lastName = FocusNode();
    _create = FocusNode();
  }

  @override
  void dispose() {
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _passwordController.clear();

    _email.dispose();
    _password.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _create.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    void validate() async {
      if (!_authHomeKey.currentState!.validate()) {
        print("Invalid");
        return;
      }
      _authHomeKey.currentState!.save();
      if (!wantSignup) {
        setState(() {
          _isLoading = true;
        });
        await context.read<AuthProvider>().login(context);
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = true;
        });
        await context.read<AuthProvider>().login(context);
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
                // margin: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Form(
                        key: _authHomeKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            wantSignup
                                ? Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: TextFormField(
                                      controller: _firstNameController,
                                      focusNode: _firstName,
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
                                        _firstName.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(_lastName);
                                      },
                                      onSaved: (newValue) {
                                        setState(() {
                                          firstName = newValue!;
                                        });
                                      },
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              height: mediaQuery.height * 0.02,
                            ),
                            wantSignup
                                ? Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: TextFormField(
                                      controller: _lastNameController,
                                      focusNode: _lastName,
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
                                        _lastName.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(_email);
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
                                focusNode: _email,
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
                                  _email.unfocus();
                                  FocusScope.of(context)
                                      .requestFocus(_password);
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
                                focusNode: _password,
                                decoration: inpDec(
                                  "Enter Password",
                                  "Password",
                                ),
                                obscureText: true,
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return "Required";
                                  }
                                  if (value.length < 5) {
                                    return "Password should be more than 5 characters";
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (String value) {
                                  userPass = value;
                                  _password.unfocus();
                                  FocusScope.of(context).requestFocus(_create);
                                },
                                onSaved: (newValue) {
                                  setState(() {
                                    userPass = newValue!;
                                  });
                                },
                              ),
                            ),
                            TextButton.icon(
                              focusNode: _create,
                              onPressed: validate,
                              icon: Icon(
                                !wantSignup
                                    ? Icons.login_rounded
                                    : Icons.app_registration,
                                color: Colors.black54,
                              ),
                              label: Text(
                                !wantSignup ? "Login" : "Create",
                                style: GoogleFonts.poppins(
                                  color: Colors.black54,
                                ),
                              ),
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(
                                  EdgeInsets.symmetric(horizontal: 20),
                                ),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    side: BorderSide(
                                      color: Colors.black54,
                                    ),
                                  ),
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
                                      "New User! Sign Up Here",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black54,
                                      ),
                                    )
                                  : Text(
                                      "Already a member!,Login Here",
                                      style: GoogleFonts.poppins(
                                        color: Colors.black54,
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
