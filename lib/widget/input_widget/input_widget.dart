import 'package:flutter/material.dart';
import 'package:oem_huining_anhui/widget/input_widget/tro_input_widget.dart';

class InputWidget extends StatefulWidget {
  const InputWidget({Key? key}) : super(key: key);

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: TroInput(
        label: '套管大径',
        width: 150,
        labelWidth: 70,
        value: '123',
        labelStyle: TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}
