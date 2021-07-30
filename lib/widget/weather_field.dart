import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spritewidget/spritewidget.dart';

ImageMap _images;

class WeatherField extends StatefulWidget {
  WeatherField({Key key}) : super(key: key);

  @override
  _WeatherFieldState createState() => new _WeatherFieldState();
}

class _WeatherFieldState extends State<WeatherField> {
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
}

class WeatherWorld extends NodeWithSize {
  WeatherWorld() : super(const Size(2048, 2048)) {
    Snow _snow = new Snow();
    _snow.active = true;
    addChild(_snow);
  }
}

class Snow extends Node {
  Snow() {
    Sprite snow0 = Sprite.fromImage(_images["assets/dollar-0.png"]);
    Sprite snow1 = Sprite.fromImage(_images["assets/dollar-1.png"]);
    Sprite snow2 = Sprite.fromImage(_images["assets/dollar-2.png"]);
    _addParticles(snow0.texture, 1.0);
    _addParticles(snow1.texture, 1.0);
    _addParticles(snow2.texture, 1.0);

    _addParticles(snow0.texture, 1.5);
    _addParticles(snow1.texture, 1.5);
    _addParticles(snow2.texture, 1.5);

    _addParticles(snow0.texture, 2.0);
    _addParticles(snow1.texture, 2.0);
    _addParticles(snow2.texture, 2.0);
  }

  List<ParticleSystem> _particles = <ParticleSystem>[];

  void _addParticles(SpriteTexture texture, double distance) {
    ParticleSystem particles = new ParticleSystem(texture,
        transferMode: BlendMode.srcATop,
        posVar: const Offset(1300.0, 0.0),
        direction: 90.0,
        directionVar: 0.0,
        speed: 150.0 / distance,
        speedVar: 50.0 / distance,
        startSize: 1.0 / distance,
        startSizeVar: 0.3 / distance,
        endSize: 1.2 / distance,
        endSizeVar: 0.2 / distance,
        life: 20.0 * distance,
        lifeVar: 10.0 * distance,
        emissionRate: 2.0,
        startRotationVar: 360.0,
        endRotationVar: 360.0,
        radialAccelerationVar: 10.0 / distance,
        tangentialAccelerationVar: 10.0 / distance);
    particles.position = const Offset(1024.0, -50.0);
    particles.opacity = 0.0;

    _particles.add(particles);
    addChild(particles);
  }

  set active(bool active) {
    motions.stopAll();
    for (ParticleSystem system in _particles) {
      if (active) {
        motions.run(new MotionTween<double>(
            (a) => system.opacity = a, system.opacity, 1.0, 2.0));
      } else {
        motions.run(new MotionTween<double>(
            (a) => system.opacity = a, system.opacity, 0.0, 0.5));
      }
    }
  }
}
