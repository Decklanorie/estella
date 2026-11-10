// ignore_for_file: must_be_immutable

import 'dart:io';
import 'dart:typed_data';
import 'package:estella/core/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:estella/gen/assets.gen.dart';

class CustomImageView extends StatelessWidget {
  ///[imagePath] is required parameter for showing image
  String? imagePath;

  double? height;
  double? width;
  Color? color;
  BoxFit? fit;
  final String placeHolder;
  Alignment? alignment;
  VoidCallback? onTap;
  EdgeInsetsGeometry? margin;
  BorderRadius? radius;
  BoxBorder? border;
  Uint8List? uint8List;
  Color? backgroundColor;
  bool isUint8List;
  bool applyRadius;

  ///a [CustomImageView] it can be used for showing any type of images
  /// it will shows the placeholder image if image is not found on network image
  CustomImageView({
    this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder = 'assets/images/image_not_found.png',
    this.uint8List,
    this.isUint8List = false,
    this.applyRadius = true,
    this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
      alignment: alignment!,
      child: _buildWidget(),
    )
        : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: _buildCircleImage(),
      ),
    );
  }

  ///build the image with border radius
  _buildCircleImage() {
    // if (radius != null) {
    return ClipRRect(
      borderRadius: radius ?? BorderRadius.circular(applyRadius?10000:0),
      child: _buildImageWithBorder(),
    );
    // } else {
    //   return _buildImageWithBorder();
    // }
  }

  ///build the image with border and border radius style
  _buildImageWithBorder() {

    return Container(
      decoration: BoxDecoration(
          border: border,
          borderRadius: radius,
          color: backgroundColor
      ),
      child: _buildImageView(),
    );

  }

  Widget _buildImageView() {
    if(isUint8List && uint8List!=null && (uint8List?.length??0)>0){
      return Container(
          height: height,
          width: width,
          color: backgroundColor,
          child: Image.memory(
            uint8List!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
          ));
    }
    else if (imagePath != null && imagePath != '') {
      switch (imagePath!.imageType) {
        case ImageType.svg:
          return Container(
            height: height,
            width: width,
            color: backgroundColor,
            child: SvgPicture.asset(
              imagePath!,
              height: height,
              width: width,
              fit: fit ?? BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  color ?? Colors.transparent, BlendMode.srcIn),
            ),
          );
        case ImageType.file:
          return Container(
              height: height,
              width: width,
              color: backgroundColor,
              child: Image.file(
                File(imagePath!),
                height: height,
                width: width,
                fit: fit ?? BoxFit.cover,
                color: color,
              ));
        case ImageType.network:
          return Container(
              height: height,
              width: width,
              color: backgroundColor,
              child: CachedNetworkImage(
                height: height,
                width: width,
                fit: fit ?? BoxFit.cover,
                imageUrl: imagePath!,
                color: color,
                placeholder: (context, url) => Container(
                  height: 30,
                  width: 30,
                  child: LinearProgressIndicator(
                    color: Colors.grey.shade200,
                    backgroundColor: Colors.grey.shade100,
                  ),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  placeHolder,
                  height: height,
                  width: width,
                  fit: fit ?? BoxFit.cover,
                ),
              ));
        case ImageType.png:
        default:
          return Container(
              height: height,
              width: width,
              color: backgroundColor,
              child: Image.asset(
                imagePath!,
                height: height,
                width: width,
                fit: fit ?? BoxFit.cover,
                color: color,
              ));
      }
    }
    return Container(
        height: height,
        width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
          color: AppColors.accentColor
      ),
    );
  }
}

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (this.startsWith('http') || this.startsWith('https')) {
      return ImageType.network;
    } else if (this.endsWith('.svg')) {
      return ImageType.svg;
    } else if (this.startsWith('file://') || this.startsWith('/data/')) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}

enum ImageType { svg, png, network, file, unknown }
