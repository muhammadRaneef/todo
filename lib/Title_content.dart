import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'Todo_Mainpage.dart';

class TC extends StatefulWidget {
   TC({Key? key,required this.a,required this.b,required this.id}) : super(key: key);
  String? a;
  String? b;
  String? id;
  @override
  State<TC> createState() => _TCState();
}

class _TCState extends State<TC> {
  TextEditingController title=TextEditingController();
  TextEditingController content=TextEditingController();
  TextEditingController id=TextEditingController();
  sentaData() async{
    var body= {
      "title": title.text,
      "content": content.text,
      "id"    : widget.id //because it's a constant

    };
    Response response=await post(Uri.parse("http://192.168.29.180:8080/updateNotes"),body:jsonEncode(body) );

    print(response.statusCode);
    print(body);
    print(response.body);
    if(response.statusCode==200) {
      var bdy=jsonDecode(response.body);
      print(response.body);
      if(bdy["message"]=="note updated") {
        Navigator.push(context,MaterialPageRoute(builder: (context) => Todo_Home(),));
      }
    }
  }
  @override
  void initState() {
    title.text=widget.a!;
    content.text=widget.b!;
    id.text=widget.id!;
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
            ),
            TextField(
              controller: content,
              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
            ),

            ElevatedButton(onPressed: (){
               sentaData();
            }, child: Text("Edit"))
          ],
        ),
      ),
    );
  }
}
