import 'package:assignment/features/auth/userAuth/login/liginView.dart';
import 'package:assignment/features/favorite/presentation/view/favoriteView.dart';
import 'package:assignment/features/home/presenation/manager/allProductCubit.dart';
import 'package:assignment/features/home/presenation/manager/fetchProductStates.dart';
import 'package:assignment/features/home/presenation/view/widgets/customProduct.dart';
import 'package:assignment/utils/responsiveSise.dart';
import 'package:assignment/utils/widgets/customText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cart/presentation/manager/addToCart.dart';
import '../../../cart/presentation/view/cartView.dart';
import '../../../profile/presentation/view/profileView.dart';



class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<ScaffoldMessengerState> scaffoldMessenger = GlobalKey();
   String cartId = 'cartId' ;
  @override
  void initState() {
    context.read<GetProductCubit>().getProducts();
      getCartId();
    super.initState();
  }
  Future<void> getCartId() async {
    cartId  = await CreateNewCart.getBasketId();
    setState(() {
    });

  }
  @override
  Widget build(BuildContext context) {

    print(FirebaseAuth.instance.currentUser?.uid ?? 'not exist');
    SizeConfig().init(context);
    return ScaffoldMessenger(
      key: scaffoldMessenger,
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          drawer: Drawer(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40,),
                    Row(
                      children: [
                        CustomText(text: 'All Categories' , color: Colors.black,fontSize: 18,),
                        Spacer(),
                        CircleAvatar(
                          radius: 16,
                            backgroundColor: Colors.green,
                            child: IconButton(onPressed:  (){
                              Navigator.pop(context);
                            }, icon: Icon(Icons.close , color: Colors.white,size: 16,)))
                      ],
                    ),

                    Divider(height: 20,),

                    CustomText(text: 'Category 1' , color: Colors.black,fontSize: 16,height: 2,),
                    CustomText(text: 'Category 2' , color: Colors.black,fontSize: 16,height: 2,),
                    CustomText(text: 'Category 3' , color: Colors.black,fontSize: 16,height: 2,),
                    CustomText(text: 'Category 4' , color: Colors.black,fontSize: 16,height: 2,)

                  ],
                ),
              ),
            ),
          ),
          // backgroundColor: Colors.grey.shade50,
          body:  SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [

                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200, // Background color
                      borderRadius: BorderRadius.circular(16), // Border radius
                    ),
                    child: TextFormField(
                      cursorColor: Colors.green,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        hintText: 'Search about anything',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none, // No internal borders
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),

                  Row(
                    children: [
                      Builder(
                          builder: (context) {
                            return Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade300),
                                    shape: BoxShape.circle
                                ),
                                child: IconButton(onPressed: (){

                                  Scaffold.of(context).openDrawer();
                                  FocusScope.of(context).unfocus();
                                }, icon:Icon(Icons.menu , color: Colors.green,)));
                          }
                      ),

                      Spacer(),
                    FirebaseAuth.instance.currentUser?.uid !=null ?   Badge(
                      backgroundColor: Colors.grey,
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
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              shape: BoxShape.circle
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(context,PageRouteBuilder(pageBuilder: (context,an,sc){
                                return FavoriteView(cartId: cartId,);
                              }));
                            },
                            icon: Icon(Icons.favorite , color: Colors.green,),
                          ),
                        ),
                      ) : GestureDetector(

                       onTap: (){
                         Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context,an,sc){
                           return LoginView();
                         }));
                       },
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green)
                          ),
                          child: Center(child: CustomText(text: 'Login' , fontSize: 16))),
                      ),
                      SizedBox(width: 16,),
                      Badge(
                        label: StreamBuilder(stream: FirebaseFirestore.instance.collection(cartId).snapshots(),
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
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            shape: BoxShape.circle
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(context,PageRouteBuilder(pageBuilder: (context,an,sc){
                                return CartView(cartId: cartId,);
                              }));
                            },
                            icon: Icon(Icons.card_travel_rounded),
                          ),
                        ),
                      ),
                      SizedBox(width: 16,),
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              shape: BoxShape.circle
                          ),
                          child: IconButton(onPressed: (){
                            Navigator.push(context, PageRouteBuilder(pageBuilder: (context, an,sc){
                              return ProfileView();
                            }));
                          },icon: Icon(Icons.person_pin_outlined),)),






                    ],
                  ),

                  Divider(),


                  Expanded(
                    child: BlocConsumer<GetProductCubit , FetchProductsStates>(
                      builder: (BuildContext context, state) {
                        if(state is LoadingStateFetchProducts){
                          return Center(child: CircularProgressIndicator(

                            color: Colors.green,backgroundColor: Colors.grey.shade300,),);
                        }else if(state is SuccessStateFetchProducts){
                          return DynamicHeightGridView(builder: (context, index){
                            return CustomProduct(productModel: state.products[index] , scaffoldMessenger: scaffoldMessenger, cartId: cartId,);
                          }, itemCount: state.products.length, crossAxisCount: 2);
                        }else if(state is FailureStateFetchProducts){
                          return Center(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Image.asset('assets/images/internet.png' , height: 100,),
                              SizedBox(height: 20,),
                              CustomText(text: state.errorMessage,fontSize: 18,),

                              InkWell(
                                onTap: (){
                                  context.read<GetProductCubit>().getProducts();
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth!*.25, vertical: 30),
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(child: CustomText(text: 'Refresh',color: Colors.green,fontSize: 18,),),
                                ),
                              ),
                            ],
                          ),);
                        }else{
                          return SizedBox();
                        }
                      }, listener: (BuildContext context, Object? state) {

                    },

                    ),
                  ),
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}



