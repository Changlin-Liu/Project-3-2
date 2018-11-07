import 'package:flutter/material.dart';
import 'global.dart';
import 'package:intl/intl.dart';

class AppointmentListPage extends StatefulWidget {
  @override createState() => AppointmentListState();
}
class AppointmentListState extends State {


  var canCreate = false;
  var nMap = {};

  @override
  void initState() {
    super.initState();
    getRoles().then((_) => getAppointmentList());
  }

  void getAppointmentList() {
    Set roleSet, AppointmentSet;
    if (roles3 != null) {
      roleSet = roles3.values.toSet();
      AppointmentSet = roles3.keys.toSet();
    } else {
      roleSet = Set();
      AppointmentSet = Set();
    }
    AppointmentSet.add('ALL');
    canCreate = roleSet.contains('teacher')
        || roleSet.contains('student')
        || roleSet.contains('administrator');

    for (var c in AppointmentSet) {

      print(c);
      var nRef = dbRef.child('Appointment/$c/notifications');
      nRef.onValue.listen((event) {
        if (event.snapshot.value == null) nMap.remove(c);
        else nMap[c] = (event.snapshot.value as Map).values.toList();
        if (mounted) setState(() {});

        print(nMap);
      });
    }
  }

  @override Widget build(BuildContext context) {
    var widgetList = <Widget>[];

    var data = List();
    for (List c in nMap.values)
      data.addAll(c);
    data.sort((a, b) => b['createdAt'] - a['createdAt']);
// for (var i = 1; i <= 20; i++) {
// var item = 'Notification $i';
    for (var i=0; i<data.length; i++){
      var item = data[i];
      var title = item['title'];
      var Appointment = item['Appointment'];
      var datetime = DateTime.fromMillisecondsSinceEpoch(item['createdAt']);
      var createdAt = DateFormat('EEE, MMMM d, y H:m:s',
          'en_US').format(datetime);

      widgetList.add(
          ListTile(
              leading: Icon(Icons.notifications),

              // title: Text('Item $i'),
              // trailing: Icon(Icons.face),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(createdAt,
                    style: TextStyle(fontSize: 10.0, color: Colors.blueGrey),),
                ],
              ),
              trailing: Text(Appointment.replaceAll(' ', '\n'),
                textAlign: TextAlign.right,),

              onTap: () {

                notificationSelection = item;
                Navigator.pushNamed(context, '/appointmentView');
              }



          )
      );
    }
    return Scaffold(

      floatingActionButton: (canCreate)?
      FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=>Navigator.pushNamed(context, '/appointmentCreate'),
      ) : null,

      appBar: AppBar(title: Text('Notifications'),),
      body: ListView(
        children: widgetList,
        padding: EdgeInsets.all(20.0),
      ),
    );
  }
}