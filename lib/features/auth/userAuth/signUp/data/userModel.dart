
class UserModell {
  late String email ;
  late String password;



  UserModell({required this.email , required this.password});


   Map<String,dynamic> dataToMapp (){
    return {
       'email' : email ,
      'password' : password,

    };
  }

}