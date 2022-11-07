import 'package:flutter/material.dart';

class FullScreenImageView extends StatelessWidget {
  final String imgPath;
  final LinearGradient _gradient = LinearGradient(
      colors: [Colors.white, Colors.black],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);

  FullScreenImageView(this.imgPath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(gradient: _gradient),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Hero(
                  tag: imgPath,
                  child: Image.network(imgPath),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    AppBar(
                      elevation: 0.0,
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                        color: Colors.black,
                        onPressed: Navigator.of(context).pop,
                        icon: Icon(Icons.cancel),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
