// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DataContainer extends StatelessWidget {
  // const DataContainer({
  //   Key? key,
  // }) : super(key: key);

  static const textStyle1 = TextStyle(
    color: Color(0xFFffffff),
    fontSize: 18.0,
  );

  static const textStyle2 = TextStyle(
    color: Color(0xFFffffff),
    fontSize: 40.0,
    fontWeight: FontWeight.w900,
  );

  static const textStyle3 = TextStyle(
    color: Color(0xFFffffff),
    fontSize: 25.0,
  );

  const DataContainer({Key? key, required this.icon, required this.title}) : super(key: key);

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          icon,
          size: 80.0,
          color: Colors.white,
        ),
        const SizedBox(height: 15.0),
        Text(
          title,
          style: textStyle1,
        )
      ],
    );
  }
}