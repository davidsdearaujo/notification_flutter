import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../loading/loading-widget.dart';

class DropdownWidget<T> extends StatelessWidget {
  final Observable<T> selectedStream;
  final Observable<List<T>> listStream;
  final Function(T) setSelected;
  final String label;

  DropdownWidget({
    this.label,
    @required this.selectedStream,
    @required this.listStream,
    @required this.setSelected,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: selectedStream,
      builder: (context, selectedType) {
        return StreamBuilder<List<T>>(
          stream: listStream,
          builder: (context, types) {
            if (types.hasData) {
              return InputDecorator(
                decoration: InputDecoration(labelText: label, errorText: selectedType.error),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    value: selectedType.data,
                    hint: Text('Selecione'),
                    items: types.data
                        .map(
                          (item) => DropdownMenuItem(
                                child: Text(item.toString()),
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
              return LoadingWidget();
            }
          },
        );
      },
    );
  }
}
