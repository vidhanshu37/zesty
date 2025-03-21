import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:zesty/screens/add_manually_address/addAddressDetailsHelper/sliverMapAddress.dart';
import 'package:zesty/screens/add_manually_address/googleMap.dart';
import 'package:zesty/screens/home/Shimmer_home.dart';
import 'package:zesty/screens/home/home.dart';
import 'package:zesty/screens/home/item_cart/cartPayment.dart';
import 'package:zesty/screens/home/item_cart/coupons.dart';
import 'package:zesty/screens/home/rough.dart';
import 'package:zesty/screens/home/user_profile/add_new_address.dart';
import 'package:zesty/screens/home/user_profile/zesty1.dart';
import 'package:zesty/screens/home/user_profile/zestyLiteActive.dart';
import 'package:zesty/screens/home/zesty_Mart/zesty_mart_page.dart';
import 'package:zesty/screens/location_access/locationAccess.dart';
import 'package:zesty/screens/location_access/shimmerEffect.dart';
import 'package:zesty/screens/login_process/otpscreen.dart';
import 'package:zesty/screens/login_process/signin.dart';
import 'package:zesty/screens/onboarding/onBoardingScreen.dart';
import 'package:zesty/screens/onboarding/splashScreen.dart';
import 'package:zesty/screens/restaurants_side/item_card.dart';
import 'package:zesty/utils/local_storage/HiveOpenBox.dart';
import 'package:zesty/utils/theme/theme.dart';

import 'myHomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Open Hive Box for user location
  await Hive.openBox(HiveOpenBox.storeLatLongTable);

  /// Open hive box for manage food cart
  await Hive.openBox(HiveOpenBox.zestyFoodCart);

  /// Open hive box for manage address and sub-address
  await Hive.openBox(HiveOpenBox.storeAddress);

  /// Open hive box for storing zesty mart item
  await Hive.openBox(HiveOpenBox.storeZestyMartItem);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Only allows portrait mode
  ]).then((_) {
    runApp(MyApp());
  });


  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.lightTheme,
        //home: HomeScreen(address: "surat", subAddress: "subAddress"),
      //home: CartPayment(restaurantName: "restaurantName", deliveryTime: "deliveryTime", totalPrice: "222"),
      // home: ItemCard(itemName: "itemName", itemDescription: "itemDescription", itemPrice: "itemPrice", itemMenuId: "itemMenuId", updateCartState: () {}, restaurantId: "restaurantId", onIncrement: (){}, onDecrement: (){}, counter: 0),
      // home: MartItemImagesScreen(martItemId: '67b9c261b10e67aa58074037',),
      // home: TrackDeliveryOrder(ResLongitude: 72.8411, ResLatitude: 21.2049),
      home: SplashScreen(),
      // home:  ZestyLiteActive(),
      // home: LocationAccess(),
    );
  }
}
