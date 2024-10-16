
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utils/responsiveSise.dart';
import '../../../../../utils/widgets/customText.dart';
import '../../manager/deleteProductFromCart.dart';

class CustomCartItem extends StatelessWidget {
  const CustomCartItem({super.key, required this.product, required this.cartId, this.scaffoldMessenger, required this.docId});
  final dynamic product;
  final String cartId ;
  final String docId;
  final dynamic scaffoldMessenger;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Row(
              children: [
                CachedNetworkImage(
                  height: SizeConfig.screenHeight! * .13,
                  width:
                  SizeConfig.screenWidth!*.2,
                  imageUrl: product['image'],
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(child: CircularProgressIndicator(
                        strokeWidth: 2,
                        backgroundColor: Colors.blueGrey,
                        value: downloadProgress.progress , color: Colors.green,)),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                SizedBox(width: 16,),
                Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5,),
                        CustomText(
                            fontSize: 16,
                            maxLines: 3,
                            text: product['title']),
                        SizedBox(height: 5,),
                        CustomText(
                            fontSize: 20,
                            height: 1.4,
                            maxLines: 3,
                            color: Colors.blueGrey,
                            text: 'Price: ${product['price']} GBP'),
                      ],
                    )),
                SizedBox(width: 50,),
              ],
            ),
            Divider(
              height: 40,
            ),
            Row(
              children: [
                CustomText(
                  letterSpacing: 1.2,
                  text: 'Total:${product['price'] * product['quntity']}GBP',
                  fontSize: 18,
                  color: Colors.green,
                ),
                Spacer(),
                IntrinsicHeight(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: product['quntity'] > 1 ? () async {
                              int current =  product['quntity']-1;
                              await FirebaseFirestore.instance.collection(cartId).doc(docId).update({
                                'quntity' : current,

                              });

                            } : null,
                            icon: Icon(
                              Icons.remove,
                              color: Colors.black.withOpacity(.5),
                            )),
                        VerticalDivider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: CustomText(
                            text: product['quntity'].toString(),
                            fontSize: 20,
                          ),
                        ),
                        VerticalDivider(),
                        IconButton(
                            onPressed: () async {
                              int current =  product['quntity']+1;
                              await FirebaseFirestore.instance.collection(cartId).doc(docId).update({
                                'quntity' : current,

                              });

                            },
                            icon: Icon(Icons.add,
                                color: Colors.black.withOpacity(.5))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              height: 20,
            ),
          ],
        ),

        Positioned(
            right: 0,
            child: BlocProvider<DeleteProductFromCartCubit>(
              create:(context)=> DeleteProductFromCartCubit() ,
              child: BlocConsumer<DeleteProductFromCartCubit, DeleteProductFromCartStates>(
                listener: (context, state){
                },
                builder: (context, state){
                  if(state is LoadingDeleteProductFromCartState){
                    return SizedBox(
                      height: 25,
                      width: 25,
                      child: FittedBox(child:CircularProgressIndicator(
                        backgroundColor: Colors.grey.shade300,
                        strokeWidth: 3,
                        color: Colors.green,),),
                    );
                  }else{
                    {
                      return InkWell(
                        onTap: () async{
                          context.read<DeleteProductFromCartCubit>().deleteFromCart(cartId, docId, context, scaffoldMessenger);
                        },
                        child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle
                            ),
                            child: Icon(Icons.delete_forever , color: Colors.red,)),
                      );
                    }
                  }
                },
              ),
            ))
      ],
    );
  }
}