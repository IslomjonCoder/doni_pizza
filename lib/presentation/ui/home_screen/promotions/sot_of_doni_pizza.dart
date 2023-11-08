import 'package:flutter/material.dart';

class SetOfDoniPizza extends StatelessWidget {
  final String image;

  const SetOfDoniPizza({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black),
        image: DecorationImage(
          fit: BoxFit.fill,
          alignment: Alignment.centerRight,
          image: AssetImage(image),
        ),
      ),
    );
  }
}
