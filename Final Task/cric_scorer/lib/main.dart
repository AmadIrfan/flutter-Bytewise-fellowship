import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cric_scorer/Scoring%20Page/scoring_page.dart';
import 'package:cric_scorer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:cric_scorer/login_singup/splash_screen.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.testMode = true;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        // primaryColor: Colors.teal,
        // primarySwatch
      ),
      home: SplashScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var currentuseremail = '';
  // var args = Get.arguments;
  var currentuserid = '';

  var currentusername = '';
  String downloadURL = '';
  final DateFormat formatter = DateFormat('MMM dd, yyyy, h:m:s a');
  // final String formatted = formatter.format(now);
  bool isloggedin = false;

  final DateTime now = DateTime.now();

  final ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    FirebaseAuth.instance.authStateChanges().listen(
      (User? user) {
        if (user == null) {
          setState(() {
            isloggedin = false;
            // Get.defaultDialog(
            //   actions: [
            //     Text('user not logged in')
            //   ],
            // );
          });
        } else {
          setState(
            () {
              isloggedin = true;
              currentuserid = user.uid;
              currentuseremail = user.email!;
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentuserid)
                  .get()
                  .then((DocumentSnapshot docsnapshot) {
                if (docsnapshot.exists) {
                  setState(() {
                    currentusername = docsnapshot['full_name'];
                  });
                } else {
                  setState(() {
                    currentusername = '';
                  });
                }
              });
              downloadURLfunc(currentuserid);

              // Get.defaultDialog(
              //   actions: [
              //     Text('user logged in')
              //   ],
              // );
            },
          );
        }
      },
    );
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    // setState(() {
    //   _connectionStatus = result;
    // });
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      // _snackbar('You Connection restored');
      Get.rawSnackbar(
        margin: EdgeInsets.all(15.0),
        // title: 'You Connection restored.',
        // message: 'You Connection restored',
        messageText: Text(
          "You are online now",
          style: TextStyle(
              color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w400),
        ),
        isDismissible: false,
        backgroundColor: Colors.teal,
        borderRadius: 20.0,
        //  borderWidth: 15.0,
        icon: Icon(
          Icons.wifi_sharp,
          color: Colors.white,
          size: 25.0,
        ),
        duration: Duration(seconds: 4),
      );

      // return true;
    } else {
      // _snackbar('You are currently offline');
      Get.rawSnackbar(
        // title: 'You are currently offline',
        // message: 'You are currently offline',
        messageText: Text(
          'You are currently offline',
          style: TextStyle(
              color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.w400),
        ),
        isDismissible: false,
        borderRadius: 25.0,
        margin: EdgeInsets.all(15.0),
        backgroundColor: Colors.teal,
        icon: Icon(
          Icons.wifi_off_sharp,
          color: Colors.white,
          size: 25.0,
        ),
        duration: Duration(seconds: 4),
      );
      // return false;

      //   showDialog(context: context, builder: (context){
      //    return WillPopScope(child: customAlert(), onWillPop: () async => false);
      //  });
    }
  }

  Future<void> downloadURLfunc(cuserid) async {
    String imgurl = await firebase_storage.FirebaseStorage.instance
        .ref('images/profile_pictures/$cuserid.png')
        .getDownloadURL();
    setState(() {
      downloadURL = imgurl;
    });
  }

  Widget customdrawertile(_title, _leading, onpressed) {
    return ListTile(
      onTap: onpressed,
      title: Text(_title),
      leading: Icon(
        _leading,
        size: 25.0,
        color: Colors.teal,
      ),
    );
  }

  Future<void> logout_func() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('you want to logout?'),
        actions: <Widget>[
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          MaterialButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              setState(() {
                isloggedin = false;
              });
              Navigator.pop(context);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to exit the App'),
            actions: <Widget>[
              MaterialButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              MaterialButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          // toolbarHeight: 70.0,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            'Live Matches',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        drawer: MyDrawer(
            isloggedin,
            isloggedin ? currentusername : '', //username
            isloggedin ? currentuseremail : '', //email
            isloggedin
                ? downloadURL
                : 'https://banner2.cleanpng.com/20180702/juw/kisspng-australia-national-cricket-team-bowling-cricket-5b39ce04df1a32.1401674715305149489138.jpg',
            logout_func),
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('livematches')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              var data = snapshot.data?.docs;
              if (snapshot.hasError) {
                return Center(
                  child: Text('Something Went Wrong'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.teal,
                  ),
                );
              }
              if (data!.length == 0) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.hourglass_empty,
                        size: 50.0,
                        color: Colors.black87.withOpacity(0.8),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'No Live Match Available',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    return StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('matches')
                          .doc(ds['user_id'])
                          .collection('mymatches')
                          .doc(ds['match_id'])
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        var data = snapshot.data;
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Something Went Wrong'),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              // child: CircularProgressIndicator(
                              // color: Colors.teal,
                              // ),
                              );
                        } else {
                          return GestureDetector(
                            onTap: () async {
                              var inning_no;
                              var ismatchended;
                              await FirebaseFirestore.instance
                                  .collection('scoring')
                                  .doc(ds['user_id'])
                                  .collection('my_matches')
                                  .doc(ds['match_id'])
                                  .collection('innings')
                                  .get()
                                  .then((QuerySnapshot qs) {
                                if (qs.docs.length > 1) {
                                  inning_no = 'inning2';
                                } else {
                                  inning_no = 'inning1';
                                }
                              });
                              inning_no == 'inning2'
                                  ? await FirebaseFirestore.instance
                                      .collection('scoring')
                                      .doc(ds['user_id'])
                                      .collection('my_matches')
                                      .doc(ds['match_id'])
                                      .collection('innings')
                                      .doc('inning2')
                                      .get()
                                      .then((DocumentSnapshot data) {
                                      data['isended'] ||
                                              data['total_inning_overs'] ==
                                                  data['Total']['total_overs']
                                                      .toString() ||
                                              data['target'] <=
                                                  data['Total']
                                                      ['total_score'] ||
                                              data['target'] - 1 ==
                                                  data['Total']['total_score']
                                          ? ismatchended = true
                                          : ismatchended = false;
                                    })
                                  : ismatchended = false;
                              Get.to(
                                () => ScoringPage(),
                                arguments: {
                                  'user_id': ds['user_id'],
                                  'match_id': ds['match_id'],
                                  'inning_no': inning_no,
                                  'team1_id': data!['team_details']['team1_id'],
                                  'team1_name': data['team_details']
                                      ['team1_name'],
                                  'team2_id': data['team_details']['team2_id'],
                                  'team2_name': data['team_details']
                                      ['team2_name'],
                                  'isscoring': false,
                                  'ismatchended': ismatchended,
                                },
                              );
                            },
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('scoring')
                                    .doc(ds['user_id'])
                                    .collection('my_matches')
                                    .doc(ds['match_id'])
                                    .collection('innings')
                                    .snapshots(),
                                builder: (context, scoring_snapshot) {
                                  var inning2 = {};
                                  var decision = '';
                                  if (scoring_snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center();
                                  } else {
                                    DocumentSnapshot inning1 =
                                        scoring_snapshot.data!.docs[0];
                                    if (scoring_snapshot.data!.docs.length >
                                        1) {
                                      DocumentSnapshot ds2 =
                                          scoring_snapshot.data!.docs[1];
                                      //  if(ds2.exists){
                                      decision =
                                          '${ds2['batting_team']} needs ${ds2['target'] - ds2['Total']['total_score']} runs to win';
                                      //  }

                                      inning2 = {
                                        'batting_team': ds2['batting_team'],
                                        'total_score': ds2['Total']
                                            ['total_score'],
                                        'total_wickets': ds2['Total']
                                            ['total_wickets'],
                                        'run_rate': ds2['Total']['run_rate'],
                                        'total_overs': ds2['Total']
                                                    ['total_overs']
                                                .toString() +
                                            '.' +
                                            ds2['Total']['balls'].toString(),
                                      };
                                    } else {
                                      inning2 = {
                                        'batting_team': '',
                                        'total_score': '0',
                                        'total_wickets': '0',
                                        'run_rate': '0.0',
                                        'total_overs': '0.0',
                                      };
                                      decision = '';
                                    }
                                    if (!scoring_snapshot.hasData) {
                                      return Center();
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.all(2.5),
                                        child: Card(
                                          color: Colors.white.withOpacity(0.9),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                          elevation: 5.0,
                                          child: Column(
                                            // mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ListTile(
                                                title: Text(
                                                  ds["user_name"] + "'s Match",
                                                  style: TextStyle(
                                                    fontSize: 19.0,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  // '',
                                                  data?['match_details']
                                                          ['ground_name'] +
                                                      '\n' +
                                                      data?['match_details']
                                                          ['date'] +
                                                      ', ' +
                                                      data?['match_details']
                                                          ['time'],
                                                  style: TextStyle(
                                                    fontSize: 19.0,
                                                  ),
                                                ),
                                                isThreeLine: true,
                                                trailing: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5.0),
                                                    color: Colors.teal,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Text(
                                                      'Live',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14.0,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Divider(
                                                color: Colors.black,
                                              ),
                                              ListTile(
                                                leading: CircleAvatar(
                                                  backgroundColor: Colors.green,
                                                  foregroundImage:
                                                      CachedNetworkImageProvider(data![
                                                                      'team_details']
                                                                  [
                                                                  'team1_name'] ==
                                                              inning1[
                                                                  'batting_team']
                                                          ? data['team_details']
                                                              ['team1_imgurl']
                                                          : data['team_details']
                                                              ['team2_imgurl']),
                                                  child: Text(
                                                    data['team_details'][
                                                                'team1_name'] ==
                                                            inning1[
                                                                'batting_team']
                                                        ? data['team_details']
                                                                ['team1_name']
                                                            .toString()
                                                            .substring(0, 2)
                                                        : data['team_details']
                                                                ['team2_name']
                                                            .toString()
                                                            .substring(0, 2),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  data['team_details']
                                                              ['team1_name'] ==
                                                          inning1[
                                                              'batting_team']
                                                      ? data['team_details']
                                                          ['team1_name']
                                                      : data['team_details']
                                                          ['team2_name'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 17.0,
                                                  ),
                                                ),
                                                trailing: Text(
                                                  "${inning1['Total']['total_score']}-${inning1['Total']['total_wickets']}\n(${inning1['Total']['total_overs']}.${inning1['Total']['balls']} Ov)",
                                                  // '0-0\n(0.0 Ov)',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ),
                                              ListTile(
                                                leading: CircleAvatar(
                                                  backgroundColor: Colors.blue,
                                                  foregroundImage:
                                                      CachedNetworkImageProvider(data[
                                                                      'team_details']
                                                                  [
                                                                  'team1_name'] ==
                                                              inning1[
                                                                  'batting_team']
                                                          ? data['team_details']
                                                              ['team2_imgurl']
                                                          : data['team_details']
                                                              ['team1_imgurl']),
                                                  child: Text(
                                                    data['team_details'][
                                                                'team1_name'] ==
                                                            inning1[
                                                                'batting_team']
                                                        ? data['team_details']
                                                                ['team2_name']
                                                            .toString()
                                                            .substring(0, 2)
                                                        : data['team_details']
                                                                ['team1_name']
                                                            .toString()
                                                            .substring(0, 2),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  data['team_details']
                                                              ['team1_name'] ==
                                                          inning1[
                                                              'batting_team']
                                                      ? data['team_details']
                                                          ['team2_name']
                                                      : data['team_details']
                                                          ['team1_name'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 17.0,
                                                  ),
                                                ),
                                                trailing: Text(
                                                  "${inning2['total_score']}-${inning2['total_wickets']}\n(${inning2['total_overs']} Ov)",
                                                  // '0-0\n(0.0 Ov)',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ),
                                              Divider(
                                                color: Colors.black,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 8.0),
                                                child: Text(
                                                  decision == ''
                                                      ? data['toss'][
                                                              'toss_winner_team'] +
                                                          ' won the toss & elected ' +
                                                          data['toss']
                                                              ['toss_decision']
                                                      : decision,
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.teal,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                }),
                          );
                        }
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
