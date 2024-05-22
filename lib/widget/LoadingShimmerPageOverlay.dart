import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmerPageOverlay extends StatelessWidget {
  const LoadingShimmerPageOverlay({
    Key? key,
    required this.child,
    this.loading = false,
  }) : super(key: key);

  final Widget child;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        loading?
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            enabled: true,
            child: child,
          ):child
      ],
    );
  }
}
