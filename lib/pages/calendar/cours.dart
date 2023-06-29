import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hidden_drawer/flutter_hidden_drawer.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:flutter_neat_and_clean_calendar/neat_and_clean_calendar_event.dart';
import 'package:intl/intl.dart';
import 'package:licence_mobile/loginMiddle.dart';
import 'package:licence_mobile/model/event.dart';
import 'package:date_format/date_format.dart';
import 'package:licence_mobile/model/matiere.dart';
import 'package:licence_mobile/pages/accueuil.dart';
import 'package:licence_mobile/service/api.dart';
import 'package:licence_mobile/widget/widget.dart';
import 'package:select_form_field/select_form_field.dart';

class Cours extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CoursState();
  }
}

class _CoursState extends State<Cours> {
  List<Event> events = [];
  final Map<DateTime, List<NeatCleanCalendarEvent>> _events = {};
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _timeFinController = TextEditingController();
  TextEditingController _matiereController = TextEditingController();
  TextEditingController _typeController = TextEditingController();
  late String _setTime, _setDate;
  late String _hour, _minute, _time;
  // late String _hourFin, _minuteFin, _timeFin;
  // String dateTime;
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedTimeFin = TimeOfDay(hour: 00, minute: 00);
  DateTime selectedDate = DateTime.now();
  final List<Map<String, dynamic>> _items = [];
  String userRole = "";

  bool load = false;

// setState(() {
//       dateDebut = DateTime(selectedDate.year, selectedDate.month,
//           selectedDate.day, selectedTime.hour, selectedTime.minute);
//     });

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context, String type) async {
    if (type == 'fin') {
      final TimeOfDay? pickedFin = await showTimePicker(
          context: context,
          initialTime: selectedTime,
          builder: (context, child) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                    // Using 12-Hour format
                    alwaysUse24HourFormat: true),
                // If you want 24-Hour format, just change alwaysUse24HourFormat to true
                child: child!);
          });
      if (pickedFin != null) {
        setState(() {
          selectedTimeFin = pickedFin;
          _hour = selectedTimeFin.hour.toString();
          _minute = selectedTimeFin.minute.toString();
          _time = _hour + ' : ' + _minute;
          _timeFinController.text = _time;
          _timeFinController.text = formatDate(
              DateTime(
                  2019, 08, 1, selectedTimeFin.hour, selectedTimeFin.minute),
              // [hh, ':', nn, " ", am]).toString();
              [H, ':', nn, " ", am]).toString();
        });
      }
    } else {
      final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: selectedTime,
          builder: (context, child) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                    // Using 12-Hour format
                    alwaysUse24HourFormat: true),
                // If you want 24-Hour format, just change alwaysUse24HourFormat to true
                child: child!);
          });
      if (picked != null) {
        setState(() {
          selectedTime = picked;
          _hour = selectedTime.hour.toString();
          _minute = selectedTime.minute.toString();
          _time = _hour + ' : ' + _minute;
          _timeController.text = _time;
          _timeController.text = formatDate(
              DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
              [hh, ':', nn, " ", am]).toString();
        });
      }
    }
  }

  modifEvent(var _event, String type) {
    if (type == 'new') {
      _matiereController.text = "";
      _typeController.text = "";
      _dateController.text = "";
      _timeController.text = "";
      _timeFinController.text = "";
    } else if (type == 'edit') {
      NeatCleanCalendarEvent event = _event;
      setState(() {
        _matiereController.text = event.description;
        _typeController.text = event.summary;
        _dateController.text =
            "${event.startTime.day} / ${event.startTime.month} / ${event.startTime.year}";
        _timeController.text =
            "${event.startTime.hour} : ${event.startTime.minute}";
        _timeFinController.text =
            "${event.endTime.hour} : ${event.endTime.minute}";
      });
    }
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text(
                type == "edit" ? "Modification du cour" : "Ajouter un cour",
                textAlign: TextAlign.center,
              ),
              content: SingleChildScrollView(
                child: Form(
                    child: Container(
                  child: Column(
                    children: [
                      // SizedBox(height: MediaQuery.of(context).size.width / 80),
                      type == "edit"
                          ? TextFormField(
                              controller: _matiereController,
                              enabled: type == 'edit' ? false : true,
                              decoration: InputDecoration(
                                  label: Text('Matière'),
                                  border: OutlineInputBorder()),
                            )
                          : SelectFormField(
                              type: SelectFormFieldType.dialog,
                              controller: _matiereController,
                              //initialValue: _initialValue,
                              // icon: Icon(Icons.format_shapes),
                              // labelText: 'Shape',
                              changeIcon: true,
                              dialogTitle: 'Sélectionner la matière',
                              dialogCancelBtn: 'Annuler',
                              enableSearch: true,
                              dialogSearchHint: 'Rechercher une matière',
                              items: _items,
                              decoration: InputDecoration(
                                  label: Text('Matière'),
                                  border: OutlineInputBorder()),
                              // onChanged: (val) => setState(() => _valueChanged = val),
                              // validator: (val) {
                              //   setState(() => _valueToValidate = val ?? '');
                              //   return null;
                              // },
                            ),
                      SizedBox(height: MediaQuery.of(context).size.height / 50),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery.of(context).size.width / 50),
                        child:
                            Text("Date du cours", textAlign: TextAlign.center),
                      ),
                      InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 0.7,
                          height: MediaQuery.of(context).size.height / 9,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: Colors.grey[200]),
                          child: TextFormField(
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width / 20.0),
                            textAlign: TextAlign.center,
                            enabled: false,
                            keyboardType: TextInputType.text,
                            controller: _dateController,
                            onSaved: (String? val) {
                              _setDate = val!;
                            },
                            decoration: const InputDecoration(
                                disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none),
                                // labelText: 'Date',
                                contentPadding: EdgeInsets.only(top: 0.0)),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 3.3,
                            child: Column(
                              children: [
                                Text("Heure de début",
                                    textAlign: TextAlign.center),
                                InkWell(
                                  onTap: () {
                                    _selectTime(context, 'debut');
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3.9,
                                    height:
                                        MediaQuery.of(context).size.height / 9,
                                    alignment: Alignment.center,
                                    decoration:
                                        BoxDecoration(color: Colors.grey[200]),
                                    child: TextFormField(
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                20.0,
                                      ),
                                      textAlign: TextAlign.center,
                                      onSaved: (String? val) {
                                        _setTime = val!;
                                      },
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      controller: _timeController,
                                      decoration: const InputDecoration(
                                          disabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide.none),
                                          // labelText: 'Heure',
                                          contentPadding: EdgeInsets.all(5)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(width: 10),
                          Container(
                            width: MediaQuery.of(context).size.width / 3.6,
                            child: Column(
                              children: [
                                Text("Heure de fin",
                                    textAlign: TextAlign.center),
                                InkWell(
                                  onTap: () {
                                    _selectTime(context, 'fin');
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3.9,
                                    height:
                                        MediaQuery.of(context).size.height / 9,
                                    alignment: Alignment.center,
                                    decoration:
                                        BoxDecoration(color: Colors.grey[200]),
                                    child: TextFormField(
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                20.0,
                                      ),
                                      textAlign: TextAlign.center,
                                      onSaved: (String? val) {
                                        _setTime = val!;
                                      },
                                      enabled: false,
                                      keyboardType: TextInputType.text,
                                      controller: _timeFinController,
                                      decoration: const InputDecoration(
                                          disabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide.none),
                                          // labelText: 'Heure',
                                          contentPadding: EdgeInsets.all(5)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )

                      //   ],
                      // )
                    ],
                  ),
                )),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 3.0,
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            _timeFinController.text;
                            selectedTimeFin.hour;
                            Map data = {
                              'dateDebut': DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      selectedTime.hour,
                                      selectedTime.minute)
                                  .toString(),
                              'dateFin': DateTime(
                                      selectedDate.year,
                                      selectedDate.month,
                                      selectedDate.day,
                                      selectedTimeFin.hour,
                                      selectedTimeFin.minute)
                                  .toString()
                            };

                            late Map result;
                            if (type == "new") {
                              data['matiere'] = _matiereController.text;
                              result = await Event.addEvent(data);
                            } else if (type == "edit") {
                              data['id'] = _event.location;
                              result = await Event.editEvent(data);
                            }
                            Widgets.mySnack(context, result['data'],
                                (result['code'] == 200) ? "success" : 'error');
                            if (result['code'] == 200) {
                              Timer(Duration(seconds: 3), () async {
                                Widgets.mySnack(
                                    context, result['data'], "success");
                                await Widgets.navigate(context, LoginMiddle());
                              });
                            } else {
                              Widgets.mySnack(context, result['data'], "error");
                              Navigator.pop(context);
                            }
                          },
                          child: Text("Enregistrer"),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 3.0,
                      child: Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red, // background
                            onPrimary: Colors.white, // foreground
                          ),
                          onPressed: () async {
                            var res = await Event.del(_event.location);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                res['data'],
                                textAlign: TextAlign.center,
                              ),
                              backgroundColor: (res['code'] == 200)
                                  ? Colors.green
                                  : Colors.red,
                            ));
                            if (res['code'] == 200) {
                              Timer(
                                  Duration(seconds: 3),
                                  await Widgets.navigate(
                                      context, LoginMiddle()));
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: Text("Supprimer"),
                        ),
                      ),
                    ),
                  ],
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height / 80.0,
                // )
              ],
            ));
  }

  getEvent() async {
    setState(() {
      load = true;
    });

    await Event.all().then((events) {
      setState(() {
        events.forEach((event) {
          _events[DateTime(event.dateDebut.year, event.dateDebut.month,
                      event.dateDebut.day)] ==
                  null
              ? _events[DateTime(event.dateDebut.year, event.dateDebut.month,
                  event.dateDebut.day)] = [
                  NeatCleanCalendarEvent(event.type,
                      startTime: DateTime(
                        event.dateDebut.year,
                        event.dateDebut.month,
                        event.dateDebut.day,
                        event.dateDebut.hour,
                        event.dateDebut.minute,
                      ),
                      endTime: DateTime(
                        event.dateFin.year,
                        event.dateFin.month,
                        event.dateFin.day,
                        event.dateFin.hour,
                        event.dateFin.minute,
                      ),
                      description: event.description,
                      location: "${event.id}",
                      color: event.type == 'cours' ? Colors.blue : Colors.red)
                ]
              : _events[DateTime(event.dateDebut.year, event.dateDebut.month,
                      event.dateDebut.day)]!
                  .add(
                  NeatCleanCalendarEvent(event.type,
                      startTime: DateTime(
                        event.dateDebut.year,
                        event.dateDebut.month,
                        event.dateDebut.day,
                        event.dateDebut.hour,
                        event.dateDebut.minute,
                      ),
                      endTime: DateTime(
                        event.dateFin.year,
                        event.dateFin.month,
                        event.dateFin.day,
                        event.dateFin.hour,
                        event.dateFin.minute,
                      ),
                      location: "Etoile",
                      color: event.type == 'cours' ? Colors.blue : Colors.red),
                );
        });
      });
    });

    setState(() {
      load = false;
    });
  }

  getData() async {
    List<Matiere> matieres = await Matiere.all();
    var _userRole = await Widgets.getPref("role");
    setState(() {
      userRole = _userRole;
    });

    for (var matiere in matieres) {
      _items.add({
        'value': matiere.id,
        'label': matiere.libelle,
        'icon': Icon(Icons.menu_book_sharp),
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
    getEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendrier"),
        centerTitle: true,
        leading: HiddenDrawerIcon(
          backIcon: null,
          mainIcon: Icon(Icons.menu),
        ),
      ),
      body: load
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              minimum:
                  EdgeInsets.only(top: MediaQuery.of(context).size.width / 50),
              top: true,
              child: Calendar(
                startOnMonday: true,
                weekDays: const [
                  'Lundi',
                  'Mardi',
                  'Mercredi',
                  'Jeudi',
                  'Vendredi',
                  'Samedi',
                  'Dimanche'
                ],
                events: _events,
                isExpandable: true,
                eventDoneColor: Colors.green,
                selectedColor: Colors.blue,
                todayColor: Colors.blue,
                eventColor: Colors.grey,
                locale: 'fr_Fr',
                todayButtonText: 'Aujourd\'hui',
                isExpanded: true,
                onEventSelected: (value) {
                  if (userRole == "responssable") {
                    modifEvent(value, 'edit');
                  }
                },
                expandableDateFormat: 'EEEE, dd. MMMM yyyy',
                dayOfWeekStyle: TextStyle(
                    color: Colors.white,
                    // fontWeight: FontWeight.w800,
                    fontSize: 11),
              ),
            ),
      floatingActionButton: (userRole == "responssable")
          ? FloatingActionButton(
              onPressed: () async {
                // NeatCleanCalendarEvent _event;
                modifEvent('_event', 'new');
              },
              child: const Icon(Icons.add),
              backgroundColor: Colors.blue,
              // ),
            )
          : null,
    );
  }
}
