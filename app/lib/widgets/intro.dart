

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';


class PreIntro extends StatelessWidget {
  const PreIntro({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(9.seconds).then((v){
      context.go('/');
    });
    return Scaffold(
      body: 
      // use animated flutter to create fade animation with delay
      Stack(
        children: [
          Center(
            child: Container(
              // maxWith 200 
              constraints: const BoxConstraints(maxWidth: 200),
              child: Image.asset('assets/logo/full.png').animate()
              .fade(duration: 1000.ms, curve: Curves.easeInExpo)
              .scale(delay: 500.ms ,begin: Offset(0.7, 0.7), curve: Curves.easeInOut)
              .then(delay: 2.seconds)
              .fade(duration: 1000.ms,begin: 1,end: 0, curve: Curves.easeInExpo)
              .scale(delay: 500.ms ,begin: Offset(1, 1),end: Offset(0.8, 0.8), curve: Curves.easeInOut),

            ),
          ),
          Center(
            child: Container(
              // maxWith 200
              constraints: const BoxConstraints(maxWidth: 600),
              child: Text('BSC 2025', style: Theme.of(context).textTheme.titleLarge).animate()
              .then(delay: 4.seconds)
              .fade(duration: 1000.ms, curve: Curves.easeInExpo)
              .scale(delay: 500.ms ,begin: Offset(0.7, 0.7), curve: Curves.easeInOut)
              .then(delay: 2.seconds)
              .fade(duration: 1000.ms,begin: 1,end: 0, curve: Curves.easeInExpo)
              .scale(delay: 500.ms ,begin: Offset(1, 1),end: Offset(0.8, 0.8), curve: Curves.easeInOut),

            ),
          ),
        ],
      )
      ,
    );
  }
}