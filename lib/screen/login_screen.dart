import 'package:flutter/material.dart';
import 'package:oem_huining_anhui/model/user_model.dart';
import 'package:oem_huining_anhui/screen/main_screen/main_page.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  User user = User();
  FocusNode focusNodeUserName = FocusNode();
  FocusNode focusNodePassword = FocusNode();
  bool isFaceRecognition = false;

  @override
  void initState() {
    super.initState();
    focusNodeUserName.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Scaffold(
        body: _buildPageContent(),
      ),
    );
  }

  Widget _buildPageContent() {
    var appName = Text(
      "安徽徽宁套管振动及强度计算软件",
      style: TextStyle(fontSize: 16, color: Colors.black),
      textScaleFactor: 3.2,
    );
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/img.png'), fit: BoxFit.cover)),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 40.0),
          Center(child: appName),
          SizedBox(height: 40.0),
          _buildLoginForm(),
          SizedBox(height: 40.0),
        ],
      ),
    );
  }

  Container _buildLoginForm() {
    return Container(
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              width: 500,
              height: 360,
              margin: EdgeInsets.only(top: 40),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                color: Color.fromRGBO(255, 255, 255, 150),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: TextFormField(
                        focusNode: focusNodeUserName,
                        initialValue: user.userName,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '用户名',
                          icon: Icon(
                            Icons.people,
                            color: Colors.blue,
                          ),
                        ),
                        onSaved: (v) {
                          user.userName = v;
                        },
                        validator: (v) {
                          return v!.isEmpty ? '请填写密码' : null;
                        },
                        onFieldSubmitted: (v) {
                          focusNodePassword.requestFocus();
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: TextFormField(
                        focusNode: focusNodePassword,
                        obscureText: true,
                        initialValue: user.passWord,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '密码',
                          icon: Icon(
                            Icons.lock,
                            color: Colors.blue,
                          ),
                        ),
                        onSaved: (v) {
                          user.passWord = v;
                        },
                        validator: (v) {
                          return v!.isEmpty ? '请输入密码' : null;
                        },
                        onFieldSubmitted: (v) {
                          _login();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundColor: Colors.blue.shade600,
                child: Icon(Icons.person),
              ),
            ],
          ),
          Container(
            height: 360,
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 420,
              child: ElevatedButton(
                onPressed: _login,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40.0))),
                ),
                child: Text('登陆',
                    style: TextStyle(color: Colors.white70, fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _login() async {
    var form = formKey.currentState!;
    if (!form.validate()) {
      return;
    }
    form.save();
    if (isAuthenticated(user)) {
      _loginSuccess();
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("密码错误"),
    ));

    focusNodePassword.requestFocus();
    return;
  }

  bool isAuthenticated(User user) {
    return user.userName == 'huining' && user.passWord == 'huining';
  }

  _loginSuccess() async {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => MainPage()));
  }
}
