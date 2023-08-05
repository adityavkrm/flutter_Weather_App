import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/weather_screen.dart';

class HomeScreen extends StatelessWidget {
  var cityName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Text(
                "WeatherWise",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    fontFamily: GoogleFonts.poppins().fontFamily),
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Icon(
            CupertinoIcons.cloud_sun_fill,
            size: 120,
            color: Colors.white.withOpacity(0.8),
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: TextField(
                controller: cityName,
                decoration: InputDecoration(
                  fillColor: Colors.white.withOpacity(0.13),
                  filled: true,
                  contentPadding: EdgeInsets.all(3),
                  prefixIcon: Icon(CupertinoIcons.search),
                  hintText: "Enter a city name..",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                ),
              )),
          SizedBox(
            height: 20,
          ),
          MaterialButton(
            padding: EdgeInsets.all(10),
            onPressed: () {
              final city = cityName.text;
              if (city.isNotEmpty) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WeatherScreen(cityName: city)));
                cityName.clear();
              }
            },
            color: const Color.fromARGB(255, 17, 97, 163),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Text("Search",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: GoogleFonts.poppins().fontFamily)),
          ),
        ],
      ),
    ));
  }
}
