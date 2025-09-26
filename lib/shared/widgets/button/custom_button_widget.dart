import 'package:flutter/material.dart';

class CustomButtonWidget extends StatefulWidget {
  final bool enabled;
  final String text;
  final double textSize;
  final FontWeight fontWeight;
  final bool outline;
  final bool shrinkWrap;
  final bool noBorder;
  final VoidCallback? onPressed;
  final Color? color;
  final EdgeInsets? padding;
  final bool isLoading;
  final double? width;

  const CustomButtonWidget({
    required this.onPressed,
    required this.text,
    this.color,
    this.padding,
    this.enabled = true,
    this.textSize = 14,
    this.fontWeight = FontWeight.bold,
    this.outline = false,
    this.noBorder = false,
    this.shrinkWrap = false,
    this.isLoading = false,
    this.width,
    super.key,
  }) : assert(
         !noBorder || !outline,
         "noBorder and outline can't be active together.",
       );

  @override
  State createState() => _CustomButtonWidgetState();
}

class _CustomButtonWidgetState extends State<CustomButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    final size = MediaQuery.of(context).size;

    return ButtonTheme(
      materialTapTargetSize: widget.shrinkWrap
          ? MaterialTapTargetSize.shrinkWrap
          : null,
      child: SizedBox(
        height: widget.shrinkWrap ? 0 : 48,
        width: widget.width ?? size.width,
        child: TextButton(
          onPressed: widget.enabled ? widget.onPressed : null,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(
              widget.outline
                  ? Colors.transparent
                  : (widget.noBorder ||
                        widget.onPressed == null ||
                        !widget.enabled)
                  ? Colors.grey
                  : widget.color ?? primaryColor,
            ),
            padding: WidgetStateProperty.all<EdgeInsetsGeometry?>(
              widget.padding,
            ),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: widget.noBorder
                    ? const BorderSide(color: Colors.transparent)
                    : widget.outline
                    ? BorderSide(color: widget.color ?? primaryColor)
                    : const BorderSide(color: Colors.transparent),
              ),
            ),
          ),
          child: widget.isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  widget.text,
                  style: TextStyle(
                    color: (widget.outline || widget.noBorder)
                        ? widget.color ?? primaryColor
                        : Colors.white,
                    fontWeight: widget.fontWeight,
                    fontSize: widget.textSize,
                  ),
                ),
        ),
      ),
    );
  }
}
