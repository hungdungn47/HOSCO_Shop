import 'package:flutter/material.dart';
import 'package:hosco_shop_2/utils/constants.dart';

import '../../models/product.dart';

class ItemCard extends StatelessWidget {
  ItemCard({super.key, required this.product});
  final Product product;

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
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 3,
            color: primaryColor,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 3,
              spreadRadius: 2
            )
          ]
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: primaryColor, width: 1)),
                // borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Image.asset(
                product.imageUrl,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Sản phẩm", style: fieldNameTextStyle,),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text( product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: boldText,),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Giá", style: fieldNameTextStyle,),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text( '${product.price}', maxLines: 1, overflow: TextOverflow.ellipsis, style: boldText,),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Số lượng", style: fieldNameTextStyle,),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text( '${product.stockQuantity}', maxLines: 1, overflow: TextOverflow.ellipsis, style: blueBoldText,),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Phân loại", style: fieldNameTextStyle,),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text( product.category, maxLines: 1, overflow: TextOverflow.ellipsis, style: italicLightText,),
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
