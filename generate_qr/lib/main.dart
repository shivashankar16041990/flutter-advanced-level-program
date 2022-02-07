import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';

import 'dataprovider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => TextValue(text: 'hi'),
    child: MaterialApp(
      home: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("controller value is${controller.text}");
    controller.addListener(() {
      print("the value in text field is ${controller.text}");
      context.read<TextValue>().updateText(updatedText: controller.text);
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: QrImage(
                data: context.watch<TextValue>().text,
                size: 200,
                version: 1,
                gapless: true,
                errorStateBuilder: (context, obj) {
                  return Center(
                    child: Container(
                      child: Center(
                        child: Text(
                          " something went Wrong",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
                // backgroundColor: Colors.red,
                foregroundColor: Colors.blue,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.circle,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "message to encode into QR",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
