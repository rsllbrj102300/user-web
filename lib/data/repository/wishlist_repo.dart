import 'package:flutter/material.dart';
import 'package:djr_shopping/data/datasource/remote/dio/dio_client.dart';
import 'package:djr_shopping/data/datasource/remote/exception/api_error_handler.dart';
import 'package:djr_shopping/data/model/response/base/api_response.dart';
import 'package:djr_shopping/utill/app_constants.dart';


class WishListRepo {
  final DioClient dioClient;

  WishListRepo({@required this.dioClient});

  Future<ApiResponse> getWishList() async {
    try {
      final response = await dioClient.get(AppConstants.WISH_LIST_GET_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addWishList(List<int> productID) async {
    try {
      final response = await dioClient.post(AppConstants.WISH_LIST_GET_URI, data: {'product_ids' : productID});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> removeWishList(List<int> productID) async {
    try {
      final response = await dioClient.delete(AppConstants.WISH_LIST_GET_URI, data: {'product_ids' : productID, '_method':'delete'});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
