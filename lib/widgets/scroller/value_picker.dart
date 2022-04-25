import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:tune/utils/constants/system_constants.dart';

class ValuePicker extends StatefulWidget {
  int _index;
  List<double> values;
  void Function(double val) onValueChange;
  String changeOtherText;

  /// Should the pitch and speed be connected?
  /// i.e. change together?
  bool changeOther;

  void Function(bool val) onChangeOtherBoolFunction;
  ValuePicker(
      {Key? key,
      int? index,
      required this.values,
      required this.onValueChange,
      required this.changeOther,
      required this.changeOtherText,
      required this.onChangeOtherBoolFunction})
      : _index = index ?? 0,
        super(key: key);

  @override
  State<ValuePicker> createState() => _ValuePickerState();
}

class _ValuePickerState extends State<ValuePicker> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                GlowCheckbox(
                  color: kSongOptionsBGColor,
                  value: widget.changeOther,
                  onChange: (bool val) {
                    setState(() {
                      widget.changeOther = val;
                    });
                    widget.onChangeOtherBoolFunction(val);
                  },
                  height: 30,
                ),
                const SizedBox(width: 5),
                Text(
                  'change ${widget.changeOtherText}',
                  style: kSongOptionsTextStyle.copyWith(fontSize: 16),
                )
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: CupertinoPicker(
              scrollController:
                  FixedExtentScrollController(initialItem: widget._index),
              itemExtent: 60,
              onSelectedItemChanged: (index) {
                widget._index = index;
                widget.onValueChange(widget.values[index]);
              },
              children: Utils.modelBuilder<double>(
                widget.values,
                (index, value) => Center(
                  child: Text(
                    '$value',
                    style: kAudioTitleTextStyle.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Utils {
  static List<Widget> modelBuilder<M>(
          List<M> models, Widget Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, Widget>(
              (index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();
}

/*

  List<double> values = [];
 for (int i = 0; i <= 20; i++) {
      values.add(i / 10);
    }
ValueScroller(
              index: 10,
              values: values,
              onChange: (double val) {
                handler.setPitch(val);
              },
            ),
 */
