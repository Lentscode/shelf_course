// Classe che contiene la secret key per creare i JWT.
class AppConfig {
  static String secretKey = "";

  static void init(String? key) => secretKey = key ?? "haduhaiusdhiuaidu";
}
