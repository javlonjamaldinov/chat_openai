import 'package:flutter/material.dart';

class LoadingPageOverlay extends StatelessWidget {
  const LoadingPageOverlay({
    Key? key,
    required this.child,
    this.loading = false,
  }) : super(key: key);

  final Widget child;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Stack(
      children: [
        child,
        if (loading)
          Material(
            color: scheme.surfaceVariant.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
