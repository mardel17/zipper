class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String currency;
  final String lang;
  final String country;
  final String surname;

  final String phone;
  final String mobile;

  final String address;
  final String city;
  final String zip;
  final String notes;

  var entries;
  final double totalPayout;
  final double biggestPrize;
  var earnings;

  final String createdAt;

  final int walletEntries;
  final int spentEntries;
  final int salePercent;

  final String path;

  User(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.currency,
      this.lang,
      this.country,
      this.surname,
      this.phone,
      this.mobile,
      this.address,
      this.city,
      this.zip,
      this.notes,
      this.entries,
      this.totalPayout,
      this.biggestPrize,
      this.earnings,
      this.createdAt,
      this.walletEntries,
      this.spentEntries,
      this.salePercent,
      this.path});

  factory User. fromJson(Map<String, dynamic> map) {
    if (map == null) return null;

    return User(
      id: map["id"],
      name: map["name"],
      username: map["username"],
      email: map["email"],
      currency: map["currency"],
      lang: map["lang"],
      country: map["country"],
      surname: map["surname"] ?? '',
      phone: map["phone"] ?? '',
      mobile: map["mobile"] ?? '',
      address: map["address"] ?? '',
      city: map["city"] ?? '',
      zip: map["zip"] ?? '',
      notes: map["notes"] ?? '',
      entries: map["entries"],
      totalPayout: map["total_payout"]==null?null:map["total_payout"].toDouble(),
      biggestPrize: map["biggest_prize"]==null?null:map["biggest_prize"].toDouble(),
      earnings: map["earnings"]==null?null:map["earnings"].toDouble(),
      createdAt: map["created_at"],
      walletEntries: map["wallet_entries"],
      spentEntries: map["spent_entries"],
      salePercent: map["sale_price_percent"],
      path: map["path"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;

    data['currency'] = this.currency;
    data['lang'] = this.lang;
    data['country'] = this.country;
    data['surname'] = this.surname;
    data['phone'] = this.phone;
    data['mobile'] = this.mobile;

    data['address'] = this.address;

    data['city'] = this.city;
    data['zip'] = this.zip;
    data['notes'] = this.notes;

    data['entries'] = this.entries;
    data['total_payout'] = this.totalPayout;
    data['biggest_prize'] = this.biggestPrize;
    data['earnings'] = this.earnings;
    data['created_at'] = this.createdAt;

    data['wallet_entries'] = this.walletEntries;
    data['spent_entries'] = this.spentEntries;
    data['sale_price_percent'] = this.salePercent;

    data['path'] = this.path;
    return data;
  }
}
