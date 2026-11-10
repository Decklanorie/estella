import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

loadingindicator() {
  return const Text('Refreshing..',
      style: TextStyle(
          color: Colors.grey, fontFamily: 'SourceSansPro-SemiBold'));
}

completeindicator() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: const <Widget>[
      Icon(
        Icons.done,
        color: Colors.grey,
      ),
      SizedBox(
        width: 10,
      ),
      Text('Refresh Completed',
          style: TextStyle(
              color: Colors.grey, fontFamily: 'SourceSansPro-SemiBold'))
    ],
  );
}

failedIndicator() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: const <Widget>[
      Icon(
        Icons.close,
        color: Colors.grey,
      ),
      SizedBox(
        width: 10,
      ),
      Text('Failed',
          style: TextStyle(
              color: Colors.grey, fontFamily: 'SourceSansPro-SemiBold'))
    ],
  );
}