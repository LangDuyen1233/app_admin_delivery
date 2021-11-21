class Apis {
  static final String baseURL = 'http://fooddelivery.gtnlu.site';
  static final String root = '$baseURL/api';

  //auth
  static String getSignInUrl = '$root/loginowner';
  static String getLogoutUrl = '$root/logout';
  static String postUpdateUidUrl = '$root/updateUid';
  static String forgotPassUrl = '$root/forgotPass';

  //home
  static String revenueWeekUrl = '$root/revenueWeek';

  //information
  static String getUsersUrl = '$root/getuser';

  //category
  static String getCategoryUrl = '$root/getCategory';
  static String addCategoryUrl = '$root/addCategory';
  static String editCategoryUrl = '$root/editCategory';
  static String updateCategoryUrl = '$root/updateCategory';
  static String deleteCategoryUrl = '$root/deleteCategory';

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
  static String changeEmailUrl = '$root/changeEmail';
  static String changePassUrl = '$root/changePass';
  static String changePhoneRestaurantUrl = '$root/changePhoneRestaurant';

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

  //statistic
  static String getSalesUrl = '$root/getSales';
  static String getCancelUrl = '$root/getCancel';
  static String getSumUrl = '$root/getSum';
  static String getRevenueUrl = '$root/getRevenue';
  static String changeRevenueUrl = '$root/changeRevenue';
  static String getWarehouseUrl = '$root/getWarehouse';
  static String changeWarehouseUrl = '$root/changeWarehouse';
  static String getOrderUrl = '$root/getOrder';
  static String changeOrderUrl = '$root/changeOrder';

  //address
  static String updateLocationUrl = '$root/updateAddressMap';

  //nofity
  static String postNotificationUrl = '$root/sendNotification';
  static String saveNotificationUrl = '$root/saveNotification';
}
