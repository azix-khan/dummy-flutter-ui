import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class LiquidGlassHome extends StatefulWidget {
  const LiquidGlassHome({super.key});

  @override
  State<LiquidGlassHome> createState() => _LiquidGlassHomeState();
}

class _LiquidGlassHomeState extends State<LiquidGlassHome> {
  Offset _glassPosition = const Offset(100, 200);
  bool _showControls = false;

  // Glass properties that can be controlled
  double _cornerRadius = 70.0;
  double _blurRadius = 25.0;
  double _opacity = 0.1;
  double _borderOpacity = 0.3;
  Color _glassColor = Colors.white;
  Color _borderColor = Colors.white;

  // Background gradient colors
  Color _gradientColor1 = const Color(0xFF6366F1);
  Color _gradientColor2 = const Color(0xFF8B5CF6);
  Color _gradientColor3 = const Color(0xFF06B6D4);
  Color _gradientColor4 = const Color(0xFFEC4899);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Static Mesh Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _gradientColor1,
                  _gradientColor2,
                  _gradientColor3,
                  _gradientColor4,
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
            child: CustomPaint(
              painter: MeshGradientPainter(
                color1: _gradientColor1,
                color2: _gradientColor2,
                color3: _gradientColor3,
                color4: _gradientColor4,
              ),
              size: Size.infinite,
            ),
          ),

          // Large Center Text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'LIQUID',
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 8,
                    height: 0.9,
                  ),
                ),
                Text(
                  'GLASS',
                  style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w900,
                    color: Colors.white.withValues(alpha: 0.1),
                    letterSpacing: 8,
                    height: 0.9,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Apple Style Glassmorphism',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.3),
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),

          // Draggable Liquid Glass Widget
          Positioned(
            left: _glassPosition.dx,
            top: _glassPosition.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _glassPosition = Offset(
                    (_glassPosition.dx + details.delta.dx).clamp(
                      0,
                      MediaQuery.of(context).size.width - 300,
                    ),
                    (_glassPosition.dy + details.delta.dy).clamp(
                      0,
                      MediaQuery.of(context).size.height - 300,
                    ),
                  );
                });
              },
              child: LiquidGlassWidget(
                cornerRadius: _cornerRadius,
                blurRadius: _blurRadius,
                opacity: _opacity,
                borderOpacity: _borderOpacity,
                glassColor: _glassColor,
                borderColor: _borderColor,
              ),
            ),
          ),

          // Controls Panel
          if (_showControls)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.9),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Handle
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 50,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Title
                    Text(
                      'Glass Controls',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Controls
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            _buildSliderControl(
                              'Corner Radius',
                              _cornerRadius,
                              0.0,
                              150.0,
                              (value) => setState(() => _cornerRadius = value),
                            ),
                            _buildSliderControl(
                              'Blur Radius',
                              _blurRadius,
                              0.0,
                              50.0,
                              (value) => setState(() => _blurRadius = value),
                            ),
                            _buildSliderControl(
                              'Glass Opacity',
                              _opacity,
                              0.0,
                              1.0,
                              (value) => setState(() => _opacity = value),
                            ),
                            _buildSliderControl(
                              'Border Opacity',
                              _borderOpacity,
                              0.0,
                              1.0,
                              (value) => setState(() => _borderOpacity = value),
                            ),
                            const SizedBox(height: 20),

                            // Color Controls
                            _buildColorSection(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Controls Toggle Button
          Positioned(
            bottom: 50,
            right: 30,
            child: FloatingActionButton(
              onPressed: () {
                setState(() {
                  _showControls = !_showControls;
                });
              },
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              child: Icon(
                _showControls ? Icons.close : Icons.tune,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliderControl(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value.toStringAsFixed(1),
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white.withValues(alpha: 0.8),
              inactiveTrackColor: Colors.white.withValues(alpha: 0.2),
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Colors',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 15),

        // Glass Colors
        Text(
          'Glass Colors',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildColorPicker('Glass', _glassColor, (color) {
              setState(() => _glassColor = color);
            }),
            const SizedBox(width: 15),
            _buildColorPicker('Border', _borderColor, (color) {
              setState(() => _borderColor = color);
            }),
          ],
        ),
        const SizedBox(height: 20),

        // Background Colors
        Text(
          'Background Gradient',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15,
          runSpacing: 15,
          children: [
            _buildColorPicker('Color 1', _gradientColor1, (color) {
              setState(() => _gradientColor1 = color);
            }),
            _buildColorPicker('Color 2', _gradientColor2, (color) {
              setState(() => _gradientColor2 = color);
            }),
            _buildColorPicker('Color 3', _gradientColor3, (color) {
              setState(() => _gradientColor3 = color);
            }),
            _buildColorPicker('Color 4', _gradientColor4, (color) {
              setState(() => _gradientColor4 = color);
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildColorPicker(
    String label,
    Color color,
    ValueChanged<Color> onChanged,
  ) {
    final colors = [
      Colors.white,
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ];

    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    backgroundColor: Colors.black.withValues(alpha: 0.9),
                    title: Text(
                      'Choose $label Color',
                      style: const TextStyle(color: Colors.white),
                    ),
                    content: SizedBox(
                      width: 300,
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                        itemCount: colors.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              onChanged(colors[index]);
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: colors[index],
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
            );
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LiquidGlassWidget extends StatelessWidget {
  final double cornerRadius;
  final double blurRadius;
  final double opacity;
  final double borderOpacity;
  final Color glassColor;
  final Color borderColor;

  const LiquidGlassWidget({
    super.key,
    required this.cornerRadius,
    required this.blurRadius,
    required this.opacity,
    required this.borderOpacity,
    required this.glassColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    const double width = 250;
    const double height = 250;

    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cornerRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: glassColor.withValues(alpha: opacity),
              borderRadius: BorderRadius.circular(cornerRadius),
              border: Border.all(
                color: borderColor.withValues(alpha: borderOpacity),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.apple_rounded,
                    size: 120,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MeshGradientPainter extends CustomPainter {
  final Color color1;
  final Color color2;
  final Color color3;
  final Color color4;

  MeshGradientPainter({
    required this.color1,
    required this.color2,
    required this.color3,
    required this.color4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Create mesh-like gradient effect
    final random = Random(42);

    for (int i = 0; i < 50; i++) {
      final center = Offset(
        random.nextDouble() * size.width,
        random.nextDouble() * size.height,
      );

      final colors = [color1, color2, color3, color4];
      final selectedColor = colors[random.nextInt(colors.length)];

      paint.shader = RadialGradient(
        colors: [
          selectedColor.withValues(alpha: 0.3),
          selectedColor.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 1.0],
      ).createShader(
        Rect.fromCircle(
          center: center,
          radius: 100 + random.nextDouble() * 200,
        ),
      );

      canvas.drawCircle(center, 100 + random.nextDouble() * 200, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
