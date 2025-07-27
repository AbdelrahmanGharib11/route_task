import 'package:flutter/material.dart';
import 'package:selfdep/core/widgets/show_connectivity.dart';
import 'package:selfdep/core/widgets/toggleswitcher.dart';
import 'package:selfdep/features/home/presentation/screen/masonry_grid.dart';
import 'package:selfdep/features/home/presentation/screen/photos_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      right: false,
      left: false,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image.asset(
                      'assets/image/route.png',
                      height: 45,
                      width: 135,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        ToggleSwitcher(),
                        SizedBox(height: 8),
                        ShowConnectivity(),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: PhotoGridScreen(),
                //PhotosLayout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
