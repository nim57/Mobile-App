// widgets/custom_rating_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomRatingBar extends StatefulWidget {
  final String title;
  final double rating;
  final ValueChanged<double> onRatingChanged;

  const CustomRatingBar({
    super.key,
    required this.title,
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  State<CustomRatingBar> createState() => _CustomRatingBarState();
}

class _CustomRatingBarState extends State<CustomRatingBar> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  bool _showError = false;
  bool _isUpdatingFromCode = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.rating.toStringAsFixed(0));
    _controller.addListener(_handleTextInput);
  }

  @override
  void didUpdateWidget(CustomRatingBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rating != widget.rating && !_focusNode.hasFocus) {
      _updateControllerText();
    }
  }

  void _updateControllerText() {
    _isUpdatingFromCode = true;
    final newText = widget.rating.toStringAsFixed(0);
    if (_controller.text != newText) {
      _controller.text = newText;
    }
    _showError = false;
    _isUpdatingFromCode = false;
  }

  void _handleTextInput() {
    if (_isUpdatingFromCode) return;
    
    final text = _controller.text;
    if (text.isEmpty) {
      setState(() => _showError = true);
      return;
    }

    final value = double.tryParse(text);
    if (value == null || value < 0 || value > 100) {
      setState(() => _showError = true);
      return;
    }

    final clampedValue = value.clamp(0, 100).toDouble();
    if (clampedValue == widget.rating) {
      setState(() => _showError = false);
      return;
    }

    setState(() => _showError = false);
    widget.onRatingChanged(clampedValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(
              width: 100,
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: InputDecoration(
                  suffixText: '%',
                  errorText: _showError ? 'Invalid' : null,
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
                onSubmitted: (value) {
                  _focusNode.unfocus();
                  _handleTextInput();
                },
              ),
            ),
          ],
        ),
        if (_showError)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              'Enter value between 0-100',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.blue,
            inactiveTrackColor: Colors.grey.shade300,
            thumbColor: Colors.blue,
            overlayColor: Colors.blue.withOpacity(0.2),
            trackHeight: 12.0,
            trackShape: const RoundedRectSliderTrackShape(),
            thumbShape: const RectangularSliderThumbShape(
              thumbHeight: 24,
              thumbWidth: 8,
            ),
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: 16.0,
            ),
          ),
          child: Slider(
            value: widget.rating,
            min: 0,
            max: 100,
            divisions: 100,
            label: widget.rating.toStringAsFixed(0),
            onChanged: (value) {
              widget.onRatingChanged(value);
              _focusNode.unfocus();
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class RoundedRectSliderTrackShape extends SliderTrackShape {
  const RoundedRectSliderTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
    Offset? secondaryOffset,
  }) {
    final Paint paint = Paint()
      ..color = sliderTheme.activeTrackColor!
      ..style = PaintingStyle.fill;

    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
    );

    // Draw inactive track
    context.canvas.drawRRect(
      RRect.fromRectAndCorners(
        trackRect,
       
      ),
      Paint()..color = sliderTheme.inactiveTrackColor!,
    );

    // Draw active track
    final activeTrackWidth = thumbCenter.dx - offset.dx;
    context.canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
          trackRect.left,
          trackRect.top,
          activeTrackWidth,
          trackRect.height,
        ),
       
      ),
      paint,
    );
  }
}

class RectangularSliderThumbShape extends SliderComponentShape {
  final double thumbHeight;
  final double thumbWidth;

  const RectangularSliderThumbShape({
    this.thumbHeight = 24.0,
    this.thumbWidth = 8.0,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(thumbWidth, thumbHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Paint paint = Paint()
      ..color = sliderTheme.thumbColor!
      ..style = PaintingStyle.fill;

    context.canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromCenter(
          center: center,
          width: thumbWidth,
          height: thumbHeight,
        ),
       
      ),
      paint,
    );
  }
}