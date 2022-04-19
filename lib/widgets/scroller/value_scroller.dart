import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tune/utils/constants/system_constants.dart';

class ValueScroller extends StatelessWidget {
  int _index;
  List<double> values;
  void Function(double val) onChange;
  ValueScroller(
      {Key? key,
      required int index,
      required this.values,
      required this.onChange})
      : _index = index,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: CupertinoPicker(
        itemExtent: 60,
        onSelectedItemChanged: (index) {
          _index = index;
          onChange(values[index]);
        },
        children: Utils.modelBuilder<double>(
          values,
          (index, value) => Center(
            child: Text(
              '$value',
              style: kAudioTitleTextStyle.copyWith(color: Colors.white),
            ),
          ),
        ),
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

  /// Alternativaly: You can display an Android Styled Bottom Sheet instead of an iOS styled bottom Sheet
  // static void showSheet(
  //   BuildContext context, {
  //   required Widget child,
  // }) =>
  //     showModalBottomSheet(
  //       context: context,
  //       builder: (context) => child,
  //     );

  static void showSheet(
    BuildContext context, {
    required Widget child,
    required VoidCallback onClicked,
  }) =>
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            child,
          ],
          cancelButton: CupertinoActionSheetAction(
            child: Text('Done'),
            onPressed: onClicked,
          ),
        ),
      );
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
