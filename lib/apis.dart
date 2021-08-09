class Apis {
  static final String baseURL = 'http://192.168.1.233:8000';
  static final String root = '$baseURL/api';

  //auth
  static String getSignInUrl = '$root/loginowner';
  static String getLogoutUrl = '$root/logout';
  static String postUpdateUidUrl = '$root/updateUid';

  //home

  //information
  static String getUsersUrl = '$root/getuser';

  //category
  static String getCategoryUrl = '$root/getCategory';
  static String addCategoryUrl = '$root/addCategory';

  //food
  static String getFoodUrl = '$root/getFood';
  static String addFoodUrl = '$root/addFood';
  static String editFoodUrl = '$root/editFood';
  static String updateFoodUrl = '$root/updateFood';
  static String deleteFoodUrl = '$root/deleteFood';

  //topping
  static String getToppingUrl = '$root/getTopping';
  static String addToppingUrl = '$root/addTopping';
  static String editToppingUrl = '$root/editTopping';
  static String updateToppingUrl = '$root/updateTopping';
  static String deleteToppingUrl = '$root/deleteTopping';

  //
  static String uploadImage = '$root/uploadImage';
  static String uploadAvatar = '$root/uploadAvatar';

  static String getReviewUrl = '$root/getReview';

  //staff
  static String getStaffUrl = '$root/getStaff';
  static String addStaffUrl = '$root/addStaff';
  static String editStaffUrl = '$root/editStaff';
  static String updateStaffUrl = '$root/updateStaff';
  static String deleteStaffUrl = '$root/deleteStaff';

  //materials
  static String getMaterialsUrl = '$root/getMaterials';
  static String addMaterialsUrl = '$root/addMaterials';
  static String editMaterialsUrl = '$root/editMaterials';
  static String updateMaterialsUrl = '$root/updateMaterials';
  static String deleteMaterialsUrl = '$root/deleteMaterials';

  //admin proflie

  static String changeUsersUrl = '$root/changeUsers';
  static String changeNameUrl = '$root/changeName';
  static String changeDobUrl = '$root/changeDob';
  static String changeGenderUrl = '$root/changeGender';
  static String changeAvatarUrl = '$root/changeAvatar';

  //admin restaurant
  static String getRestaurantUrl = '$root/getRestaurant';
  static String changeImageRestaurantUrl = '$root/changeImageRestaurant';

  //admin discount
  static String getDiscountUrl = '$root/getDiscount';
  static String addDiscountVoucherUrl = '$root/addDiscountVoucher';
  static String editDiscountVoucherUrl = '$root/editDiscountVoucher';
  static String updateDiscountVoucherUrl = '$root/updateDiscountFood';
  static String deleteDiscountVoucherUrl = '$root/deleteDiscountVoucher';

  static String getDiscountFoodUrl = '$root/getDiscountFood';
  static String addDiscountFoodUrl = '$root/addDiscountFood';
  static String editDiscountFoodUrl = '$root/editDiscountFood';
  static String updateDiscountFoodUrl = '$root/updateDiscountFood';
  static String deleteDiscountFoodUrl = '$root/deleteDiscountFood';

  //admin order
  static String getNewCardUrl = '$root/getNewCard';
  static String cancelOrderUrl = '$root/cancelOrder';
  static String prepareOrderUrl = '$root/prepareOrder';

  ////
  static String getPrepareCardUrl = '$root/getPrepareCard';
  static String deliveryByRestaurantUrl = '$root/deliveryByRestaurant';
  static String deliveryByUserUrl = '$root/deliveryByUser';

  ////
  static String getDeliveringCardUrl = '$root/getDeliveringCard';
  static String deliveredUrl = '$root/delivered';

  static String getDeliveredCardUrl = '$root/getDeliveredCard';

  static String getHistoryCardUrl = '$root/getHistoryCard';

  //notify
  static String getNotifyUrl = '$root/getNotify';
}
