import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../services/problem_service.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );
        await _controller!.initialize();
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      if (mounted) {
        _showErrorDialog('Failed to initialize camera: $e');
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Capture Problem',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomControls(),
    );
  }

  Widget _buildBody() {
    if (!_isInitialized) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Initializing camera...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        Positioned.fill(
          child: CameraPreview(_controller!),
        ),
        _buildCameraOverlay(),
      ],
    );
  }

  Widget _buildCameraOverlay() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white.withOpacity(0.5),
          width: 2,
        ),
      ),
      margin: const EdgeInsets.all(20),
      child: const SizedBox.expand(),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: _switchCamera,
            icon: const Icon(
              Icons.flip_camera_ios,
              color: Colors.white,
              size: 32,
            ),
          ),
          GestureDetector(
            onTap: _isCapturing ? null : _captureImage,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
                color: _isCapturing ? Colors.grey : Colors.transparent,
              ),
              child: _isCapturing
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 32,
                    ),
            ),
          ),
          IconButton(
            onPressed: () {}, // Placeholder for flash toggle
            icon: const Icon(
              Icons.flash_off,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized || _isCapturing) {
      return;
    }

    setState(() {
      _isCapturing = true;
    });

    try {
      final XFile image = await _controller!.takePicture();
      final problemService = Provider.of<ProblemService>(context, listen: false);
      
      final problem = await problemService.addProblem(
        File(image.path),
        title: 'Captured Problem',
      );

      if (mounted) {
        context.pop();
        context.push('/problem-viewer?problemId=${problem.id}');
      }
    } catch (e) {
      debugPrint('Error capturing image: $e');
      if (mounted) {
        _showErrorDialog('Failed to capture image: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;

    final currentIndex = _cameras!.indexOf(_controller!.description);
    final nextIndex = (currentIndex + 1) % _cameras!.length;

    await _controller?.dispose();
    
    _controller = CameraController(
      _cameras![nextIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error switching camera: $e');
      if (mounted) {
        _showErrorDialog('Failed to switch camera: $e');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}