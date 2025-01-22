class Localization {
  static String getFlag(String code) {
    switch (code) {
      case 'en':
        return "${String.fromCharCode(0x1F1EC)}${String.fromCharCode(0x1F1E7)}";
      case 'zh':
        return "${String.fromCharCode(0x1F1E8)}${String.fromCharCode(0x1F1F3)}";
      case 'ko':
        return "${String.fromCharCode(0x1F1F0)}${String.fromCharCode(0x1F1F7)}";
      case 'id':
      default:
        return "${String.fromCharCode(0x1F1EE)}${String.fromCharCode(0x1F1E9)}";
    }
  }
}
