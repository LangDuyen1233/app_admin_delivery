class Apis {
  static final String baseURL = 'http://192.168.1.233:8000';
  static final String root = '$baseURL/api';

  //auth
  static String getSignInUrl = '$root/loginowner';
  static String getLogoutUrl = '$root/logout';

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
}
