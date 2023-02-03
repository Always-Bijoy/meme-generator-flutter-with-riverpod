import 'package:flutter/material.dart';

class TextOverImage extends StatelessWidget {
  const TextOverImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Text Over Image Image Example'),
      ),
      body: Center(
        child: SizedBox(
          height: 300,
          width: 300,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue,
                    image: const DecorationImage(
                        image: NetworkImage(
                            "https://thumbs.dreamstime.com/b/funny-face-baby-27701492.jpg"),
                        fit: BoxFit.fill)),
              ),
              const HomePage()
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Offset offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              offset = Offset(
                  offset.dx + details.delta.dx, offset.dy + details.delta.dy);
            });
          },
          child: const SizedBox(
            width: 300,
            height: 300,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text("You Think You Are Funny But You Are Not",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28.0,
                        color: Colors.red)),
              ),
            ),
          )),
    );
  }
}