class ApiEndPoints {
  static const String baseUrl = "https://ecommerce.doucsoft.com";
  static _AuthEndPoints authEndPoints = _AuthEndPoints();
}


class _AuthEndPoints {
  final String register = "${ApiEndPoints.baseUrl}/api/register";
  final String auth = "${ApiEndPoints.baseUrl}/api/login";
  final String verifyNumber = "${ApiEndPoints.baseUrl}/api/verifyNumber";
  final String verifyNumberAuth = "${ApiEndPoints.baseUrl}/api/verifyNumberAuth";
  final String profils = "${ApiEndPoints.baseUrl}/api/v1/profils/";
  final String orders = "${ApiEndPoints.baseUrl}/api/v1/orders/";
  final String profilUser = "${ApiEndPoints.baseUrl}/api/v1/getProfilUser/";
  final String products = "${ApiEndPoints.baseUrl}/api/v1/products/";
  final String myProducts = "${ApiEndPoints.baseUrl}/api/v1/myProducts";
  final String verifyImge = "${ApiEndPoints.baseUrl}/api/v1/verifyImge/";
  final String profilUrl = "${ApiEndPoints.baseUrl}/api/v1/getProfilImage/";
  final String userAuth = "${ApiEndPoints.baseUrl}/api/v1/userAuth/";
  final String sellerCompte = "${ApiEndPoints.baseUrl}/api/v1/createCompteSeller";
  final String getProductImage = "${ApiEndPoints.baseUrl}/api/v1/getProductImage";
  final String getImageProductM = "${ApiEndPoints.baseUrl}/api/v1/getImageProductM";
  final String sellers = "${ApiEndPoints.baseUrl}/api/v1/sellers";
  final String users = "${ApiEndPoints.baseUrl}/api/v1/users/";
  final String messages = "${ApiEndPoints.baseUrl}/api/v1/messages/";
  final String sellerProduct = "${ApiEndPoints.baseUrl}/api/v1/sellerProduct/";
  final String conversations = "${ApiEndPoints.baseUrl}/api/v1/conversations/";
  final String selectconver = "${ApiEndPoints.baseUrl}/api/v1/selectconver/";
  final String getOrderWithUser = "${ApiEndPoints.baseUrl}/api/v1/getOrderWithUser/";
  final String getOrderAuth = "${ApiEndPoints.baseUrl}/api/v1/getOrderAuth/";
  final String checkUserIsLine = "${ApiEndPoints.baseUrl}/api/v1/checkUserIsLine/";
  final String setToken = "${ApiEndPoints.baseUrl}/api/v1/setToken/";
  final String getOrderImage = "${ApiEndPoints.baseUrl}/api/v1/getOrderImage/";
  final String getOrderDetail = "${ApiEndPoints.baseUrl}/api/v1/getOrderDetail/";
  final String logout = "${ApiEndPoints.baseUrl}/api/v1/logout/";
}