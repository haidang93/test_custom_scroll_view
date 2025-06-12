part of 'project.library.dart';

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
    home: const MyHomePage(),
  ));
}

class Data {
  final int id;
  Data(this.id);
}

Future<List<Data>> simulateCallApi({
  int? page,
  int? limit,
}) async {
  await Future.delayed(Duration(milliseconds: 500));

  final maxCount = 684;
  page ??= 1;
  limit ??= 100;
  final totalPages = (maxCount / limit).ceil();

  if (page > totalPages) {
    return [];
  }

  final startIndex = (page - 1) * limit;
  final endIndex = (startIndex + limit).clamp(0, maxCount);

  return List.generate(endIndex - startIndex, (i) => Data(startIndex + i));
}
