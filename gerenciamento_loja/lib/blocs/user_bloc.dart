import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase {

  final _usersController = BehaviorSubject<List>();

  Stream<List> get outUsers => _usersController.stream;
  
  Map<String, Map<String, dynamic>> _users = {};

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserBloc() {
    _addUserListener();
  }

  void onChangedSearch(String search) {
    if(search.trim().isEmpty){
      _usersController.add(_users.values.toList());
    } else {
      _usersController.add(_filter(search.trim()));
    }
  }

  List<Map<String, dynamic>> _filter(String search) {
    List<Map<String, dynamic>> filteredUsers = List.from(_users.values.toList());

    filteredUsers.retainWhere((user){
      return user["name"].toUpperCase().contains(search.toUpperCase());
    });

    return filteredUsers;
  }

  void _addUserListener() {
    _firestore.collection("users").snapshots().listen((snapshot){
      snapshot.docChanges.forEach((change){

        String uid = change.doc.id;

        switch(change.type) {
          case DocumentChangeType.added:
          _users[uid] = change.doc.data();
          _subscribeToOrders(uid);
          break;
          case DocumentChangeType.modified:
          _users[uid].addAll(change.doc.data());
          _usersController.add(_users.values.toList());
          break;
          case DocumentChangeType.removed:
          _users.remove(uid);
          _unsubscribeToOrders(uid);
          _usersController.add(_users.values.toList());
          break;
        }
      });
    });
  }

  void _subscribeToOrders(String uid) {
    _users[uid]["subscription"] = _firestore.collection("users").doc(uid).collection("orders").snapshots().listen((orders) async {

      int numOrders = orders.docs.length;

      double money = 0.0;

      for(DocumentSnapshot d in orders.docs) {
        DocumentSnapshot<Map<String, dynamic>> order = await _firestore.collection("orders").doc(d.id).get();

        if(order.data == null) continue; //ignora a parte a seguir e volta para a parte de cima 

        money += order.data()["totalPrice"];
      }

      _users[uid].addAll(
        {"money" : money, "orders": numOrders} 
      );

      _usersController.add(_users.values.toList());
    });
  }

  Map<String,dynamic> getUser(String uid) {
    return _users[uid];
  }

  void _unsubscribeToOrders(String uid) {
    _users[uid]["subscription"].cancel();
  }

  @override 
  void dispose() {
    _usersController.close();
    super.dispose();
  }
}