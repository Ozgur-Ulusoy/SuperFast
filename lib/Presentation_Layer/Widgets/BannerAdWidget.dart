import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  String adId;
  double height;
  bool isLoading;
  // VoidCallback callback;
  BannerAdWidget({
    Key? key,
    required this.adId,
    this.height = 0,
    this.isLoading = true,
    // this.callback,
  }) : super(key: key);

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;

  void _loadBannerAd() {
    BannerAd(
      adUnitId: widget.adId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
            widget.height = _bannerAd!.size.height.toDouble();
            // if (widget.scaffoldKey != null) {
            //   widget.scaffoldKey!.currentState!.setState(() {});
            // }
            // widget.isLoading = false;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          // setState(() {
          //   widget.isLoading = false;
          // });
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadBannerAd();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bannerAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd != null) {
      return SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    }
    return const SizedBox(
      height: 50,
    );
  }
}
