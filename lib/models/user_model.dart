class User {
  final String id;
  final String displayName;
  final bool isAdmin;

  User({required this.id, required this.displayName, required this.isAdmin});

  User.fromJson(String id, Map<String, dynamic> json)
      : this(
            id: id,
            displayName: json["display_name"],
            isAdmin: json["isAdmin"]);

  Map<String, Object?> toJson() {
    return {"display_name": displayName, "isAdmin": isAdmin};
  }
}
