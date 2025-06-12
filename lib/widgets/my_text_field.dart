part of '../project.library.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: TEXTFIELD_HEIGHT,
      margin: const EdgeInsets.symmetric(
          horizontal: 10, vertical: TEXTFIELD_VERTICLE_MARGIN),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Search...",
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black26),
            borderRadius: BorderRadius.circular(8),
          ),
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
