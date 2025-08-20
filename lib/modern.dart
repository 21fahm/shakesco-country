import 'package:flutter/material.dart';
import 'dart:ui';

class FuturisticCountrySelect extends StatefulWidget {
  final String selectedFlag;
  final String selectedCountry;
  final VoidCallback onTap;

  const FuturisticCountrySelect({
    Key? key,
    required this.selectedFlag,
    required this.selectedCountry,
    required this.onTap,
  }) : super(key: key);

  @override
  State<FuturisticCountrySelect> createState() =>
      _FuturisticCountrySelectState();
}

class _FuturisticCountrySelectState extends State<FuturisticCountrySelect>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _shimmerController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _shimmerAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_controller, _shimmerController]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                height: 64,
                width: MediaQuery.of(context).size.width * 0.95,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Stack(
                  children: [
                    // Main container with enhanced gradient
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF4F46E5)
                                .withValues(alpha: _isHovered ? 0.25 : 0.18),
                            const Color(0xFF7C3AED)
                                .withValues(alpha: _isHovered ? 0.25 : 0.18),
                            const Color(0xFFEC4899)
                                .withValues(alpha: _isHovered ? 0.25 : 0.18),
                            const Color(0xFFF59E0B)
                                .withValues(alpha: _isHovered ? 0.2 : 0.15),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _isHovered
                              ? Colors.white.withValues(alpha: 0.3)
                              : Colors.white.withValues(alpha: 0.15),
                          width: _isHovered ? 1.5 : 1,
                        ),
                      ),
                    ),

                    // Shimmer overlay effect
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: _isHovered ? 0.4 : 0.2,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(
                                  -1.0 + _shimmerAnimation.value, -1.0),
                              end:
                                  Alignment(1.0 + _shimmerAnimation.value, 1.0),
                              colors: [
                                Colors.transparent,
                                Colors.white.withValues(alpha: 0.1),
                                Colors.white.withValues(alpha: 0.2),
                                Colors.white.withValues(alpha: 0.1),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.4, 0.5, 0.6, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Glassmorphism effect
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withValues(
                                    alpha: _isHovered ? 0.15 : 0.08),
                                Colors.white
                                    .withValues(alpha: _isHovered ? 0.1 : 0.04),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Enhanced glow effect
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4F46E5)
                                .withValues(alpha: _glowAnimation.value * 0.4),
                            blurRadius: 20,
                            spreadRadius: -3,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: const Color(0xFFEC4899)
                                .withValues(alpha: _glowAnimation.value * 0.3),
                            blurRadius: 15,
                            spreadRadius: -5,
                            offset: const Offset(-2, -2),
                          ),
                          BoxShadow(
                            color: const Color(0xFF7C3AED)
                                .withValues(alpha: _glowAnimation.value * 0.2),
                            blurRadius: 25,
                            spreadRadius: -1,
                          ),
                        ],
                      ),
                    ),

                    // Content
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                // Enhanced flag container
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 36,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color:
                                          Colors.white.withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF06B6D4)
                                            .withValues(
                                                alpha:
                                                    _glowAnimation.value * 0.5),
                                        blurRadius: 12,
                                        spreadRadius: -3,
                                      ),
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.asset(
                                      widget.selectedFlag,
                                      package: 'country_list_pick',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Enhanced country name
                                AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 300),
                                  style: TextStyle(
                                    color: _isHovered
                                        ? Colors.white.withValues(alpha: 1.0)
                                        : Colors.white.withValues(alpha: 0.92),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                    shadows: [
                                      Shadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.3),
                                        offset: const Offset(0, 1),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Text(widget.selectedCountry),
                                ),
                              ],
                            ),
                            // Enhanced dropdown icon with pulse effect
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.white.withValues(
                                        alpha: _isHovered ? 0.15 : 0.08),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: AnimatedRotation(
                                duration: const Duration(milliseconds: 300),
                                turns: _isHovered ? 0.125 : 0,
                                child: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: _isHovered
                                      ? Colors.white.withValues(alpha: 0.9)
                                      : Colors.white.withValues(alpha: 0.7),
                                  size: 28,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
