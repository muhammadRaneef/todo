import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'Connecting_todo.dart';
import 'Title_content.dart';

class Todo_Home extends StatefulWidget {
  const Todo_Home({Key? key}) : super(key: key);

  @override
  State<Todo_Home> createState() => _Todo_HomeState();
}

class _Todo_HomeState extends State<Todo_Home> {
  TextEditingController search = TextEditingController();
  getaData() async{
    Response response=await get(Uri.parse("http://192.168.29.180:8080/getNotes"));
    if(response.statusCode==200) {

        var bdy=jsonDecode(response.body);
        print(response.body);
        return bdy;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    getaData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.only(left: 138.0),
          child: Icon(
            Icons.note,
            color: Colors.white,
            size: 30,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 98.0),
          child: Icon(
            Icons.date_range_rounded,
            color: Colors.yellow,
            size: 40,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: Icon(
              Icons.settings,
              color: Colors.white,
              size: 35,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.yellow,child: Icon(Icons.add),elevation: 20,shape: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Header_Title(),
                ));
          }),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: search,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "  Search notes",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30))),
              ),
            ),
            FutureBuilder(
              future: getaData(),
              builder: (context,AsyncSnapshot snapshot) {

                if(snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                         itemCount: snapshot.data["message"].length,
                        itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TC(a: snapshot.data["message"][index]["title"], b: snapshot.data["message"][index]["content"],id:snapshot.data["message"][index]["id"] ),));
                          },
                          child: Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(color: Colors.yellow),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text(snapshot.data["message"][index]["title"]), Text(snapshot.data["message"][index]["content"])],
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }else {
                  return Center(child: Text("No Data"),);
                }

              }
            )
          ],
        ),
      ),
    );
  }
}
