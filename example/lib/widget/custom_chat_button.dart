// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

// Project imports:

class CustomChatButton extends StatefulWidget {
  const CustomChatButton({
    super.key,
    this.placeHolder = 'Say something...',
    this.payloadAttributes,
    this.backgroundColor,
    this.inputBackgroundColor,
    this.textColor,
    this.textHintColor,
    this.cursorColor,
    this.buttonColor,
    this.borderRadius,
    this.enabled = true,
    this.autofocus = true,
    this.onSubmit,
    this.valueNotifier,
    this.focusNotifier,
  });

  final String placeHolder;
  final Map<String, String>? payloadAttributes;
  final Color? backgroundColor;
  final Color? inputBackgroundColor;
  final Color? textColor;
  final Color? textHintColor;
  final Color? cursorColor;
  final Color? buttonColor;
  final double? borderRadius;
  final bool enabled;
  final bool autofocus;
  final VoidCallback? onSubmit;
  final ValueNotifier<String>? valueNotifier;
  final ValueNotifier<bool>? focusNotifier;

  @override
  State<CustomChatButton> createState() => _CustomChatButtonState();
}

class _CustomChatButtonState extends State<CustomChatButton> {
  final TextEditingController textController = TextEditingController();
  ValueNotifier<bool> isEmptyNotifier = ValueNotifier(true);
  var focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    focusNode.addListener(onFocusChange);

    if (widget.valueNotifier != null) {
      textController.text = widget.valueNotifier!.value;

      isEmptyNotifier.value = textController.text.isEmpty;
    }
  }

  @override
  void dispose() {
    super.dispose();

    focusNode
      ..removeListener(onFocusChange)
      ..dispose();
  }

  void onFocusChange() {
    widget.focusNotifier?.value = focusNode.hasFocus;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      color: widget.backgroundColor ?? const Color(0xff222222).withOpacity(0.8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 90,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: 10),
            messageInput(),
            const SizedBox(width: 10),
            sendButton(),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Widget messageInput() {
    final messageSendBgColor = widget.buttonColor ?? const Color(0xff3e3e3d);
    final messageSendCursorColor =
        widget.cursorColor ?? const Color(0xffA653ff);
    final messageSendHintStyle = TextStyle(
      color: widget.textHintColor ?? const Color(0xffa4a4a4),
      fontSize: 28,
      fontWeight: FontWeight.w400,
    );
    final messageSendInputStyle = TextStyle(
      color: widget.textColor ?? Colors.white,
      fontSize: 28,
      fontWeight: FontWeight.w400,
    );

    return Expanded(
      child: Container(
        height: 78,
        decoration: BoxDecoration(
          color: widget.inputBackgroundColor ?? messageSendBgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          enabled: widget.enabled,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: null,
          autofocus: widget.autofocus,
          focusNode: focusNode,
          inputFormatters: <TextInputFormatter>[
            LengthLimitingTextInputFormatter(400)
          ],
          controller: textController,
          onChanged: (String inputMessage) {
            widget.valueNotifier?.value = inputMessage;

            final valueIsEmpty = inputMessage.isEmpty;
            if (valueIsEmpty != isEmptyNotifier.value) {
              isEmptyNotifier.value = valueIsEmpty;
            }
          },
          textInputAction: TextInputAction.send,
          onSubmitted: (message) => send(),
          cursorColor: messageSendCursorColor,
          cursorHeight: 30,
          cursorWidth: 3,
          style: messageSendInputStyle,
          decoration: InputDecoration(
            hintText: widget.placeHolder,
            hintStyle: messageSendHintStyle,
            contentPadding: const EdgeInsets.only(
              left: 20,
              top: -5,
              right: 20,
              bottom: 15,
            ),
            // isDense: true,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget sendButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: isEmptyNotifier,
      builder: (context, bool isEmpty, Widget? child) {
        return ZegoTextIconButton(
          onPressed: () {
            if (!isEmpty) send();
          },
          icon: ButtonIcon(
            icon: isEmpty
                ? UIKitImage.asset(StyleIconUrls.iconSendDisable)
                : UIKitImage.asset(StyleIconUrls.iconSend),
            backgroundColor: widget.buttonColor,
          ),
          iconSize: const Size(68, 68),
          buttonSize: const Size(72, 72),
        );
      },
    );
  }

  void send() {
    if (textController.text.isEmpty) {
      ZegoLoggerService.logInfo(
        'message is empty',
        tag: 'uikit-component',
        subTag: 'in room message input',
      );
      return;
    }

    if (widget.payloadAttributes?.isEmpty ?? true) {
      ZegoUIKit().sendInRoomMessage(textController.text);
    } else {
      ZegoUIKit().sendInRoomMessage(
        ZegoInRoomMessage.jsonBody(
          message: textController.text,
          attributes: widget.payloadAttributes!,
        ),
      );
    }
    textController.clear();

    widget.valueNotifier?.value = '';

    widget.onSubmit?.call();
  }
}

class ZegoTextIconButton extends StatefulWidget {
  final String? text;
  final TextStyle? textStyle;
  final bool? softWrap;

  final ButtonIcon? icon;
  final Size? iconSize;
  final double? iconTextSpacing;
  final Color? iconBorderColor;

  final Size? buttonSize;
  final double? borderRadius;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  final VoidCallback? onPressed;
  final Color? clickableTextColor;
  final Color? unclickableTextColor;
  final Color? clickableBackgroundColor;
  final Color? unclickableBackgroundColor;

  final bool verticalLayout;

  const ZegoTextIconButton({
    super.key,
    this.text,
    this.textStyle,
    this.softWrap,
    this.icon,
    this.iconTextSpacing,
    this.iconSize,
    this.iconBorderColor,
    this.buttonSize,
    this.borderRadius,
    this.margin,
    this.padding,
    this.onPressed,
    this.clickableTextColor = Colors.black,
    this.unclickableTextColor = Colors.black,
    this.clickableBackgroundColor = Colors.transparent,
    this.unclickableBackgroundColor = Colors.transparent,
    this.verticalLayout = true,
  });

  @override
  State<ZegoTextIconButton> createState() => _ZegoTextIconButtonState();
}

class _ZegoTextIconButtonState extends State<ZegoTextIconButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      onLongPress: onPressed,
      child: Container(
        width: widget.buttonSize?.width ?? 120,
        height: widget.buttonSize?.height ?? 120,
        margin: widget.margin,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.onPressed != null
              ? widget.clickableBackgroundColor
              : widget.unclickableBackgroundColor,
          borderRadius: null != widget.borderRadius
              ? BorderRadius.all(Radius.circular(widget.borderRadius!))
              : null,
          shape: null != widget.borderRadius
              ? BoxShape.rectangle
              : BoxShape.circle,
        ),
        child: widget.verticalLayout
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children(context),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children(context),
              ),
      ),
    );
  }

  List<Widget> children(BuildContext context) {
    return [
      icon(),
      ...text(),
    ];
  }

  Widget icon() {
    if (widget.icon == null) {
      return Container();
    }

    return Container(
      width: widget.iconSize?.width ?? 74,
      height: widget.iconSize?.height ?? 74,
      decoration: BoxDecoration(
        color: widget.icon?.backgroundColor ?? Colors.transparent,
        border: Border.all(
            color: widget.iconBorderColor ?? Colors.transparent, width: 1),
        borderRadius:
            BorderRadius.all(Radius.circular(widget.iconSize?.width ?? 74 / 2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.iconSize?.width ?? 74 / 2),
        child: widget.icon?.icon,
      ),
    );
  }

  List<Widget> text() {
    if (widget.text == null || widget.text!.isEmpty) {
      return [Container()];
    }

    final iconTextSpacing =
        (widget.icon == null ? 0.0 : widget.iconTextSpacing) ?? 12.0;
    return [
      if (widget.verticalLayout)
        SizedBox(height: iconTextSpacing)
      else
        SizedBox(width: iconTextSpacing),
      Text(
        widget.text!,
        softWrap: widget.softWrap,
        style: widget.textStyle ??
            TextStyle(
              color: widget.onPressed != null
                  ? widget.clickableTextColor
                  : widget.unclickableTextColor,
              fontSize: 26,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none,
            ),
      ),
    ];
  }

  void onPressed() {
    widget.onPressed?.call();
  }
}
