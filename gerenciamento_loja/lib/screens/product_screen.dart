import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/blocs/products_bloc.dart';


class ProductScreen extends StatefulWidget {
  String categoryId;
  final DocumentSnapshot product;



  ProductScreen({this.categoryId, this.product});


  @override
  _ProductScreenState createState() => _ProductScreenState(categoryId, product);
}

class _ProductScreenState extends State<ProductScreen> {

  final ProductBloc _productBloc;

final _formKey = GlobalKey<FormState>();

_ProductScreenState(String categoryId, DocumentSnapshot product) :
   _productBloc = ProductBloc(categoryId: categoryId, product: product);

  @override
  Widget build(BuildContext context) {

     InputDecoration _buildDecoration(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey)
      );
    }

    final _fieldStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
    );


    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        elevation: 0,
        title: Text("Criar Produto"),
        actions: <Widget> [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {},
          ),
        ]
      ),
      body: Form(
        key: _formKey,
        child: StreamBuilder <Map> (
          stream: _productBloc.outData,
          builder: (context, snapshot) {
            if(!snapshot.hasData) return Container();
            return ListView(
          padding: EdgeInsets.all(16),
          children: <Widget> [ 
            TextFormField(
              initialValue: snapshot.data["title"],
              style: _fieldStyle,
              decoration: _buildDecoration("Título"),
              onSaved: (t) {},
              validator: (t) {},
            ),
              TextFormField(
              initialValue: snapshot.data["description"],
                style: _fieldStyle,
                maxLines: 6,
                decoration: _buildDecoration("Descrição"),
                onSaved: (t) {},
                validator: (t) {},
              ),
            TextFormField(
              initialValue: snapshot.data["price"]?.toStringAsFixed(2),
                style: _fieldStyle,
                decoration: _buildDecoration("Preço"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSaved: (t) {},
                validator: (t) {},
              ),
          ]
        );
          }
        )
      )
    );
  }
}