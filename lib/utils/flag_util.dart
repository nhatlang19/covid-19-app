class FlagUtil {
  static String getFlagFlat(String code) {
    return 'https://www.countryflags.io/${code.toLowerCase()}/flat/64.png';
  }

  static String getFlagShiny(String code) {
    return 'https://www.countryflags.io/${code.toLowerCase()}/shiny/64.png';
  }
}
