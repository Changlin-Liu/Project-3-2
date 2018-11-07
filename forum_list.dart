import 'package:flutter/material.dart';
import 'global.dart';
import 'package:intl/intl.dart';

class ForumListPage extends StatefulWidget {
  @override createState() => ForumListState();
}
class ForumListState extends State {


  var canCreate = false;
  var nMap = {};

  @override
  void initState() {
    super.initState();
    getRoles().then((_) => getForumList());
  }

  void getForumList() {
    Set roleSet, forumSet;
    if (roles2 != null) {
      roleSet = roles2.values.toSet();
      forumSet = roles2.keys.toSet();
    } else {
      roleSet = Set();
      forumSet = Set();
    }
    forumSet.add('ALL');
    canCreate = roleSet.contains('teacher')
        || roleSet.contains('student')
        || roleSet.contains('administrator');

    for (var c in forumSet) {

      print(c);
      var nRef = dbRef.child('forum/$c/notifications');
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
      var forum = item['forum'];
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
              trailing: Text(forum.replaceAll(' ', '\n'),
                textAlign: TextAlign.right,),

              onTap: () {

                notificationSelection = item;
                Navigator.pushNamed(context, '/forumView');
              }



          )
      );
    }
    return Scaffold(

      floatingActionButton: (canCreate)?
      FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: ()=>Navigator.pushNamed(context, '/forumCreate'),
      ) : null,

      appBar: AppBar(title: Text('Notifications'),),
      body: ListView(
        children: widgetList,
        padding: EdgeInsets.all(20.0),
      ),
    );
  }
}