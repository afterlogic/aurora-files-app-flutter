The current status of transferring the project to the new version of Flutter.

1. The code base of the project has been transferred to Null-safety, the packages used have been updated, deprecated methods and properties have been replaced with current ones.

2. Self-written libraries have been replaced with standard ones:
1) receive_sharing (https://github.com/afterlogic/receive_sharing ) -> receive_sharing_intent (pub.dev)
2) localizator (https://github.com/afterlogic/flutter_localizator.git) -> flutter gen-l10n

3. Updated packages/plugins:
1) crypto_stream (https://github.com/afterlogic/flutter_crypto_stream) branch "flutter_2.10"
2) build_variant (https://github.com/afterlogic/build_variant) branch "flutter_2.10"
3) localizator (https://github.com/afterlogic/flutter_localizator.git) branch "flutter_2.10"
4) aurora_logger (https://github.com/afterlogic/aurora_logger_flutter) "master" branch, the previous state is saved in the branch
   "flutter_2.2.3"
5) aurora_ui_kit (https://github.com/afterlogic/aurora_ui_kit_flutter) "master" branch, the previous state is saved in the branch
   "flutter_2.2.3"
6) yubico_flutter (https://github.com/afterlogic/yubico_flutter) branch "flutter_2.10"

4. It remains to do:
1) check the correctness of the color themes for different configurations
3) check the yubico_flutter plugin (https://github.com/afterlogic/yubico_flutter )
