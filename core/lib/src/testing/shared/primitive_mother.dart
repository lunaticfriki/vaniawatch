import 'dart:math';

abstract final class PrimitiveMother {
  static final Random _random = Random();
  static const String _letters = 'abcdefghijklmnopqrstuvwxyz';
  static const String _hex = '0123456789abcdef';

  static int integer({int min = 0, int max = 1000}) =>
      min + _random.nextInt(max - min + 1);

  static T pick<T>(List<T> values) => values[_random.nextInt(values.length)];

  static String stringOfLength(int length) => List.generate(
    length,
    (_) => _letters[_random.nextInt(_letters.length)],
  ).join();

  static String word({int minLength = 3, int maxLength = 10}) =>
      stringOfLength(integer(min: minLength, max: maxLength));

  static List<String> uniqueWords(int count) {
    final words = <String>{};
    while (words.length < count) {
      words.add(word());
    }
    return words.toList();
  }

  static String words({int count = 3}) => uniqueWords(count).join(' ');

  static String sentence({int minWords = 4, int maxWords = 12}) => words(
    count: integer(min: minWords, max: maxWords),
  );

  static String uuid() {
    String hex(int length) =>
        List.generate(length, (_) => _hex[_random.nextInt(_hex.length)]).join();
    final variant = pick(['8', '9', 'a', 'b']);
    return '${hex(8)}-${hex(4)}-4${hex(3)}-$variant${hex(3)}-${hex(12)}';
  }

  static String email() => '${word()}.${word()}@${word()}.com';

  static String url() => 'https://${word()}.com/${word()}/${word()}.jpg';

  static DateTime dateTime({DateTime? from, DateTime? to}) {
    final start = from ?? DateTime.utc(2020);
    final end = to ?? DateTime.utc(2030);
    final seconds = min(end.difference(start).inSeconds, 0xFFFFFFFF);
    return start.toUtc().add(Duration(seconds: _random.nextInt(seconds + 1)));
  }
}
