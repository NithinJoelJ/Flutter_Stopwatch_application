import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeApp(),
    );
  }
}

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  int seconds = 0, minutes = 0, hours = 0;
  String digitSeconds = "00", digitMinutes = "00", digitHours = "00";
  Timer? timer;
  bool started = false;
  List laps = [];

  // Stop timer function
  void stop() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }

  // Reset function
  void reset() {
    timer!.cancel();
    setState(() {
      seconds = 0;
      minutes = 0;
      hours = 0;

      digitSeconds = "00";
      digitMinutes = "00";
      digitHours = "00";

      started = false;
      laps.clear(); // Clear laps on reset
    });
  }

  void addLaps() {
    String lap = "$digitHours:$digitMinutes:$digitSeconds";
    setState(() {
      laps.add(lap);
    });
  }

  // Start timer function
  void start() {
    started = true;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int localSeconds = seconds + 1;
      int localMinutes = minutes;
      int localHours = hours;

      if (localSeconds > 59) {
        if (localMinutes > 59) {
          localHours++;
          localMinutes = 0;
        } else {
          localMinutes++;
          localSeconds = 0;
        }
      }
      setState(() {
        seconds = localSeconds;
        minutes = localMinutes;
        hours = localHours;
        digitSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
        digitHours = (hours >= 10) ? "$hours" : "0$hours";
        digitMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF201E43),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "STOPWATCH",
                  style: TextStyle(
                    color: const Color(0xFFEEEEEE),
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Center(
                child: Text(
                  "$digitHours:$digitMinutes:$digitSeconds",
                  style: TextStyle(
                    color: const Color(0xFFEEEEEE),
                    fontSize: 80.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                height: 400.0,
                decoration: BoxDecoration(
                  color: const Color(0xFF134B70),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                // List builder
                child: ListView.builder(
                  itemCount: laps.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Lap n°${index + 1}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight:
                                  FontWeight.w500, // Increased font weight
                            ),
                          ),
                          Text(
                            "${laps[index]}",
                            style: TextStyle(
                              color: Colors
                                  .white, // Changed lap text color to white
                              fontSize: 16.0,
                              fontWeight:
                                  FontWeight.w500, // Increased font weight
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        (!started) ? start() : stop();
                      },
                      shape: const StadiumBorder(
                        side: BorderSide(color: Colors.blue),
                      ),
                      child: Text(
                        (!started) ? "START" : "PAUSE",
                        style: TextStyle(color: const Color(0xFFEEEEEE)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  IconButton(
                    color: const Color(0xFFEEEEEE),
                    onPressed: () {
                      addLaps();
                    },
                    icon: const Icon(Icons.flag),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () {
                        reset();
                      },
                      fillColor: Colors.blue,
                      shape: const StadiumBorder(),
                      child: const Text(
                        "RESET",
                        style: TextStyle(color: Color(0xFFEEEEEE)),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
