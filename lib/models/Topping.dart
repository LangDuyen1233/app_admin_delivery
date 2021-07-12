class Topping {
  final String name;
  final double price;

  Topping(this.name, this.price);
}

Topping t1 = new Topping('Thạch củ năng', 5);
Topping t2 = new Topping('Hạt đẹp', 15);
List<Topping> listTopping = [t1, t2];
