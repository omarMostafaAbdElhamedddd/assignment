import 'dart:io';

import 'package:assignment/features/auth/userAuth/login/liginView.dart';
import 'package:assignment/features/cart/data/cartModel.dart';
import 'package:assignment/features/cart/presentation/manager/addToCart.dart';
import 'package:assignment/features/cart/presentation/view/cartView.dart';
import 'package:assignment/features/detailsView/presentation/view/detailsView.dart';
import 'package:assignment/features/favorite/presentation/manager/addToFavorite.dart';
import 'package:assignment/features/favorite/presentation/view/favoriteView.dart';
import 'package:assignment/utils/widgets/customSnakBAr.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utils/responsiveSise.dart';
import '../../../../../utils/widgets/customText.dart';
import '../../../data/productModel.dart';

class CustomProduct extends StatelessWidget {
  const CustomProduct(
      {super.key,
      required this.productModel,
      this.scaffoldMessenger,
      required this.cartId});

  final ProductModel productModel;

  final dynamic scaffoldMessenger;
  final String cartId;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            Navigator.push(context,
                PageRouteBuilder(pageBuilder: (context, an, sc) {
              return DetailsView(
                cartId: cartId,
                productModel: productModel,
              );
            }));
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: '${productModel.id}',
                  child: Center(
                    child: CachedNetworkImage(
                      height: SizeConfig.screenHeight! * .2,
                      imageUrl: productModel.image,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                        strokeWidth: 2,
                        backgroundColor: Colors.blueGrey,
                        value: downloadProgress.progress,
                        color: Colors.green,
                      )),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                CustomText(
                  text: productModel.title,
                  maxLines: 3,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7, bottom: 15),
                  child: CustomText(
                    text: '${productModel.price} GBP',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                       return !items.contains(productModel.id) ?BlocProvider(
                         create: (context) => AddProductToCartCubit(),
                         child: BlocConsumer<AddProductToCartCubit,
                             AddProductToCartStates>(
                           listener: (context, state) {
                           },
                           builder: (context, state) {
                             if (state is InitAddProductToCartState) {
                               return GestureDetector(
                                 onTap: () {
                                   CartModel product = CartModel(id: productModel.id, title: productModel.title, price: productModel.price, category: productModel.category, description: productModel.description, image: productModel.image, quntity: 1);

                                   context
                                       .read<AddProductToCartCubit>()
                                       .addToCart(product, context,
                                       scaffoldMessenger);
                                 },
                                 child: Container(
                                   padding: EdgeInsets.symmetric(vertical: 7),
                                   margin: EdgeInsets.symmetric(horizontal: 12),
                                   decoration: BoxDecoration(
                                       border: Border.all(
                                           color: Colors.green, width: .5),
                                       borderRadius: BorderRadius.circular(8)),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       Icon(
                                         Icons.card_travel_rounded,
                                         size: 20,
                                         color: Colors.green,
                                       ),
                                       SizedBox(
                                         width: 4,
                                       ),
                                       CustomText(
                                         text: 'Add to cart',
                                         color: Colors.green,
                                       ),
                                     ],
                                   ),
                                 ),
                               );
                             } else if (state is LoadingAddProductToCartState) {
                               return Container(
                                 padding: EdgeInsets.symmetric(vertical: 7),
                                 margin: EdgeInsets.symmetric(horizontal: 12),
                                 decoration: BoxDecoration(
                                     color: Colors.green,
                                     borderRadius: BorderRadius.circular(8)),
                                 child: Center(
                                   child: SizedBox(
                                     height: 20,
                                     width: 20,
                                     child: FittedBox(
                                       child: CircularProgressIndicator(
                                         strokeWidth: 2,
                                         color: Colors.white,
                                         backgroundColor: Colors.grey.shade300,
                                       ),
                                     ),
                                   ),
                                 ),
                               );
                             } else if (state is SuccessAddProductToCartState) {
                               return GestureDetector(
                                 onTap: () {
                                   Navigator.push(context, PageRouteBuilder(
                                       pageBuilder: (context, an, sc) {
                                         return CartView(cartId: cartId,);
                                       }));
                                 },
                                 child: Container(
                                   padding: EdgeInsets.symmetric(vertical: 7),
                                   margin: EdgeInsets.symmetric(horizontal: 12),
                                   decoration: BoxDecoration(
                                       border: Border.all(
                                           color: Colors.green, width: .5),
                                       borderRadius: BorderRadius.circular(8)),
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       Icon(
                                         Icons.card_travel_rounded,
                                         size: 20,
                                         color: Colors.green,
                                       ),
                                       SizedBox(
                                         width: 4,
                                       ),
                                       CustomText(
                                         text: 'Go to cart',
                                         color: Colors.green,
                                       ),
                                     ],
                                   ),
                                 ),
                               );
                             }

                             else {
                               return SizedBox();
                             }
                           },
                         ),
                       ) : GestureDetector(
                         onTap: () {
                           Navigator.push(context, PageRouteBuilder(
                               pageBuilder: (context, an, sc) {
                                 return CartView(cartId: cartId,);
                               }));
                         },
                         child: Container(
                           padding: EdgeInsets.symmetric(vertical: 7),
                           margin: EdgeInsets.symmetric(horizontal: 12),
                           decoration: BoxDecoration(
                               border: Border.all(
                                   color: Colors.green, width: .5),
                               borderRadius: BorderRadius.circular(8)),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               Icon(
                                 Icons.card_travel_rounded,
                                 size: 20,
                                 color: Colors.green,
                               ),
                               SizedBox(
                                 width: 4,
                               ),
                               CustomText(
                                 text: 'Go to cart',
                                 color: Colors.green,
                               ),
                             ],
                           ),
                         ),
                       );
                     }else if(state.connectionState == ConnectionState.waiting){
                       return  Container(
                         padding: EdgeInsets.symmetric(vertical: 7),
                         margin: EdgeInsets.symmetric(horizontal: 12),
                         decoration: BoxDecoration(
                             color: Colors.green,
                             borderRadius: BorderRadius.circular(8)),
                         child: Center(
                           child: SizedBox(
                             height: 20,
                             width: 20,
                             child: FittedBox(
                               child: CircularProgressIndicator(
                                 strokeWidth: 2,
                                 color: Colors.white,
                                 backgroundColor: Colors.grey.shade300,
                               ),
                             ),
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
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: InkWell(
            onTap: (){
              if(FirebaseAuth.instance.currentUser?.uid==null){
                showDialog(context: context, builder:(context){
                  return AlertDialog(
                    backgroundColor: Colors.grey.shade100,
                    content: Column(
                      mainAxisSize:MainAxisSize.min,
                      children: [
                        CustomText(
                          textAlign: TextAlign.center,
                          fontSize: 20,
                          text: 'You do not have account, please login to add to favorite', maxLines: 5,),
                         SizedBox(height: 50,),
                        Row(
                          children: [
                            Expanded(child: GestureDetector(
                              onTap: (){
                                Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context,an,sc){
                                  return LoginView();
                                }));
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(8)

                                ),child: Center(child: CustomText(text: 'Login',color: Colors.white,)),),
                            )),
                            SizedBox(width: 20,),
                            Expanded(child: GestureDetector(

                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.green)

                                ),child: Center(child: CustomText(text: 'Continue',color: Colors.green,)),),
                            ))

                          ],
                        ),
                      ],
                    ),
                  );
                });
              }
            },
            child:
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, statee) {
                  if(statee.hasData){
                    List<dynamic> items = [];
                    for(int i=0; i<statee.data!.docs.length; i++){
                      items.add(statee.data!.docs[i]['id']);
                    }
                    return !items.contains(productModel.id) ?BlocProvider(
                      create: (context) => AddProductToFavoriteCubit(),
                      child: BlocConsumer<AddProductToFavoriteCubit,
                          AddProductToFavoriteStates>(
                        listener: (context, state) {

                          if(state is SuccessAddProductToFavoriteState){
                            MySanckBar.snackBar('Success', scaffoldMessenger);
                          }
                        },
                        builder: (context, state) {
                          if (state is InitAddProductToFavoriteState) {
                            return GestureDetector(
                              onTap: () {


                                context
                                    .read<AddProductToFavoriteCubit>()
                                    .addToCart(productModel, context,
                                    scaffoldMessenger);
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.grey.shade100,
                                child: Center(
                                  child: Icon(
                                    Icons.favorite_border_rounded,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            );
                          }

                          else if (state is LoadingAddProductToFavoriteState) {
                            return  CircleAvatar(
                              backgroundColor: Colors.grey.shade100,
                              child: Center(
                                child: Icon(
                                  Icons.favorite_border_rounded,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          } else if (state is SuccessAddProductToFavoriteState) {
                            return GestureDetector(
                              onTap: () async{
                                Navigator.push(context, PageRouteBuilder(pageBuilder: (context,an,sc){
                                  return FavoriteView(cartId:cartId);
                                }));
                              },
                              child:  CircleAvatar(
                                backgroundColor: Colors.grey.shade100,
                                child: Center(
                                  child: Icon(
                                    Icons.favorite,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                            );
                          }

                          else {
                            return SizedBox();
                          }
                        },
                      ),
                    ) :  GestureDetector(
                      onTap: (){
                        Navigator.push(context, PageRouteBuilder(pageBuilder: (context,an,sc){
                          return FavoriteView(cartId:cartId);
                        }));
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey.shade100,
                        child: Center(
                          child: Icon(

                            Icons.favorite,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    );
                  }else if(statee.connectionState == ConnectionState.waiting){
                    return  SizedBox(
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

          ),
        ),
      ],
    );
  }
}
