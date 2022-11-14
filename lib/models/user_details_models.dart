class UserDetailsModels{
  final String name;
  final String city;
  final String gmail;

  UserDetailsModels({ required this.name,required this.city,
  required this.gmail});

   Map<String, dynamic> getJon()=>
       {
         'name'  : name,
         'city' : city,
         'gmail' : gmail,
       };
  factory UserDetailsModels.getModelFromJson(Map<String, dynamic> json) {
    return UserDetailsModels(name: json["name"], gmail:json["gmail"], city: json['city']);
  }
}