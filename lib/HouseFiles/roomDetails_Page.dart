import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:intl/intl.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:roomi/user_data/user_profile_data.dart';
import 'package:url_launcher/url_launcher.dart';

class HouseDetail extends StatefulWidget {
  int index;
  HouseDetail({Key key, @required this.index}) : super(key: key);
  @override
  _HouseDetailState createState() => _HouseDetailState(index);
}

class _HouseDetailState extends State<HouseDetail> {
  int index1;
  DocumentSnapshot documentSnapshot;
  _HouseDetailState(this.index1);
  @override
  void initState() {
    UserData().refreshList().then((QuerySnapshot results) {
      setState(() {
        documentSnapshot = results.documents[index1];
      });
    });
    super.initState();
  }

  Text textWidgetForLocation(int index) {
    List<String> listOfLocation = List.from(documentSnapshot.data['Location']);
    String locationstr = "";
    listOfLocation.forEach((element) {
      locationstr = locationstr + " " + element;
    });
    return Text(
      locationstr,
      style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65.0),
          child: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Details',
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xfffbb448), Color(0xffe46b10)])),
            ),
            elevation: 0,
          ),
        ),
        body: documentSnapshot != null
            ? Container(
                child: SingleChildScrollView(child: getCards()),
              )
            : Center(
                child: Container(
                    width: 80,
                    height: 80,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withAlpha(100),
                              offset: Offset(2, 4),
                              blurRadius: 8,
                              spreadRadius: 2)
                        ],
                        color: Colors.white),
                    child: CircularProgressIndicator())),
      ),
    );
  }

  Widget getFirstCard() {
    return Center(
      child: Card(
        elevation: 6,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(0.0),
            child: Container(
              child: Row(
                children: <Widget>[
                  ResponsiveContainer(
                    widthPercent: 67,
                    heightPercent: 10,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: new EdgeInsets.fromLTRB(15, 16, 5, 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${documentSnapshot['Overview']['room']} BHK in ${documentSnapshot['Address'].elementAt(2)}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                          ),
                          Container(
                            padding: new EdgeInsets.fromLTRB(15, 0, 5, 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'At ${documentSnapshot['Address'].elementAt(3)}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ResponsiveContainer(
                    widthPercent: 26,
                    heightPercent: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: new EdgeInsets.fromLTRB(10, 16, 10, 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                documentSnapshot['builtUpArea'].toString(),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.6)),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          Container(
                            padding: new EdgeInsets.fromLTRB(10, 0, 10, 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Sq. ft.',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getSecondCard() {
    return Center(
      child: Card(
        elevation: 6,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(0.0),
            child: Container(
              child: Row(
                children: <Widget>[
                  ResponsiveContainer(
                    widthPercent: 47,
                    heightPercent: 10,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: new EdgeInsets.fromLTRB(15, 16, 5, 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.rupeeSign,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                  Text(
                                    "${documentSnapshot.data["depositAmount"]}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: new EdgeInsets.fromLTRB(15, 0, 5, 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Security Deposit',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ResponsiveContainer(
                    widthPercent: 47,
                    heightPercent: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            //                   <--- left side
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: new EdgeInsets.fromLTRB(10, 16, 10, 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.rupeeSign,
                                    color: Colors.black.withOpacity(0.6),
                                  ),
                                  Text(
                                    "${documentSnapshot.data["monthlyRent"]}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black.withOpacity(0.6)),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: new EdgeInsets.fromLTRB(10, 0, 10, 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Rent per month',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getThirdCard() {
    return Center(
      child: Card(
        elevation: 6,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(0.0),
            child: Container(
              child: Row(
                children: <Widget>[
                  ResponsiveContainer(
                    widthPercent: 47,
                    heightPercent: 10,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: new EdgeInsets.fromLTRB(15, 16, 5, 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${documentSnapshot.data["Overview"]["furnishingStatus"]}', //'Fully Furnished',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                          ),
                          Container(
                            padding: new EdgeInsets.fromLTRB(15, 0, 5, 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Furnishing Status',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black.withOpacity(0.5)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ResponsiveContainer(
                    widthPercent: 47,
                    heightPercent: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            //                   <--- left side
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: new EdgeInsets.fromLTRB(10, 16, 10, 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${documentSnapshot.data["Overview"]["preferedType"]}',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.6)),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          Container(
                            padding: new EdgeInsets.fromLTRB(10, 0, 10, 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Prefered Tanents',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black.withOpacity(0.5)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getFourthCard() {
    return Center(
      child: Card(
        elevation: 6,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(0.0),
            child: Container(
                padding: new EdgeInsets.fromLTRB(10, 16, 10, 16),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              //                   <--- left side
                              width: 3.0,
                            ),
                          ),
                        ),
                        child: Text(
                          'OVERVIEW',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                ResponsiveContainer(
                                  widthPercent: 44,
                                  heightPercent: 7,
                                  child: Container(
                                    padding: new EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                        left: BorderSide(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                        right: BorderSide(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(FontAwesomeIcons.bed,
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        documentSnapshot.data['Overview']
                                                    ['propertyType'] ==
                                                "Room"
                                            ? Text(
                                                '${documentSnapshot.data['Overview']['room']} Beds',
                                                style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  fontSize: 20,
                                                ),
                                              )
                                            : Text(
                                                '${documentSnapshot.data['Overview']['room']} Bedrooms',
                                                style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  fontSize: 18,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                ResponsiveContainer(
                                  widthPercent: 44,
                                  heightPercent: 7,
                                  child: Container(
                                    padding: new EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                        left: BorderSide(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                        right: BorderSide(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(FontAwesomeIcons.home,
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          //'Apartment',
                                          '${documentSnapshot.data['Overview']['propertyType']}',
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ResponsiveContainer(
                                  widthPercent: 44,
                                  heightPercent: 7,
                                  child: Container(
                                    padding: new EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                        left: BorderSide(
                                          color: Colors.grey,
                                          width: 1.5,
                                        ),
                                        right: BorderSide(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                        bottom: BorderSide(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(FontAwesomeIcons.users,
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          //'Apartment',
                                          "${documentSnapshot.data["Members"]} Member",
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                ResponsiveContainer(
                                  widthPercent: 43,
                                  heightPercent: 7,
                                  child: Container(
                                    padding: new EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                        right: BorderSide(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(FontAwesomeIcons.toilet,
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${documentSnapshot.data['Overview']['bathroom']} Bathroom',
                                            style: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ResponsiveContainer(
                                  widthPercent: 43,
                                  heightPercent: 7,
                                  child: Container(
                                    padding: new EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                        right: BorderSide(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(FontAwesomeIcons.calendarAlt,
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          DateFormat('dd/MM/yyyy')
                                              .format((documentSnapshot[
                                                          'Date Updated']
                                                      as Timestamp)
                                                  .toDate())
                                              .toString(),
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ResponsiveContainer(
                                  widthPercent: 43,
                                  heightPercent: 7,
                                  child: Container(
                                    padding: new EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        top: BorderSide(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                        right: BorderSide(
                                          color: Colors.grey,
                                          width: 2,
                                        ),
                                        bottom: BorderSide(
                                          color: Colors.grey,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: <Widget>[
                                        Icon(FontAwesomeIcons.key,
                                            color:
                                                Colors.black.withOpacity(0.6)),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${documentSnapshot.data["status"]}',
                                          style: TextStyle(
                                            color:
                                                Colors.black.withOpacity(0.6),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget getFifthCard() {
    return Center(
      child: Card(
        elevation: 6,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(0.0),
            child: Container(
                padding: new EdgeInsets.fromLTRB(15, 16, 15, 16),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              //                   <--- left side
                              color: Colors.blue[500].withOpacity(0.6),
                              width: 3.0,
                            ),
                          ),
                        ),
                        child: Text('FACILITIES',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black.withOpacity(0.7),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Wrap(
                      children: <Widget>[
                        for (var i in documentSnapshot['Facilities'])
                          getFacility(i)
                      ],
                    )

                    // Body Here
                  ],
                )),
          ),
        ),
      ),
    );
  }

  // ignore: missing_return
  Widget getFacility(var fac) {
    switch (fac) {
      case 'Fire Safety':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffE6B15C), Color(0xffFFF84E)])),
              child: Image.asset(
                'assets/icons/fire-extinguisher.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'Air Conditioner':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffFFB849), Color(0xffD20B54)])),
              child: Image.asset(
                'assets/icons/ac.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'Washing Machine':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff76BAFF), Color(0xff4EFFF8)])),
              child: Image.asset(
                'assets/icons/washing-machine.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'Car Parking':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff3A40EE), Color(0xffF747AB)])),
              child: Image.asset(
                'assets/icons/parking.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'Wi-Fi':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffff74a4), Color(0xffCA54D4)])),
              child: Image.asset(
                'assets/icons/wifi-signal.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'Tiffin Facility':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffff74a4), Color(0xffCA54D4)])),
              child: Image.asset(
                'assets/icons/restaurant.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case '24x7 Water Supply':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffE6B15C), Color(0xffFFF84E)])),
              child: Image.asset(
                'assets/icons/water.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'Garden':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff2BFBED), Color(0xffD9E021)])),
              child: Image.asset(
                'assets/icons/garden.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'Lift':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffFBBF36), Color(0xffF88D44)])),
              child: Image.asset(
                'assets/icons/lift.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case '24x7 CCTV':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffC8E234), Color(0xff6AEB34)])),
              child: Image.asset(
                'assets/icons/cctv.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'Swimming Pool':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff77A5F8), Color(0xffD5A3FF)])),
              child: Image.asset(
                'assets/icons/swimming-pool.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'Security':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffB26FEC), Color(0xff22E6B9)])),
              child: Image.asset(
                'assets/icons/watchman.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'Children Park':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffB4FF4E), Color(0xff2FC145)])),
              child: Image.asset(
                'assets/icons/children-playarea.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'Gym':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffFCCF31), Color(0xffF55555)])),
              child: Image.asset(
                'assets/icons/dumbbell.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
      case 'HouseKeeping':
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff60FF04), Color(0xff23EDED)])),
              child: Image.asset(
                'assets/icons/house-keeping.png',
                width: 45,
              ),
            ),
          ),
        );
        break;
    }
  }

  // ignore: missing_return

  Widget getSixthCard() {
    return Center(
      child: Card(
        elevation: 6,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(0.0),
            child: Container(
                padding: new EdgeInsets.fromLTRB(15, 16, 15, 16),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              //                   <--- left side
                              color: Colors.blue[500].withOpacity(0.6),
                              width: 3.0,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text('PICTURES BY OWNER',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black.withOpacity(0.7),
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 150,
                      child: Carousel(
                        overlayShadow: true,
                        dotHorizontalPadding: 10,
                        boxFit: BoxFit.cover,
                        images: [
                          FullScreenWidget(
                            backgroundIsTransparent: true,
                            child: Image.network(
                              documentSnapshot.data['houseImages'][0]
                                  .toString(),
                              fit: BoxFit.contain,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                          FullScreenWidget(
                            backgroundIsTransparent: true,
                            child: Image.network(
                              documentSnapshot.data['houseImages'][1]
                                  .toString(),
                              fit: BoxFit.contain,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                          FullScreenWidget(
                            backgroundIsTransparent: true,
                            child: Image.network(
                              documentSnapshot.data['houseImages'][2]
                                  .toString(),
                              fit: BoxFit.contain,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                          FullScreenWidget(
                            backgroundIsTransparent: true,
                            child: Image.network(
                              documentSnapshot.data['houseImages'][2]
                                  .toString(),
                              fit: BoxFit.contain,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        autoplay: false,
                        animationCurve: Curves.fastOutSlowIn,
                        animationDuration: Duration(milliseconds: 1000),
                        dotSize: 4.0,
                        indicatorBgPadding: 2.0,
                        dotBgColor: Colors.transparent,
                      ),
                    ),

                    // Body Here
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget getSeventhCard() {
    return Center(
      child: Card(
        elevation: 6,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(0.0),
            child: Container(
                padding: new EdgeInsets.fromLTRB(15, 16, 15, 16),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              //                   <--- left side
                              color: Colors.blue[500].withOpacity(0.6),
                              width: 3.0,
                            ),
                          ),
                        ),
                        child: Text('ADDRESS',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black.withOpacity(0.7),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        documentSnapshot['Address'].elementAt(3) + ',',
                        style: TextStyle(
                          fontFamily: 'Ex02',
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        documentSnapshot['Address'].elementAt(2) + ',',
                        style: TextStyle(
                          fontFamily: 'Ex02',
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        documentSnapshot['Address'].elementAt(1) + ',',
                        style: TextStyle(
                          fontFamily: 'Ex02',
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 18,
                        ),
                      ),
                    ),

                    // Body Here
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget getEightCard() {
    return Center(
      child: Card(
        elevation: 6,
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          child: ClipRRect(
            borderRadius: new BorderRadius.circular(0.0),
            child: Container(
                padding: new EdgeInsets.fromLTRB(10, 16, 10, 16),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: new EdgeInsets.fromLTRB(0, 0, 0, 3),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              //                   <--- left side
                              color: Colors.blue[500].withOpacity(0.6),
                              width: 3.0,
                            ),
                          ),
                        ),
                        child: Text(
                          'OWNER\'S DETAIL',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    getUserCard(context),
                    // Body Here
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Widget getUserCard(var context) {
    var size = Screen(MediaQuery.of(context).size);
    return Card(
      elevation: 0,
      borderOnForeground: true,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          //Fluttertoast.showToast(msg: "Card Tapped ${docsSnap['firstName']} ${docsSnap['lastName']}" );
        },
        child: Container(
          width: size.wp(100),
          height: size.hp(15),
          child: Row(
            children: <Widget>[
              Container(
                width: size.hp(17),
                color: Colors.grey,
                child: Image.asset('assets/icons/avatar.png'),
              ),
              Container(
                width: size.wp(84) - size.hp(16),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: size.getWidthPx(0),
                      horizontal: size.getWidthPx(10)),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${documentSnapshot.data["OwnerName"]}",
                          style: TextStyle(
                              fontFamily: 'Ex02',
                              fontSize: size.getWidthPx(20),
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.5)),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.mapMarkerAlt,
                            size: size.getWidthPx(16),
                            color: Colors.grey,
                          ),
                          Text("${documentSnapshot.data["OwnerCity"]}",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: size.getWidthPx(16))),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: TextButton(
                          onPressed: () => launch(
                              "tel://${documentSnapshot.data["OwnerPhone"]}"),
                          child: Row(
                            children: [
                              Icon(
                                Icons.phone_forwarded_rounded,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text("${documentSnapshot.data["OwnerPhone"]}",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue,
                                      fontSize: size.getWidthPx(20))),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getCards() {
    return Container(
      padding: new EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Column(
        children: <Widget>[
          CarouselWithIndicator(documentSnapshot),

          documentSnapshot.data["Overview"]["propertyType"] != "Room"
              ? getFirstCard()
              : SizedBox(),

          getSecondCard(),

          getThirdCard(),

          getFourthCard(),

          getSeventhCard(),

          getFifthCard(),

          getEightCard(),
          // Tenth Card
        ],
      ),
    );
  }
}

class Screen {
  Size screenSize;

  // ignore: unused_element
  Screen._internal();
  Screen(this.screenSize);

  double wp(percentage) {
    return percentage / 100 * screenSize.width;
  }

  double hp(percentage) {
    return percentage / 100 * screenSize.height;
  }

  double getWidthPx(int pixels) {
    return (pixels / 3.61) / 100 * screenSize.width;
  }
}

class CarouselWithIndicator extends StatefulWidget {
  final DocumentSnapshot snapshot;
  @override
  _CarouselWithIndicatorState createState() =>
      _CarouselWithIndicatorState(snapshot);
  CarouselWithIndicator(this.snapshot);
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  final DocumentSnapshot snapshot;
  _CarouselWithIndicatorState(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
      child: Swiper(
        autoplay: false,
        itemBuilder: (BuildContext context, int index) {
          return FullScreenWidget(
            backgroundIsTransparent: true,
            child: Image.network(
              snapshot.data['houseImages'][index].toString(),
              fit: BoxFit.contain,
            ),
          );
        },
        itemCount: snapshot['houseImages'].length,
        viewportFraction: 1,
        scale: 1,
        pagination: SwiperPagination(),
      ),
    );
  }
}
