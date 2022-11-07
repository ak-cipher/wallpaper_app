class DemoUser {
  String name;
  String Location;

  DemoUser({required this.name, required this.Location});

  factory DemoUser.FromJson(Map<String, dynamic> user) {
    return DemoUser(name: user['name'], Location: user['Location']);
  }
}
