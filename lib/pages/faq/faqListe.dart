import 'package:flutter/material.dart';
import 'package:licence_mobile/model/faq.dart';
import 'package:licence_mobile/pages/faq/showfaq.dart';
import 'package:licence_mobile/widget/widget.dart';
import 'package:search_page/search_page.dart';

class FAQ extends StatefulWidget {
  const FAQ({Key? key}) : super(key: key);

  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  List<Question> questions = [];
  bool load = true;

  getData() async {
    Question.all().then((_questions) {
      setState(() {
        questions = _questions;
      });
    });
    setState(() {
      load = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Page'),
      ),
      body: load
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.7), BlendMode.luminosity),
                      image: AssetImage("assets/images/faqs.jpeg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                questions.isEmpty
                    ? Center(
                        child: Text(
                          "Aucune donnée trouvée",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width / 20,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : ListView.builder(
                        itemCount: questions.length,
                        itemBuilder: (context, index) {
                          final Question question = questions[index];
                          return Card(
                            margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 30,
                              right: MediaQuery.of(context).size.width / 30,
                              top: MediaQuery.of(context).size.height / 30,
                            ),
                            elevation: 5.0,
                            child: ListTile(
                              onTap: () {
                                Widgets.navigate(
                                    context, ShowFaq(faq: questions[index]));
                              },
                              title: Padding(
                                padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height / 80,
                                ),
                                child: Text(
                                  question.titre,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                              subtitle: Column(
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              50.0),
                                  Text(
                                    question.description.length < 60
                                        ? question.description
                                        : question.description
                                                .substring(0, 60) +
                                            ' ...',
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              50.0),
                                ],
                              ),
                              // trailing: Text('${question.etapes} yo'),
                            ),
                          );
                        },
                      ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Search questions',
        onPressed: () => showSearch(
          context: context,
          delegate: SearchPage<Question>(
            onQueryUpdate: (s) => print(s),
            items: questions,
            searchLabel: 'Recherche ...',
            suggestion: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.7), BlendMode.luminosity),
                      image: const AssetImage("assets/images/faqs.jpeg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Faite une recherche ...',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            failure: const Center(
              child: Text('Aucun FAQ ne repond à votre recherche :('),
            ),
            filter: (question) => [
              question.titre,
              question.description,
              // question.etapes.toString(),
            ],
            builder: (question) => Container(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 50,
                right: MediaQuery.of(context).size.width / 50,
                top: MediaQuery.of(context).size.height / 50,
              ),
              child: ListTile(
                onTap: () {
                  Widgets.navigate(context, ShowFaq(faq: question));
                },
                title: Text(question.titre),
                subtitle: Column(
                  children: [
                    // Text('${question.description.substring(0, 55)} ...'),
                    const Divider()
                  ],
                ),
                // trailing: Text('${question.etapes} yo'),
              ),
            ),
          ),
        ),
        child: const Icon(Icons.search),
      ),
    );
  }
}
