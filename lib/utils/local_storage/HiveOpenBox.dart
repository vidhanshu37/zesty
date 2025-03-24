import 'package:hive/hive.dart';

class HiveOpenBox {
  static String zestyFoodCart = "ZestyFoodCart";

  /// Store exist user data
  static String storeAddress = "storeAddress";
  static String storeAddressTitle = "title";
  static String storeAddressSubTitle = "subTitle";
  static String storeAddressLat = "lat";
  static String storeAddressLong = "long";
  static String userId = "userId";
  static String userEmail = "userEmail";
  static String userMobile = "userMobile";
  static String userZestyLite = "userZestyLite";
  static String userZestyMoney = "userZestyMoney";
  static String userName = "userName";
  static String zestyLiteOrder = "zestyLiteOrder";
  static String zestyMartLiteOrder = "zestyMartLiteOrder";



  /// Store latitude and Longitude
  static String storeLatLongTable = "zestyBox";
  static String lat = "latitude";
  static String long = "longitude";
  static String address = "address";
  static String mobile = "mobile";
  static String email = "email";


  /// Hive for store Zesty mart item
  static String storeZestyMartItem = "ZestyMart";


  ///Hive for store Search item
  static String searchItem = "SearchItem";
  static String searchItemSuggestion = "searchItemSuggestion";

  ///Hive for LikeResturants
  static String likedResturants = 'likedResturants';

}