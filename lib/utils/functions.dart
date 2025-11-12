import 'dart:math';

String getRandomId() {
    final Random random = Random();
    return "pswrd${random.nextInt(10000000)}";
  }