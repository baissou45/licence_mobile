import 'dart:convert';

import 'package:licence_mobile/model/user.dart';
import 'package:licence_mobile/service/api.dart';

class Vote {
  late int id;
  late Map votes;

  Vote({required this.id, required this.votes});

  static Vote fromjson(var json) {
    return Vote(
      id: json['id'],
      votes: jsonDecode(json['votes']),
    );
  }

  votants() async {
    List listVotant = [];
    List vontantsVotes = [];

    votes.forEach((key, value) async {
      vontantsVotes.add(key);
    });

    for (var vontantsVote in vontantsVotes) {
      listVotant.add({'user': await User.find(int.parse(vontantsVote))});
    }

    votes.forEach((key, value) {
      for (int i = 0; i < listVotant.length; i++) {
        if (listVotant[i]['user'].id == int.parse(key)) {
          listVotant[i]['votes'] = value;
        }
      }
    });

    return listVotant;
  }

  static get() async {
    var result = await Api.get("votes/getVote", promo: true);
    Vote vote = Vote.fromjson(result);
    return vote;
  }

  static postuler() async {
    User user = await User.authUser();
    Vote vote = await Vote.get();
    vote.votes[user.id.toString()] = "1";
    var result = await Api.post(
        {'vote': jsonEncode(vote.votes), 'id': vote.id.toString()},
        'votes/voter');

    return result;
  }

  static getVotes() async {
    Vote vote = await Vote.get();
    List votants = await vote.votants();

    return votants;
  }

  static voter(int id) async {
    Vote vote = await Vote.get();

    print(vote.votes);
    vote.votes[id.toString()] =
        (int.parse(vote.votes[id.toString()]) + 1).toString();
    print(vote.votes);
    var result = await Api.post(
        {'vote': jsonEncode(vote.votes), 'id': vote.id.toString()},
        'votes/voter');

    return result;
  }

  static stat() async {
    var postulant;
    int votes = 0;
    User user = await User.authUser();
    List votants = await Vote.getVotes();
    votants.sort((b, a) => (a['votes']).compareTo(b['votes']));
    for (int i = 0; i < votants.length; i++) {
      if (votants[i]['user'].id == user.id) {
        votants[i]['rang'] = i;
        postulant = votants[i];
      }
      votes += int.parse(votants[i]['votes']);
    }
    postulant['total'] = votes;

    return postulant;
  }
}
