import 'package:locaface/Model/company_model.dart';

class CompanyResponseModel {
  CompanyModel? company;
  CompanyResponseModel({this.company});
  factory CompanyResponseModel.fromJson(Map<String, dynamic> json) {
    return CompanyResponseModel(
      company: CompanyModel.fromJson(json['company']),
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (company != null) {
      data['company'] = company!.toJson();
    }
    return data;
  }
}
