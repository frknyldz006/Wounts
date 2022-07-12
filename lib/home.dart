import 'package:about/about.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wounts/constants.dart';
import 'package:wounts/tracked_datas.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double waterHeight = 350;
  double addedWater = 0;
  var selectedWater = 1.0;
  double tankVolume = 5;
  List dropdownItemList = [
    {'label': '0.5 liter', 'value': 0.5},
    {'label': '1 liter', 'value': 1.0},
    {'label': '1.5 liter', 'value': 1.5},
    {'label': '2 liter', 'value': 2.0},
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: darkBlue,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        showAboutPage(
                          context: context,
                          values: {
                            'version': '1.0',
                            'year': "11.07.2022",
                          },
                          applicationLegalese:
                              'Copyright © Furkan Yıldız, {{ 2022 }}',
                          applicationDescription: const Text(
                              'You can easily track your have drunk water amount via Wounts'),
                          applicationIcon: const SizedBox(
                            width: 100,
                            height: 100,
                            child: Image(
                              image: AssetImage('assets/images/logo.png'),
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.settings,
                        color: white,
                      )),
                  Text(
                    "Wounts",
                    style: TextStyle(
                        color: white, fontSize: 36, fontFamily: "metal"),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrackedDatas(),
                            ));
                      },
                      icon: Icon(
                        Icons.receipt_long,
                        color: white,
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  bottom: 0,
                  child: Container(
                    height:
                        ((553 / 100) * (addedWater / tankVolume * 100)) > 565
                            ? 565
                            : (553 / 100) * (addedWater / tankVolume * 100),
                    width: 300,
                    decoration: BoxDecoration(
                        color: blue,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.zero,
                            topRight: Radius.zero,
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30))),
                  ),
                ),
                Positioned(
                  top: 200,
                  left: 125,
                  child: Text(
                    "Tank\n${tankVolume}lt",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: white.withOpacity(0.5), fontSize: 24),
                  ),
                ),
                Container(
                  height: 575 - 10,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.zero,
                          topRight: Radius.zero,
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      border: Border.all(color: white, width: 12),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 0,
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 0))
                      ]),
                ),
                Positioned(
                  left: 25,
                  top: 35,
                  child: Container(
                    height: 505,
                    width: 10,
                    decoration: BoxDecoration(
                        color: white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 0,
                              color: Colors.white.withOpacity(0.2),
                              offset: Offset(5, 0))
                        ]),
                  ),
                ),
                addedWater < 0.5
                    ? SizedBox()
                    : Positioned(
                        right: 20,
                        bottom: ((553 / 100) *
                                    (addedWater / tankVolume * 100)) >
                                531
                            ? 531
                            : (553 / 100) * (addedWater / tankVolume * 100) -
                                22,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: 5,
                              left: 33,
                              child: Container(
                                height: 20,
                                width: 20,
                                color: gray,
                                transform: Matrix4.rotationZ(130 / 180),
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: gray,
                              child: Text(
                                "%${(addedWater / tankVolume * 100).floorToDouble().toDouble()}",
                                style: TextStyle(color: white, fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      )
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            FutureBuilder(
                future: Hive.openBox('tracklist'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final _tracklist = Hive.box("tracklist");
                    String today =
                        formatDate(DateTime.now(), [dd, '-', mm, '-', yyyy]);
                    return Stack(
                      clipBehavior: Clip.none,
                      alignment: AlignmentDirectional.center,
                      children: [
                        Container(
                          height: 50,
                          width: 300,
                          decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 85.0),
                            child: CoolDropdown(
                              dropdownList: dropdownItemList,
                              onChange: (val) {
                                setState(() {
                                  selectedWater = val["value"];
                                });
                              },
                              defaultValue: dropdownItemList[1],
                              resultWidth: 300,
                              resultPadding: EdgeInsets.only(left: 12),
                              dropdownHeight: 200,
                              resultIcon: Icon(
                                Icons.keyboard_arrow_up,
                                color: darkBlue,
                              ),
                              resultReverse: true,
                              gap: 15,
                              isTriangle: false,
                              dropdownBD: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(10)),
                              selectedItemTS:
                                  TextStyle(color: darkBlue, fontSize: 20),
                              selectedItemBD: BoxDecoration(
                                  color: darkBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10)),
                              resultBD: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.circular(30)),
                              resultTS:
                                  TextStyle(color: darkBlue, fontSize: 20),
                              resultAlign: Alignment.center,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(70),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 6,
                                      spreadRadius: 0,
                                      color: Colors.black.withOpacity(0.16),
                                      offset: const Offset(0, 0))
                                ]),
                            child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    addedWater = selectedWater + addedWater;
                                  });
                                  Future<void> _createItem(
                                      Map<String, dynamic> newItem) async {
                                    await _tracklist
                                        .add(newItem); // update the UI
                                  }

                                  _createItem({
                                    "amount": "${(selectedWater)} liter",
                                    "date": today
                                  });
                                },
                                child: Icon(
                                  Icons.add,
                                  color: darkBlue,
                                )),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(70),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 6,
                                      spreadRadius: 0,
                                      color: Colors.black.withOpacity(0.16),
                                      offset: const Offset(0, 0))
                                ]),
                            child: TextButton(
                                onPressed: () {
                                  if (selectedWater <= addedWater) {
                                    setState(() {
                                      addedWater = addedWater - selectedWater;
                                    });
                                  }
                                },
                                child: Text(
                                  "—",
                                  style:
                                      TextStyle(color: darkBlue, fontSize: 24),
                                )),
                          ),
                        )
                      ],
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: white,
                    ),
                  );
                }),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Text(
                "2022 © Furkan Yıldız",
                style: TextStyle(color: white.withOpacity(0.5), fontSize: 14),
              ),
            )
          ],
        ),
      ),
    );
  }
}
