import 'package:flutter/material.dart';
import 'package:djr_shopping/data/datasource/remote/dio/dio_client.dart';
import 'package:djr_shopping/data/datasource/remote/exception/api_error_handler.dart';
import 'package:djr_shopping/data/model/response/base/api_response.dart';
import 'package:djr_shopping/utill/app_constants.dart';

class CouponRepo {
  final DioClient dioClient;

  CouponRepo({@required this.dioClient});

  Future<ApiResponse> getCouponList() async {
    try {
      final response = await dioClient.get(AppConstants.COUPON_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> applyCoupon(String couponCode) async {
    try {
      final response = await dioClient.get('${AppConstants.COUPON_APPLY_URI}$couponCode');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
