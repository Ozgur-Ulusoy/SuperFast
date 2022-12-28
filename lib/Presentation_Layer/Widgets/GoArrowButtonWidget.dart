import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../Data_Layer/consts.dart';

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
