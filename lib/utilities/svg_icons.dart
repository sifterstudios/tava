enum svgEnum {
  cloudAndSun,
  cloudy,
  nightCloudy,
  rain,
  rainAndLightning,
  nightRainAndLightning,
  rainAndSun,
  nightRain,
  riskOfRain,
  slush,
  nightSlush,
  snow,
  nightSnow,
  sunny,
  nightSunny,
  temperature,
}
const List svgList = [
  'assets/svg/svg_cloud_and_sun.svg',
  'assets/svg/svg_cloudy.svg',
  'assets/svg/svg_rain.svg',
  'assets/svg/svg_cloudy_night.svg',
  'assets/svg/svg_rain_and_lightning.svg',
  'assets/svg/svg_rain_and_lightning_night.svg',
  'assets/svg/svg_rain_and_sun.svg',
  'assets/svg/svg_rain_night.svg',
  'assets/svg/svg_risk_of_rain.svg',
  'assets/svg/svg_slush.svg',
  'assets/svg/svg_slush_night.svg',
  'assets/svg/svg_snow.svg',
  'assets/svg/svg_snow_night.svg',
  'assets/svg/svg_sunny.svg',
  'assets/svg/svg_sunny_night.svg',
  'assets/svg/svg_temp.svg',
];

class SvgIcons {
  static String? getIconPath(int index) {
    return svgList[index];
  }
}
