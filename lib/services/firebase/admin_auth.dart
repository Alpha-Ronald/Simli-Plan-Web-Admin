import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Logs in the admin user
  Future<User?> loginAdmin(String email, String password) async {
    try {
      print('Attempting to sign in with email: $email'); // Debug statement

      // Sign in with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user == null) {
        print('Sign-in failed. User is null.'); // Debug statement
        throw Exception('Sign-in failed.');
      }

      print('User signed in: UID = ${user.uid}'); // Debug statement

      // Check if user has the admin role
      bool isAdmin = await _checkAdminRole(user.uid);

      if (!isAdmin) {
        print('User is not an admin. Logging out.'); // Debug statement
        await _auth.signOut();
        throw Exception('Access denied. You are not an admin.');
      }

      print('User is an admin. Login successful.'); // Debug statement
      return user;
    } catch (e) {
      print('Error during login: $e'); // Debug statement
      rethrow;
    }
  }

  /// Checks if the logged-in user has the "admin" role
  Future<bool> _checkAdminRole(String uid) async {
    try {
      print('Checking admin role for UID: $uid'); // Debug statement

      // Query the "lecturers" collection for any document where the UID matches and role is "admin"
      QuerySnapshot query = await _firestore
          .collection('Lecturers')
          .where(FieldPath.documentId, isEqualTo: uid)
          .where('role', isEqualTo: 'admin')
          .get();

      print('Admin role query result: ${query.docs.length} documents found'); // Debug statement

      // Check if any documents were returned
      return query.docs.isNotEmpty;
    } catch (e) {
      print('Error while checking admin role: $e'); // Debug statement
      return false;
    }
  }

  /// Logs out the current user
  Future<void> logout() async {
    print('Logging out user.'); // Debug statement
    await _auth.signOut();
  }
}
