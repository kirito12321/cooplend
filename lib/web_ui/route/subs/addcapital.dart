import 'package:ascoop/web_ui/constants.dart';
import 'package:ascoop/web_ui/styles/buttonstyle.dart';
import 'package:ascoop/web_ui/styles/textstyles.dart';
import 'package:ascoop/web_ui/utils/alertdialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCapitalShare extends StatefulWidget {
  String docid;
  AddCapitalShare({super.key, required this.docid});

  @override
  State<AddCapitalShare> createState() => _AddCapitalShareState();
}

class _AddCapitalShareState extends State<AddCapitalShare> {
  late final SharedPreferences prefs;
  late final prefsFuture =
      SharedPreferences.getInstance().then((v) => prefs = v);
  var amount;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: prefsFuture,
        builder: (context, prefs) {
          if (prefs.hasError) {
            return onWait;
          } else {
            switch (prefs.connectionState) {
              case ConnectionState.waiting:
                return onWait;
              default:
                return AlertDialog(
                  content: SizedBox(
                    width: 200,
                    height: 50,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[0-9.]+')),
                          ],
                          controller: amount = TextEditingController(text: '0'),
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                FontAwesomeIcons.pesoSign,
                                color: Colors.grey[800],
                                size: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 0, 105, 92),
                                  width: 2.0,
                                ),
                              ),
                              labelText: 'Deposit Amount',
                              labelStyle: TextStyle(
                                  fontFamily: FontNameDefault,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  letterSpacing: 1)),
                          style: const TextStyle(
                              fontFamily: FontNameDefault,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Colors.black,
                              letterSpacing: 1),
                          onTap: () {
                            amount.clear();
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () async {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            content: Container(
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.teal[800],
                                ),
                              ),
                            ),
                          ),
                        );
                        myDb
                            .collection('subscribers')
                            .doc(widget.docid)
                            .collection('coopAccDetails')
                            .doc('Data')
                            .get()
                            .then(
                              (value) => myDb
                                  .collection('subscribers')
                                  .doc(widget.docid)
                                  .collection('coopAccDetails')
                                  .doc('Data')
                                  .update({
                                'capitalShare': value.data()!['capitalShare'] +
                                    double.parse(amount.text)
                              }),
                            )
                            .whenComplete(() {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          okDialog(context, 'Deposit Successfully',
                              'Deposit amount successfully added to capital share');
                        });
                      },
                      style: ForTealButton,
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Deposit',
                          style: TextStyle(
                              fontFamily: FontNameDefault,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                              color: Colors.white),
                        ),
                      ),
                    )
                  ],
                );
            }
          }
        });
  }
}
