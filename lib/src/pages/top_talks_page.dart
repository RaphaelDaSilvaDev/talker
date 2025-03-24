import 'package:flutter/material.dart';


class TopTalksPage extends StatefulWidget {
  const TopTalksPage({super.key});

  @override
  State<TopTalksPage> createState() => _TopTalksPageState();
}

class _TopTalksPageState extends State<TopTalksPage> {
  @override
  Widget build(BuildContext context) {

    List<Widget> data = [];

    return Scaffold(
      backgroundColor: Color.fromRGBO(52, 53, 65, 1),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: data.isNotEmpty 
         ? ListView.separated(
          padding: EdgeInsets.only(top: 16),
          itemCount: data.length,
          itemBuilder: (context, index){
            return data[index];
          },
          separatorBuilder: (_,_) => SizedBox(height: 14,),
        )
        : Center(
          child: Text("Não existe Conversar no momento", style: TextStyle(fontSize: 18, color: Colors.white),),
        )
      )
    );
  }
}