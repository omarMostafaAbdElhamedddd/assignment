import 'package:assignment/features/cart/presentation/manager/addToCart.dart';
import 'package:assignment/features/cart/presentation/manager/deleteProductFromCart.dart';
import 'package:assignment/features/cart/presentation/view/widgets/customItemCart.dart';
import 'package:assignment/features/home/data/productModel.dart';
import 'package:assignment/utils/responsiveSise.dart';
import 'package:assignment/utils/widgets/customButton.dart';
import 'package:assignment/utils/widgets/customText.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/widgets/customSnakBAr.dart';
import '../../../detailsView/presentation/view/detailsView.dart';
import '../../../payment/presentation/view/paymentView.dart';
import '../manager/getCartProducts.dart';
import '../manager/getCartProductsStates.dart';

class CartView extends StatefulWidget {
  const CartView({super.key, required this.cartId});
final String cartId ;
  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
GlobalKey<ScaffoldMessengerState> scaffoldMessenger = GlobalKey();
   // late String cartId ;
  @override
  void initState() {
    // getCartId();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: ScaffoldMessenger(
        key: scaffoldMessenger,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.green,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  CustomText(
                    text: 'Cart',
                    color: Colors.green,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  Spacer(),

                  Badge(
                      label: StreamBuilder(stream: FirebaseFirestore.instance.collection(widget.cartId).snapshots(),
                        builder: (context, state){
                          if(state.hasData){
                            return Text('${state.data!.docs.length}' , style: TextStyle(
                                color: Colors.white ,
                                fontWeight: FontWeight.w500,
                                fontSize: 12
                            ),);
                          }else{
                            return SizedBox();
                          }
                        },),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.card_travel_rounded,
                          color: Colors.grey,
                        ),
                      )),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              Divider(),
             Expanded(child: StreamBuilder(
               stream: FirebaseFirestore.instance.collection(widget.cartId).snapshots(),
               builder: (context, state){
                 if(state.connectionState == ConnectionState.waiting){
                   return Center(child: CircularProgressIndicator(color: Colors.green , backgroundColor: Colors.grey.shade300,),);
                 }else if(state.hasData){
                   if(state.data!.docs.isEmpty){
                     return Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                      Image.asset('assets/images/cartt.JPG' ,height: 150,),
                         CustomText(text: 'Your cart is empty!' , fontSize: 20,),
                           SizedBox(height: 20,),
                           InkWell(
                               onTap: (){
                                 Navigator.pop(context);
                               },
                               child: CustomText(text: 'Shopping now' , fontSize: 20,decoration: TextDecoration.underline,color: Colors.green,))
                       ],
                     );
                   }
                   return ListView.builder(
                     padding: EdgeInsets.symmetric(horizontal: 16 , vertical: 10),
                       itemCount: state.data!.docs.length,
                       itemBuilder: (context, index){
                     return GestureDetector(
                         onTap: (){
                           dynamic data = state.data!.docs[index];
                           ProductModel productModel =  ProductModel(id: data['id'], title: data['title'], price: data['price'], category: data['category'], description: data['description'], image: data['image']);
                           Navigator.push(context,
                               PageRouteBuilder(pageBuilder: (context, an, sc) {
                                 return DetailsView(
                                   cartId: widget.cartId,
                                   productModel: productModel,
                                 );
                               }));
                         },
                         child: CustomCartItem(product : state.data!.docs[index] , cartId: widget.cartId, docId: state.data!.docs[index].id,scaffoldMessenger: scaffoldMessenger,));
                   });
                 }else{
                   return Center(child: CustomText(text: 'Something went wrong',),);
                 }
               },
             )),

             StreamBuilder(stream: FirebaseFirestore.instance.collection(widget.cartId).snapshots(), builder: (context, state){
               if(state.hasData){

                 if(state.data!.docs.isEmpty){
                   return SizedBox();
                 }else{
                   double total = 0.0;
                   for(int i=0 ; i<state.data!.docs.length;i++){
                     total += state.data!.docs[i]['price'] * state.data!.docs[i]['quntity'];
                   }
                   return  Container(
                     padding: EdgeInsets.symmetric(
                         horizontal: 16,
                         vertical: 10
                     ),
                     decoration: BoxDecoration(
                         color: Colors.grey.shade100,
                         borderRadius: BorderRadius.circular(8)
                     ),

                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [

                         CustomText(text: 'Order details ' , fontSize: 20,height: 2,),
                         SizedBox(height: 8,),
                         Divider(),
                         Row(
                           children: [
                             CustomText(text: 'Total products' , fontSize: 18,),
                             Spacer(),
                             CustomText(text: '${total}')
                           ],
                         ),

                         Padding(
                           padding: const EdgeInsets.only(top: 6, bottom: 12),
                           child: Row(children: [
                             CustomText(text: 'Total',fontSize: 18,),
                             Spacer(),
                           CustomText(text: '${total}')
                           ],),
                         ),
                         Divider(),


                         InkWell(
                           onTap: (){

                             Navigator.push(context,PageRouteBuilder(pageBuilder: (context , an,sc){
                               return PaymentView();
                             }));
                           },
                           child: Container(
                             margin: EdgeInsets.symmetric(horizontal: 20 , vertical: 20),
                             padding: EdgeInsets.symmetric(vertical: 6),
                             decoration: BoxDecoration(
                                 color: Colors.green,
                                 borderRadius: BorderRadius.circular(16)
                             ),
                             child: Center(child: CustomText(text: 'Confirm',color: Colors.white,fontSize: 18,),),
                           ),
                         ),
                       ],
                     ),
                   );
                 }

               }
               return SizedBox();
             })

            ],
          ),
        ),
      ),
    );
  }
}


