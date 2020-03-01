
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {

  final DocumentSnapshot post;
  DetailPage({this.post});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0,128,0,0.8),
        title: Text(widget.post.data['user name']),
      ),
      body: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(image: new AssetImage("assets/images/go.jpg"), fit: BoxFit.cover,),
        ),
          child: ListView(
            children: ListTile.divideTiles(context: context,
                tiles: [
                  ListTile(
                    title: Text('User Name' , style: new TextStyle(color: Colors.white),),
                    subtitle: Text(widget.post.data['user name'], style: new TextStyle(color: Colors.white),),
                  ),
                  ListTile(
                    title: Text('First Name', style: new TextStyle(color: Colors.white),),
                      subtitle : Text(widget.post.data['Fname'], style: new TextStyle(color: Colors.white),)
                  ),
                  ListTile(
                    title: Text('Last Name', style: new TextStyle(color: Colors.white),),
                    subtitle: Text(widget.post.data['Lname'], style: new TextStyle(color: Colors.white),),
                  ),
                  ListTile(
                    title: Text('Gender', style: new TextStyle(color: Colors.white),),
                    subtitle: Text(widget.post.data['Gender'], style: new TextStyle(color: Colors.white),),
                  ),
                  ListTile(
                    title: Text('mobile', style: new TextStyle(color: Colors.white),),
                      subtitle: Text(widget.post.data['mobile'], style: new TextStyle(color: Colors.white),)
                  ),
            ]  ).toList(),
            //title: Text(widget.post.data['user name']),
          ),

      ),
    );
  }
}
