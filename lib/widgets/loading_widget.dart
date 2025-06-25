import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum LoadingWidgetType { circular, linear }

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({
    super.key,
    this.value,
    this.backgroundColor,
    this.valueColor,
    this.type = LoadingWidgetType.circular,
    this.showNumber = true,
  });

  final double? value;
  final Color? backgroundColor;
  final Color? valueColor;
  final LoadingWidgetType type;
  final bool showNumber;

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  var _value = 0.0;
  var _oldValue = 0.0;

  @override
  void didUpdateWidget(covariant LoadingWidget oldWidget) {
    if (widget.value != null) {
      setState(() {
        _oldValue = _value;
        _value = widget.value!;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.value == null) {
      return switch (widget.type) {
        LoadingWidgetType.circular => Center(
          child: CircularProgressIndicator(
            backgroundColor: widget.backgroundColor,
            valueColor: AlwaysStoppedAnimation(widget.valueColor),
          ),
        ),
        LoadingWidgetType.linear => LinearProgressIndicator(
          backgroundColor: widget.backgroundColor,
          valueColor: AlwaysStoppedAnimation(widget.valueColor),
        ),
      };
    }

    return switch (widget.type) {
      LoadingWidgetType.circular => Center(
        child: TweenAnimationBuilder(
          builder: (context, value, child) => Stack(
            children: [
              Center(
                child: CircularProgressIndicator(
                  value: value,
                  backgroundColor: widget.backgroundColor,
                  valueColor: AlwaysStoppedAnimation(widget.valueColor),
                ),
              ),

              if (widget.showNumber)
                Center(
                  child: Text(
                    '${(value * 100).toInt()}%',
                    style: TextStyle(
                      color: widget.valueColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          tween: Tween(begin: _oldValue, end: _value),
          duration: 200.milliseconds,
        ),
      ),
      LoadingWidgetType.linear => Stack(
        children: [
          Positioned.fill(
            child: LinearProgressIndicator(
              value: _value,
              backgroundColor: widget.backgroundColor,
              valueColor: AlwaysStoppedAnimation(widget.valueColor),
            ),
          ),

          if (widget.showNumber)
            Center(
              child: Text(
                '${(_value * 100).toInt()}%',
                style: TextStyle(
                  color: widget.valueColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    };
  }
}
