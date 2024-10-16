
import 'package:assignment/features/cart/data/cartModel.dart';
import 'package:assignment/features/cart/presentation/manager/addToCart.dart';
import 'package:assignment/features/home/data/productModel.dart';
import 'package:assignment/features/payment/presentation/view/paymentView.dart';
import 'package:assignment/utils/responsiveSise.dart';
import 'package:assignment/utils/widgets/customText.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/widgets/customSnakBAr.dart';
import '../../../cart/presentation/view/cartView.dart';
import '../../../favorite/presentation/manager/addToFavorite.dart';
import '../../../favorite/presentation/view/favoriteView.dart';
class DetailsView extends StatefulWidget {
  const DetailsView({super.key, required this.productModel, required this.cartId});
final ProductModel productModel ;
final String cartId;
  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessenger = GlobalKey();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ScaffoldMessenger(
      key:scaffoldMessenger ,
      child: Scaffold(

        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back , color: Colors.green,),
          ),

        ),

        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: 40 , top: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Hero(
                            tag: '${widget.productModel.id}',
                            child: Center(child: InteractiveViewer(child: CachedNetworkImage(
                              width: SizeConfig.screenWidth! * .9,
                              imageUrl: widget.productModel.image , height: SizeConfig.screenHeight!*.4,))),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          bottom: 10,
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection(FirebaseAuth.instance.currentUser!.uid)
                                  .snapshots(),
                              builder: (context, statee) {
                                if(statee.hasData){
                                  List<dynamic> items = [];
                                  for(int i=0; i<statee.data!.docs.length; i++){
                                    items.add(statee.data!.docs[i]['id']);
                                  }
                                  return !items.contains(widget.productModel.id) ?BlocProvider(
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
                                                  .addToCart(widget.productModel, context,
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
                                                return FavoriteView(cartId:widget.cartId);
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
                                        return FavoriteView(cartId:widget.cartId);
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


                              }),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [


                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: CustomText(text: widget.productModel.category),
                          ),

                          CustomText(text: widget.productModel.title , color: Colors.black,fontSize: 16,maxLines: 10,),
                          Row(
                            children: [
                              CustomText(text: 'Price', fontSize: 20,),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: CustomText(text: '${widget.productModel.price} GBP' , fontSize: 22,),
                              ),
                            ],
                          ),

                          CustomText(text: '${widget.productModel.description}' , maxLines: 20,)
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            ),

             Container(
               decoration: BoxDecoration(
                 color: Colors.white
               ),

               child: Column(
                 children: [
                   Divider(),


                   SizedBox(height: 10,),
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 10),
                     child: Row(
                       children: [
                         Expanded(
                           child: GestureDetector(
                             onTap: (){
                               Navigator.push(context, PageRouteBuilder(pageBuilder: (context, an,sc){
                                 return PaymentView();
                               }));
                             },
                             child: Container(
                         padding: EdgeInsets.symmetric(vertical: 8),
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(8),
                                 border: Border.all(color: Colors.green)
                               ),
                               child: Center(child: CustomText(text: 'Buy now',color: Colors.green,),),
                             ),
                           ),
                         ),
                         SizedBox(width: 16,),
                         Expanded(
                          child:    StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection(widget.cartId)
                                  .snapshots(),
                              builder: (context, state) {
                                if(state.hasData){
                                  List<dynamic> items = [];
                                  for(int i=0; i<state.data!.docs.length; i++){
                                    items.add(state.data!.docs[i]['id']);
                                  }
                                  return !items.contains(widget.productModel.id) ?BlocProvider(
                                    create: (context) => AddProductToCartCubit(),
                                    child: BlocConsumer<AddProductToCartCubit,
                                        AddProductToCartStates>(
                                      listener: (context, state) {

                                      },
                                      builder: (context, state) {
                                        if (state is InitAddProductToCartState) {
                                          return GestureDetector(
                                            onTap: () {
                                              CartModel product = CartModel(id: widget.productModel.id, title: widget.productModel.title, price: widget.productModel.price, category: widget.productModel.category, description: widget.productModel.description, image: widget.productModel.image, quntity: 1);
                                              context
                                                  .read<AddProductToCartCubit>()
                                                  .addToCart(product, context,
                                                  scaffoldMessenger);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 7),
                                              margin: EdgeInsets.symmetric(horizontal: 12),
                                              decoration: BoxDecoration(
                                            color: Colors.green,
                                                  borderRadius: BorderRadius.circular(8)),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.card_travel_rounded,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  CustomText(
                                                    text: 'Add to cart',
                                                    color: Colors.white,
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
                                                    return CartView(cartId: widget.cartId,);
                                                  }));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(vertical: 7),
                                              margin: EdgeInsets.symmetric(horizontal: 12),
                                              decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius: BorderRadius.circular(8)),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.card_travel_rounded,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  CustomText(
                                                    text: 'Go to cart',
                                                    color: Colors.white,
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
                                            return CartView(cartId: widget.cartId,);
                                          }));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 7),
                                      margin: EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                      color: Colors.green,
                                          borderRadius: BorderRadius.circular(8)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.card_travel_rounded,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          CustomText(
                                            text: 'Go to cart',
                                            color: Colors.white,
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


                              }),
                         ),
                       ],
                     ),
                   ),
                   SizedBox(height: 8,),
                 ],
               ),
             ),




          ],
        ),
      ),
    );
  }
}
