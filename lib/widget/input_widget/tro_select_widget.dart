import 'package:flutter/material.dart';
import 'package:oem_huining_anhui/widget/input_widget/tro_text_field.dart';

class TroSelect extends TroFormField {
  TroSelect({
    Key? key,
    String? label,
    String? value,
    double? width,
    double? valueWidth,
    double? labelWidth,
    TextStyle? labelStyle,
    ValueChanged? onChange,
    FormFieldSetter? onSaved,
    List<SelectOptionVO> dataList = const [],
  }) : super(
          key: key,
          label: label,
          width: width,
          labelStyle: labelStyle,
          labelWidth: labelWidth,
          builder: (TroFormFieldState state) {
            return DropdownButtonFormField<String>(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 5),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 12,
                  fontFamily: "NotoSerifSC"),
              value: value,
              items: dataList.map((v) {
                return DropdownMenuItem<String>(
                  value: v.value as String?,
                  child: Container(
                    width: valueWidth ?? 60,
                    child: Text(
                      v.label!,
                      style: TextStyle(
                          overflow: TextOverflow.visible,
                          color: Colors.black,
                          fontSize: 12),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (v) {
                value = v;
                if (onChange != null) {
                  onChange(v);
                }
                state.didChange();
              },
              onSaved: (v) {
                if (onSaved != null) {
                  onSaved(v);
                }
              },
            );
          },
        );
}

class SelectOptionVO {
  SelectOptionVO({this.value, this.label});

  Object? value;
  String? label;
}
