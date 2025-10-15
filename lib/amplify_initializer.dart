import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/services.dart';

Future<void> configureAmplify() async {
  try {
    await Amplify.addPlugin(AmplifyAuthCognito());
    final config = await rootBundle.loadString('assets/amplify_configuration.json');
    await Amplify.configure(config);
    safePrint('Amplify configured successfully');
  } on AmplifyAlreadyConfiguredException {
    safePrint('Amplify was already configured.');
  } on Exception catch (e) {
    safePrint('Error configuring Amplify: $e');
  }
}
