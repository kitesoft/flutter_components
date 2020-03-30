import 'package:flutter/material.dart';

class ChatBubble<T> extends StatelessWidget {
  final String headerText;
  final Widget bodyWidget;
  final String message;
  final double headerTextScaleSize;
  final double messageTextScaleSize;
  final String avatarUrl;
  final String avatarPlaceholderPath;
  final Color backgroundColor;
  final Color textColor;
  final double bubbleMaxWidth;
  final double avatarSize;
  final bool showSpacingWithHiddenAvatar;
  final bool isOnTheLeftSide;
  final bool displayNameInHeader;
  final double borderRadius;
  final bool showAvatar;
  final Color headerColor;
  final Widget headerWidget;
  final Widget footerWidget;
  final int maxMessageLines;
  final EdgeInsets padding;
  final FontWeight headerFontWeight;
  final FontWeight fontWeight;
  final CrossAxisAlignment avatarAlignment;
  final List<BoxShadow> bubbleShadows;
  final List<dynamic> replies;
  final Widget Function(T) replyBuilder;

  /// Chat bubble mostly used for messaging.
  /// One of the parameter
  /// [message] or [bodyText] must exist.
  /// [message] where the chat bubble contains and wrap around.
  /// [isOnTheLeftSide] oh the list view, if its true bubble will be on the left side.
  /// [textColor] of the text on bubble.
  /// [backgroundColor] of the bubble.
  ChatBubble({
    this.bodyWidget,
    this.message,
    this.bubbleMaxWidth,
    this.showAvatar = true,
    this.headerTextScaleSize = 1,
    this.messageTextScaleSize = 1.2,
    this.headerText,
    this.avatarPlaceholderPath,
    this.avatarUrl,
    this.isOnTheLeftSide = false,
    this.displayNameInHeader = true,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.blue,
    this.bubbleShadows,
    this.showSpacingWithHiddenAvatar = false,
    this.avatarAlignment = CrossAxisAlignment.start,
    this.borderRadius = 10,
    this.avatarSize = 33,
    this.headerColor,
    this.headerWidget,
    this.maxMessageLines,
    this.headerFontWeight = FontWeight.normal,
    this.fontWeight,
    this.footerWidget,
    this.padding = const EdgeInsets.symmetric(vertical: 3),
    // For the reply section
    List<T> replies,
    this.replyBuilder,
  })  : assert(!(bodyWidget == null && message == null)),
        this.replies = replies ?? [];

  /// Circle avatar for profile image
  Widget _avatar(BuildContext context) {
    /// Create the image avatar widget
    Widget image = Container();

    /// Edge case of the avatar widget
    if (!this.showAvatar) return image;
    if (this.avatarPlaceholderPath == null)
      image = Image.network(this.avatarUrl,
          width: this.avatarSize, height: this.avatarSize, fit: BoxFit.cover);
    if (this.avatarUrl == null)
      image = Image.asset(this.avatarPlaceholderPath,
          width: this.avatarSize, height: this.avatarSize, fit: BoxFit.cover);
    if (this.avatarUrl != null && this.avatarPlaceholderPath != null)
      image = FadeInImage.assetNetwork(
          image: this.avatarUrl,
          placeholder: this.avatarPlaceholderPath,
          width: this.avatarSize,
          height: this.avatarSize,
          fit: BoxFit.cover);

    /// Create the avatar widget
    return Opacity(
        opacity: (this.showSpacingWithHiddenAvatar) ? 0 : 1,
        child: Container(
            padding: EdgeInsets.only(right: 10),
            child: ClipOval(child: image)));
  }

  /// A single box chat tile
  Widget _chatBox(BuildContext context) {
    return Container(
        padding: this.padding,
        child: Row(
            crossAxisAlignment: this.avatarAlignment,
            mainAxisAlignment: (isOnTheLeftSide == false)
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              /// Avatar
              this.avatarUrl == null ? Container() : _avatar(context),

              /// The message bubble
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _bubbleContent(context),
                    _replyBox(context),
                  ]),
            ]));
  }

  /// The reply box content
  Widget _replyBox(BuildContext context) {
    if (this.replies == null || this.replies.length == 0) return Container();

    /// Get the replies data
    List<Widget> list = [];
    int num = 0;
    for (var each in this.replies) {
      list.add(replyBuilder(each));
      num++;
      if (num >= 3) break;
    }

    /// Return the content
    return Container(
        padding: EdgeInsets.all(5),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: list));
  }

  /// The message in the bubble and padding
  LimitedBox _bubbleContent(BuildContext context) {
    List<Widget> innerText = [];

    /// The name on top
    if (this.headerText != null && this.displayNameInHeader)
      innerText.add(Container(
          padding: EdgeInsets.only(bottom: 5),
          child: _smallText(this.headerText),
          color: this.headerColor));

    /// Header widget
    if (this.headerWidget != null) innerText.add(this.headerWidget);

    /// The message
    innerText.add(this.bodyWidget ??
        RichText(
            overflow: this.maxMessageLines == null
                ? TextOverflow.visible
                : TextOverflow.ellipsis,
            textScaleFactor: this.messageTextScaleSize,
            maxLines: this.maxMessageLines,
            text: TextSpan(
                style: TextStyle(
                    fontWeight: this.headerFontWeight,
                    color: this.headerColor ?? this.textColor.withAlpha(200)),
                text: (this.headerText != null && !this.displayNameInHeader)
                    ? '$headerText: '
                    : '',
                children: [
                  TextSpan(
                      text: '$message',
                      style: TextStyle(
                          fontWeight: this.fontWeight, color: this.textColor)),
                ])));

    /// The footer of the bubble
    if (footerWidget != null) innerText.add(this.footerWidget);

    /// Create bubble
    return LimitedBox(
        maxWidth: bubbleMaxWidth ?? MediaQuery.of(context).size.width * 0.7,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            // Message bubble color
            decoration: BoxDecoration(
                color: this.backgroundColor,
                borderRadius: BorderRadius.circular(this.borderRadius),
                boxShadow: this.bubbleShadows),
            // Inner text, the message
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: innerText)));
  }

  /// The text in the bubble
  Widget _smallText(String text, {Color color}) {
    return Text(text,
        overflow: this.maxMessageLines == null
            ? TextOverflow.visible
            : TextOverflow.ellipsis,
        textScaleFactor: this.headerTextScaleSize,
        style: TextStyle(color: color ?? textColor.withAlpha(200)));
  }

  /// Build the widget
  @override
  Widget build(BuildContext context) {
    return _chatBox(context);
  }
}
