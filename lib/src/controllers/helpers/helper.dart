class Helper {
  static dynamic convertSecondsToMinutes(
      {required int durationInSeconds, bool settings = false}) {
    if (settings) {
      return durationInSeconds ~/ 60;
    } else {
      String minutes = (durationInSeconds ~/ 60).toString().padLeft(2, '0');
      String seconds = (durationInSeconds % 60).toString().padLeft(2, '0');

      return '$minutes:$seconds';
    }
  }

  static int convertMinutesToSeconds(
      {required int durationInMinutes, bool settings = false}) {
    return durationInMinutes * 60;
  }

  static Map<String, int>  convertTaskTime({required int seconds}) {
    int hours = seconds ~/ 3600; // 3600 segundos em 1 hora
    int minutes = (seconds % 3600) ~/ 60;

    final convertedTime = {
      'hour': hours,
      'minutes': minutes,
      'seconds': seconds,
    };

    return convertedTime;
  }
}
