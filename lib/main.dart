import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:lottie_flutter/lottie_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Lottie Animation',
      theme:  ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LottieDemo(),
    );
  }
}

class LottieDemo extends StatefulWidget {
  const LottieDemo({Key key}) : super(key: key);

  @override
  _LottieDemoState createState() =>  _LottieDemoState();
}

class _LottieDemoState extends State<LottieDemo>
    with SingleTickerProviderStateMixin {

  LottieComposition _composition;
  AnimationController _controller;
  bool _repeat;

  @override
  void initState() {
    super.initState();

    _repeat = true;
    _controller =  AnimationController(
      duration: const Duration(milliseconds: 1),
      vsync: this,
    );
    loadAsset("assets/16846-walking-burger.json").then((LottieComposition composition) {
      setState(() {
          _composition = composition;
        _controller.reset();
      });
    });
    _controller.addListener(() => setState(() {}));
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
        title: const Text('Flutter Lottie Animation'),
      ),
      body:  Center(
        child:  Column(
        mainAxisAlignment:  MainAxisAlignment.center,
          children: <Widget>[
             Lottie(
              composition: _composition,
              size: const Size(300.0, 300.0),
              controller: _controller,
               coerceDuration: true,

            ),
             Slider(
              value: _controller.value,
              onChanged: _composition != null
                  ? (double val) => setState(() => _controller.value = val)
                  : null,
            ),
             Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                   IconButton(
                    icon: const Icon(Icons.repeat),
                    color: _repeat ? Colors.black : Colors.black45,
                    onPressed: () => setState(() {
                      _repeat = !_repeat;
                      if (_controller.isAnimating) {
                        if (_repeat) {
                          _controller.forward().then<Null>(
                                  (nul) => _controller.repeat());
                        } else {
                          _controller.forward();
                        }
                      }
                    }),
                  ),
                   IconButton(
                    icon: const Icon(Icons.fast_rewind),
                    onPressed: _controller.value > 0 && _composition != null
                        ? () => setState(() => _controller.reset())
                        : null,
                  ),
                   IconButton(
                    icon: _controller.isAnimating
                        ? const Icon(Icons.pause)
                        : const Icon(Icons.play_arrow),
                    onPressed: _controller.isCompleted || _composition == null
                        ? null
                        : () {
                      setState(() {
                        if (_controller.isAnimating) {
                          _controller.stop();
                        } else {
                          if (_repeat) {
                            _controller.repeat();
                          } else {
                            _controller.forward();
                          }
                        }
                      });
                    },
                  ),
                   IconButton(
                    icon: const Icon(Icons.stop),
                    onPressed: _controller.isAnimating && _composition != null
                        ? () {
                      _controller.reset();
                    }
                        : null,
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}

Future<LottieComposition> loadAsset(String assetName) async {
  return await rootBundle
      .loadString(assetName)
      .then<Map<String, dynamic>>((String data) => json.decode(data))
      .then((Map<String, dynamic> map) =>  LottieComposition.fromMap(map));
}