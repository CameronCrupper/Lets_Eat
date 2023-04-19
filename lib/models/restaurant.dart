class Restaurant {
  String id;
  String? streetAddress;
  String? cityStateZip;
  String phoneNumber;
  String name;
  String imageUrl;
  List<dynamic> categories;

  Restaurant(
    {
      required this.id,
      required this.streetAddress,
      required this.cityStateZip,
      required this.phoneNumber,
      required this.name,
      required this.imageUrl,
      required this.categories
    }
  );
}