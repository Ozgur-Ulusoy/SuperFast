import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Data_Layer/consts.dart';
import '../../Data_Layer/data.dart';

class SettingsCard extends StatefulWidget {
  final String title;
  bool value;
  final Function(bool) onChanged;
  SettingsCard(
      {Key? key,
      required this.title,
      required this.value,
      required this.onChanged})
      : super(key: key);

  @override
  State<SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ScreenUtil.width * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 10,
            child: SizedBox(
              width: ScreenUtil.width * 0.65,
              child: Text(
                widget.title,
                style: GoogleFonts.poppins(
                  fontSize: ScreenUtil.letterSpacing * 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const Spacer(),
          Transform.scale(
            scale: 1.5,
            child: Switch.adaptive(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: Colors.green,
              inactiveTrackColor: Colors.red,
              inactiveThumbColor: Colors.red,
              value: widget.value,
              onChanged: (value) => widget.onChanged(value),
            ),
          ),
          // const Spacer(),
        ],
      ),
    );
  }
}
