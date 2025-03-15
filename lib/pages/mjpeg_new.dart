// import 'package:flutter_mjpeg/flutter_mjpeg.dart';

// @override
// Widget build(BuildContext context) {
//   return Column(
//     children: [
//       Expanded(
//         child: Mjpeg(
//           isLive: true,
//           stream: 'http://172.20.10.2:8080/stream.mjpeg?clientId=PSKPXXZ5e4ndDJh2',
//           error: (context, error, stack) {
//             print("Error: $error");
//             return Center(
//               child: Text("Error: $error", style: TextStyle(color: Colors.red)),
//             );
//           },
//           loading: (context) => Center(
//             child: CircularProgressIndicator(),
//           ),
//         ),
//       ),
//     ],
//   );
// }