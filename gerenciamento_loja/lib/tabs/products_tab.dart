import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/widgets/category_tile.dart';

class ProductsTab extends StatefulWidget {

  @override
  _ProductsTabState createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection("products").snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData) return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
            backgroundColor: Colors.transparent,
          )
        );
        return ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            return CategoryTile(snapshot.data.docs[index]);
          }
        );
      }   
       );
  }

  @override  
  bool get wantKeepAlive => true;
}