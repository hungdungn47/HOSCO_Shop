import 'package:flutter/material.dart';
import 'package:hosco_shop_2/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../../models/product.dart';

class BestSellingItemCard extends StatelessWidget {
  BestSellingItemCard({super.key, required this.product});
  final dynamic product;

  final TextStyle fieldNameTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w300
  );
  final TextStyle boldText = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold
  );
  final TextStyle blueBoldText = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: primaryColor
  );
  final TextStyle italicLightText = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic
  );
  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                  color: primaryColor,
                  blurRadius: 3,
                  spreadRadius: 1
              )
            ]
        ),
        child: Row(
          children: [
            Container(
                padding: const EdgeInsets.all(2.0),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border(right: BorderSide(color: primaryColor, width: 1)),
                  // borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: CachedNetworkImage(
                  imageUrl: product['imageUrl'],
                  placeholder: (context, url) => Center(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text( product['name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: boldText,),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Giá", style: fieldNameTextStyle,),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text( NumberFormat.decimalPattern().format(product['price']), maxLines: 1, overflow: TextOverflow.ellipsis, style: boldText,),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Đã bán", style: fieldNameTextStyle,),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text( '${product['totalSold']}', maxLines: 1, overflow: TextOverflow.ellipsis, style: blueBoldText,),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
