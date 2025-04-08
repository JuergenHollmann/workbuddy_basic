import 'package:flutter/material.dart';
import 'package:workbuddy/config/wb_textformfield_shadow_with_2_icons.dart';

class JHsAutocomplete extends StatelessWidget {
  final String keyName;
  final TextEditingController controller;
  final List<String> items;

  const JHsAutocomplete({
    super.key,
    required this.keyName,
    required this.controller,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return items;
        }
        return items.where((item) =>
            item.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      onSelected: (String selection) {
        controller.text = selection;
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        textEditingController.text = controller.text;
        return WbTextFormFieldShadowWith2Icons(
          controller: textEditingController,
          focusNode: focusNode,
          labelText: keyName,
          hintText: '$keyName eingeben',
          prefixIcon: Icons.text_fields,
          onChanged: (value) {
            controller.text = value;
          },
        );
      },
    );
  }
}
