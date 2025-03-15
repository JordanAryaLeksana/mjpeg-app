import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:typed_data';

class MjpegView extends StatefulWidget {
  final String streamUrl;
  final BoxFit fit;
  final double width;
  final double height;
  final Map<String, String>? headers;

  const MjpegView({
    Key? key,
    required this.streamUrl,
    this.fit = BoxFit.contain,
    this.width = double.infinity,
    this.height = double.infinity,
    this.headers,
  }) : super(key: key);

  @override
  _MjpegViewState createState() => _MjpegViewState();
}

class _MjpegViewState extends State<MjpegView> {
  Uint8List? _imageBytes;
  HttpClient? _httpClient;
  bool _isConnected = false;
  StreamSubscription? _streamSubscription;
  String _statusMessage = "Menghubungkan...";
  int _retryCount = 0;
  static const int _maxRetries = 5;
  bool _processingImage = false;
  List<int> _buffer = [];
  int _frameCount = 0;
  String _debugInfo = "";

  @override
  void initState() {
    super.initState();
    _connect();
  }

  @override
  void dispose() {
    _disconnect();
    super.dispose();
  }

  @override
  void didUpdateWidget(MjpegView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.streamUrl != widget.streamUrl) {
      _disconnect();
      _retryCount = 0;
      _buffer = [];
      _connect();
    }
  }

  Future<void> _connect() async {
    if (_isConnected) return;
    
    if (_retryCount >= _maxRetries) {
      setState(() {
        _statusMessage = "Gagal terhubung setelah $_maxRetries percobaan";
      });
      return;
    }
    
    _retryCount++;
    
    setState(() {
      _statusMessage = "Menghubungkan (percobaan $_retryCount)...";
      _debugInfo = "";
    });
    
    print("Percobaan $_retryCount - Menghubungkan ke: ${widget.streamUrl}");
    
    _httpClient = HttpClient();
    _httpClient!.connectionTimeout = const Duration(seconds: 15);
    
    try {
      final request = await _httpClient!.getUrl(Uri.parse(widget.streamUrl));
      
      // Add necessary headers
      request.headers.set('Connection', 'keep-alive');
      request.headers.set('Accept', '*/*');
      request.headers.set('Cache-Control', 'no-cache');
      request.headers.set('User-Agent', 'Flutter-MJPEG-Client');
      
      // Add custom headers if provided
      widget.headers?.forEach((key, value) {
        request.headers.set(key, value);
      });
      
      final response = await request.close().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw TimeoutException('Connection timed out');
        },
      );
      
      print("Terhubung, status: ${response.statusCode}");
      print("Content-Type: ${response.headers.contentType}");
      
      if (response.statusCode != 200) {
        throw HttpException("HTTP Error: ${response.statusCode}");
      }
      
      // Get content type and boundary
      final contentType = response.headers.contentType?.toString() ?? '';
      String? boundary;
      bool isMultipart = false;
      
      setState(() {
        _debugInfo = "Content-Type: $contentType";
      });
      
      if (contentType.contains('multipart/x-mixed-replace')) {
        isMultipart = true;
        final boundaryMatch = RegExp(r'boundary=(.+?)($|;)').firstMatch(contentType);
        if (boundaryMatch != null) {
          boundary = boundaryMatch.group(1);
          // Remove quotes if present
          if (boundary != null && boundary.startsWith('"') && boundary.endsWith('"')) {
            boundary = boundary.substring(1, boundary.length - 1);
          }
          print("Found boundary: $boundary");
          setState(() {
            _debugInfo += "\nBoundary: $boundary";
          });
        } else {
          print("No boundary found in Content-Type");
          setState(() {
            _debugInfo += "\nNo boundary found";
          });
        }
      } else {
        print("Not a multipart stream, treating as direct JPEG stream");
        setState(() {
          _debugInfo += "\nJPEG Direct Stream";
        });
      }
      
      setState(() {
        _isConnected = true;
        _statusMessage = "Terhubung, menunggu frame...";
        _buffer = [];
      });

      _streamSubscription = response.listen(
        (data) {
          _buffer.addAll(data);
          
          if (_buffer.length > 5) {
            setState(() {
              _debugInfo = "Buffer: ${_buffer.length} bytes\n" + 
                         "First bytes: ${_buffer.take(10).toList()}\n" +
                         "Content-Type: $contentType";
              if (boundary != null) {
                _debugInfo += "\nBoundary: $boundary";
              }
            });
          }
          
          if (!_processingImage) {
            _processingImage = true;
            
            if (isMultipart && boundary != null) {
              _processMultipartData(boundary);
            } else {
              _processJpegData();
            }
            
            _processingImage = false;
          }
        },
        onDone: () {
          print("Stream selesai");
          if (mounted) {
            setState(() {
              _isConnected = false;
              _statusMessage = "Koneksi terputus";
            });
            
            // Try to reconnect
            Future.delayed(Duration(seconds: 2), () {
              if (mounted) _connect();
            });
          }
        },
        onError: (error) {
          print("Error streaming: $error");
          if (mounted) {
            setState(() {
              _isConnected = false;
              _statusMessage = "Error: $error";
            });
            
            // Try to reconnect
            Future.delayed(Duration(seconds: 2), () {
              if (mounted) _connect();
            });
          }
        },
        cancelOnError: false,
      );
    } catch (e) {
      print("Kesalahan koneksi: $e");
      if (mounted) {
        setState(() {
          _isConnected = false;
          _statusMessage = "Kesalahan: $e";
        });
        
        // Try again after a delay
        Future.delayed(Duration(seconds: 3), () {
          if (mounted) _connect();
        });
      }
    }
  }

  void _processJpegData() {
    // Look for JPEG markers in the buffer
    int start = -1;
    int end = -1;
    
    // Find the start marker (FFD8)
    for (int i = 0; i < _buffer.length - 1; i++) {
      if (_buffer[i] == 0xFF && _buffer[i + 1] == 0xD8) {
        start = i;
        break;
      }
    }
    
    if (start == -1) return; // No start marker found
    
    // Find the end marker (FFD9)
    for (int i = start + 2; i < _buffer.length - 1; i++) {
      if (_buffer[i] == 0xFF && _buffer[i + 1] == 0xD9) {
        end = i + 1; // Include the end marker
        break;
      }
    }
    
    if (end == -1) return; // No end marker found
    
    // We found a complete JPEG image
    try {
      final imageData = Uint8List.fromList(_buffer.sublist(start, end + 1));
      _frameCount++;
      
      print("Frame #$_frameCount, size: ${imageData.length} bytes");
      
      setState(() {
        _imageBytes = imageData;
        _statusMessage = "Frame #$_frameCount diterima";
      });
      
      // Remove the processed data from the buffer
      _buffer = _buffer.sublist(end + 1);
    } catch (e) {
      print("Error processing JPEG: $e");
    }
  }

  void _processMultipartData(String boundary) {
    final boundaryBytes = "--$boundary".codeUnits;
    
    // Look for two consecutive boundaries to extract a part
    int firstBoundary = _findBoundary(boundaryBytes, 0);
    if (firstBoundary == -1) return;
    
    int secondBoundary = _findBoundary(boundaryBytes, firstBoundary + boundaryBytes.length);
    if (secondBoundary == -1) return;
    
    // Extract the data between boundaries
    final partData = _buffer.sublist(firstBoundary + boundaryBytes.length, secondBoundary);
    
    // Look for the end of headers (double CRLF)
    int headerEnd = _findDoubleCRLF(partData);
    if (headerEnd == -1) return;
    
    // Extract the image data after headers
    final imageData = partData.sublist(headerEnd + 4); // +4 for double CRLF
    
    // Check if the data contains JPEG markers
    int jpegStart = -1;
    int jpegEnd = -1;
    
    // Find JPEG start
    for (int i = 0; i < imageData.length - 1; i++) {
      if (imageData[i] == 0xFF && imageData[i + 1] == 0xD8) {
        jpegStart = i;
        break;
      }
    }
    
    if (jpegStart == -1) {
      // If no JPEG start found, try using the data directly
      jpegStart = 0;
    }
    
    // Find JPEG end
    for (int i = jpegStart + 2; i < imageData.length - 1; i++) {
      if (imageData[i] == 0xFF && imageData[i + 1] == 0xD9) {
        jpegEnd = i + 1; // Include the end marker
        break;
      }
    }
    
    if (jpegEnd == -1) {
      // If no end marker found, try using all remaining data
      jpegEnd = imageData.length - 1;
    }
    
    try {
      final jpegData = Uint8List.fromList(imageData.sublist(jpegStart, jpegEnd + 1));
      _frameCount++;
      
      print("Frame #$_frameCount, size: ${jpegData.length} bytes");
      
      // Only update if it looks like a valid JPEG (starts with FFD8)
      if (jpegData.length > 1 && jpegData[0] == 0xFF && jpegData[1] == 0xD8) {
        setState(() {
          _imageBytes = jpegData;
          _statusMessage = "Frame #$_frameCount diterima";
        });
      }
      
      // Remove the processed part from the buffer
      _buffer = _buffer.sublist(secondBoundary);
    } catch (e) {
      print("Error processing multipart data: $e");
    }
  }

  int _findBoundary(List<int> boundaryBytes, int startPos) {
    for (int i = startPos; i <= _buffer.length - boundaryBytes.length; i++) {
      bool match = true;
      for (int j = 0; j < boundaryBytes.length; j++) {
        if (_buffer[i + j] != boundaryBytes[j]) {
          match = false;
          break;
        }
      }
      if (match) return i;
    }
    return -1;
  }

  int _findDoubleCRLF(List<int> data) {
    for (int i = 0; i < data.length - 3; i++) {
      if (data[i] == 13 && data[i + 1] == 10 && data[i + 2] == 13 && data[i + 3] == 10) {
        return i;
      }
    }
    return -1;
  }

  void _disconnect() {
    _streamSubscription?.cancel();
    _httpClient?.close();
    _httpClient = null;
    _isConnected = false;
  }

  void _resetAndReconnect() {
    _disconnect();
    _retryCount = 0;
    _buffer = [];
    _connect();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_imageBytes != null)
            Image.memory(
              _imageBytes!,
              fit: widget.fit,
              gaplessPlayback: true,
              errorBuilder: (context, error, stackTrace) {
                print("Error displaying image: $error");
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.broken_image, color: Colors.red, size: 48),
                      SizedBox(height: 8),
                      Text(
                        "Error gambar: $error",
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _resetAndReconnect,
                        child: Text("Coba Lagi"),
                      ),
                    ],
                  ),
                );
              },
            )
          else
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    _statusMessage,
                    style: TextStyle(color: Colors.white),
                  ),
                  if (_retryCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: ElevatedButton(
                        onPressed: _resetAndReconnect,
                        child: Text("Coba Lagi"),
                      ),
                    ),
                ],
              ),
            ),
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Container(
              padding: EdgeInsets.all(4),
              color: Colors.black54,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _statusMessage,
                        style: TextStyle(color: Colors.white),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: _isConnected ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _isConnected ? "Connected" : "Disconnected",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _debugInfo,
                    style: TextStyle(color: Colors.yellow, fontSize: 10),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Example usage:
class MjpegExample extends StatelessWidget {
  const MjpegExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MJPEG Stream Viewer'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // Force rebuild by replacing the current route
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MjpegExample()),
              );
            },
          ),
        ],
      ),
      body: MjpegView(
        streamUrl: 'http://172.20.10.2:8080/stream.mjpeg?clientId=PSKPXXZ5e4ndDJh2',
        fit: BoxFit.contain,
        headers: {
          "Cache-Control": "no-cache",
          "Connection": "keep-alive",
        },
      ),
    );
  }
}