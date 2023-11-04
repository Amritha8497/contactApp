
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:product/pages/addcontact.dart';

import 'editcontact.dart';
class listpage extends StatefulWidget {


  listpage({Key? key,}) : super(key: key);

  @override
  _listpageState createState() => _listpageState();
}

class _listpageState extends State<listpage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color:Colors.white),
        backgroundColor: Color(0xff283593),
        onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=>Addcontact()));


        },
      ),
      appBar: AppBar(
        title: Text("Contacts",style: TextStyle(color: Colors.white),),
        backgroundColor:  Color(0xff283593),
        leading: IconButton(
          icon:Icon(Icons.menu,color: Colors.white,),
          onPressed: (){
          //  Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('contact').


            snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              else if (snapshot.hasData &&  snapshot.data!.docs.length==0)
                return Center(child: Text("No Data Found"));
              else
                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context,int index){
                    return Card(
                      color: Colors.white,
                      elevation: 8.0,
                      child: ListTile(

                        onTap: (){
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context)=>editpage(
                                uid: snapshot.data!.docs[index]['id'],
                                image: snapshot.data!.docs[index]['imgurl'],


                                name: snapshot.data!.docs[index]['name'],
                                group: snapshot.data!.docs[index]['group'],
                                phone: snapshot.data!.docs[index]['number'],
                                email: snapshot.data!.docs[index]['email'],


                              )));

                        },
                        title: Text(snapshot.data!.docs[index]['name'],style: TextStyle(fontSize: 20),),
                        leading: Image.network(snapshot.data!.docs[index]['imgurl'],),

                        subtitle: Text(snapshot.data!.docs[index]['email'],),
                        trailing:IconButton(
                          icon:Icon(Icons.delete,),


                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Do you want delete"),

                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance.collection("contact").doc(snapshot.data!.docs[index]['id']).delete();
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      color: Colors.green,
                                      padding: const EdgeInsets.all(14),
                                      child: const Text("Yes"),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },

                        ),


                      ),
                    );

                  },
                );
            }
        ),

      ),

    );
  }
}
