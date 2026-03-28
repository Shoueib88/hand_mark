import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class LiveVideoRecording extends StatefulWidget {
  const LiveVideoRecording({Key? key}) : super(key: key);

  @override
  _LiveVideoRecordingState createState() => _LiveVideoRecordingState();
}

class _LiveVideoRecordingState extends State<LiveVideoRecording>
    with WidgetsBindingObserver {
  CameraController? _cameraController;
  CameraDescription? _camera;
  String _videoPath = '';
  bool _isRecording = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _cameraController?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _showSnackBar('No cameras available');
        return;
      }
      _camera = cameras.first;
      _cameraController = CameraController(
        _camera!,
        ResolutionPreset.high,
      );
      await _cameraController!.initialize();
      setState(() {});
    } catch (e) {
      _showSnackBar('Error initializing camera: $e');
    }
  }

  Future<void> _startVideoRecording() async {
    if (_cameraController == null ||
        !_cameraController!.value.isInitialized ||
        _isRecording) return;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/video.mp4');
      _videoPath = file.path;

      await _cameraController!.startVideoRecording();
      _cameraController = CameraController(
        _camera!,
        ResolutionPreset.high,
      );
      await _cameraController!.initialize();
      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      _showSnackBar('Error starting video recording: $e');
    }
  }

  Future<void> _stopVideoRecording() async {
    if (_cameraController == null || !_cameraController!.value.isRecordingVideo)
      return;

    try {
      await _cameraController!.stopVideoRecording();
      setState(() {
        _isRecording = false;
      });
    } catch (e) {
      _showSnackBar('Error stopping video recording: $e');
    }
  }

  Future<void> _sendVideoToAPI() async {
    if (_isSending) return;

    final file = File(_videoPath);
    if (!file.existsSync()) {
      _showSnackBar('Video file does not exist');
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      final bytes = await file.readAsBytes();
      final stream = Stream.fromIterable([bytes]);

      final request = http.MultipartRequest(
          'POST', Uri.parse('http://192.168.101.60:8000/upload/'));
      request.files.add(
        http.MultipartFile(
          'video',
          stream,
          bytes.length,
          filename: 'video.mp4',
        ),
      );

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        _showSnackBar('Video sent successfully!');
        print('Response: $responseBody');
      } else {
        _showSnackBar('Error sending video: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Error sending video: $e');
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Video Recording'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_cameraController != null &&
                  _cameraController!.value.isInitialized)
                AspectRatio(
                  aspectRatio: _cameraController!.value.aspectRatio,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 3.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: CameraPreview(_cameraController!),
                    ),
                  ),
                )
              else
                Center(child: CircularProgressIndicator()),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isRecording ? null : _startVideoRecording,
                child: Text('Start Recording'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isRecording ? _stopVideoRecording : null,
                child: Text('Stop Recording'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: (_videoPath.isNotEmpty && !_isSending)
                    ? _sendVideoToAPI
                    : null,
                child: _isSending
                    ? CircularProgressIndicator()
                    : Text('Send Video to API'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
