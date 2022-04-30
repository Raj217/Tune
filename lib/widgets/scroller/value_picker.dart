import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';

import 'package:tune/utils/app_constants.dart';
import 'package:tune/widgets/buttons/extended_button.dart';

/// Brings a [_ValuePicker] to set value
Future<void> valuePicker(
    {required BuildContext context,
    required List<double> values,
    required bool changeOther,
    required String changeOtherText,
    required void Function(double value) onChange,
    required void Function(bool value) onChangeOtherBoolFunction,
    int index = 10}) async {
  await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return _ValuePicker(
            values: values,
            onValueChange: onChange,
            index: index,
            changeOther: changeOther,
            changeOtherText: changeOtherText,
            onChangeOtherBoolFunction: onChangeOtherBoolFunction);
      });
}

class _ValuePicker extends StatefulWidget {
  /// Current Index
  int _index;

  /// Values to be shown(user can pick these by scrolling)
  List<double> values;
  void Function(double val) onValueChange;

  /// What is the other text that is connected
  ///
  /// If this is empty, it is assumed that this checkbox is not required thus is
  /// not shown
  String? changeOtherText;

  /// Should the pitch and speed be connected?
  /// i.e. change together?
  bool changeOther;

  void Function(bool val) onChangeOtherBoolFunction;
  _ValuePicker(
      {Key? key,
      int? index,
      this.changeOtherText,
      this.changeOther = true,
      required this.values,
      required this.onValueChange,
      required this.onChangeOtherBoolFunction})
      : _index = index ?? 0,
        super(key: key);

  @override
  State<_ValuePicker> createState() => _ValuePickerState();
}

class _ValuePickerState extends State<_ValuePicker> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: widget.changeOtherText != null,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        GlowCheckbox(
                          color: AppConstants
                              .colors.tertiaryColors.kSongOptionsBGColor,
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
                          style: AppConstants.textStyles.kSongOptionsTextStyle
                              .copyWith(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: GlowButton(
                    width: 70,
                    height: 30,
                    color:
                        AppConstants.colors.tertiaryColors.kSongOptionsBGColor,
                    child: Text(
                      'APPLY',
                      style: AppConstants.textStyles.kAudioTitleTextStyle
                          .copyWith(fontSize: 10),
                    ),
                    onPressed: () {
                      widget.onValueChange(widget.values[widget._index]);
                    },
                  ),
                )
              ],
            ),
            SizedBox(
              height: 100,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                    initialItem: widget
                        ._index), // So that the initially selected value is _index
                itemExtent: 60,
                onSelectedItemChanged: (index) {
                  widget._index = index;
                },
                children: Utils.modelBuilder<double>(
                  widget.values,
                  (index, value) => Center(
                    child: Text(
                      '$value',
                      style: AppConstants.textStyles.kAudioTitleTextStyle
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ]),
    );
  }
}

class Utils {
  static List<Widget> modelBuilder<M>(
          // TODO: Analyze this
          List<M> models,
          Widget Function(int index, M model) builder) =>
      models
          .asMap()
          .map<int, Widget>(
              (index, model) => MapEntry(index, builder(index, model)))
          .values
          .toList();
}
