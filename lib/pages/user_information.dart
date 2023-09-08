import 'package:flutter/material.dart';
import 'package:flutter_exam_jonathan_b/models/user.dart';
import 'dart:async';
import 'package:mysql1/mysql1.dart';
import 'package:flutter_exam_jonathan_b/db/database_connection.dart';
import 'package:flutter_exam_jonathan_b/utils/styles.dart';
import 'package:path_provider/path_provider.dart';
// Je possède un soucis par rapport à update et enregistrer avec le path_provider
// Error: MissingPluginException(No implementation found for method getApplicationDocumentsDirectory on channel plugins.flutter.io/path_provider)
// dart-sdk/lib/_internal/js_dev_runtime/private/ddc_runtime/errors.dart 294:49  throw_
// packages/flutter/src/services/platform_channel.dart 308:7                     _invokeMethod
// dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 45:50            <fn>
// dart-sdk/lib/async/zone.dart 1661:54                                          runUnary
// dart-sdk/lib/async/future_impl.dart 156:18                                    handleValue
// dart-sdk/lib/async/future_impl.dart 840:44                                    handleValueCallback
// dart-sdk/lib/async/future_impl.dart 869:13                                    _propagateToListeners
// dart-sdk/lib/async/future_impl.dart 641:5                                     [_completeWithValue]
// dart-sdk/lib/async/future_impl.dart 715:7                                     callback
// dart-sdk/lib/async/schedule_microtask.dart 40:11                              _microtaskLoop
// dart-sdk/lib/async/schedule_microtask.dart 49:5                               _startMicrotaskLoop
// dart-sdk/lib/_internal/js_dev_runtime/patch/async_patch.dart 181:15           <fn>

class UserInformationPage extends StatefulWidget {
  User user;

  UserInformationPage({required this.user});

  @override
  _UserInformationPageState createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController userNameController = TextEditingController();

  String originalUserName = '';

  @override
  void initState() {
    super.initState();
    originalUserName = widget.user.userName ?? '';
    userNameController.text = originalUserName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Bonjour ${widget.user.userName ?? ''}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('ID Utilisateur: ${widget.user.userID}'),
            TextFormField(
              controller: userNameController,
              decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    updateUserNameInDatabase();
                  },
                  child: Text('Update'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    saveUserInformationInDatabase();
                  },
                  child: Text('Enregistrer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateUserNameInDatabase() async {
    if (userNameController.text != originalUserName) {
      final db = await DatabaseConnection().setDatabase();
      try {
        await db.update(
          'users',
          {
            'userName': userNameController.text,
          },
          where: 'userID = ?',
          whereArgs: [widget.user.userID],
        );

        setState(() {
          originalUserName = userNameController.text;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Nom d\'utilisateur mis à jour avec succès.'),
        ));
      } catch (error) {
        print('Erreur lors de la mise à jour du nom d\'utilisateur : $error');

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erreur lors de la mise à jour du nom d\'utilisateur.'),
        ));
      } finally {
        await db.close();
      }
    }
  }

  Future<void> saveUserInformationInDatabase() async {
    final db = await DatabaseConnection().setDatabase();
    try {
      await db.transaction((txn) async {
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Données utilisateur enregistrées avec succès.'),
      ));
    } catch (error) {
      print('Erreur lors de l\'enregistrement des données utilisateur : $error');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de l\'enregistrement des données utilisateur.'),
      ));
    } finally {
      await db.close();
    }
  }
}
