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
  //static String getAllMartItem = "https://zesty-backend.onrender.com/zestyMart/get/{id}";


// Zesty particular food item - https://zesty-backend.onrender.com/menu/get/67b75d821b1d9625f4c099c0{id}


}