import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class WorldTime {
  late String location; //location name for ui
  late String time; //location time
  late String flag; //url to asset flag icon
  late String url;  //location url for api endpoint
  late bool isDayTime = false;

  WorldTime(
      {required this.location,
      required this.flag,
      required this.url});

  Future<void> getTime() async {
    try {
      var ur =
          Uri.http('worldtimeapi.org', '/api/timezone/$url', {'q': '{http}'});

      // Await the http get response, then decode the json-formatted response.
      var response = await http.get(ur);
      if (response.statusCode == 200) {
        var jsonResponse =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        var datetime = jsonResponse['datetime'];
        String offset = jsonResponse['utc_offset'].substring(1, 3);
        //print('datetime : $datetime.');
        //print('offset : $offset');
        DateTime now = DateTime.parse(datetime);
        now = now.add(Duration(hours: int.parse(offset)));
        //print(now);
        //time = now.toString();
        isDayTime = now.hour > 6 && now.hour < 20 ? true : false;
        time = DateFormat.jm().format(now);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('caught error: $e');
      time = 'could not get time data';
    }
  }
}
