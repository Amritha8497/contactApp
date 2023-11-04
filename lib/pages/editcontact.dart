import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

import 'listall.dart';

class editpage extends StatefulWidget {
  var uid;

  var name;
  var group;
  var phone;

  var email;
  var image;
   editpage({Key? key,
    this.phone,
    this.uid,
    this.name,
    this.email,
    this.image,
    this.group
  }) : super(key: key);

  @override
  State<editpage> createState() => _editpageState();
}


RegExp regex = RegExp(PatterStrings.email);

bool isHidePassword = true;
bool loading = true;
var url;
var productid;
var filename;
XFile ? image;
final ImagePicker _picker=ImagePicker();

TextEditingController _firstNameController = TextEditingController();
TextEditingController _emailController = TextEditingController();
TextEditingController _numberController = TextEditingController();
TextEditingController _groupController = TextEditingController();


var size, height, width;
var _registerkey=new GlobalKey<FormState>();

class _editpageState extends State<editpage> {

  void initState() {

    _firstNameController.text=widget.name;
    _groupController.text=widget.group;
    _numberController.text=widget.phone;
    _emailController.text=widget.email;





    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff283593),
        leading: IconButton(
          icon:Icon(Icons.clear,color: Colors.white,),
          onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context)=>listpage()));
          },
        ),

        title: Text("Edit",style: TextStyle(color: Colors.white),),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _registerkey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),

                  ),

                  GestureDetector(
                    onTap: (){
                      showimagepicker();
                    },
                    child: Container(
                      height: 250,
                      width: 200,
                      color: Colors.grey,
                      child: image!=null
                          ?Image.file(
                        File(image!.path),fit: BoxFit.fill,)
                          : Container(
                          color: Colors.blueGrey,
                          child: Image.network(widget.image,fit: BoxFit.fill,)
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(8),
                    child: buildTextField(
                      label: "Email *",
                      controller: _emailController,
                      prefix: IconButton(
                        icon:Icon(Icons.email,color: Color(0xff283593),),
                        onPressed: (){},
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please enter email address";
                        }
                        if (!regex.hasMatch(val)) {
                          return "Enter valid email address";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: buildTextField(
                      label: "Name *",
                      prefix: IconButton(
                        icon:Icon(Icons.person,color: Color(0xff283593),),
                        onPressed: (){},
                      ),
                      controller: _firstNameController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please enter name";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: buildTextField(
                      label: "Group *",
                      controller: _groupController,
                      prefix: IconButton(
                        icon:Icon(Icons.person,color: Color(0xff283593),),
                        onPressed: (){},
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please enter group";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: buildTextField(
                      label: "Number *",
                      controller: _numberController,
                      prefix: IconButton(
                        icon:Icon(Icons.phone,color: Color(0xff283593),),
                        onPressed: (){},
                      ),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please enter number";
                        }
                        return null;
                      },
                    ),
                  ),

                  SizedBox(
                    width: width / 1.3,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_registerkey.currentState!.validate()) {

                          if(image==null) {
                            FirebaseFirestore.instance.collection('contact').doc(widget.uid).update({



                                      'name':_firstNameController.text,
                                      'group':_groupController.text,
                                      'number':_numberController.text,
                                      'email':_emailController.text,





                            }).then((value){
                              _showsnackbar(context,"Successfully edited");
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context)=>listpage()));
                            });
                          }
                          else if(image!=null)
                          {
                            var ref=FirebaseStorage.instance.ref().child('products/$filename');
                            UploadTask utask=ref.putFile(File(image!.path));
                            utask.then((res) async {
                              url=(await ref.getDownloadURL()).toString();
                            }).then((value){
                              FirebaseFirestore.instance.collection('contact').doc(widget.uid).update({


                                        'name':_firstNameController.text,
                                        'group':_groupController.text,
                                        'number':_numberController.text,
                                        'email':_emailController.text,
                                        'date':DateTime.now(),
                                        'imgurl':url,



                              }).then((value){
                                _showsnackbar(context,"Successfully edited");
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context)=>listpage()));

                              });
                            });
                          }



                        }
                      },

                      style: ElevatedButton.styleFrom(
                          backgroundColor:Color(0xff283593),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ) // Background color
                      ),
                      child: Text(
                        "edit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Padding buildTextField(
      {String? label,
        String? Function(String?)? onChanged,
        final TextEditingController? controller,
        List<TextInputFormatter>? inputFormatter,
        final String? Function(String?)? validator,
        final TextInputType? keyboardType,
        final int? maxLines,
        Widget? prefix,
        final int? maxLength}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: SizedBox(
        child: TextFormField(
          // style: ,
          inputFormatters: inputFormatter,
          keyboardType: keyboardType,
          textCapitalization: TextCapitalization.sentences,
          maxLines: maxLines,
          maxLength: maxLength,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            prefix: prefix,


            label: Text(label!),
         
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff283593)),
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff283593)),
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onChanged: onChanged,
          controller: controller,
          validator: validator,
        ),
      ),
    );
  }
  imagefromgallery()async{

    final XFile? _image= await _picker.pickImage(source:ImageSource.gallery );
    setState(() {
      image=_image;
    });
  }
  imagefromcamera()async{

    final XFile? _image= await _picker.pickImage(source:ImageSource.camera );
    setState(() {
      image=_image;
    });
  }
  showimagepicker(){
    showModalBottomSheet(context: context,
        builder: (context){
          return Wrap(
            children: [
              ListTile(
                title: Text("camera"),
                onTap: (){
                  imagefromcamera();
                },

              ),
              ListTile(
                title: Text("gallery"),
                onTap: (){
                  imagefromgallery();
                },
              ),

            ],

          );
        });

  }
}
void _showsnackbar(BuildContext context,String value) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(value),
        backgroundColor: Colors.black,
      )
  );
}

class PatterStrings {
  static const String email =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  //    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  static const String phone = r'^(?:[+0]9)?[0-9]{8}$';
}
