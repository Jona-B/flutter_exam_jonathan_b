import 'package:flutter/material.dart';
import 'package:flutter_exam_jonathan_b/models/user.dart';
import 'user_information.dart';
import 'package:flutter_exam_jonathan_b/utils/styles.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User user = User.generateID();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page de Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/welcome_image.jpeg',
              width: 200.0,
              height: 200.0,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Veuillez saisir votre nom d\'utilisateur';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      if (value != null) {
                        user.userName = value;
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Mot de passe'),
                    obscureText: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Veuillez saisir votre mot de passe';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      if (value != null) {
                        user.userPassword = value;
                      }
                    },
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UserInformationPage(user: user),
                          ),
                        );
                      }
                    },
                    child: Text('Connexion'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}