import 'package:flutter/material.dart';
import 'package:faulkner_footsteps/app_router.dart';

class ListPage extends StatefulWidget{
  const ListPage({super.key});

  
  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(child: ElevatedButton(onPressed: () => AppRouter.navigateTo(context, AppRouter.hsitePage), child: Text("Historical Site Page")),
      alignment: Alignment.center,),
      
    );
  }

}