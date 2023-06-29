import 'package:flutter/material.dart';
import 'package:licence_mobile/model/faq.dart';

class ShowFaq extends StatelessWidget {
  // const ShowFaq({Key? key}) : super(key: key);
  ShowFaq({required this.faq});
  Question faq;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double widht = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
      ),
      body: Center(
        child: Container(
          width: widht,
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.7), BlendMode.luminosity),
              image: AssetImage("assets/images/faq.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                faq.titre,
                style: TextStyle(
                  fontSize: widht / 15.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: height / 30.0),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: widht / 50.0),
                  child: Text(
                    faq.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  )),
              SizedBox(height: height / 30.0),
              Text(
                "Etapes à suivre",
                style: TextStyle(
                  fontSize: widht / 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: height / 90.0),
              // for (var etape in faq.etapes)
              Text(
                // '- ' + etape,
                "e",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
