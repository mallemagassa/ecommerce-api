import 'package:ecommerce/app/models/ProductModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProductController extends GetxController{
  var products = <ProductModel>[].obs;
  var productsData = <ProductModel>[].obs;

    @override
    void onInit() {
      super.onInit();
      //fetchProducts();
    }

  RxString imagePath = ''.obs;
  RxString imageName = ''.obs;

  Future getImageCamera() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      imagePath.value = image.path.toString();
      imageName.value = image.name.toString();
    }
  }

  Future getImageGallery() async {
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePath.value = image.path.toString();
      imageName.value = image.name.toString();
    }
  }

}
