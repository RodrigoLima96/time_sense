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
}
