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
  List m=[];
  List<Map<dynamic,dynamic>> searchList=[];
  deleteaData(String id)async{

    var body= {
       "id": id,
    };
    Response response=await post(Uri.parse("http://192.168.1.34:8080/removeNotes"),body: jsonEncode(body));
    print(response.statusCode);
    print(response.body);
    if(response.statusCode==200) {
      var by=jsonDecode(response.body);
      print(response.body);
      if(by["message"]=="deleted") {
        setState(() {

        });
      }
    }
  }
  getaData() async{
    Response response=await get(Uri.parse("http://192.168.1.34:8080/getNotes"));

    if(response.statusCode==200) {

        var bdy=jsonDecode(response.body);
        print(response.body);
         setState(() {
           m=bdy["message"];//adding elements
         });
        return bdy;
    }
  }
  searchaData() {
    searchList.clear();//to clear
    m.forEach((e) {
      if(e["title"].contains(search.text)==true) {
        setState(() {
          searchList.add(e);
        });
      }
    });
  }
  bool isClicked=false;
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
                onChanged: (v){
                  setState(() {
                    isClicked=true;
                  });
                  searchaData();
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "  Search notes",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30))),
              ),
            ),
      isClicked==false ?Expanded(
        child: ListView.builder(
            itemCount: m.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TC(a: m[index]["title"], b: m[index]["content"],id:m[index]["id"].toString() ),));
                  },
                  child: Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: Colors.yellow),

                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text(m[index]["title"]), Text(m[index]["content"])],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: () {
                              deleteaData(m[index]["id"].toString());
                            },
                            child: Container(
                              height:40,
                              width:40,
                              decoration: BoxDecoration(color: Colors.black12),
                              child: Icon(Icons.delete),
                            ),
                          ),
                        )
                      ],
                    ),

                  ),
                ),
              );

            }),
      ) :SizedBox(),
            isClicked==true ? Expanded(
              child: ListView.builder(
                  itemCount: searchList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TC(a: searchList[index]["title"], b: searchList[index]["content"],id:searchList[index]["id"].toString() ),));
                        },
                        child: Container(
                          height: 150,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: Colors.yellow),

                          child: Stack(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Text(searchList[index]["title"]), Text(searchList[index]["content"])],
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                  onTap: () {
                                    deleteaData(searchList[index]["id"].toString());
                                  },
                                  child: Container(
                                    height:40,
                                    width:40,
                                    decoration: BoxDecoration(color: Colors.black12),
                                    child: Icon(Icons.delete),
                                  ),
                                ),
                              )
                            ],
                          ),

                        ),
                      ),
                    );

                  }),
            ) :SizedBox()
          ],
        ),
      ),
    );
  }
}
