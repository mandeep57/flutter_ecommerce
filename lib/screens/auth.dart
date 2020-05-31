import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heady_ecommerce/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class Authentication extends StatefulWidget {
  final int index;
  Authentication(this.index);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> with SingleTickerProviderStateMixin {
  bool _isLoader = false;
  TabController _tabController;
  final Map<String, dynamic> _formData = {'email': null, 'password': null};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyForLogin = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _passwordTextController = TextEditingController();
  final UnderlineInputBorder _underlineInputBorder =
  UnderlineInputBorder(borderSide: BorderSide(color: Colors.black54));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(initialIndex: widget.index, vsync: this, length: 2);

  }
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;

    return MaterialApp(
      color: Colors.deepOrange,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.white,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            centerTitle: false,
            backgroundColor: Colors.deepOrange,
            leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            bottom: TabBar(
              indicatorWeight: 4.0,
              controller: _tabController,
              indicatorColor: Colors.deepOrange,
              tabs: [
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    "SIGN IN",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                Text(
                  "CREATE ACCOUNT",
                  style: TextStyle(fontSize: 13),
                )
              ],
            ),
            title: Text(
              'heady',
              style: TextStyle(fontFamily: 'HolyFat', fontSize: 40),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _renderLogin(targetWidth),
              _renderSignup(targetWidth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderLogin(double targetWidth) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Container(
                width: targetWidth,
                child: Form(
                  key: _formKeyForLogin,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildEmailTextField(),
                      SizedBox(
                        height: 45.0,
                      ),
                      _buildPasswordTextField(false),
                      SizedBox(
                        height: 35.0,
                      ),
                      _isLoader
                          ? CircularProgressIndicator(backgroundColor: Colors.deepOrange)
                          : Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(15),
                          child: FlatButton(
                            textColor: Colors.white,
                            color: Colors.deepOrange,
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(fontSize: 12.0),
                            ),
                            onPressed: () => _submitLogin(model),
                          )),
                      SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Fluttertoast.showToast(
                            msg: "Coming Soon...",
                            toastLength: Toast.LENGTH_LONG,
                          );
                        },
                        child: Text(
                          'FORGOT PASSWORD?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blueAccent,
                              fontSize: 12.0),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _renderSignup(double targetWidth) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: Container(
          width: targetWidth,
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                _buildEmailTextField(),
                SizedBox(
                  height: 45.0,
                ),
                _buildPasswordTextField(true),
                SizedBox(
                  height: 45.0,
                ),
                _buildPasswordConfirmTextField(),
                SizedBox(
                  height: 45.0,
                ),
                _isLoader
                    ? CircularProgressIndicator(backgroundColor: Colors.deepOrange)
                    : Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(15),
                    child: FlatButton(
                      textColor: Colors.white,
                      color: Colors.deepOrange,
                      child: Text('CREATE ACCOUNT',
                          style: TextStyle(fontSize: 12.0)),
                      onPressed: () => _submitForm(),
                    )),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailTextField() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: TextFormField(
          decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.grey),
              labelText: 'Email',
              contentPadding: EdgeInsets.all(0.0),
              enabledBorder: _underlineInputBorder),
          keyboardType: TextInputType.emailAddress,
          validator: (String value) {
            if (value.isEmpty ||
                !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                    .hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
          onSaved: (String value) {
            _formData['email'] = value;
          },
        ));
  }

  Widget _buildPasswordTextField([bool isLimitCharacter = false]) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: isLimitCharacter
                ? 'Password (Atleast 6 Characters)'
                : 'Password',
            labelStyle: TextStyle(color: Colors.grey),
            contentPadding: EdgeInsets.all(0.0),
            enabledBorder: _underlineInputBorder),
        obscureText: true,
        controller: _passwordTextController,
        validator: (String value) {
          if (value.isEmpty || value.length < 6) {
            return 'Password must be atleast 6 characters';
          }
          return null;
        },
        onSaved: (String value) {
          _formData['password'] = value;
        },
      ),
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Theme(
          data: ThemeData(hintColor: Colors.grey.shade700),
          child: TextFormField(
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.grey),
              labelText: 'Confirm Password',
              enabledBorder: _underlineInputBorder,
              contentPadding: EdgeInsets.all(0.0),
            ),
            obscureText: true,
            validator: (String value) {
              if (_passwordTextController.text != value) {
                return 'Passwords do not match.';
              }
              return null;
            },
          ),
        ));
  }

  void _submitLogin(MainModel model) async {
    setState(() {
      _isLoader = true;
    });
    if (!_formKeyForLogin.currentState.validate()) {
      setState(() {
        _isLoader = false;
      });
      return;
    }
    _formKeyForLogin.currentState.save();
    final Map<String, dynamic> authData = {
      "spree_user": {
        'email': _formData['email'],
        'password': _formData['password'],
      }
    };

    setState(() {
      _isLoader = false;
    });
  }

  void _submitForm() async {
    setState(() {
      _isLoader = true;
    });
    if (!_formKey.currentState.validate()) {
      setState(() {
        _isLoader = false;
      });
      return;
    }
    _formKey.currentState.save();

    setState(() {
      _isLoader = false;
    });
  }
}
