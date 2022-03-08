import 'package:flutter/material.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/models/Product.dart';

import '../../../size_config.dart';
import 'section_title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class PopularProducts extends StatelessWidget {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final String documentId;

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('products');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text("Full Name: ${data['full_name']} ${data['last_name']}");
        }

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: SectionTitle(title: "Popular Products", press: () {}),
            ),
            SizedBox(height: getProportionateScreenWidth(20)),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...List.generate(
                    demoProducts.length,
                    (index) {
                      if (demoProducts[index].isPopular)
                        return ProductCard(product: demoProducts[index]);

                      return SizedBox
                          .shrink(); // here by default width and height is 0
                    },
                  ),
                  SizedBox(width: getProportionateScreenWidth(20)),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
