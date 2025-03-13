import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';

class HomeCarousel extends StatefulWidget {
  const HomeCarousel({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeCarousel();
  }
}

class _HomeCarousel extends State<HomeCarousel> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CarouselSlider(
        items: carouselItem,
        options: CarouselOptions(
          height: 400,
          aspectRatio: 16 / 9,
          viewportFraction: 0.8,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          enlargeFactor: 0.3,
          scrollDirection: Axis.horizontal,
        ));
  }
}

    List<Widget> carouselItem = [
      Image.asset(
        'assets/images/infographics1.jpg',
        height: 400,
        width: double.infinity,
        fit: BoxFit.fill,
      ),Image.asset(
        'assets/images/infographics2.jpg',
        height: 400,
        width: double.infinity,
        fit: BoxFit.fill,
      ),Image.asset(
        'assets/images/infographics3.jpg',
        height: 400,
        width: double.infinity,
        fit: BoxFit.fill,
      ),Image.asset(
        'assets/images/infographics4.jpg',
        height: 400,
        width: double.infinity,
        fit: BoxFit.fill,
      )
    ];