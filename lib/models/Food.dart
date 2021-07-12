import 'package:app_delivery/models/Size.dart';
import 'package:app_delivery/models/Topping.dart';

class Food {
  final String name;
  final String img;
  final int quantity;
  final String ingredient;
  final double price;
  final String status;
  final String note;
  final Size size;
  final List<Topping> topping;

  Food(
      {this.name,
      this.img,
      this.quantity,
      this.ingredient,
      this.price,
      this.status,
      this.note,
      this.size,
      this.topping});
}

Food f1 = new Food(
  name: 'Phở bò',
  img:
      'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  quantity: 5,
);
Food f2 = new Food(
  name: 'Trà đào cam sả',
  img:
      'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  quantity: 5,
  size: s1,
  topping: [t1],
);
Food f3 = new Food(
  name: 'Trà đào cam sả',
  img:
      'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
  quantity: 5,
  size: s2,
  topping: [t1, t2],
);
List<Food> list = [f1, f2, f3];
