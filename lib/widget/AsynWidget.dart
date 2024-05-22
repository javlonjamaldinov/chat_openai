

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

class AsyncWidget<T> extends StatelessWidget{

  final AsyncValue<T> value;
  final Widget Function(T data)  data;
  final VoidCallback? retryAgain;

  const AsyncWidget({super.key, required this.value, required this.data, this.retryAgain});

  @override
  Widget build(BuildContext context) {


    return value.when(data: data, error: (error, stackTrace) {


      return Padding(padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$error'),
            if (retryAgain != null) ...[
              const SizedBox(
                height: 14,

              ),
              TextButton(onPressed: retryAgain, child: const Text('Retry'))
            ]
          ],
        ),
      ),);
    }, loading:() =>  const Center(
      child: Padding(padding: const EdgeInsets.all(10),
      child: CircularProgressIndicator(),)
    ),);
  }
}
