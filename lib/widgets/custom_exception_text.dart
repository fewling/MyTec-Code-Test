import 'package:flutter/material.dart';

import '../utils/mixins/exceptions/custom_exception_handler.dart';

class CustomExceptionText extends StatelessWidget {
  const CustomExceptionText({super.key, required this.exception});

  final CustomException? exception;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.error,
      ),
      child: switch (exception) {
        null => const Text('Null exception caught'),
        AppException() => Text((exception! as AppException).code.label),
        TecException() => Text((exception! as TecException).code.label),
        UnknownException() => Text(
          (exception! as UnknownException).code.label +
              ((exception! as UnknownException).message ??
                  'No message provided'),
        ),
      },
    );
  }
}
