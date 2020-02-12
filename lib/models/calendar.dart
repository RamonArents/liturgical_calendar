/*
this class is the model for the calendar.
*/
class Calendar {
  //define the columns to use
  final String date;
  final String season;
  final int seasonWeek;
  final String title1;
  final String rank1;
  final String weekday;
  //constructor
  Calendar({this.date, this.season, this.seasonWeek, this.title1, this.rank1, this.weekday});
  //connect the data with the api
  factory Calendar.fromJson(Map<String, dynamic> json) {
    return Calendar(
      date: json['date'],
      season: json['season'],
      seasonWeek: json['season_week'],
      title1: json['celebrations'][0]['title'],
      rank1: json['celebrations'][0]['rank'],
      weekday: json['weekday']
    );
  }
}

