import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;




import '../util/utils.dart' as util;


import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() =>  _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {

  String _cityEntered;



  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator
        .of(context)
        .push(MaterialPageRoute<Map>(builder: (BuildContext context) { //change to Map instead of dynamic for this to work
      return ChangeCity();
    }));

    if ( results != null && results.containsKey('enter')) {
      setState(() {
        _cityEntered = results['enter'];
        debugPrint(_cityEntered);

      });

//      debugPrint("From First screen" + results['enter'].toString());
    }
  }


  void showStuff() async {
    Map data = await getWeather(util.appId, util.defaultCity);
    debugPrint(data.toString());
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Text('Check Climate',style: TextStyle(fontSize:25,fontWeight: FontWeight.bold,color:Colors.white)),
            Text(' of any City',style: TextStyle(fontSize:20,fontWeight: FontWeight.normal,color:Colors.white,fontStyle: FontStyle.italic)),

          ],
        ),

        backgroundColor: Colors.redAccent,
        actions: <Widget>[
           IconButton(
              icon:  FaIcon(FontAwesomeIcons.arrowCircleDown),
              color: Colors.white,
              onPressed: () {
                _goToNextScreen(context);
              })
        ],
      ),
      body:  Stack(
        children: <Widget>[
           Center(
            child:  Image.asset(
              'images/umbrella.png',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  children:<Widget>[
                    Flexible(
                      flex: 0,
                      child: Container(
                        alignment: Alignment.topRight,
                        margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
                        child:  Text(
                          '${_cityEntered == null ? util.defaultCity : _cityEntered}',
                          style: cityStyle(),
                        ),
                      ),
                    ),
                    // SizedBox(height: 50,),
                    Flexible(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.topCenter,
                        child:  Image.asset('images/light_rain.png'),
                      ),
                    ),
                    // SizedBox(height: 2,),

                    Flexible(
                      flex: 4,
                        child: Container(
                          alignment: Alignment.center,
                            child: updateTempWidget(_cityEntered)),
                    ),
                    SizedBox(height: 60,),

                    Flexible(
                      flex: 1,
                          child: TextLiquidFill(
                            text: '- Bilal Jh (Flutter Developer)',
                            waveColor: Colors.blue,
                            waveDuration: Duration(milliseconds:700),
                            loadDuration: Duration(seconds:20),
                            //boxBackgroundColor: Colors.grey,
                            textStyle: TextStyle(fontSize:23, fontWeight: FontWeight.bold),
                            boxHeight: 40,
                      ),
                    ),
                    Flexible(
                      flex: 0,
                      child: Align(
                        alignment: Alignment.bottomLeft,

                        child:   TyperAnimatedTextKit(
                          onTap: () {
                            print("Tap Event");
                          },
                          text: [
                            "See other Flutter Examples on:",
                            "Github,",
                            "Youtube",
                            "- Bilal Jh (Flutter Developer)",
                          ],
                          textStyle: TextStyle(fontSize: 20.0, fontFamily: "Bobbers",color:Colors.white),


                          pause: Duration(seconds:  3),
                          // speed: Duration(milliseconds:  1000),
                        ),
                      ),
                    )]

                ),
              )


            ],
          ),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.github),
            title: Text('Github',style: oneStyle,),
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.youtube),
            title: Text('Youtube',style: oneStyle,),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
        backgroundColor: Colors.red,
      ),
    );

  }
  Future<Map> getWeather(String appId, String city) async {
    String apiUrl = 'http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.appId}';
    http.Response response = await http.get(apiUrl);
    debugPrint(response.toString());
    if(response.toString()==null){
      debugPrint("No data");
    }
    else{
      debugPrint(response.toString());
    }

    return json.decode(response.body);
  }
  Widget updateTempWidget(String city) {
    return new FutureBuilder(
        future: getWeather(util.appId, city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          //where we get all of the json data, we setup widgets etc.
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return Container(
              margin: EdgeInsets.fromLTRB(0.0, 12, 44, 0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new ListTile(
                    title: new Text(
                      content['main']['temp'].toString() +" F",
                      style: new TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 49.9,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: new ListTile(
                      title: new Text(
                        "Humidity: ${content['main']['humidity'].toString()}\n"
                            "Min: ${content['main']['temp_min'].toString()} F\n"
                            "Max: ${content['main']['temp_max'].toString()} F ",

                        style: extraData(),

                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return new Container();
          }
        });
  }

  //Code for BottomNavigation Purpose
  static const TextStyle oneStyle =
  TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white);
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      if(index==0){
        launch('https://github.com/bilalsaeedjh');
        _selectedIndex = index;
      }
      if(index==1){
        launch('https://www.youtube.com/channel/UCZSgQGG74K2yuEDnbG4U1tQ?view_as=subscriber');
        _selectedIndex = index;
      }

    });

  }
  //NavigationBar work ends here







}

class ChangeCity extends StatelessWidget {

  var _cityFieldController =  TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.red,
        title:  Text('Type name of City'),
        centerTitle: true,
      ),
      body:  Stack(
        children: <Widget>[
          Center(
            child:  Image.asset(
              'images/beauti_fog.jpg',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),

          ListView(
            children: <Widget>[
              ListTile(
                title:  TextField(
                  decoration:  InputDecoration(
                    hintText: 'Enter City',
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),

              ),
              ListTile(
                  title:  RaisedButton(
                      onPressed: () {

                        Navigator.pop(context, {
                          'enter': _cityFieldController.text
                        });
                      },

                      textColor: Colors.white70,
                      color: Colors.redAccent,
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: FaIcon(FontAwesomeIcons.walking),
                          ),
                          Text(
                            "Check Weather",style: tempStyle1(),
                          )
                        ],
                      )
                  )
              )
            ],

          )
        ],
      ),
    );
  }
}


TextStyle tempStyle1() {
  return TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: 19
  );
}
TextStyle cityStyle() {
  return  TextStyle(
      color: Colors.black54, fontSize: 30, fontStyle: FontStyle.italic,fontWeight: FontWeight.bold);
}
TextStyle extraData() {
  return  TextStyle(
      color: Colors.white70,
      fontStyle: FontStyle.normal,
      fontSize: 20.0);

}
TextStyle tempStyle() {
  return  TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: 50
  );
}
