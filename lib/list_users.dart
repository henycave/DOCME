import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_autentication/detail.dart';
import 'package:user_autentication/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ListPage extends StatefulWidget {

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  FirebaseAuth firebaseAuth;
  var firestore = Firestore.instance;

  Future getPosts() async {
    QuerySnapshot qn = await firestore.collection('users').getDocuments();
    return qn.documents;
  }

  navigateToDetail(DocumentSnapshot post ){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailPage(post: post,)));
  }
  void signOut(String choice) async{
    firebaseAuth = FirebaseAuth.instance;
      await firebaseAuth.signOut();
    Navigator.pop(context);
  }
  void deleteUsers(docId) async{
    await Firestore.instance.collection('users').document(docId).delete().catchError((e){
        print(e);
    });

    print(docId);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'login',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new Scaffold(
            appBar: new AppBar(
              backgroundColor: Color.fromRGBO(0,128,0,0.8),
              title: new Text('users'),
              actions: <Widget>[
                PopupMenuButton<String>(
                  color: Color.fromRGBO(0,128,0,0.8),
                  onSelected: signOut,
                  itemBuilder: (BuildContext context){
                    return Constants.choices.map((String choice){
                      return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice, style: new TextStyle(color: Colors.white),),
                      );
                    }).toList();
                  },
                )
              ],
    ),
    body: Container(
      decoration: new BoxDecoration(
        image: new DecorationImage(image: new AssetImage("assets/images/go.jpg"), fit: BoxFit.cover,),
      ),
      child: FutureBuilder(
          future: getPosts(),
          builder:(_, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: Text('loading'),
              );
            }else{
              return ListView.builder(
                itemCount : snapshot.data.length,
                itemBuilder: (_,index){
              return Card(
                color: Color.fromRGBO(0,128,0,0.8),
                child: ListTile(

                    leading: Icon(Icons.account_circle),
                  title: Text(snapshot.data[index].data['user name'], style: new TextStyle(fontSize: 20.0, color: Colors.white),),
                  subtitle: Text(snapshot.data[index].documentID, style: new TextStyle(color: Colors.white),),

                  onTap: ()=> navigateToDetail(snapshot.data[index]),
                  onLongPress: (){
                    deleteUsers(snapshot.data[index].documentID);
                    setState(() {
                      snapshot.data.removeAt(index);
                    });
                  },
                ),
              );
                });
                  }
          }),
    ),
        ));

  }
}

