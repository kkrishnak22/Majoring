
import 'package:flutter/cupertino.dart';

import '../models/product_model.dart';
import '../widgets/simple_product_widget.dart';



const double kAppBarHeight = 100;

List <Color> backgroundGradient = [
const  Color(0xFFFF3E3E),
const  Color(0xFF822DEA)
];


List<String> largeAds = [
  'https://www.shalicenoel.com/wp-content/uploads/2017/01/shalice-225.jpg',
'https://static.twinesocial.com/images/blog/iStock-863190232.jpg',
'https://cdn2.veltra.com/ptr/20130207082409_288392461_2806_0.jpg',
  'https://img.freepik.com/free-photo/beautiful-woman-walking-street-holding-shopping-bags_142605-694.jpg'

];

List<Widget> testChildren = [
  SimpleProductWidget(
    productModel: ProductModel(
        url:   'https://www.shalicenoel.com/wp-content/uploads/2017/01/shalice-225.jpg',
        productName: "Rick Astley",
        cost: 9999999999999,
        discount: 0,
        uid: "eioejfbkn",
        sellerName: "Rick Seller",
        sellerUid: "983498ihjb",
        rating: 1,
        noOfRating: 1),
  ),
  SimpleProductWidget(
    productModel: ProductModel(
        url: 'https://static.twinesocial.com/images/blog/iStock-863190232.jpg',
        productName: "Rick Astley",
        cost: 9999999999999,
        discount: 0,
        uid: "eioejfbkn",
        sellerName: "Rick Seller",
        sellerUid: "983498ihjb",
        rating: 1,
        noOfRating: 1),
  ),
  SimpleProductWidget(
    productModel: ProductModel(
        url: 'https://static0.srcdn.com/wordpress/wp-content/uploads/2021/03/a32-a52-a72-2000.jpg',
        productName: "Rick Astley",
        cost: 9999999999999,
        discount: 0,
        uid: "eioejfbkn",
        sellerName: "Rick Seller",
        sellerUid: "983498ihjb",
        rating: 1,
        noOfRating: 1),
  ),
  SimpleProductWidget(
    productModel: ProductModel(
        url: 'https://ronishdhakal.com/wp-content/uploads/2021/03/Samsung-Galaxy-A52-5G-Design-1920x1080.jpg',
        productName: "Rick Astley",
        cost: 9999999999999,
        discount: 0,
        uid: "eioejfbkn",
        sellerName: "Rick Seller",
        sellerUid: "983498ihjb",
        rating: 1,
        noOfRating: 1),
  ),
  SimpleProductWidget(
    productModel: ProductModel(
        url: 'https://img.freepik.com/free-photo/beautiful-woman-walking-street-holding-shopping-bags_142605-694.jpg',
        productName: "Rick Astley",
        cost: 9999999999999,
        discount: 0,
        uid: "eioejfbkn",
        sellerName: "Rick Seller",
        sellerUid: "983498ihjb",
        rating: 1,
        noOfRating: 1),
  )
];

List<String> keyOfRating = ["Ver bad" ,'Poor','Average','Good', 'Excellent' ];

// SimpleProductWidget(url: 'https://ronishdhakal.com/wp-content/uploads/2021/03/Samsung-Galaxy-A52-5G-Design-1920x1080.jpg'),
// SimpleProductWidget(url: 'https://static0.srcdn.com/wordpress/wp-content/uploads/2021/03/a32-a52-a72-2000.jpg'),
// SimpleProductWidget(url: 'https://ronishdhakal.com/wp-content/uploads/2021/03/Samsung-Galaxy-A52-5G-Design-1920x1080.jpg'),
// SimpleProductWidget(url: 'https://static0.srcdn.com/wordpress/wp-content/uploads/2021/03/a32-a52-a72-2000.jpg'),
// SimpleProductWidget(url: 'https://ronishdhakal.com/wp-content/uploads/2021/03/Samsung-Galaxy-A52-5G-Design-1920x1080.jpg'),
// SimpleProductWidget(url: 'https://static0.srcdn.com/wordpress/wp-content/uploads/2021/03/a32-a52-a72-2000.jpg')
const List<String> categoryLogos = [
  "https://m.media-amazon.com/images/I/11uufjN3lYL._SX90_SY90_.png",
  "https://m.media-amazon.com/images/I/116KbsvwCRL._SX90_SY90_.png",
  "https://m.media-amazon.com/images/I/115yueUc1aL._SX90_SY90_.png",
  "https://m.media-amazon.com/images/I/11qyfRJvEbL._SX90_SY90_.png",
  "https://m.media-amazon.com/images/I/11BIyKooluL._SX90_SY90_.png",
  "https://m.media-amazon.com/images/I/11CR97WoieL._SX90_SY90_.png",
  "https://m.media-amazon.com/images/I/01cPTp7SLWL._SX90_SY90_.png",
  "https://m.media-amazon.com/images/I/11yLyO9f9ZL._SX90_SY90_.png",
  "https://m.media-amazon.com/images/I/11M0jYc-tRL._SX90_SY90_.png",
];

const List<String> categoriesList = [
  "Prime",
  "Mobiles",
  "Fashion",
  "Electronics",
  "Home",
  "Fresh",
  "Appliances",
  "Books, Toys",
  "Essential"
];