import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utils/responsiveSise.dart';
import '../../../../../utils/widgets/customText.dart';
import '../../../../cart/data/cartModel.dart';
import '../../../../cart/presentation/manager/addToCart.dart';
import '../../manager/deleteItemFromFavorite.dart';

class CustomFavoriteItem extends StatelessWidget {
  const CustomFavoriteItem({super.key, required this.productt, this.scaffoldMessenger, required this.docId, required this.cartId});
  final dynamic productt;
  final String cartId;
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
                  imageUrl: productt['image'],
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
                            text: productt['title']),
                        SizedBox(height: 5,),
                        CustomText(
                            fontSize: 20,
                            height: 1.4,
                            maxLines: 3,
                            color: Colors.blueGrey,
                            text: 'Price: ${productt['price']} GBP'),
                      ],
                    )),
                SizedBox(width: 12,),
                Column(
                  children: [
                    BlocProvider<DeleteProductFromFavoriteCubit>(
                      create:(context)=>DeleteProductFromFavoriteCubit () ,
                      child: BlocConsumer<DeleteProductFromFavoriteCubit, DeleteProductFromFavoriteStates>(
                        listener: (context, state){
                        },
                        builder: (context, state){
                          if(state is LoadingDeleteProductFromFavoriteState){
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
                                  context.read<DeleteProductFromFavoriteCubit>().deleteFromCart(FirebaseAuth.instance.currentUser!.uid, docId, context, scaffoldMessenger);
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
                    ),
                    // IconButton(onPressed: (){}, icon: Icon(Icons.delete_forever , color: Colors.green,)),
                    SizedBox(height: 50,),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection(cartId)
                            .snapshots(),
                        builder: (context, state) {
                          if(state.hasData){
                            List<dynamic> items = [];
                            for(int i=0; i<state.data!.docs.length; i++){
                              items.add(state.data!.docs[i]['id']);
                            }
                            return !items.contains(productt['id']) ?BlocProvider(
                              create: (context) => AddProductToCartCubit(),
                              child: BlocConsumer<AddProductToCartCubit,
                                  AddProductToCartStates>(
                                listener: (context, state) {
                                },
                                builder: (context, state) {
                                  if (state is InitAddProductToCartState) {
                                    return GestureDetector(
                                        onTap: () {
                                          CartModel product = CartModel(id: productt['id'], title: productt['title'], price: productt['price'], category: productt['category'], description: productt['description'], image: productt['image'], quntity: 1);

                                          context
                                              .read<AddProductToCartCubit>()
                                              .addToCart(product, context,
                                              scaffoldMessenger);
                                        },
                                        child: Icon(Icons.add_shopping_cart_outlined)
                                    );
                                  } else if (state is LoadingAddProductToCartState) {
                                    return SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: FittedBox(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                          backgroundColor: Colors.grey.shade300,
                                        ),
                                      ),
                                    );
                                  } else if (state is SuccessAddProductToCartState) {
                                    return SizedBox();
                                  }

                                  else {
                                    return SizedBox();
                                  }
                                },
                              ),
                            ) : SizedBox();
                          }else if(state.connectionState == ConnectionState.waiting){
                            return SizedBox(
                              height: 20,
                              width: 20,
                              child: FittedBox(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                  backgroundColor: Colors.grey.shade300,
                                ),
                              ),
                            );
                          }
                          else{
                            return SizedBox();
                          }


                        })

                  ],
                ),
              ],
            ),
            Divider(
              height: 40,
            ),


          ],
        ),

      ],
    );
  }
}