// import 'dart:io';
// import 'dart:async';

// // import 'package:angel_container/mirrors.dart';
// import 'package:angel_framework/angel_framework.dart';
// import 'package:angel_framework/http.dart';
// import 'package:angel_static/angel_static.dart';
// import 'package:file/local.dart';

// import 'package:flutter/material.dart';

// class NetworkServer extends StatefulWidget {
//   NetworkServer({Key key}) : super(key: key);

//   @override
//   _NetworkServerState createState() => _NetworkServerState();
// }

// class _NetworkServerState extends State<NetworkServer> {
//   String statusText = "Start Server";
//   bool host=false;
//   HttpServer server;
//   AngelHttp http;

//   // static var app = Angel();
//   // static var fs = const LocalFileSystem();

//   // // var vDir = VirtualDirectory(app, fs,source:Directory('/storage/emulated/0/Movies'));
//   // var vDir = CachingVirtualDirectory(app, fs,source:Directory('/storage/emulated/0/Movies'));
//   // app.fallback(vDir.handleRequest(req,res));

//   // startServer() async {
//   //   setState(() {
//   //     statusText = "Starting server on Port : 8080";
//   //   });
//   //   server = await HttpServer.bind(InternetAddress.anyIPv4, 9876);
//   //   print("Server running on IP : " +
//   //       server.address.toString() +
//   //       " On Port : " +
//   //       server.port.toString());
//   //   await for (var request in server) {
//   //     request.response
//   //       ..headers.contentType =
//   //           new ContentType("plain", "text")
//   //       ..write('/storage/emulated/0/Movies/Rick.and.Morty.S04E06.720p.mkv')
//   //       ..close();
//   //   }
//   //   setState(() {
//   //     statusText = "Server running on IP : " +
//   //         server.address.toString() +
//   //         " On Port : " +
//   //         server.port.toString();
//   //   });
//   // }

//   stopServer() async{
//     setState(() {
//       statusText = "Start Server";
//       server.close();
//     });

//   }
//   startServer() async{
//     var app = Angel();
//     var fs = const LocalFileSystem();

//     // var vDir = VirtualDirectory(app, fs,source:Directory('/storage/emulated/0/Movies'));
//     var vDir = CachingVirtualDirectory(app, fs,source:Directory('/storage/emulated/0/Movies'));
//     app.fallback(vDir.handleRequest);
//     server = await AngelHttp(app).startServer('0.0.0.0',3000);
//   }
//   // startServer() async{
//   //   // Create our server.
//   // var app = Angel(
//   //   // logger: Logger('angel'),
//   // //   reflector: MirrorsReflector(),
//   // );

//   // // Index route. Returns JSON.
//   // app.get('/', (req, res) => 'Welcome to Angel!');

//   // // Accepts a URL like /greet/foo or /greet/bob.
//   // app.get(
//   //   '/greet/:name',
//   //   (req, res) {
//   //     var name = req.params['name'];
//   //     res
//   //       ..write('Hello, $name!')
//   //       ..close();
//   //   },
//   // );

//   // // Pattern matching - only call this handler if the query value of `name` equals 'emoji'.
//   // app.get(
//   //   '/greet',
//   //   ioc((@Query('name', match: 'emoji') String name) => '😇🔥🔥🔥'),
//   // );

//   // // Handle any other query value of `name`.
//   // app.get(
//   //   '/greet',
//   //   ioc((@Query('name') String name) => 'Hello, $name!'),
//   // );

//   // // Simple fallback to throw a 404 on unknown paths.
//   // app.fallback((req, res) {
//   //   throw AngelHttpException.notFound(
//   //     message: 'Unknown path: "${req.uri.path}"',
//   //   );
//   // });

//   // http = AngelHttp(app);
//   // server = await http.startServer('0.0.0.0', 3000);
//   // var url = 'http://${server.address.address}:${server.port}';
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           !host?RaisedButton(
//             onPressed: () {
//               startServer();
//               setState(() {
//                 host=true;
//               });
//             },
//             child: Text(statusText),
//           ):Container(),
//           host?RaisedButton(
//             onPressed: () {
//               stopServer();
//               setState(() {
//                 host=false;
//               });
//             },
//             child: Text("Stop"),
//           ):Container()
//         ],
//       ),
//     ));
//   }
// }
