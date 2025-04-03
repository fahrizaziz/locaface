class CompanyModel {
  String? name, email, address, lat, long, distance, timeIn, timeOut;
  CompanyModel({
    this.address,
    this.distance,
    this.email,
    this.lat,
    this.long,
    this.name,
    this.timeIn,
    this.timeOut,
  });
  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      name: json['name'],
      email: json['email'],
      address: json['address'],
      lat: json['latitude'],
      long: json['longitude'],
      distance: json['radius_km'],
      timeIn: json['time_in'],
      timeOut: json['time_out'],
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['address'] = address;
    data['latitude'] = lat;
    data['longitude'] = long;
    data['radius_km'] = distance;
    data['time_in'] = timeIn;
    data['time_out'] = timeOut;
    return data;
  }
}
