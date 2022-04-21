import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tava/services/weather/open_weather_map.dart';
import '../utilities/colors.dart';
import '../utilities/svg_icons.dart';

final WeatherService weatherService = WeatherService();
final weatherResponse = weatherService.getWeatherData();

final nameProvider =
    FutureProvider((ref) async => (await weatherResponse)['name']);
final iconProvider =
    FutureProvider((ref) async => (await weatherResponse)['icon']);
final tempProvider =
    FutureProvider((ref) async => (await weatherResponse)['temp']);

class HomeToday extends ConsumerStatefulWidget {
  const HomeToday({
    Key? key,
  }) : super(key: key);

  @override
  _HomeTodayState createState() => _HomeTodayState();
}

class _HomeTodayState extends ConsumerState<HomeToday> {
  // var weather = WeatherService().getWeatherData();
  @override
  void initState() {
    super.initState();
    final name = ref.read(nameProvider);
    final temp = ref.read(tempProvider);
    final icon = ref.read(iconProvider);
  }

  @override
  Widget build(BuildContext context) {
    final name = ref.watch(nameProvider);
    final temp = ref.watch(tempProvider);
    final icon = ref.watch(iconProvider);

    return Container(
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: backgroundColor,
        border: Border.all(
          width: 2,
          color: cardBackgroundColor,
        ),
      ),
      child: Row(
        children: [
          Text(
            name.toString(),
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SvgPicture.asset(SvgIcons.getIconPath(svgEnum.temperature.index)!)
        ],
      ),
    );
  }

//   void _weather() async {
//     final response = await WeatherService().getWeatherData();
//     print(response.name);
//   }
}
