import 'package:flutter/material.dart';

class DropdownButtonMultiple<T, V> extends StatefulWidget {
  final String placeholder;
  final List<T> choices;
  final String Function(T label) displayLabelWith;
  final dynamic Function(T value) getValueWith;
  final bool Function(T choice, V value) compareWith;
  final Function(List<V> values) onChanged;
  final Function(List<V> values) onSaved;
  final List<V> initValues;

  const DropdownButtonMultiple({
    Key key,
    this.choices,
    this.displayLabelWith,
    this.getValueWith,
    this.onChanged,
    this.initValues,
    this.compareWith,
    this.placeholder,
    this.onSaved,
  }) : super(key: key);

  @override
  _DropdownButtonMultipleState<T, V> createState() =>
      _DropdownButtonMultipleState<T, V>();
}

class _DropdownButtonMultipleState<T, V>
    extends State<DropdownButtonMultiple<T, V>> {
  List<_SelectionObject<T, V>> itemsSelection = [];
  List<_SelectionObject<T, V>> get selectedItems =>
      itemsSelection.where((e) => e.isSelected).toList();
  GlobalKey<FormFieldState> _key;

  @override
  void initState() {
    _key = GlobalKey();
    itemsSelection = widget.choices
        .map(
          (e) => _SelectionObject<T, V>(
            label: widget.displayLabelWith(e),
            value: widget.getValueWith(e),
            isSelected: false,
            obj: e,
          ),
        )
        .toList();

    widget.initValues.forEach((value) {
      final item = itemsSelection
          .firstWhere((item) => widget.compareWith(item.obj, value));
      if (item != null) {
        item.isSelected = true;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: -4,
          children: itemsSelection
              .where((e) => e.isSelected)
              .map(
                (e) => Chip(
                  label: Text(e.label),
                  onDeleted: () {
                    setState(() => e.isSelected = false);
                    widget
                        .onChanged(selectedItems.map((e) => e.value).toList());
                  },
                ),
              )
              .toList(),
        ),
        DropdownButtonFormField<_SelectionObject<T, V>>(
          key: _key,
          decoration: InputDecoration(
              labelText: selectedItems.isEmpty
                  ? widget.placeholder
                  : '${widget.placeholder} (${selectedItems.length} selected)'),
          isExpanded: true,
          icon: Icon(Icons.local_offer),
          items: itemsSelection
              .where((e) => !e.isSelected)
              .map(
                (e) => DropdownMenuItem<_SelectionObject<T, V>>(
                  child: Text(e.label),
                  value: e,
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              _key.currentState.reset();
              value.isSelected = true;
            });
            widget.onChanged(selectedItems.map((e) => e.value).toList());
          },
          onSaved: (value) {
            widget.onSaved(selectedItems.map((e) => e.value).toList());
          },
        ),
      ],
    );
  }
}

class _SelectionObject<T, V> {
  final String label;
  final V value;
  bool isSelected;
  final T obj;

  _SelectionObject({
    this.label,
    this.value,
    this.isSelected,
    this.obj,
  });
}
