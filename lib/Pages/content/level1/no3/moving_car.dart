// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:kido/Widgets/responsive_provider.dart';
import 'package:lottie/lottie.dart';
import '../../../../Widgets/content/level1/no3/moving_car.dart';
import '../../../../Widgets/content/level1/road_widget.dart';
import '../../../../constants.dart';
import '../../../../services/audio_service.dart';
import '../level1_home.dart';

class MovingCarPage extends StatefulWidget {
  const MovingCarPage({super.key});

  @override
  State<MovingCarPage> createState() => _MovingCarPageState();
}

class _MovingCarPageState extends State<MovingCarPage>
    with TickerProviderStateMixin {
  late AnimationController _carController;
  late Animation<double> _carMovement;
  late AnimationController _cloudController;
  final List<int> _placedCubes = [];
  bool _isReadyToDrive = false;
  final List<Color> _lightColors = [
    AppColors.kidoRed,
    AppColors.kidoOrange,
    AppColors.kidoGreen
  ];

  @override
  void initState() {
    super.initState();
    _carController = AnimationController(
        duration: const Duration(seconds: 4), vsync: this);

    _carMovement = Tween<double>(begin: 1000, end: 400).animate(
      CurvedAnimation(parent: _carController, curve: Curves.easeOutQuart),
    );
    _carController.forward();
    _cloudController = AnimationController(
        duration: const Duration(seconds: 25), vsync: this)
      ..repeat();
  }

  void _onCubePlaced(int index) async {
    if (_placedCubes.contains(index)) return;

    setState(() => _placedCubes.add(index));
    await AudioService.play(fileName: 'win.wav');

    if (_placedCubes.length == 3) {
      _startDrivingSequence();
    }
  }

  void _startDrivingSequence() async {
    setState(() => _isReadyToDrive = true);
    await AudioService.play(fileName: 'car.mp3');
    await Future.delayed(const Duration(milliseconds: 800));
    await AudioService.play(fileName: 'yaay.mp3');
    _carMovement = Tween<double>(begin: 400, end: -500).animate(
      CurvedAnimation(parent: _carController, curve: Curves.linear),
    );
    _carController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Level1Home(childName: 'habiba',)
                )
            );
            }
        });
      }
    });

    _carController.duration = const Duration(seconds: 3);
    _carController.forward(from: 0);
  }

  @override
  void dispose() {
    _carController.dispose();
    _cloudController.dispose();
    AudioService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = ResponsiveProvider.of(context);
    final sw = r.localWidth;
    final sh = r.localHeight;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.kidoBlue, AppColors.kidoColors[0]],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
                top: sh * 0.05,
                left: sw * 0.05,
                child: Container(
                  padding: EdgeInsets.all(sw * 0.03),
                  decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.kidoYellow,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.yellowAccent.withOpacity(0.5),
                        blurRadius: sw * 0.04,
                        spreadRadius: sw * 0.01
                    )
                  ],
                  ),
                  child: Icon(
                      Icons.wb_sunny_rounded,
                      color: AppColors.kidoOrange,
                      size: r.buttonHeight
                  ),
                )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(height: sh * 0.05, color: AppColors.kidoGreen),
                  Container(
                    height: sh * 0.15,
                    color: AppColors.textDark,
                    child: CustomPaint(
                      painter: RoadLinesPainter(),
                      size: Size.infinite,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: sw * 0.12,
              bottom: sh * 0.2,
              child: MovingCarWidget(
                placedCubes: _placedCubes,
                lightColors: _lightColors,
                onAccept: _onCubePlaced,
              ),
            ),
            AnimatedBuilder(
              animation: _carMovement,
              builder: (context, child) {
                return Positioned(
                  bottom: sh * 0.03,
                  left: _carMovement.value,
                  child: Transform.scale(
                    scale: 1.2,
                    child: Image.asset(
                        "assets/images/kido-car.png",
                        height: r.imageHeight(0.15),
                        width: r.imageWidth(0.6)
                    ),
                  ),
                );
              },
            ),

            if (!_isReadyToDrive)
              Align(
                alignment: Alignment.centerRight,
                child: _buildCubeDock(r),
              ),

            if (_isReadyToDrive)
              Positioned.fill(
                child: Lottie.asset(
                  'assets/lottie/confetti.json',
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCubeDock(var responsive) {
    return Container(
      margin: EdgeInsets.only(right: responsive.localWidth * 0.04),
      padding: EdgeInsets.symmetric(
          vertical: responsive.localHeight * 0.02,
          horizontal: responsive.localWidth * 0.02
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(responsive.localWidth * 0.05),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          if (_placedCubes.contains(index)) {
            return SizedBox(height: responsive.localHeight * 0.1);
          }
          return Draggable<int>(
            data: index,
            feedback: _buildCube(index, true, responsive),
            childWhenDragging: Opacity(
                opacity: 0.2,
                child: _buildCube(index, false, responsive)
            ),
            child: _buildCube(index, false, responsive),
          );
        }),
      ),
    );
  }

  Widget _buildCube(int index, bool isDragging, var responsive) {
    final double size = responsive.imageWidth(0.12);
    return Container(
      width: size,
      height: size,
      margin: EdgeInsets.symmetric(vertical: responsive.localHeight * 0.01),
      decoration: BoxDecoration(
        color: _lightColors[index],
        borderRadius: BorderRadius.circular(size * 0.2),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(size * 0.05, size * 0.08),
              blurRadius: size * 0.1
          ),
        ],
      ),
    );
  }
}