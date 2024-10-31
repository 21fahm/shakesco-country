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
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
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
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                height: 56,
                width: MediaQuery.of(context).size.width * 0.8,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Stack(
                  children: [
                    // Animated background gradient
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF6366F1)
                                .withOpacity(_isHovered ? 0.15 : 0.1),
                            Color(0xFFA855F7)
                                .withOpacity(_isHovered ? 0.15 : 0.1),
                            Color(0xFFEC4899)
                                .withOpacity(_isHovered ? 0.15 : 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    ),
                    // Glassmorphism effect
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.1),
                                Colors.white.withOpacity(0.05),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Glow effect
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF6366F1)
                                .withOpacity(_glowAnimation.value * 0.2),
                            blurRadius: 15,
                            spreadRadius: -2,
                          ),
                        ],
                      ),
                    ),
                    // Content
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                // Flag with subtle glow
                                Container(
                                  width: 32,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withOpacity(
                                            _glowAnimation.value * 0.3),
                                        blurRadius: 8,
                                        spreadRadius: -2,
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    widget.selectedFlag,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Country name with modern typography
                                Text(
                                  widget.selectedCountry,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                            // Animated dropdown icon
                            AnimatedRotation(
                              duration: const Duration(milliseconds: 200),
                              turns: _isHovered ? 0.125 : 0,
                              child: Icon(
                                Icons.expand_more_rounded,
                                color: Colors.white.withOpacity(0.7),
                                size: 24,
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
