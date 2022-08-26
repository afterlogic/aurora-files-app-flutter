class ServerSettings {
  final List<String> availableModules;
  final Map<String, dynamic> modulesSettings;

  ServerSettings({
    this.availableModules = const [],
    this.modulesSettings = const {},
  });

  bool isModuleEnable(String module) {
    if (module == null) {
      return false;
    }
    //request for available modules is still in progress
    if (availableModules.isEmpty) {
      return true;
    }
    return availableModules.contains(module);
  }

  bool isMethodEnable(String module, String method) {
    if (module == null || method == null) {
      return false;
    }
    final moduleEnable = isModuleEnable(module);
    if (moduleEnable == false) {
      return false;
    }
    final settings = modulesSettings[module] as Map<String, dynamic>;
    if (settings == null || settings.length == 0) {
      return true;
    }
    bool methodEnable;
    if (module == "CoreParanoidEncryptionWebclientPlugin") {
      switch (method) {
        case "UpdateSettings":
          methodEnable = settings["AllowChangeSettings"];
          break;
      }
    } else if (module == "TwoFactorAuth") {
      switch (method) {
        case "SaveDevice":
          methodEnable = settings["AllowUsedDevices"];
          break;
        case "TrustDevice":
          methodEnable = settings["AllowUsedDevices"];
          break;
        case "VerifyAuthenticatorAppCode":
          methodEnable = settings["AuthenticatorAppEnabled"];
          break;
        case "VerifyBackupCode":
          methodEnable = settings["AllowBackupCodes"];
          break;
        case "VerifySecurityKeyBegin":
          methodEnable = settings["AllowSecurityKeys"];
          break;
        case "VerifySecurityKeyFinish":
          methodEnable = settings["AllowSecurityKeys"];
          break;
      }
    }
    return methodEnable ?? true;
  }
}
