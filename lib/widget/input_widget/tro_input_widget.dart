import 'package:flutter/material.dart';
import 'package:oem_huining_anhui/widget/input_widget/tro_text_field.dart';

///输入组件（输入框）
class TroInput extends TroFormField {
  TroInput({
    Key? key,
    double? width,
    String? label,
    double? labelWidth,
    String? value,
    int? maxLines,
    ValueChanged? onChange,
    TextStyle? labelStyle,
    TextStyle? valueStyle,
    FormFieldSetter? onSaved,
    FormFieldValidator<String>? validator,
    bool? enable,
  }) : super(
          key: key,
          width: width,
          label: label,
          labelWidth: labelWidth,
          labelStyle: labelStyle,
          builder: (state) {
            return TextFormField(
              maxLines: maxLines,
              style: valueStyle,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                border: OutlineInputBorder(),
                enabled: enable ?? true,
              ),
              controller: TextEditingController(text: value),
              onChanged: (v) {
                if (onChange != null) {
                  onChange(v);
                }
              },
              onSaved: (v) {
                if (onSaved != null) {
                  onSaved(v);
                }
              },
              validator: validator,
            );
          },
        );
}
