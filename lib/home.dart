import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  double h = 300;
  double w = 500;
  String ip = ".....";
  Timer? timer;
  var ipAddress = IpAddress();
  late AnimationController controller;

  late AnimationController animationController1;
  late Animation<double> animation1;

  @override
  void initState() {
    super.initState();
    // the rotating logo animation
    controller = AnimationController(vsync: this);
    controller.repeat(min: 0.0, max: 1.0, period: const Duration(seconds: 60));

    // for the Homie Studion logo animation
    animationController1 = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    animation1 = Tween<double>(begin: 0, end: pi * 2).animate(animationController1);

    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      try {
        dynamic data = await ipAddress.getIpAddress();
        setState(() {
          ip = data;
        });
      } catch (e) {
        setState(() {
          ip = "Check your network...";
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    animationController1.dispose();
  }

  Widget ruler(double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          height: height,
          width: 8,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(20),
          ),
          child: null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xff121212),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ruler(100),
          SizedBox(
            height: h * 0.05,
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "Don't worry mate,\n [ we refresh every second ]",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white30,
              ),
            ),
          ),
          SizedBox(
            width: w * 0.73,
            height: w * 0.73,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: w * 0.6,
                  height: w * 0.6,
                  decoration: const BoxDecoration(
                    color: Color(0xff222222),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      ip,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: ip.startsWith("C") ? 16 : 25,
                        fontWeight: ip.startsWith("C") ? FontWeight.bold : FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                RotationTransition(
                  turns: controller,
                  child: const Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: 50.0,
                      width: 50.0,
                      child: Image(
                        image: AssetImage("assets/icon.png"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          IconButton(
              onPressed: () async {
                try {
                  dynamic data = await ipAddress.getIpAddress();
                  setState(() {
                    ip = data;
                  });
                } catch (e) {
                  setState(() {
                    ip = "Check your network...";
                  });
                }
              },
              icon: const Icon(
                Icons.refresh_rounded,
                size: 40,
                color: Colors.white30,
              )),
          const SizedBox(
            height: 5,
          ),
          ruler(h * 0.5),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.2, vertical: 5),
            child: GestureDetector(
              onTap: (() => animationController1.forward(from: 0)),
              child: AnimatedBuilder(
                animation: animation1,
                child: const Image(
                  image: AssetImage("assets/homie.png"),
                ),
                builder: (context, child) {
                  return Transform.rotate(
                    angle: animation1.value,
                    child: Container(
                      child: child,
                    ),
                  );
                },
              ),
            ),
          ),
          const Text(
            "[ Homie Studio Kenya ]",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white30,
            ),
          ),
          IconButton(
              onPressed: () async {
                const url = 'https://homiestudiokenya.web.app';
                if (await canLaunchUrlString(url)) {
                  await launchUrlString(url, mode: LaunchMode.externalApplication);
                } else {
                  // throw 'Could not launch $url';
                }
              },
              splashRadius: 25,
              icon: const Icon(
                Icons.language_rounded,
                color: Colors.white60,
              )),
          ruler(h * 0.1),
          SizedBox(
            height: h * 0.01,
          ),
        ],
      ),
    );
  }
}
