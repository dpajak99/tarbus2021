import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:tarbus2021/src/app/app_string.dart';
import 'package:tarbus2021/src/model/api/response/response_welcome_dialog.dart';
import 'package:tarbus2021/src/presentation/views/factory_main/controller/welcome_dialog_controller.dart';
import 'package:tarbus2021/src/utils/web_page_utils.dart';

class WelcomeDialog extends StatelessWidget {
  final ResponseWelcomeDialog dialog;

  const WelcomeDialog({Key key, this.dialog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WelcomeDialogController viewController = WelcomeDialogController();

    return AlertDialog(
      title: Text(dialog.title),
      content: SingleChildScrollView(
        child: Wrap(
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (dialog.content.isNotEmpty)
                    Markdown(
                      padding: EdgeInsets.all(0),
                      data: dialog.content,
                      shrinkWrap: true,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        if (dialog.hasButtonClose)
          FlatButton(
            onPressed: () {
              viewController.addDialogToList(dialog.id);
              Navigator.of(context).pop();
            },
            child: Text(AppString.labelNeverShowAgain),
          ),
        if (dialog.hasButtonRemindMeLater)
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppString.labelRemindMeLater),
          ),
        if (dialog.hasButtonLink)
          FlatButton(
            onPressed: () {
              WebPageUtils.openURL(dialog.buttonLinkHref);
            },
            child: Text(
              dialog.buttonLinkContent,
            ),
          ),
      ],
    );
  }
}
