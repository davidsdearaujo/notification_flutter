import 'package:flutter/material.dart';

class DropdownWidget extends StatelessWidget {
  final Stream<String> selectedStream;
  final Stream<List<String>> listStream;
  final Function(String) setSelected;
  final String label;

  DropdownWidget({
    this.label,
    @required this.selectedStream,
    @required this.listStream,
    @required this.setSelected,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: selectedStream,
      builder: (context, selectedType) {
        return StreamBuilder<List<String>>(
          stream: listStream,
          builder: (context, types) {
            if (types.hasData) {
              return InputDecorator(
                decoration: InputDecoration(labelText: label),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedType.data,
                    hint: Text('Selecione'),
                    items: types.data
                        .map(
                          (item) => DropdownMenuItem(
                                child: new Text(item),
                                value: item,
                              ),
                        )
                        .toList(),
                    onChanged: (value) {
                      this.setSelected(value);
                    },
                  ),
                ),
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        );
      },
    );
  }
}
