import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('바로 Alpha'),
        elevation: 0.0,
        backgroundColor: Colors.amberAccent,
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.amberAccent,
              ),
              child: const Text("M2 메뉴"),
            ),
            ExpansionTile(
              title: const Text("테스트 메뉴 1"),
              children: const <Widget>[
                ListTile(
                  title: Text("테스트 하단 메뉴 1-1"),
                ),
                ListTile(
                  title: Text("테스트 하단 메뉴 1-2"),
                ),
              ],
            ),
            ExpansionTile(
              title: const Text("테스트 메뉴 2"),
              children: const <Widget>[
                ListTile(
                  title: Text("테스트 하단 메뉴 2-1"),
                ),
                ListTile(
                  title: Text("테스트 하단 메뉴 2-2"),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => print("GestureDetector used."),
                  child: Container(
                    width: 200,
                    height: 200,
                    color: Colors.green,
                  ),
                ),
                GestureDetector(
                  onTap: () => print("GestureDetector used."),
                  child: Container(
                    width: 200,
                    height: 200,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => print("GestureDetector used."),
                  child: Container(
                    width: 200,
                    height: 200,
                    color: Colors.amber,
                  ),
                ),
                GestureDetector(
                  onTap: () => print("GestureDetector used."),
                  child: Container(
                    width: 200,
                    height: 200,
                    color: Colors.amberAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print("Clicked"),
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}