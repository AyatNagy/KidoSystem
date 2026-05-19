import 'package:flutter/material.dart';
import 'kido_strings.dart';

extension BuildContextL10n on BuildContext {
  KidoStrings get l10n => KidoStrings.of(this);
}
