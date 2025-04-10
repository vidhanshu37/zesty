import 'dart:math';

class ApiConstants {
  static const String getAllcategory = "https://zesty-backend.onrender.com/category/get-all-category";
  static const String getAllRestuarnat = "https://zesty-backend.onrender.com/restaurant/get-all-restaurants";

  static String getSingleRestaurantData(String id){
    return "https://zesty-backend.onrender.com/restaurant/get/$id";
  }

  static String getAllMartItem = "https://zesty-backend.onrender.com/zestyMart/get-all-martItem";

  static String getMartImage(String imgId) {
    return "https://zesty-backend.onrender.com/zestyMart/get-martItem-image/$imgId";
  }

  static String getCouponData = "https://zesty-backend.onrender.com/coupon/get-all-coupons";

  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    print("+++++++++++++++++++++++++++++++++++++$lat1");
    const double R = 6371; // Earth's radius in km
    double dLat = (lat2 - lat1) * pi / 180;
    double dLon = (lon2 - lon1) * pi / 180;

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) * cos(lat2 * pi / 180) *
            sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return R * c; // Distance in km
  }

  //static String getAllMartItem = "https://zesty-backend.onrender.com/zestyMart/get/{id}";


// Zesty particular food item - https://zesty-backend.onrender.com/menu/get/67b75d821b1d9625f4c099c0{id}


}