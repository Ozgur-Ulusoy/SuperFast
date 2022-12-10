import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  double w;
  LogoWidget({Key? key, required this.w}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: w,
      child: Column(
        children: [
          Expanded(
            flex: 4,
            child: SizedBox(
              width: w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(253, 131, 13, 1),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: const BoxDecoration(
                        // color: Color.fromRGBO(253, 131, 13, 1),
                        // borderRadius: BorderRadius.all(Radius.circular(5)),
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: AssetImage("assets/images/Group4.png"),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          Expanded(
            flex: 4,
            child: SizedBox(
              width: w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(187, 250, 240, 1),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(233, 244, 255, 1),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
