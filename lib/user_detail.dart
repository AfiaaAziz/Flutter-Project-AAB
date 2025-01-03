class UserDetails {
  // Singleton instance
  // This creates a single instance of the UserDetails class that will be shared across the entire app.
  static final UserDetails _instance = UserDetails._internal();

  // Private constructor
  // This private named constructor prevents external instantiation of the class.
  UserDetails._internal();

  // Factory constructor to return the same instance
  // The factory constructor always returns the singleton instance (_instance).
  factory UserDetails() => _instance;

  // User details
  // A nullable string property to store the user's ID.
  String? userId;

  // Clear user details
  // A method to reset the userId by setting it to null.
  void clearUserDetails() {
    userId = null;
  }
}
