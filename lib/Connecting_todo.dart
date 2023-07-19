import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'Todo_Mainpage.dart';

class Header_Title extends StatefulWidget {
  const Header_Title({Key? key}) : super(key: key);

  @override
  State<Header_Title> createState() => _Header_TitleState();
}

class _Header_TitleState extends State<Header_Title> {
  TextEditingController header=TextEditingController();
  TextEditingController title=TextEditingController();
   sentaData() async{
     var body = {
       "title" : header.text,
       "content"  : title.text
     };
     Response response=await post(Uri.parse("http://192.168.29.180:8080/addNotes"),body: jsonEncode(body));

     print("bdchb");
     if(response.statusCode==200) {
       var bdy=jsonDecode(response.body);
       print(bdy);
       if(bdy["message"]=="inserted") {
         Navigator.push(context, MaterialPageRoute(builder: (context) => Todo_Home(),));
       }
     }
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: header,
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: title,
                decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
              ),
            ),
            ElevatedButton(onPressed: (){
                  sentaData();
            }, child: Text("submit"))
          ],
        ),
      ),
    );
  }
}
