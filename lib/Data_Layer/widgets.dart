import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'consts.dart';

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

class GoArrowButton extends StatelessWidget {
  Function? toDo;
  GoArrowButton({Key? key, this.toDo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(233, 244, 255, 1),
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      height: ScreenUtil.height * 0.125,
      width: ScreenUtil.height * 0.125,
      child: Padding(
        padding: const EdgeInsets.all(3.5),
        child: GestureDetector(
          onTap: () {
            toDo!();
            // //! Login Page Nagivate
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) {
            //     return const LoginPage();
            //   }),
            // );
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(76, 81, 198, 1),
              borderRadius: BorderRadius.all(
                Radius.circular(100),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: FittedBox(
                child: Icon(
                  MdiIcons.arrowRight,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
