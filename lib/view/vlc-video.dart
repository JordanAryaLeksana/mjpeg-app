import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class VLCvideopage extends StatefulWidget {
  const VLCvideopage({super.key});

  @override
  State<VLCvideopage> createState() => _VLCvideopageState();
}

class _VLCvideopageState extends State<VLCvideopage> {
  late VlcPlayerController _vlcViewController;
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();

    _vlcViewController = VlcPlayerController.network(
      'rtmp://192.168.1.10:1935/live/stream',
      hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
  }

  @override
  void dispose() {
    _vlcViewController.stop();
    _vlcViewController.dispose();
    super.dispose();
  }

  void togglePlayPause() async {
    final state = await _vlcViewController.isPlaying();
    if (state ?? false) {
      await _vlcViewController.pause();
      setState(() {
        isPlaying = false;
      });
    } else {
      await _vlcViewController.play();
      setState(() {
        isPlaying = true;
      });
    }
  }

  void stopStream() async {
    await _vlcViewController.stop();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("VLC Stream Control")),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: VlcPlayer(
              controller: _vlcViewController,
              aspectRatio: 16 / 9,
              placeholder: const Center(child: CircularProgressIndicator()),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                label: Text(isPlaying ? 'Pause' : 'Play'),
                onPressed: togglePlayPause,
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.stop),
                label: const Text('Stop'),
                onPressed: stopStream,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
