import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hidden_drawer/flutter_hidden_drawer.dart';
import 'package:licence_mobile/pages/Matieres/matieres_liste.dart';
import 'package:licence_mobile/pages/accueuil.dart';
import 'package:licence_mobile/pages/calendar/cours.dart';
import 'package:licence_mobile/pages/faq/faqListe.dart';
import 'package:licence_mobile/widget/widget.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Botom_Nav extends StatefulWidget {
  const Botom_Nav({Key? key}) : super(key: key);

  @override
  State<Botom_Nav> createState() => _Botom_NavState();
}

class _Botom_NavState extends State<Botom_Nav> {
  var _currentIndex = 0;
  final _pageController = PageController();

  changemenu(int _index) {
    setState(() {
      _currentIndex = _index;
      _pageController.jumpToPage(_index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawer(
      drawerWidth: MediaQuery.of(context).size.width * .4,
      drawer: Widgets.studentDawer(context, changemenu),
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          children: [
            Accueil(),
            MatieresList(),
            Cours(),
            FAQ(),
          ],
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
              _pageController.jumpToPage(index);
            });
          },
        ),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() {
            _currentIndex = i;
            _pageController.jumpToPage(i);
          }),
          items: [
            SalomonBottomBarItem(
              icon: Icon(Icons.home),
              title: Text('Accueil'),
              selectedColor: Colors.blue,
            ),
            SalomonBottomBarItem(
              icon: Icon(CupertinoIcons.rectangle_grid_3x2_fill),
              title: Text('Matières'),
              selectedColor: Colors.blue,
            ),
            SalomonBottomBarItem(
              icon: Icon(CupertinoIcons.calendar_today),
              title: Text('Cours'),
              selectedColor: Colors.blue,
            ),
            SalomonBottomBarItem(
              icon: Icon(CupertinoIcons.question_diamond_fill),
              title: Text('FAQ'),
              selectedColor: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}
