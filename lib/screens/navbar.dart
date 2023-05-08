import 'dart:io';

import 'package:flutter/material.dart';
import 'package:podify/common/custom_textfiled.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});
  static const String routeName = '/navbar';

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final TextEditingController _codeController = TextEditingController();
  final openAI = OpenAI.instance.build(
    token: "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",
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 5)),
  );
  String code = "";

  void optimize() async {
    try {
      final request = ChatCompleteText(
          messages: [
            {
              "role": "user",
              "content":
                  '${_codeController.text}\noptimze this code with dead code elimination,constant folding and reduction in strength and dont add any explanation in the response '
            }
          ],
          model: ChatModel.gptTurbo, // is model kGPT35Turbo => 'gpt-3.5-turbo'
          maxToken: 800,
          temperature: 0.5);
      final response = await openAI.onChatCompletion(request: request);
      setState(() {
        code = response!.choices[0].message!.content;
        vis = code.isNotEmpty ? true : false;
      });

      //print(code);
    } catch (e) {
      print(e);
    }

    ///cancel request
    //print(_codeController.text);
  }

  bool vis = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.7;
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Center(
              child: SizedBox(
                width: width,
                child: CustomTextField(
                  controller: _codeController,
                  hintText: "code",
                  maxLines: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                optimize();
              },
              child: const Text("Optimize"),
            ),
            const SizedBox(
              height: 30,
            ),
            Visibility(
              visible: vis,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.lightBlue[100],
                  width: width,
                  child: code.isNotEmpty
                      ? Text(code)
                      : const Text("Enter the code above"),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
