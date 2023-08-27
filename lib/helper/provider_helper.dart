
import 'package:finacial_saving/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class ProviderHelper {
  static List<ChangeNotifierProvider> providers = [
    ChangeNotifierProvider<AuthProvider>(create: (context) => AuthProvider()),
    ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider()),
   
  ];
}
