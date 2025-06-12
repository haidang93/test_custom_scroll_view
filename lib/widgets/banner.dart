part of '../project.library.dart';

class Banner extends StatelessWidget {
  const Banner({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: BANNER_ASPECTRATIO,
      child: Image.asset(
        BANNER_ASSET,
        fit: BoxFit.cover,
      ),
    );
  }
}
