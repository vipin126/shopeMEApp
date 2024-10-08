// providers/user_provider.dart
import 'dart:convert';
import 'dart:io';
import 'package:anaar_demo/helperfunction/helperfunction.dart';
import 'package:anaar_demo/model/consumer_model.dart';
import 'package:anaar_demo/model/reseller_model.dart';
import 'package:anaar_demo/model/userModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  Reseller? _reseller;

  Reseller? get reseller => _reseller;
  ConsumerModel? _consumer;
  ConsumerModel? get consumer=> _consumer;
  // Usermodel? _usermodel;
  // Usermodel? get usermodel => _usermodel;
  bool _isloading = false;
  
  
  static bool _cmtloading=false;
  static bool cmtloading()=>_cmtloading;
  
  bool get isloading => _isloading;
  //  bool get cmtisloading => _isloading;
  
  static  set cmtisloading(bool value) {
    if (_cmtloading != value) {
      _cmtloading = value;
     // notifyListeners(); // Notify listeners about the change (if using ChangeNotifier)
    }
  }
  Map<String, Usermodel> _userModels = {};

  Usermodel? getUserModel(String userId) => _userModels[userId];

  Future<Usermodel?> fetchUserinfo(String? userId,{String? userType='reseller'}) async {
    if (userId == null) return null;
         print("yha ayta hu.......................");
    if (_userModels.containsKey(userId)) {
      return _userModels[userId];
    }
    _isloading=true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      return null;
    }
    var url;
    print("${userType}......................................");
if(userType=="consumer"){

     url = Uri.parse(
        'https://shopemeapp-backend.onrender.com/api/user/getConsumer?id=$userId');
}
else{
     url=Uri.parse(
        'https://shopemeapp-backend.onrender.com/api/user/getReseller?id=$userId');

}


    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
        _isloading=false;
    notifyListeners();

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        final userModel = Usermodel.fromJson(userData);
        _userModels[userId] = userModel;
        print("successfully comment card ki detail mil giye ............");
        notifyListeners();
        return userModel;
      } else {
        print('Failed to load user data. Status code: ${response.statusCode}${response.body}');
        return null;
      }
    } catch (error) {
      print('Error fetching user data......................: $error');
      return null;
    }
  }

//................................Reseller info  for post........................


  Future<Reseller?> fetchResellerinfo_post(String? userId) async {
    if (userId == null) return null;
         print("yha ayta hu.......................");
    // if (_userModels.containsKey(userId)) {
    //   return _userModels[userId];
    // }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      return null;
    }
    var url;


     url=Uri.parse(
        'https://shopemeapp-backend.onrender.com/api/user/getReseller?id=$userId');



    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        final userModel = Reseller.fromJson(userData);
        _reseller= userModel;
        print("successfully requirement card ki detail mil giye ............");
        notifyListeners();
        return userModel;
      } else {
        print('Failed to load user data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error fetching user data: $error');
      return null;
    }
  }






//.................fetch Reseller dat.......................................


  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      return;
    }

    print(token);
    final userId = prefs.getString('userId');
    print(userId);
    final url = Uri.parse(
        'https://shopemeapp-backend.onrender.com/api/user/getReseller?id=$userId');

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'barrer $token',
      });

      if (response.statusCode == 200) {
        print("uyessssssssssssss");
        final userData = json.decode(response.body);
        _reseller = Reseller.fromJson(userData);
        print(_reseller!.ownerName);
        print(response.body);
        notifyListeners();
      } else {
        print(response.statusCode);
        throw Exception('Failed to load user data');
      }
    } catch (error) {
      throw error;
    }
  }



//......................Fetch cosumer details....................

  Future<void> fetchConsumerData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      return;
    }

    print(token);
    final userId = prefs.getString('userId');
    print(userId);
    final url = Uri.parse(
        'https://shopemeapp-backend.onrender.com/api/user/getConsumer?id=$userId');

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'barrer $token',
      });

      if (response.statusCode == 200) {
        print("............Got the consumer data..........");
        final userData = json.decode(response.body);
        _consumer = ConsumerModel.fromJson(userData);
        print(_consumer!.businessName);
        notifyListeners();
      } else {
        print(response.statusCode);
        print(response.body);
        throw Exception('Failed to load user data');
      }
    } catch (error) {
      throw error;
    }
  }














//.......................................update userprofile data..for reseller.....................

  Future<void> _updateResellerInfo(Reseller reseller) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      _isloading = true;
      notifyListeners();
      final url = Uri.parse(
          'https://shopemeapp-backend.onrender.com/api/user/updateReseller');

      var response = await http.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(reseller.toJson()),
      );
      _isloading = false;
      notifyListeners();
      if (response.statusCode == 200) {
        print("Successfully update userdata...........");
        notifyListeners();
      } else if (response.statusCode == 400) {
        print("bad request");
      } else if (response.statusCode == 401) {
        throw Exception('user already exists');

        // return false;
      } else {
        print(response.statusCode);
        notifyListeners();
        throw Exception('Failed to register');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateresellerinfowithImage(
      Reseller info, File? image, File? bgImage) async {
    try {
      _isloading=true;
      notifyListeners();
      if(image==null && bgImage!=null){
 String? imageurl1 = await Helperfunction.uploadImage(image);
 info.image = imageurl1;
      }
      else if(bgImage==null && image!=null){
 String? bgimage_url = await Helperfunction.uploadImage(bgImage);
 info.bgImage = bgimage_url;
      }
     
     // String? bgimage_url = await Helperfunction.uploadImage(bgImage);

     
      
      print("Success");
      await _updateResellerInfo(info);
    } catch (error) {
      _isloading=false;
      notifyListeners();
      print("herereeeeeeeeeeeeeeeeeeeeeeeeeee");
      throw error;
    }
  }
//.......................................Connect with user.......................
 List<String?> _connections = [];
  List<String?> get connections => _connections;

Future<void> connectUser(String? loggedInUserId, String? targetUserId ,String? targetUsertype) async {
     final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final logginusertype=prefs.getString('userType');
     loggedInUserId=  await  Helperfunction.getUserId();
        var url;
    var body;
    print("logged in user type ................${logginusertype}");
    print("target user type...............${targetUsertype}");
    if(logginusertype=='reseller' && targetUsertype=='reseller'){
      url='https://shopemeapp-backend.onrender.com/api/user/resellerToReseller';

      body=json.encode({
           'resellerId1': loggedInUserId,
          'resellerId2': targetUserId,

      });
    }

   if(logginusertype=='reseller' && targetUsertype=='consumer'){
      url='https://shopemeapp-backend.onrender.com/api/user/resellerToConsumer';

      body=json.encode({
           'resellerId': loggedInUserId,
          'consumerId': targetUserId,

      });
    }
       if(logginusertype=='consumer' && targetUsertype=='reseller'){
      url='https://shopemeapp-backend.onrender.com/api/user/consumerToReseller';
       print('consumer -reseller');
       print(loggedInUserId);
       print(targetUserId);
      body=json.encode({
           'consumerId': loggedInUserId,
          'resellerId': targetUserId,

      });
    }
       if(logginusertype=='consumer' && targetUsertype=='consumer'){
      url='https://shopemeapp-backend.onrender.com/api/user/consumerToConsumer';

      body=json.encode({
           'consumerId1': loggedInUserId,
          'consumerId2': targetUserId,

      });
    }


    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json',
                    'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        _connections.add(targetUserId);
        print('........................connection successfull');
        notifyListeners();
      } else {
        throw Exception('Failed to connect to user .......${response.body}............${response.statusCode}');
      }
    } catch (error) {
      print('Error connecting to user: $error');
    }
  }


//............................................update Consumer info................................................................




 Future<void> _updateConsumerInfo(ConsumerModel cons) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      
      final url = Uri.parse(
          'https://shopemeapp-backend.onrender.com/api/user/updateConsumer');

      var response = await http.post(
        url,
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(cons.toJson()),
      );
      _isloading = false;
      notifyListeners();
      if (response.statusCode == 200) {
        print("Successfully update userdata...........");
        notifyListeners();
      } else if (response.statusCode == 400) {
        print("bad request");
      } else if (response.statusCode == 401) {
        throw Exception('user already exists');

        // return false;
      } else {
        print(response.statusCode);
        notifyListeners();
        throw Exception('Failed to register');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updaterConsumer_infowithImage(
    ConsumerModel info, File? image,) async {
    _isloading = true;
      notifyListeners();
    try {
      if(image==null){
await _updateConsumerInfo(info);
     
      }else{

      String? imageurl1 = await Helperfunction.uploadImage(image);
      //String? bgimage_url = await Helperfunction.uploadImage(bgImage);

      info.image = imageurl1;
     // info.bgImage = bgimage_url;}
      print("Success");
      
      await _updateConsumerInfo(info);}
    } catch (error) {

      _isloading = false;
      notifyListeners();
      throw error;
    }
  }












}
