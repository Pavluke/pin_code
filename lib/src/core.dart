//region 4. CORE LOGIC MIXIN

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code/src/config.dart';
import 'package:pin_code/src/pin_code_painters.dart';

import 'pin_code_widget.dart';

/// A `mixin` that contains all the state and UI logic for [PinCode].
/// This keeps the [_PinCodeState] class clean and focused on its lifecycle.
mixin PinCodeMixin on State<PinCode> {
  TextEditingController? textEditingController;
  FocusNode? focusNode;
  late List<String> inputList;
  int selectedIndex = 0;
  BorderRadius? borderRadius;

  // Animation Controllers
  late AnimationController errorController;
  late AnimationController cursorController;
  late Animation<Offset> offsetAnimation;
  late Animation<double> cursorAnimation;

  StreamSubscription<PinCodeErrorAnimationType>? errorAnimationSubscription;
  bool isInErrorMode = false;

  PinCodeTheme get pinTheme => widget.pinTheme;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  /// Initializes all controllers, listeners, and animations.
  void _initialize() {
    textEditingController = widget.controller ?? TextEditingController();
    textEditingController!.addListener(_onTextChanged);
    focusNode = widget.focusNode ?? FocusNode();
    focusNode!.addListener(() => setState(() {}));

    inputList = List<String>.filled(widget.length, "");
    if (textEditingController!.text.isNotEmpty) {
      _setTextToInput(textEditingController!.text);
    }

    if (pinTheme.shape != PinCodeFieldShape.circle) {
      borderRadius = pinTheme.borderRadius;
    }

    errorController = AnimationController(
      duration: Duration(milliseconds: widget.errorAnimationDuration),
      vsync: this as TickerProvider,
    );
    cursorController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this as TickerProvider,
    );

    offsetAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0.1, 0.0)).animate(
          CurvedAnimation(parent: errorController, curve: Curves.elasticIn),
        );

    cursorAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(parent: cursorController, curve: Curves.easeIn));

    if (widget.showCursor) {
      cursorController.repeat();
    }

    errorController.addStatusListener((status) {
      if (status == .completed) {
        errorController.reverse();
      }
    });

    errorAnimationSubscription = widget.errorAnimationController?.stream.listen(
      (error) {
        final bool isShake = error == .shake;

        if (isShake) {
          errorController.forward();
        }
        setState(() => isInErrorMode = isShake);
      },
    );
  }

  /// Disposes all resources used by the widget.
  void _dispose() {
    textEditingController?.removeListener(_onTextChanged);
    if (widget.autoDisposeControllers) {
      textEditingController?.dispose();
      focusNode?.dispose();
    }
    errorAnimationSubscription?.cancel();
    errorController.dispose();
    cursorController.dispose();
  }

  /// Handles the logic whenever the text in the controller changes.
  void _onTextChanged() {
    if (widget.useHapticFeedback) {
      HapticFeedback.lightImpact();
    }
    if (isInErrorMode) {
      setState(() => isInErrorMode = false);
    }

    String currentText = textEditingController!.text;
    if (widget.enabled && inputList.join("") != currentText) {
      if (currentText.length >= widget.length) {
        if (widget.onCompleted != null) {
          if (currentText.length > widget.length) {
            currentText = currentText.substring(0, widget.length);
          }
          Future.delayed(
            const Duration(milliseconds: 100),
            () => widget.onCompleted!(currentText),
          );
        }
        if (widget.autoDismissKeyboard) {
          focusNode!.unfocus();
        }
      }
      widget.onChanged?.call(currentText);
    }
    _setTextToInput(currentText);
  }

  /// Handles the logic for requesting or removing focus.
  void _onFocus() {
    if (widget.autoUnfocus &&
        focusNode!.hasFocus &&
        MediaQuery.of(context).viewInsets.bottom == 0) {
      focusNode!.unfocus();
      Future.delayed(
        const Duration(microseconds: 1),
        () => focusNode!.requestFocus(),
      );
    } else {
      focusNode!.requestFocus();
    }
  }

  /// Updates the `inputList` to reflect the current text in the UI.
  void _setTextToInput(String data) {
    if (!mounted) return;

    var updatedList = List<String>.filled(widget.length, "");
    for (int i = 0; i < widget.length; i++) {
      if (i < data.length) {
        updatedList[i] = data[i];
      }
    }
    setState(() {
      selectedIndex = data.length;
      inputList = updatedList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: offsetAnimation,
      child: Container(
        height: (widget.validator == null)
            ? pinTheme.fieldHeight
            : pinTheme.fieldHeight + widget.errorTextSpace,
        color: widget.backgroundColor,
        child: Stack(
          alignment: .bottomCenter,
          children: <Widget>[
            _HiddenTextFormField(
              controller: textEditingController!,
              focusNode: focusNode!,
              enabled: widget.enabled,
              enablePinAutofill: widget.enablePinAutofill,
              autoFocus: widget.autoFocus,
              keyboardType: widget.keyboardType,
              textCapitalization: widget.textCapitalization,
              validator: widget.validator,
              onSaved: widget.onSaved,
              autovalidateMode: widget.autovalidateMode,
              inputFormatters: widget.inputFormatters,
              length: widget.length,
              onSubmitted: widget.onSubmitted,
              onEditingComplete: widget.onEditingComplete,
              scrollPadding: widget.scrollPadding,
              readOnly: widget.readOnly,
              onAutoFillDisposeAction: widget.onAutoFillDisposeAction,
              inputDecoration: widget.inputDecoration,
            ),
            _PinFieldsRow(
              onTap: () {
                widget.onTap?.call();
                _onFocus();
              },
              onLongPress: widget.enabled
                  ? () async {
                      var data = await Clipboard.getData("text/plain");
                      if (data != null && data.text != null) {
                        if (widget.beforeTextPaste?.call(data.text) ?? true) {
                          textEditingController!.text = data.text!;
                        }
                      }
                    }
                  : null,
              mainAxisAlignment: widget.mainAxisAlignment,
              length: widget.length,
              pinTheme: pinTheme,
              animationCurve: widget.animationCurve,
              animationDuration: widget.animationDuration,
              enableActiveFill: widget.enableActiveFill,
              boxShadows: widget.boxShadows,
              borderRadius: borderRadius,
              inputList: inputList,
              hasFocus: focusNode!.hasFocus,
              selectedIndex: selectedIndex,
              obscureText: widget.obscureText,
              obscuringWidget: widget.obscuringWidget,
              obscuringCharacter: widget.obscuringCharacter,
              textStyle: widget.textStyle,
              hintCharacter: widget.hintCharacter,
              hintStyle: widget.hintStyle,
              showCursor: widget.showCursor,
              cursorColor: widget.cursorColor,
              cursorHeight: widget.cursorHeight,
              cursorWidth: widget.cursorWidth,
              cursorAnimation: cursorAnimation,
              separatorBuilder: widget.separatorBuilder,
              isInErrorMode: isInErrorMode,
              enabled: widget.enabled,
            ),
          ],
        ),
      ),
    );
  }
}

/// A hidden [TextFormField] that handles the actual text input.
///
/// This widget is invisible to the user but captures keyboard input
/// and manages autofill functionality for OTP codes.
class _HiddenTextFormField extends StatelessWidget {
  const _HiddenTextFormField({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.enablePinAutofill,
    required this.autoFocus,
    required this.keyboardType,
    required this.textCapitalization,
    required this.autovalidateMode,
    required this.inputFormatters,
    required this.length,
    required this.scrollPadding,
    required this.readOnly,
    required this.onAutoFillDisposeAction,
    this.validator,
    this.onSaved,
    this.onSubmitted,
    this.onEditingComplete,
    this.inputDecoration,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final bool enablePinAutofill;
  final bool autoFocus;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final AutovalidateMode autovalidateMode;
  final List<TextInputFormatter> inputFormatters;
  final int length;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final EdgeInsets scrollPadding;
  final bool readOnly;
  final AutofillContextAction onAutoFillDisposeAction;
  final InputDecoration? inputDecoration;

  @override
  Widget build(BuildContext context) => AbsorbPointer(
    absorbing: true,
    child: AutofillGroup(
      onDisposeAction: onAutoFillDisposeAction,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        enabled: enabled,
        autofillHints: enablePinAutofill && enabled
            ? <String>[AutofillHints.oneTimeCode]
            : null,
        autofocus: autoFocus,
        autocorrect: false,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        validator: validator,
        onSaved: onSaved,
        autovalidateMode: autovalidateMode,
        inputFormatters: [
          ...inputFormatters,
          LengthLimitingTextInputFormatter(length),
        ],
        onFieldSubmitted: onSubmitted,
        onEditingComplete: onEditingComplete,
        showCursor: false,
        cursorWidth: 0.01,
        decoration:
            inputDecoration ??
            const InputDecoration(
              contentPadding: EdgeInsets.all(0),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              fillColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
            ),
        style: TextStyle(
          color: Colors.transparent,
          height: 0.01,
          fontSize: kIsWeb ? 1 : 0.01,
        ),
        scrollPadding: scrollPadding,
        readOnly: readOnly,
      ),
    ),
  );
}

/// Builds the visible row of PIN fields that the user interacts with.
///
/// Uses [PinFieldStyleCalculator] to compute styles for each field
/// and generates widgets via `.expand()` for clean functional composition.
class _PinFieldsRow extends StatelessWidget {
  const _PinFieldsRow({
    required this.onTap,
    required this.mainAxisAlignment,
    required this.length,
    required this.pinTheme,
    required this.animationCurve,
    required this.animationDuration,
    required this.enableActiveFill,
    required this.inputList,
    required this.hasFocus,
    required this.selectedIndex,
    required this.obscureText,
    required this.obscuringCharacter,
    required this.showCursor,
    required this.cursorWidth,
    required this.cursorAnimation,
    required this.isInErrorMode,
    required this.enabled,
    this.onLongPress,
    this.boxShadows,
    this.borderRadius,
    this.obscuringWidget,
    this.textStyle,
    this.hintCharacter,
    this.hintStyle,
    this.cursorColor,
    this.cursorHeight,
    this.separatorBuilder,
  });

  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final MainAxisAlignment mainAxisAlignment;
  final int length;
  final PinCodeTheme pinTheme;
  final Curve animationCurve;
  final Duration animationDuration;
  final bool enableActiveFill;
  final List<BoxShadow>? boxShadows;
  final BorderRadius? borderRadius;
  final List<String> inputList;
  final bool hasFocus;
  final int selectedIndex;
  final bool obscureText;
  final Widget? obscuringWidget;
  final String obscuringCharacter;
  final TextStyle? textStyle;
  final String? hintCharacter;
  final TextStyle? hintStyle;
  final bool showCursor;
  final Color? cursorColor;
  final double? cursorHeight;
  final double cursorWidth;
  final Animation<double> cursorAnimation;
  final IndexedWidgetBuilder? separatorBuilder;
  final bool isInErrorMode;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final styleCalculator = PinFieldStyleCalculator(
      pinTheme: pinTheme,
      enabled: enabled,
      hasFocus: hasFocus,
      selectedIndex: selectedIndex,
      isInErrorMode: isInErrorMode,
      enableActiveFill: enableActiveFill,
    );

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: [
            ...styleCalculator
                .calculate(length, inputList)
                .expand(
                  (data) => [
                    _PinField(
                      data: data,
                      pinTheme: pinTheme,
                      animationCurve: animationCurve,
                      animationDuration: animationDuration,
                      boxShadows: boxShadows,
                      borderRadius: borderRadius,
                      hasFocus: hasFocus,
                      selectedIndex: selectedIndex,
                      length: length,
                      obscureText: obscureText,
                      obscuringWidget: obscuringWidget,
                      obscuringCharacter: obscuringCharacter,
                      textStyle: textStyle,
                      hintCharacter: hintCharacter,
                      hintStyle: hintStyle,
                      showCursor: showCursor,
                      cursorColor: cursorColor,
                      cursorHeight: cursorHeight,
                      cursorWidth: cursorWidth,
                      cursorAnimation: cursorAnimation,
                    ),
                    if (separatorBuilder != null && data.index < length - 1)
                      separatorBuilder!(context, data.index),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}

/// Renders a single PIN field with animated container and decoration.
///
/// Receives pre-calculated styles from [PinFieldData] to display
/// the appropriate fill color and border based on the field state.
class _PinField extends StatelessWidget {
  const _PinField({
    required this.data,
    required this.pinTheme,
    required this.animationCurve,
    required this.animationDuration,
    required this.hasFocus,
    required this.selectedIndex,
    required this.length,
    required this.obscureText,
    required this.obscuringCharacter,
    required this.showCursor,
    required this.cursorWidth,
    required this.cursorAnimation,
    this.boxShadows,
    this.borderRadius,
    this.obscuringWidget,
    this.textStyle,
    this.hintCharacter,
    this.hintStyle,
    this.cursorColor,
    this.cursorHeight,
  });

  final PinFieldData data;
  final PinCodeTheme pinTheme;
  final Curve animationCurve;
  final Duration animationDuration;
  final List<BoxShadow>? boxShadows;
  final BorderRadius? borderRadius;
  final bool hasFocus;
  final int selectedIndex;
  final int length;
  final bool obscureText;
  final Widget? obscuringWidget;
  final String obscuringCharacter;
  final TextStyle? textStyle;
  final String? hintCharacter;
  final TextStyle? hintStyle;
  final bool showCursor;
  final Color? cursorColor;
  final double? cursorHeight;
  final double cursorWidth;
  final Animation<double> cursorAnimation;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    padding: pinTheme.fieldOuterPadding,
    curve: animationCurve,
    duration: animationDuration,
    width: pinTheme.fieldWidth,
    height: pinTheme.fieldHeight,
    decoration: BoxDecoration(
      color: data.fillColor,
      boxShadow: boxShadows,
      shape: pinTheme.shape == PinCodeFieldShape.circle
          ? BoxShape.circle
          : BoxShape.rectangle,
      borderRadius: borderRadius,
      border: data.border,
    ),
    child: Center(
      child: AnimatedSwitcher(
        duration: animationDuration,
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: _PinFieldChild(
          index: data.index,
          character: data.character,
          hasFocus: hasFocus,
          selectedIndex: selectedIndex,
          length: length,
          obscureText: obscureText,
          obscuringWidget: obscuringWidget,
          obscuringCharacter: obscuringCharacter,
          textStyle: textStyle,
          hintCharacter: hintCharacter,
          hintStyle: hintStyle,
          showCursor: showCursor,
          cursorColor: cursorColor,
          cursorHeight: cursorHeight,
          cursorWidth: cursorWidth,
          cursorAnimation: cursorAnimation,
        ),
      ),
    ),
  );
}

/// Renders the inner content of a PIN field (character, hint, or cursor).
///
/// Uses pattern matching to determine what to display based on:
/// - Whether the field has a character entered
/// - Whether the text should be obscured
/// - Whether a hint character should be shown
class _PinFieldChild extends StatelessWidget {
  const _PinFieldChild({
    required this.index,
    required this.character,
    required this.hasFocus,
    required this.selectedIndex,
    required this.length,
    required this.obscureText,
    required this.obscuringCharacter,
    required this.showCursor,
    required this.cursorWidth,
    required this.cursorAnimation,
    this.obscuringWidget,
    this.textStyle,
    this.hintCharacter,
    this.hintStyle,
    this.cursorColor,
    this.cursorHeight,
  });

  final int index;
  final String character;
  final bool hasFocus;
  final int selectedIndex;
  final int length;
  final bool obscureText;
  final Widget? obscuringWidget;
  final String obscuringCharacter;
  final TextStyle? textStyle;
  final String? hintCharacter;
  final TextStyle? hintStyle;
  final bool showCursor;
  final Color? cursorColor;
  final double? cursorHeight;
  final double cursorWidth;
  final Animation<double> cursorAnimation;

  @override
  Widget build(BuildContext context) => Stack(
    alignment: .center,
    children: [
      switch ((character.isNotEmpty, obscureText, hintCharacter)) {
        (true, true, _) =>
          obscuringWidget ??
              Text(
                obscuringCharacter,
                key: ValueKey('obscure_$index'),
                style: textStyle,
              ),
        (true, false, _) => Text(
          character,
          key: ValueKey('char_$index'),
          style: textStyle,
        ),
        (false, _, String hint) => Text(
          hint,
          key: ValueKey('hint_$index'),
          style: hintStyle,
        ),
        _ => SizedBox.shrink(key: ValueKey('empty_$index')),
      },
      if (showCursor &&
          hasFocus &&
          (selectedIndex == index ||
              (selectedIndex == index + 1 && index + 1 == length)))
        FadeTransition(
          opacity: cursorAnimation,
          child: CustomPaint(
            size: Size(0, cursorHeight ?? (textStyle?.fontSize ?? 20) + 8),
            painter: PinCodePainter(
              cursorColor:
                  cursorColor ?? Theme.of(context).colorScheme.secondary,
              cursorWidth: cursorWidth,
            ),
          ),
        ),
    ],
  );
}

//endregion
