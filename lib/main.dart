import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;

import 'ProductDataModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {


  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sho Shop'),elevation: 0,),
        body: FutureBuilder(
          future: ReadJsonData(),
          builder: (context,snapshot){
            if(snapshot.hasError){
              return Center(child: Text("${snapshot.error}"));
            }else if(snapshot.hasData){
              var items =snapshot.data as List<ProductDataModel>; /////
              return ListView.builder(
                  itemCount: items == null? 0: items.length,
                  itemBuilder: (context,index){
                    return InkWell(
                      child: Card(
                        elevation: 5,
                        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                        child: Container(
                          padding: EdgeInsets.all(18),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 51,
                                height: 50,
                                child: Image(image: NetworkImage(items[index].imageURL.toString()),fit: BoxFit.fill,),
                              ),
                              Expanded(child: Container(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(padding: EdgeInsets.only(left: 8,right: 8),child: Text(items[index].name.toString(),style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),),),
                                    Padding(padding: EdgeInsets.only(left: 8,right: 8),child: Text(items[index].price.toString()),)
                                  ],
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return   AlertDialog(
                                title: Text("Best Shoes "),
                                content: SingleChildScrollView(child: Column(
                                  children: [
                                    Container(
                                      width: 110,
                                      height: 110,
                                      child: Image(image: NetworkImage(items[index].imageURL.toString()),fit: BoxFit.fill,),
                                    ),
                                    Padding(padding: EdgeInsets.only(top: 10,left: 8,right: 8),child: Text('Shoes:  ${items[index].name.toString()}',style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),),),
                                    Padding(padding: EdgeInsets.only(top:10,left: 8,right: 8),child: Text('Price: ${items[index].price.toString()}'),)
                                  ],
                                ),),
                              );
                            }
                        );
                      }
                    );
                  }
              );
            }else{
              return Center(child: CircularProgressIndicator(),);
            }
          },
        )
    );
  }

  Future<List<ProductDataModel>>ReadJsonData() async{
    final jsondata = await rootBundle.rootBundle.loadString('asset/jsondata.json');
    final list = json.decode(jsondata) as List<dynamic>;
    return list.map((e) => ProductDataModel.fromJson(e)).toList();
  }
}

