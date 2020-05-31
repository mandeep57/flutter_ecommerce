import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:heady_ecommerce/scoped-models/main.dart';
import 'package:heady_ecommerce/screens/account.dart';
import 'package:heady_ecommerce/screens/auth.dart';
import 'package:heady_ecommerce/screens/favorites.dart';
import 'package:heady_ecommerce/screens/retun_policy.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  int favCount = 0;
  String userName = '';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
          DrawerHeader(
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'heady',
                style: TextStyle(
                    fontFamily: 'HolyFat', fontSize: 40, color: Colors.white),
              ),
              Text(
                'v 1.0.0',
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
              ),
              signInLineTile()
            ]),
            decoration: BoxDecoration(color: Colors.deepOrange),
          ),
          ListTile(
            onTap: () {
              Navigator.popUntil(
                  context, ModalRoute.withName(Navigator.defaultRouteName));
            },
            leading: Icon(
              Icons.home,
              color: Colors.deepOrange,
            ),
            title: Text(
              'Home',
              style: TextStyle(color: Colors.deepOrange),
            ),
          ),
          favoritesLineTile(),
          accountListTile(),
          Divider(color: Colors.grey,),
          ListTile(
            title: Text(
              'Help & Others',
            ),
          ),
          InkWell(
            onTap: () {
              _callMe('999-9999-999');
            },
            child: ListTile(
              leading: Icon(
                Icons.call,
              ),
              title: Text(
                'Call: 999-9999-999',
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _sendMail('support@heady.com');
            },
            child: ListTile(
              leading: Icon(
                Icons.mail,
              ),
              title: Text(
                'Email: support@heady.com',
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ReturnPolicy();
              }));
            },
            child: ListTile(
              leading: Icon(
                Icons.assignment,
              ),
              title: Text(
                'Return Policy',
              ),
            ),
          ),
          Divider(color: Colors.grey,),
          logOutButton()
        ],
      ),
    );
  }

  Widget signInLineTile() {
    getUserName();
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        if (!model.isAuthenticated) {
          return Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300),
                    ),
                    onTap: () {
                      MaterialPageRoute route = MaterialPageRoute(
                          builder: (context) => Authentication(0));

                      Navigator.push(context, route);
                    },
                  ),
                  Text(' | ',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w300)),
                  GestureDetector(
                    child: Text('Create Account',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w300)),
                    onTap: () {
                      MaterialPageRoute route = MaterialPageRoute(
                          builder: (context) => Authentication(1));

                      Navigator.push(context, route);
                    },
                  )
                ],
              ));
        } else {
          return Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('Hi, ${formatName()}!',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500
                    )
                )
              ],
            ),
          );
        }
      },
    );
  }

  formatName() {
    if (userName != null) {
      return userName[0].toUpperCase() + userName.substring(1).split('@')[0];
    }
  }

  getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('email');
    });
  }

  Widget favoritesLineTile() {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          return ListTile(
            leading: Icon(
              Icons.favorite,
              color: Colors.deepOrange,
            ),
            trailing: Container(
              width: 30.0,
              height: 30.0,
              child: favCount != null && favCount > 0
                  ? Stack(
                children: <Widget>[
                  Icon(Icons.brightness_1, size: 30.0, color: Colors.deepOrange),
                  Center(
                    child: Text(
                      '${favCount}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )
                  : Container(
                width: 30.0,
                height: 30.0,
              ),
            ),
            title: Text(
              'Favorites',
              style: TextStyle(color: Colors.deepOrange),
            ),
            onTap: () {
              if (model.isAuthenticated) {
                MaterialPageRoute orderList =
                MaterialPageRoute(builder: (context) => FavoritesScreen());
                Navigator.push(context, orderList);
              } else {
                MaterialPageRoute route =
                MaterialPageRoute(builder: (context) => Authentication(0));

                Navigator.push(context, route);
              }
            },
          );
        });
  }

  Widget accountListTile() {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          return ListTile(
            leading: Icon(
              Icons.person,
              color: Colors.deepOrange,
            ),
            title: Text(
              'Account',
              style: TextStyle(color: Colors.deepOrange),
            ),
            onTap: () {
              if (model.isAuthenticated) {
                Fluttertoast.showToast(
                  msg: "Coming Soon...",
                  toastLength: Toast.LENGTH_LONG,
                );
              } else {
                MaterialPageRoute route =
                MaterialPageRoute(builder: (context) => Authentication(0));

                Navigator.push(context, route);
              }
            },
          );
        });
  }

  void _showDialog(context, model) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Logout"),
            content: new Text("Are you sure you want to logout?"),
            actions: <Widget>[
              new FlatButton(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Widget logOutButton() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListTile(
          leading: Icon(
            Icons.power_settings_new,
            color: Colors.grey,
          ),
          title: Text(
            'Logout',
            style: TextStyle(color: Colors.grey),
          ),
          onTap: () {
            _showDialog(context, model);
          },
        );
      },
    );
  }
}

_sendMail(String email) async {
  final uri = 'mailto:$email?subject=&body=';
  if (await canLaunch(uri)) {
    await launch(uri);
  } else {
    throw 'Could not launch $uri';
  }
}

_callMe(String phone) async {
  final uri = 'tel:$phone';
  if (await canLaunch(uri)) {
    await launch(uri);
  } else {
    throw 'Could not launch $uri';
  }
}
