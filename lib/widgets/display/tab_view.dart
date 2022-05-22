import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tune/utils/app_constants.dart';
import 'package:tune/utils/formatter.dart';
import 'package:tune/widgets/scroller/vertical_scroll.dart';

class CustomTab {
  final String? text;

  /// Please give the index in order of 0,1,2,... else
  /// it will not work.
  ///
  /// Always start from 0 and go on with the increment of 1
  final int index;
  TextStyle? textStyle;
  Color? activeColor;
  Color? inactiveColor;
  final IconData? icon;
  double? _iconWidth;
  double? _iconHeight;
  final bool takeWidthAsDefault;
  bool _isActive = false;
  // TODO: Add animation to color

  CustomTab(
      {this.text,
      required this.index,
      this.textStyle,
      this.activeColor,
      this.inactiveColor,
      this.icon,
      double? iconHeight,
      double? iconWidth,
      this.takeWidthAsDefault = false}) {
    activeColor =
        activeColor ?? AppConstants.colors.secondaryColors.kActiveColor;
    inactiveColor =
        inactiveColor ?? AppConstants.colors.secondaryColors.kInactiveColor;

    textStyle = textStyle ?? AppConstants.textStyles.kSongInfoValueTextStyle;
    _iconWidth = iconWidth;
    _iconHeight = iconHeight;
    if (takeWidthAsDefault) {
      _iconWidth = AppConstants.sizes.kDefaultIconWidth;
    } else {
      _iconHeight = AppConstants.sizes.kDefaultIconHeight;
    }
  }

  Padding toWidget(int currentActiveIndex) {
    if (currentActiveIndex == index) {
      _isActive = true;
    } else {
      _isActive = false;
    }
    List<Widget> children = [
      Icon(
        icon,
        color: _isActive ? activeColor : inactiveColor,
        size: _iconWidth ?? _iconHeight,
      ),
    ];
    if (text != null) {
      children.add(Text(text!,
          style: textStyle?.copyWith(
              color: _isActive ? activeColor : inactiveColor)));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: children,
      ),
    );
  }
}

class CustomTabView extends StatefulWidget {
  final Color _backgroundColor;

  /// This tab will be selected initially
  /// Default value = 0
  int currentActiveIndex; // TODO: Migrate this to screen_state_tracker

  /// These are the icons that are shown on the tab bar at the top
  final List<CustomTab> tabs;

  /// These are the views which are shown when the respective tab is pressed
  final List<Widget> views;

  /// Length of the pointer which slides below the tab
  final double pointerLength;

  /// Thickness of the pointer which slides below the tab
  final double pointerThickness;

  /// The gap between the tab and the pointer
  final double pointerTabGap;

  /// The gap between he tabs and views
  final double tabViewGap;

  /// Max height of the the tab and views
  final double? height;
  CustomTabView(
      {Key? key,
      required this.tabs,
      required this.views,
      this.currentActiveIndex = 0,
      this.pointerLength = 30,
      this.pointerThickness = 2,
      this.pointerTabGap = 4,
      this.tabViewGap = 10,
      this.height,
      Color? backgroundColor})
      : _backgroundColor = backgroundColor ??
            AppConstants.colors.secondaryColors.kBackgroundColor,
        assert(tabs.length == views.length,
            'length of tabs and views must be same'),
        super(key: key);

  @override
  State<CustomTabView> createState() => _CustomTabViewState();
}

class _CustomTabViewState extends State<CustomTabView> {
  double gap = 0;
  double left = 0;
  double textHeight = 0;
  @override
  void initState() {
    widget.tabs.sort((a, b) => a.index.compareTo(b.index));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    gap = MediaQuery.of(context).size.width;
    for (CustomTab tab in widget.tabs) {
      gap -= Formatter.textSize(tab.text, tab.textStyle).width;
    }
    gap /= widget.tabs.length;
    left = gap / 2;
    int i;

    textHeight = Formatter.textSize(widget.tabs[widget.currentActiveIndex].text,
            widget.tabs[widget.currentActiveIndex].textStyle)
        .height;

    for (i = 0; i < widget.currentActiveIndex; i++) {
      left += gap +
          Formatter.textSize(widget.tabs[i].text, widget.tabs[i].textStyle)
              .width;
    }
    left += Formatter.textSize(widget.tabs[i].text, widget.tabs[i].textStyle)
            .width /
        3;
    return Container(
      color: widget._backgroundColor,
      child: Column(
        children: [
          SizedBox(
            height: textHeight + widget.pointerTabGap + widget.pointerThickness,
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: AppConstants.durations.kQuick -
                      const Duration(milliseconds: 100),
                  top: textHeight + widget.pointerTabGap,
                  left: left,
                  child: Container(
                    height: widget.pointerThickness,
                    width: widget.pointerLength,
                    decoration: BoxDecoration(
                      color: AppConstants.colors.secondaryColors.kBaseColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: widget.tabs
                      .map((CustomTab tab) => GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.currentActiveIndex = tab.index;
                            });
                          },
                          child: tab.toWidget(widget.currentActiveIndex)))
                      .toList(),
                ),
              ],
            ),
          ),
          SizedBox(
            height: widget.tabViewGap,
          ),
          GestureDetector(
            onHorizontalDragEnd: (DragEndDetails drag) {
              final Velocity vel = drag.velocity;
              if (vel.pixelsPerSecond.dx < 0 &&
                  widget.currentActiveIndex + 1 < widget.views.length) {
                setState(() {
                  widget.currentActiveIndex++;
                });
              } else if (vel.pixelsPerSecond.dx > 0 &&
                  widget.currentActiveIndex > 0) {
                setState(() {
                  widget.currentActiveIndex--;
                });
              }
            },
            child: SingleChildScrollView(
                child: SizedBox(
                    height: widget.height ?? double.infinity,
                    child: widget.views[widget.currentActiveIndex])),
          ),
        ],
      ),
    );
  }
}
