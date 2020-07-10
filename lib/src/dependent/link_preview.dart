import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Link preview to the preview of the URL.
class LinkPreview extends StatelessWidget {
  /// Link preview to the preview of the URL.
  LinkPreview({
    Key key,
    @required this.url,
    @required this.onTap,
    this.title,
    this.description,
    BorderRadius borderRadius,
    BorderRadius imageBorderRadius,
    this.padding = const EdgeInsets.all(0),
    this.backgroundColor = Colors.transparent,
    this.elevation = 0,
    this.linkStyle,
    this.titleStyle,
    this.descriptionStyle,
    this.isLinkAtBottom = false,
    this.imagePadding = const EdgeInsets.only(bottom: 10),
    this.titlePadding = const EdgeInsets.only(bottom: 10),
    this.descriptionPadding = const EdgeInsets.only(bottom: 10),
    this.linkPadding = const EdgeInsets.only(bottom: 10),
  })  : this.borderRadius = borderRadius ?? BorderRadius.circular(0),
        this.imageBorderRadius = imageBorderRadius ?? BorderRadius.circular(0),
        assert(url != null),
        assert(onTap != null),
        super(key: key);

  LinkPreview.bubble({
    Key key,
    @required this.url,
    @required this.onTap,
    this.title,
    this.description,
    this.backgroundColor = Colors.transparent,
    this.padding = const EdgeInsets.all(0),
    this.elevation = 0,
    double radius = 20,
    this.linkStyle,
    this.titleStyle,
    this.descriptionStyle,
    this.isLinkAtBottom = false,
    this.imagePadding = const EdgeInsets.only(bottom: 10),
    this.titlePadding = const EdgeInsets.only(bottom: 10),
    this.descriptionPadding = const EdgeInsets.only(bottom: 10),
    this.linkPadding = const EdgeInsets.only(bottom: 10),
  })  : this.borderRadius = BorderRadius.circular(radius),
        this.imageBorderRadius = BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius)),
        assert(url != null),
        assert(onTap != null),
        super(key: key);

  @override
  Widget build(BuildContext context) => _linkPreview();

  final String url;
  final String title;
  final String description;
  final BorderRadius borderRadius;
  final BorderRadius imageBorderRadius;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  final Function() onTap;
  final double elevation;
  final TextStyle linkStyle;
  final TextStyle titleStyle;
  final TextStyle descriptionStyle;
  final bool isLinkAtBottom;
  final EdgeInsets imagePadding;
  final EdgeInsets titlePadding;
  final EdgeInsets descriptionPadding;
  final EdgeInsets linkPadding;

  _stripUrl(String url) {
    url = url.replaceAll(RegExp(r'http[s ]://'), '');
    print('first: $url');
    url = url.replaceAll(RegExp(r'/[^]*'), '');
    print('second: $url');
    return url;
  }

  _horPad(Widget child) => Padding(
      child: child, padding: const EdgeInsets.symmetric(horizontal: 10));

  _linkPreview() => Material(
      borderRadius: borderRadius,
      elevation: elevation,
      color: this.backgroundColor,
      child: InkWell(
          onTap: () => this.onTap,
          child: Padding(
              padding: this.padding,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Image
                    Padding(
                        padding: imagePadding,
                        child: ClipRRect(
                            borderRadius: this.imageBorderRadius,
                            child: CachedNetworkImage(
                                imageUrl: url,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error, color: Colors.red)))),

                    /// Footer
                    isLinkAtBottom ? Container() : _linkText(),

                    /// Title
                    _title(),

                    /// Description
                    _desc(),

                    /// Link text
                    this.isLinkAtBottom ? _linkText() : Container(),
                  ]))));

  _title() => this.title == null
      ? Container()
      : _horPad(Padding(
          padding: titlePadding,
          child: Text(title,
              textScaleFactor: 1,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: this.titleStyle ??
                  TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black))));

  _desc() => this.description == null
      ? Container()
      : _horPad(Padding(
          padding: descriptionPadding,
          child: Text(description,
              textScaleFactor: 1,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: this.descriptionStyle ??
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.grey))));

  _linkText() => this.url == null || this.url == ''
      ? Container()
      : _horPad(Padding(
          padding: linkPadding,
          child: Text(_stripUrl(url),
              textScaleFactor: 1,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: this.linkStyle ??
                  TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey))));
}