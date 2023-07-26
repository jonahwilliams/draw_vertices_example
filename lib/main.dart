import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<ui.Image> loadImageFromAsset(String assetName) async {
  var buffer = await ImmutableBuffer.fromAsset(assetName);
  var codec = await ui.instantiateImageCodecFromBuffer(buffer);
  var frame = await codec.getNextFrame();
  return frame.image;
}

late ui.Image assetImage;

void main() async {
  assetImage = await loadImageFromAsset('assets/dash.jpg');
  runApp(MaterialApp(
    home: Scaffold(
      body: ListView(
        children: [
          for (var i = 0; i < 100; i++)
            CustomPaint(
              painter: FooPainter(),
              size: Size(400, 50),
            )
        ],
      )
    ),
  ));
}


class FooPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var vertices = ui.Vertices(
      VertexMode.triangles,
      [
        Offset.zero,
        Offset(0, 250),
        Offset(250, 0),
        Offset(0, 250),
        Offset(250, 0),
        Offset(250, 250)
      ],
      textureCoordinates: [
        Offset.zero,
        Offset(0, assetImage.height.toDouble()),
        Offset(assetImage.width.toDouble(), 0),
        Offset(0, assetImage.height.toDouble()),
        Offset(assetImage.width.toDouble(), 0),
        Offset(assetImage.width.toDouble(),  assetImage.height.toDouble())
      ],
      colors: [
        Colors.red,
        Colors.blue,
        Colors.green,
        Colors.red,
        Colors.blue,
        Colors.green,
      ].map((x) => x.withAlpha(100)).toList()
    );
    canvas.drawVertices(vertices, BlendMode.colorDodge, Paint()..shader = ImageShader(assetImage, TileMode.clamp, TileMode.clamp, Matrix4.identity().storage));
    canvas.translate(250, 0);
    canvas.drawVertices(vertices, BlendMode.colorDodge, Paint()..shader = ImageShader(assetImage, TileMode.clamp, TileMode.clamp, Matrix4.identity().storage));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
