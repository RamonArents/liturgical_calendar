// warning!!!: do not rename this file
// import required packages
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:liturgical_calendar/controllers/get_api_data.dart';
import 'package:liturgical_calendar/models/calendar.dart';

// run app with data from api
void main() => runApp(CalendarApp(data:fetchData()));
/*
this is the main class of the App. This runs the LiturgicalCalendar() class
*/
class CalendarApp extends StatelessWidget {
  //initalize variables
  final Future<Calendar> data;
  //constructor
  CalendarApp({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //use only portrait orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      //set title, color, fontfamily and return the home screen
      title: 'Liturgical Calendar',
      theme: ThemeData(primarySwatch: Colors.brown, fontFamily: 'Aladin'),
      debugShowCheckedModeBanner: false,
      home: LiturgicalCalendar(),
    );
  }
}
/*
this class displays the view with the api data. Modifications to the view should be made here
*/
class LiturgicalCalendar extends StatefulWidget {
  @override
  _LiturgicalCalendarState createState() => _LiturgicalCalendarState();
}
// extend the stateful class
class _LiturgicalCalendarState extends State<LiturgicalCalendar> {
  //initialize variables
  Future<Calendar> data;

  @override
  void initState() {
    //to get the data, we must fetch it first
    super.initState();
    data = fetchData();
  }
  /**
   * Selects the right images for the day
   * @param String date, String title
   * @return String image path
   */
  String selectImage(String date, String title){
    if(title == 'Ash Wednesday'){
      return 'images/ashwednesday.jpg';
    }else{
      if(date.endsWith('01-17')){
        return 'images/saintanthony.png';
      }else if(date.endsWith('01-21')){
        return 'images/saintagnes.jpg';
      }
      else if(date.endsWith('01-24')){
        return 'images/franciscusvansales.jpg';
      }
      else if(date.endsWith('01-25')){
        return 'images/conversionstpaul.jpg';
      }else if(date.endsWith('01-28')){
        return 'images/thomasaquino.jpg';
      }
      else if(date.endsWith('01-31')){
        return 'images/johnbosco.jpg';
      }
      else if(date.endsWith('02-02')){
        return 'images/presentation.jpg';
      }
      else if(date.endsWith('02-05')){
        return 'images/saintagatha.jpg';
      }
      else if(date.endsWith('02-06')){
        return 'images/saintspaulmikicompanions.jpg';
      }
      else if(date.endsWith('02-10')){
        return 'images/saintscholastica.jpg';
      }
      else if(date.endsWith('02-14')){
        return 'images/saintcyrillus.jpg';
      }
      else if(date.endsWith('02-22')){
        return 'images/stpeterchair.jpg';
      }
      else{
        return 'images/default.jpeg';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //appbar title
        title: Text('Liturgical Calendar'),
      ),
      //backgroundcolor of this page
      backgroundColor: Colors.lightBlueAccent,
      // the actual content
      body: Center(
        child: FutureBuilder<Calendar>(
          future: data,
          builder: (context, snapshot) {
            //default textStyle
            TextStyle textStyle = TextStyle(fontSize: 18.0, color: Colors.white);
            if (snapshot.hasData) {
              //data from API
              var date = snapshot.data.date;
              var season = snapshot.data.season;
              var seasonWeek = snapshot.data.seasonWeek.toString();
              var title = snapshot.data.title1;
              var rank = snapshot.data.rank1;
              var weekDay = snapshot.data.weekday;
              // change beforetitle of title (display saint(s) if there are saints for that day, else display just the liturgical day)
              var beforetitle = '';
              if (title.startsWith('Saint')) {
                beforetitle = 'Saint(s):';
              } else {
                beforetitle = 'Liturgical day:';
              }
              // Column with the data to display
              return Column(
                children: <Widget>[
                  //use SizedBox to create space between the elements
                  SizedBox(
                    height: 10.0,
                  ),
                  //display the date
                  Text('Date: $date',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          color: Colors.white)),
                  SizedBox(
                    height: 20.0,
                  ),
                  //display the image (images should be saved in the images folder and defined in pubspec.yaml)
                  Image.asset(
                    selectImage(date, title),
                    height: 350,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  //display the other data
                  Text(
                    'Season: $season',
                    style: textStyle,
                  ),
                  Text(
                    'Seasonweek: $seasonWeek',
                    style: textStyle,
                  ),
                  Text(
                    '$beforetitle $title',
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Rank: $rank',
                    style: textStyle,
                  ),
                  Text(
                    'Weekday: $weekDay',
                    style: textStyle,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              //display this if the content cannot be displayed
              return Container(
                margin: EdgeInsets.only(top:200.0),
                child: Column(
                  children: <Widget>[
                    //show message to user that displays what is wrong
                    Text(
                      "We were unable to get the data because either you have no internet connection at the moment or the liturgical website is down.",
                      style: textStyle,
                      textAlign: TextAlign.center,
                    ),
                    //refresh button to refresh if the problem is fixed
                    RaisedButton(
                        child: Text('Refresh'),
                        textColor: Colors.white,
                        color: Colors.brown,
                        onPressed: () => {
                              //if the problem is fixed, display the data again
                              setState(() {
                                data = fetchData();
                              })
                            }),
                  ],
                ),
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
