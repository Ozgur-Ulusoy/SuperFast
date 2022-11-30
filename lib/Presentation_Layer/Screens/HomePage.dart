import 'package:engame2/Data_Layer/consts.dart';
import 'package:engame2/Presentation_Layer/Screens/PlayPage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(flex: 1, child: SizedBox()),
              //* Play Button
              SizedBox(
                width: ScreenUtil.width * 0.2,
                height: ScreenUtil.width * 0.2,
                child: FittedBox(
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return const PlayPage();
                        }),
                      );
                    },
                    child: const Icon(Icons.play_arrow),
                  ),
                ),
              ),
              const Expanded(flex: 1, child: SizedBox()),
              //* Record
              const Text(
                "Record",
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(height: ScreenUtil.height * 0.025),
            ],
          ),
        ),
      ),
    );
  }
}
