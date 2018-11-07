import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'global.dart';

class NotificationCreationPage extends StatefulWidget {
  @override createState() => NotificationCreationState();
}
class NotificationCreationState extends State {
  var imgBytes = null;
  var imgBytes1 = null;
  List<DropdownMenuItem> getListdata(){
    List<DropdownMenuItem> item = new List();
    DropdownMenuItem a1 = new DropdownMenuItem(child: new Text('COMP 7510'),value: 'COMP7510',);
    DropdownMenuItem a2 = new DropdownMenuItem(child: new Text('COMP 7520'),value: 'COMP7520',);
    DropdownMenuItem a3 = new DropdownMenuItem(child: new Text('COMP 7580'),value: 'COMP7580',);
    item.add(a1);
    item.add(a2);
    item.add(a3);
    return item ;
  }

  @override void initState() {
    super.initState();
    var url = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRWvgfr5NB8Iqg0Jr-3d2g0UnoEY78D8pOW4j1CMdl_b0LFXF1l';
    http.get(url).then((response) {
      print('download complete!');
      setState(() => imgBytes = response.bodyBytes);
    });
    var url1 = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRE2Ktf9PQ_OxB4tqBXCp9Uno0pj0Mm-p2ciebuwClbJthhmns3fQ';
    http.get(url1).then((response) {
      print('download complete!');
      setState(() => imgBytes1 = response.bodyBytes);
    });
  }

  @override
  Widget build(BuildContext context) {
    var childWidgets = <Widget>[];
    if (imgBytes != null)
      childWidgets.add(Image.memory(imgBytes,
          width: MediaQuery.of(context).size.width - 120)
      );
    childWidgets.add(Icon(Icons.cancel));
    var childWidgets1 = <Widget>[];
    if (imgBytes1 != null)
      childWidgets1.add(Image.memory(imgBytes1,
          width: MediaQuery.of(context).size.width - 120)
      );
    childWidgets1.add(Icon(Icons.cancel));






    var content=null;
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(icon: new Icon(Icons.navigate_before,color: Colors.white,), onPressed: null),
        title: Text('Compose...'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.camera_alt,color: Colors.white,),onPressed: null,),
          new IconButton(icon: new Icon(Icons.panorama,color: Colors.white,),onPressed: null,),
          new IconButton(icon: new Icon(Icons.send,color: Colors.white,),onPressed: null,),
        ],
      ),

      body: ListView(

        padding: EdgeInsets.all(20.0),
        children: <Widget>[
          Text('Post to',textAlign: TextAlign.center,),
          Container(
            margin: EdgeInsets.fromLTRB(90.0, 20.0, 90.0, 10.0),
            child: DropdownButton(items: getListdata(),
                hint: Text('COMP 7510',textAlign: TextAlign.center),
                onChanged: null),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Mobile App Development',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              onChanged: (text) => setState(() => content = text),
            ),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(10.0, 3.0, 10.0, 10.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'The notification creation page allows\n the user to pick photos from the\n gallery or the camera.',
                ),
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (text) => setState(() => content = text),
              )
          ),
          Container(
            margin: EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
            child: Row(
                children: childWidgets
            ),
          ),

          Container(
            margin: EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 20.0),
            child: Row(
                children: childWidgets1
            ),
          ),



        ],

      ),

    );
  }
}