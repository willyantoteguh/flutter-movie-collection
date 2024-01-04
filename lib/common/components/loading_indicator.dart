import 'package:flutter/material.dart';

Center buildLoadingIndicator() {
  return const Center(
    child: CircularProgressIndicator.adaptive(backgroundColor: Colors.black),
  );
}
