import 'package:flutter/material.dart';
import 'package:zesty/utils/constants/colors.dart';

class ReorderPage extends StatefulWidget {
  const ReorderPage({super.key});

  @override
  State<ReorderPage> createState() => _ReorderPageState();
}

class _ReorderPageState extends State<ReorderPage> {

  List<Map<String, dynamic>> restaurants = [
    {
      "name": "The Glorious Restaurant",
      "image": "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg?resize=768,574",
      "time": "25-30 mins",
      "discount": "₹125 off above ₹249",
      "items": [
        {"name": "Paneer Lazagar", "price": 265},
        {"name": "Cheesy Garlic Paneer Masala", "price": 265},
        {"name": "Butter Naan", "price": 55},
      ]
    },
    {
      "name": "Radhe Dhokla (Punjabi)",
      "image": "https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg?resize=768,574",
      "time": "25-30 mins",
      "discount": "₹125 off above ₹249",
      "items": [
        {"name": "Veg Fried Rice", "price": 240},
        {"name": "Oil Pavbhaji", "price": 190},
      ]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("REORDER", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                FilterChip(label: Text("Favourites"), onSelected: (_) {}),
                SizedBox(width: 8),
                FilterChip(label: Text("Price 149 - 300"), onSelected: (_) {}),
                SizedBox(width: 8),
                FilterChip(label: Text("Price > 300"), onSelected: (_) {}),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  var resturant = restaurants[index];
                  return Card(
                    margin: EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(resturant["image"],height: 50,width: 50,fit: BoxFit.cover,)),
                            SizedBox(width: 10,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(resturant["name"], style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                Text(resturant["time"],style: TextStyle(fontSize: 12,color: TColors.black),),
                                if (resturant['discount'].isNotEmpty)
                                  Row(
                                    children: [
                                      Icon(Icons.local_offer, size: 16, color: Colors.red),
                                      SizedBox(width: 5),
                                      Text(resturant['discount'], style: TextStyle(color: TColors.darkerGrey)),
                                    ],
                                  ),
                              ],
                            ),
                            SizedBox(width: 70,),
                            Icon(Icons.favorite_border_outlined,color: TColors.darkGrey,),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Column(
                          children: resturant['items'].map<Widget>((item){
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Icon(Icons.radio_button_checked,color: Colors.green,),
                              title: Text(item["name"],maxLines: 1,overflow: TextOverflow.ellipsis,),
                              subtitle: Text("₹${item["price"]}"),
                              trailing: IconButton(onPressed: (){}, icon: Icon(Icons.add,color: Colors.green,)),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  );
                },
              )
          )
        ],
      )
    );
  }
}
