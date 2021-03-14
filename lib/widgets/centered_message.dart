import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CenteredMessage extends StatelessWidget {
  final String message;
  final double iconSize;
  final IconData icon;
  final double space;

  const CenteredMessage({
    Key key,
    @required this.message,
    this.iconSize = 64.0,
    this.icon = Icons.warning,
    this.space = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildIcon(),
          SizedBox(height: space),
          _buildText(),
        ],
      ),
    );
  }

  _buildIcon() {
    return Icon(
      icon,
      color: Color(0xffFFCE68),
      size: iconSize,
    );
  }

  _buildText() {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(color: Color(0xffFFCE68)),
    );
  }
}
