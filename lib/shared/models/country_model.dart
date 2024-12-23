class CountryModel {
  final int countryID;
  final String countryName;
  final String countryLanguage;
  final String countryDomain;

  CountryModel({
    required this.countryID,
    required this.countryName,
    required this.countryLanguage,
    required this.countryDomain,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      countryID: json['countryID'],
      countryName: json['countryName'],
      countryLanguage: json['countryLanguage'],
      countryDomain: json['countryDomain'],
    );
  }
}
