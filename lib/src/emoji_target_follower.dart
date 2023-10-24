//
//  EmojiTargetFollower.dart
//  flutter_templet_project
//
//  Created by shang on 2023/10/18 14:05.
//  Copyright © 2023/10/18 shang. All rights reserved.
//


import 'package:flutter/material.dart';


class EmojiTargetFollower extends StatefulWidget {

  EmojiTargetFollower({
    Key? key,
    this.targetAnchor = Alignment.topCenter,
    this.followerAnchor = Alignment.bottomCenter,
    this.showWhenUnlinked = true,
    this.offset = Offset.zero,
    this.onTap,
    this.onLongPressEnd,
    required this.target,
    required this.follower,
  }) : super(key: key);


  final Alignment followerAnchor;
  final Alignment targetAnchor;

  final bool showWhenUnlinked;
  final Offset offset;

  final GestureTapCallback? onTap;

  /// 实现此方法则弹窗不会自动关闭,需手动关闭
  final GestureLongPressEndCallback? onLongPressEnd;

  final Widget target;
  final Widget? follower;


  @override
  _EmojiTargetFollowerState createState() => _EmojiTargetFollowerState();
}

class _EmojiTargetFollowerState extends State<EmojiTargetFollower> {

  final LayerLink layerLink = LayerLink();
  late OverlayEntry _overlayEntry;
  bool show = false;
  Offset indicatorOffset = const Offset(0, 0);

  @override
  Widget build(BuildContext context) {
    if (widget.follower == null) {
      return widget.target;
    }
    return GestureDetector(
      onTap: widget.onTap,
      // onTap: _toggleOverlay,
      // onPanStart: (e) => _showOverlay(),
      // onPanEnd: (e) => _hideOverlay(),
      // onPanUpdate: updateIndicator,
      onLongPressStart: (e) => _showOverlay(),
      onLongPressEnd: widget.onLongPressEnd ?? (e) => _hideOverlay(),
      onLongPressMoveUpdate: updateIndicatorLongPress,
      child: CompositedTransformTarget(
        link: layerLink,
        child: widget.target,
      ),
    );
  }

  void _toggleOverlay() {
    if (!show) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
    show = !show;
  }

  void _showOverlay() {
    _overlayEntry = _createOverlayEntry(indicatorOffset);
    Overlay.of(context).insert(_overlayEntry);
  }

  void _hideOverlay() {
    _overlayEntry.remove();
  }

  void updateIndicator(DragUpdateDetails details) {
    indicatorOffset = details.localPosition;
    _overlayEntry.markNeedsBuild();
  }


  void updateIndicatorLongPress(LongPressMoveUpdateDetails details) {
    indicatorOffset = details.localPosition;
    _overlayEntry?.markNeedsBuild();
  }

  OverlayEntry _createOverlayEntry(Offset localPosition) {
    indicatorOffset = localPosition;
    return OverlayEntry(
      builder: (BuildContext context) => UnconstrainedBox(
        child: CompositedTransformFollower(
          link: layerLink,
          // offset: indicatorOffset,
          followerAnchor: widget.followerAnchor,
          targetAnchor: widget.targetAnchor,
          offset: widget.offset,
          showWhenUnlinked: widget.showWhenUnlinked,
          child: widget.follower,
        ),
      ),
    );
  }
}