import 'package:engame2/Data_Layer/consts.dart';
import 'package:engame2/Presentation_Layer/Widgets/SettingsCard.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Business_Layer/cubit/homepage_notifi_alert_cubit.dart';
import '../../Data_Layer/data.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: ScreenUtil.width * 0.035,
                top: ScreenUtil.height * 0.035,
                right: ScreenUtil.width * 0.035,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: ScreenUtil.letterSpacing * 40,
                      color: cBlueBackground,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ScreenUtil.height * 0.025),
            Padding(
              padding: EdgeInsets.only(
                left: ScreenUtil.width * 0.05,
              ),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      "Ayarlar",
                      style: GoogleFonts.poppins(
                        fontSize: ScreenUtil.letterSpacing * 28,
                        fontWeight: FontWeight.bold,
                        color: cBlueBackground,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ScreenUtil.height * 0.025),
            SettingsCard(
              title: "Oyun İçi Sesleri Aç",
              value: MainData.isSoundOn,
              onChanged: (value) async {
                setState(() {
                  MainData.isSoundOn = value;
                });
                await MainData.localData!.put(KeyUtils.isSoundOnKey, value);
              },
            ),
            SizedBox(height: ScreenUtil.height * 0.025),
            SettingsCard(
              title: "Bildirim Al",
              value: MainData.getNotification,
              onChanged: (value) async {
                setState(() {
                  MainData.getNotification = value;
                });
                await MainData.localData!
                    .put(KeyUtils.isGetNotificationOnKey, value);
                try {
                  if (MainData.getNotification == true) {
                    await FirebaseMessaging.instance
                        .subscribeToTopic(KeyUtils.notificationTopicKey);
                  } else {
                    await FirebaseMessaging.instance
                        .unsubscribeFromTopic(KeyUtils.notificationTopicKey);
                  }
                } catch (e) {}
              },
            ),
            SizedBox(height: ScreenUtil.height * 0.025),
            SettingsCard(
              title: "Kontrol Butonunu Kaldır",
              value: MainData.removeControlButtonEngame,
              onChanged: (value) async {
                setState(() {
                  MainData.removeControlButtonEngame = value;
                });
                await MainData.localData!
                    .put(KeyUtils.isEngameControlButtonOnKey, value);
              },
            ),
            SizedBox(height: ScreenUtil.height * 0.025),
            SettingsCard(
              title: "İlk Açılışta Günün Kelimesini Göster",
              value: MainData.showAlwaysDailyWord,
              onChanged: (value) async {
                setState(() {
                  MainData.showAlwaysDailyWord = value;
                });
                await MainData.localData!
                    .put(KeyUtils.isShowDailyWordOnKey, value);
              },
            ),
            SizedBox(height: ScreenUtil.height * 0.025),
            SettingsCard(
              title: "Ana Menüde Bildirim Alarmını Göster",
              value:
                  context.watch<HomepageNotifiAlertCubit>().state.isNotifiAlert,
              onChanged: (value) async {
                BlocProvider.of<HomepageNotifiAlertCubit>(context)
                    .ChangeNotifiAlert(value);
                await MainData.localData!
                    .put(KeyUtils.isShowHomePageNotifiAlertOnKey, value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
