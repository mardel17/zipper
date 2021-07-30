import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spritewidget/spritewidget.dart';

ImageMap _images;

class FireworkField extends StatefulWidget {
  FireworkField({Key key}) : super(key: key);

  @override
  FireworkFieldState createState() => new FireworkFieldState();
}

class FireworkFieldState extends State<FireworkField> {
  bool assetsLoaded = false;
  WeatherWorld weatherWorld;

  Future<Null> _loadAssets(AssetBundle bundle) async {
    // Load images using an ImageMap
    _images = new ImageMap(bundle);
    await _images.load(<String>[
      'assets/dollar-0.png',
      'assets/dollar-1.png',
      'assets/dollar-2.png'
    ]);
  }

  @override
  void initState() {
    super.initState();
    // Get our root asset bundle
    AssetBundle bundle = rootBundle;

    _loadAssets(bundle).then((_) {
      setState(() {
        assetsLoaded = true;
        weatherWorld = new WeatherWorld();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (assetsLoaded) ? SpriteWidget(weatherWorld) : Container();
  }

  refreshAnimation() {
    weatherWorld._snow.removeAllChildren();
    weatherWorld._snow.addAnimation();
  }
}

class WeatherWorld extends NodeWithSize {
  Snow _snow;
  WeatherWorld() : super(const Size(512, 512)) {
    _snow = new Snow();
    addChild(_snow);
  }
}

class Snow extends Node {
  Sprite snow0, snow1, snow2;
  Snow() {
    snow0 = Sprite.fromImage(_images["assets/dollar-0.png"]);
    snow1 = Sprite.fromImage(_images["assets/dollar-1.png"]);
    snow2 = Sprite.fromImage(_images["assets/dollar-2.png"]);
  }

  void _addParticles(SpriteTexture texture) {
    ParticleSystem particles = new ParticleSystem(texture,
        numParticlesToEmit: 100,
        emissionRate: 1000,
        rotateToMovement: true,
        startRotation: 90,
        speed: 100,
        speedVar: 50,
        startSize: 0.5,
        startSizeVar: 0.15,
        gravity: Offset(0, 30));

    particles.position = const Offset(256.0, 100.0);
    addChild(particles);
  }

  void addAnimation() {
    _addParticles(snow0.texture);
    _addParticles(snow1.texture);
    _addParticles(snow2.texture);
  }
}
