import 'package:flutter/material.dart';
import 'package:oem_huining_anhui/model/list_node.dart';
import 'package:oem_huining_anhui/widget/button_widget/button_with_icon.dart';
import 'package:oem_huining_anhui/widget/input_widget/tro_input_widget.dart';

class DataEditScreen extends StatefulWidget {
  final List<ListNode?> listNodes;
  const DataEditScreen({Key? key, required this.listNodes}) : super(key: key);

  @override
  State<DataEditScreen> createState() => _DataEditScreenState();
}

class _DataEditScreenState extends State<DataEditScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ListNode listNode = ListNode(
      nom: '请输入位号',
      data: InitCalculate(),
      ans: CalculateResult(),
    );
    if (widget.listNodes.isNotEmpty) {
      listNode = widget.listNodes.last!.copyWith();
    }
    // ListNode listNode = widget.listNodes?.last ?? ListNode().copyWith();
    var form = Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TroInput(
            value: listNode.nom,
            label: '位号',
            onSaved: (v) {
              listNode.nom = v;
              listNode.data!.nom = v;
            },
            validator: (v) {
              if (widget.listNodes.map((e) => e?.nom).toList().contains(v)) {
                return '重复';
              }
              return v!.isEmpty ? 'required' : null;
            },
          ),
        ],
      ),
    );
    var buttonBar = ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        ButtonWithIcon(
          label: '保存',
          iconData: Icons.save,
          onPressed: () {
            FormState form = formKey.currentState!;
            if (!form.validate()) {
              return;
            }
            form.save();
            widget.listNodes.add(listNode);
            Navigator.pop(context, true);
            // TroUtils.message('saved');
          },
        ),
        ButtonWithIcon(
          label: '取消',
          iconData: Icons.cancel,
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
    var result = Scaffold(
      appBar: AppBar(
        title: const Text('添加新数据'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            form,
          ],
        ),
      ),
      bottomNavigationBar: buttonBar,
    );
    return SizedBox(
      width: 400,
      height: 400,
      child: result,
    );
  }
}
