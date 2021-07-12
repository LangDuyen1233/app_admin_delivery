import 'package:app_delivery/models/Food.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class ChooseFood extends StatefulWidget {
  @override
  _ChooseFood createState() => _ChooseFood();
}

class _ChooseFood extends State<ChooseFood> {
  final _items = list.map((f) => MultiSelectItem<Food>(f, f.name)).toList();
  List<Food> _selectedAnimals3 = [];
  final _multiSelectKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: MultiSelectBottomSheetField<Food>(
          key: _multiSelectKey,
          initialChildSize:  .7,
          maxChildSize: 0.95,
          title: Text("Món ăn"),
          buttonText: Text("Chọn món áp dụng"),
          buttonIcon: Icon(
            Icons.arrow_drop_down,
            color: Colors.grey,
          ),
          decoration: BoxDecoration(),
          items: _items,
          searchable: true,
          validator: (values) {
            if (values == null || values.isEmpty) {
              return null;
            }
            List<String> names = values.map((e) => e.name).toList();
            if (names.contains("Frog")) {
              return "Frogs are weird!";
            }
            return null;
          },
          onConfirm: (values) {
            setState(() {
              _selectedAnimals3 = values;
            });
            _multiSelectKey.currentState.validate();
          },
          chipDisplay: MultiSelectChipDisplay(
            onTap: (item) {
              setState(() {
                _selectedAnimals3.remove(item);
              });
              _multiSelectKey.currentState.validate();
            },
            icon: Icon(
              Icons.close,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
