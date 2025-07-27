import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

class ShowConnectivity extends StatefulWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final TextStyle? textStyle;
  final Duration animationDuration;
  final bool showIcon;
  final bool showText;

  const ShowConnectivity({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 20.0,
    this.textStyle,
    this.animationDuration = const Duration(milliseconds: 300),
    this.showIcon = true,
    this.showText = true,
  });

  @override
  State<ShowConnectivity> createState() => _NetworkStatusWidgetState();
}

class _NetworkStatusWidgetState extends State<ShowConnectivity>
    with SingleTickerProviderStateMixin {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool isConnected = false;
  String connectionType = 'Offline';
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkInitialConnectivity();
    _listenToConnectivityChanges();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  Future<void> _checkInitialConnectivity() async {
    final List<ConnectivityResult> connectivityResult = await Connectivity()
        .checkConnectivity();
    _updateConnectionStatus(connectivityResult);
  }

  void _listenToConnectivityChanges() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      _updateConnectionStatus(result);
    });
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    bool wasConnected = isConnected;

    if (results.contains(ConnectivityResult.wifi)) {
      isConnected = true;
      connectionType = 'WiFi';
    } else if (results.contains(ConnectivityResult.mobile)) {
      isConnected = true;
      connectionType = 'Mobile Data';
    } else {
      isConnected = false;
      connectionType = 'Offline';
    }

    if (wasConnected != isConnected) {
      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    }

    if (mounted) {
      setState(() {});
    }
  }

  Color get _backgroundColor {
    return isConnected ? Colors.green : Colors.red;
  }

  Color get _textColor {
    return Colors.white;
  }

  IconData get _statusIcon {
    if (isConnected) {
      return connectionType == 'WiFi'
          ? Icons.wifi
          : Icons.signal_cellular_4_bar;
    }
    return Icons.wifi_off;
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: AnimatedContainer(
            duration: widget.animationDuration,
            width: widget.width ?? 120,
            height: widget.height ?? 40,
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: _backgroundColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.showIcon) ...[
                    Icon(_statusIcon, color: _textColor, size: 16),
                    if (widget.showText) const SizedBox(width: 6),
                  ],
                  if (widget.showText)
                    Flexible(
                      child: Text(
                        isConnected ? 'Online' : 'Offline',
                        style:
                            widget.textStyle ??
                            TextStyle(
                              color: _textColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
