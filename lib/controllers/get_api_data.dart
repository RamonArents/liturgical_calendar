//import required packages
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:liturgical_calendar/models/calendar.dart';
/*
this class fetches the data from the API and connects it to the calendar model
@return Calendar (json object) if the request was successful. Otherwise throw an exception.
*/
Future<Calendar> fetchData() async {
  final response =
      await http.get('http://calapi.inadiutorium.cz/api/v0/en/calendars/default/today');

  if (response.statusCode == 200) {
    return Calendar.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}