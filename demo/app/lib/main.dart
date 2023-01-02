import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'demo_method_channel.dart';
import 'models/store_credential_data.dart';
import 'views/dashboard.dart';
import 'package:app/services/storage_service.dart';

final WalletSDKPlugin = MethodChannelWallet();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await WalletSDKPlugin.initSDK();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Image.asset('lib/assets/images/logo.png', fit: BoxFit.scaleDown),
          toolbarHeight: 120.0,
          leadingWidth: 80,
          centerTitle: true,
          backgroundColor: Colors.deepPurple[800],
        ),
        body: const MyStatefulWidget(),
        backgroundColor: Colors.deepPurple[800],
      ),
      debugShowCheckedModeBanner: false, //Removing Debug Banner
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final TextEditingController _usernameController = TextEditingController();
  final StorageService _storageService = StorageService();
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  var userDIDId = '';

  Future<String?> _createDid() async {
    var didID = await WalletSDKPlugin.createDID();
    setState(() {
      userDIDId = didID!;
    });
    log("created didID :$didID");
    return didID;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            SizedBox(height: size.height * 0.02),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _usernameController,
                style: const TextStyle(fontSize: 20, color: Colors.black),
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  labelText: 'Enter Username',
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // <-- Radius
                    ),
                  ),
                onPressed: () async {
                 final SharedPreferences pref = await prefs;
                 String? userLoggedIn =  pref.getString("userLoggedIn");
                    if (_usernameController.text == userLoggedIn.toString()){
                      _navigateToDashboard();
                    } else {
                       await _createDid();
                       pref.setString('userLoggedIn', _usernameController.text);
                       pref.setString('userDID', userDIDId);
                      _navigateToDashboard();
                    }
                  },
                  child: const Text('Register', style: TextStyle(fontSize: 22, color: Colors.deepPurple)),
                )),
          ],
        ));
  }
  _navigateToDashboard() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const  Dashboard()));
  }
}
