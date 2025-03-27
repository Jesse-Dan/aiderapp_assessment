import "dart:io";

import "package:cached_network_image/cached_network_image.dart";
import "package:do_it_now/src/resources/extensions/context.dart";
import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:transparent_image/transparent_image.dart";

enum ImageResizeMode {
  cover,
  contain,
  stretch,
}

class AppImageViewer extends StatelessWidget {
  const AppImageViewer(this.imagePath,
      {super.key,
      this.width,
      this.height,
      this.color,
      this.fit = BoxFit.cover,
      this.resizeMode = ImageResizeMode.cover,
      this.borderRadius,
      this.colorFilter});

  final String imagePath;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit fit;
  final ImageResizeMode resizeMode;
  final BorderRadiusGeometry? borderRadius;
  final ColorFilter? colorFilter;

  AppImageViewer copyWith({
    String? imagePath,
    double? width,
    double? height,
    Color? color,
    BoxFit? fit,
    ImageResizeMode? resizeMode,
    BorderRadiusGeometry? borderRadius,
    ColorFilter? colorFilter,
  }) {
    return AppImageViewer(
      imagePath ?? this.imagePath,
      width: width ?? this.width,
      height: height ?? this.height,
      color: color ?? this.color,
      fit: fit ?? this.fit,
      resizeMode: resizeMode ?? this.resizeMode,
      borderRadius: borderRadius ?? this.borderRadius,
      colorFilter: colorFilter ?? this.colorFilter,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double? imageWidth;
        double? imageHeight;

        switch (resizeMode) {
          case ImageResizeMode.cover:
            if (width != null && height != null) {
              if (constraints.maxWidth / width! >
                  constraints.maxHeight / height!) {
                imageWidth = constraints.maxWidth;
                imageHeight = height! * imageWidth / width!;
              } else {
                imageHeight = constraints.maxHeight;
                imageWidth = width! * imageHeight / height!;
              }
            }
            break;
          case ImageResizeMode.contain:
            if (width != null && height != null) {
              if (constraints.maxWidth / width! <
                  constraints.maxHeight / height!) {
                imageWidth = constraints.maxWidth;
                imageHeight = height! * imageWidth / width!;
              } else {
                imageHeight = constraints.maxHeight;
                imageWidth = width! * imageHeight / height!;
              }
            }
            break;
          case ImageResizeMode.stretch:
            imageWidth = constraints.maxWidth;
            imageHeight = constraints.maxHeight;
            break;
        }

        Widget getImageWidget() {
          if (imagePath.endsWith(".svg")) {
            return SvgPicture.asset(
              imagePath,
              width: width,
              height: height,
              // ignore: deprecated_member_use
              color: color,
              fit: fit,
              colorFilter: colorFilter,
              placeholderBuilder: (context) => const Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            );
          } else if (imagePath.contains("http")) {
            return CachedNetworkImage(
              imageUrl: imagePath,
              fadeInDuration: Durations.long4,
              fadeInCurve: Curves.linear,
              width: width,
              height: height,
              fit: fit,
              placeholder: (context, url) => Center(
                child: ColoredBox(
                  color: Colors.grey,
                  child: SizedBox(
                    width: context.width,
                    height: height,
                  ),
                ),
              ),
              errorWidget: (context, url, error) {
                return SizedBox(
                  width: width,
                  height: height,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            );
          } else if (imagePath.contains("com.digitwhale")) {
            return FadeInImage(
              fit: fit,
              height: height,
              placeholder: MemoryImage(kTransparentImage),
              image: FileImage(File(imagePath)),
            );
          } else {
            return FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: AssetImage(imagePath),
              width: width,
              height: height,
              color: color,
              fit: fit,
              imageErrorBuilder: (context, error, stackTrace) {
                return SizedBox(
                  width: width,
                  height: height,
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            );
          }
        }

        return ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          child: SizedBox(
            width: width,
            height: height,
            child: getImageWidget(),
          ),
        );
      },
    );
  }
}
