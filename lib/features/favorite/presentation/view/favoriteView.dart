import 'package:assignment/features/favorite/presentation/view/widgets/customFavoriteItem.dart';
import 'package:assignment/features/favorite/presentation/view/widgets/noAccount.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../utils/widgets/customText.dart';
import '../../../detailsView/presentation/view/detailsView.dart';
import '../../../home/data/productModel.dart';


class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key, required this.cartId});
  final String cartId ;
  @override
  State<FavoriteView> createState() => _CartViewState();
}

class _CartViewState extends State<FavoriteView> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessenger = GlobalKey();

  @override
  void initState() {

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
                    text: 'Favorite',
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  Spacer(),

                  Badge(
                      label: StreamBuilder(stream: FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).snapshots(),
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
            FirebaseAuth.instance.currentUser?.uid !=null ?   Expanded(child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                builder: (context, state){
                  if(state.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(color: Colors.green , backgroundColor: Colors.grey.shade300,),);
                  }else if(state.hasData){
                    if(state.data!.docs.isEmpty){
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/ff.png' ,height: 100,),
                          SizedBox(height: 30,),
                          CustomText(text: 'Your favorite is empty!' , fontSize: 20,),
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
                              child: CustomFavoriteItem(productt : state.data!.docs[index] ,cartId: widget.cartId, docId: state.data!.docs[index].id,scaffoldMessenger: scaffoldMessenger,));
                        });
                  }else{
                    return Center(child: CustomText(text: 'Something went wrong',),);
                  }
                },
              )) : NoAccount(),


            ],
          ),
        ),
      ),
    );
  }
}


