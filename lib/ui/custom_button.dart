import 'package:flutter/material.dart';
import 'package:flutter_videocall/utils/math_utils.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton({
    this.shape,
    this.padding,
    this.variant,
    this.fontStyle,
    this.alignment,
    this.onTap,
    this.width,
    this.margin,
    this.text,
  });

  ButtonShape? shape;
  ButtonPadding? padding;
  ButtonVariant? variant;
  ButtonFontStyle? fontStyle;
  Alignment? alignment;
  VoidCallback? onTap;
  double? width;
  EdgeInsetsGeometry? margin;
  String? text;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: _buildButtonWidget(),
          )
        : _buildButtonWidget();
  }

  Widget _buildButtonWidget() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: _buildDecoration(),
        margin: margin,
        padding: _setPadding(),
        width: getHorizontalSize(width ?? 0),
        child: Text(
          text ?? "",
          textAlign: TextAlign.center,
          style: _setFontStyle(),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: _setColor(),
      borderRadius: _setBorderRadius(),
      boxShadow: _setBoxShadow(),
    );
  }

  EdgeInsetsGeometry _setPadding() {
    switch (padding) {
      case ButtonPadding.PaddingAll12:
        return EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      default:
        return EdgeInsets.symmetric(horizontal: 12, vertical: 8);
    }
  }

  Color _setColor() {
    switch (variant) {
      case ButtonVariant.FillIndigo50:
        return Color(0xFF2087C9);
      case ButtonVariant.FillIndigoA700:
        return Color(0xFF2087C9);
      case ButtonVariant.FillWhiteA700:
        return Colors.white;
      case ButtonVariant.FillGreen50:
        return Colors.green;
      case ButtonVariant
            .FillCustomColor: // Nuevo caso para el color personalizado
        return const Color(0xFF0D49A1);
      default:
        return Color(0xFF2087C9);
    }
  }

  BorderRadius _setBorderRadius() {
    switch (shape) {
      case ButtonShape.RoundedBorder4:
        return BorderRadius.circular(getHorizontalSize(4.00));
      case ButtonShape.Square:
        return BorderRadius.circular(0);
      default:
        return BorderRadius.circular(getHorizontalSize(8.00));
    }
  }

  List<BoxShadow>? _setBoxShadow() {
    return null; // No agregar sombra
  }

  TextStyle _setFontStyle() {
    switch (fontStyle) {
      case ButtonFontStyle.GilroyMedium12:
        return TextStyle(
          color: Color(0xFF2087C9),
          fontSize: getFontSize(12),
          fontFamily: 'Gilroy-Medium',
          fontWeight: FontWeight.w500,
        );
      case ButtonFontStyle.GilroyMedium12WhiteA700:
        return TextStyle(
          color: Colors.white,
          fontSize: getFontSize(12),
          fontFamily: 'Gilroy-Medium',
          fontWeight: FontWeight.w500,
        );
      case ButtonFontStyle.GilroyRegular14:
        return TextStyle(
          color: Colors.green,
          fontSize: getFontSize(14),
          fontFamily: 'Gilroy-Medium',
          fontWeight: FontWeight.w400,
        );
      case ButtonFontStyle.GilroyMedium16IndigoA700:
        return TextStyle(
          color: Color(0xFF2087C9),
          fontSize: getFontSize(16),
          fontFamily: 'Gilroy-Medium',
          fontWeight: FontWeight.w500,
        );
      default:
        return TextStyle(
          color: Colors.white,
          fontSize: getFontSize(16),
          fontFamily: 'Gilroy-Medium',
          fontWeight: FontWeight.w500,
        );
    }
  }
}

enum ButtonShape {
  Square,
  RoundedBorder8,
  RoundedBorder4,
}

enum ButtonPadding {
  PaddingAll20,
  PaddingAll12,
}

enum ButtonVariant {
  OutlineDeeppurple9002b,
  FillIndigo50,
  FillIndigoA700,
  FillWhiteA700,
  FillGreen50,
  FillCustomColor, // Nuevo valor agregado para el color personalizado
}

enum ButtonFontStyle {
  GilroyMedium16,
  GilroyMedium12,
  GilroyMedium12WhiteA700,
  GilroyRegular14,
  GilroyMedium16IndigoA700,
}
