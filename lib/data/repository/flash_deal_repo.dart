import 'package:flutter/material.dart';
import 'package:djr_shopping/data/datasource/remote/dio/dio_client.dart';
import 'package:djr_shopping/data/datasource/remote/exception/api_error_handler.dart';
import 'package:djr_shopping/data/model/response/base/api_response.dart';
import 'package:djr_shopping/utill/app_constants.dart';

class FlashDealRepo {
  final DioClient dioClient;
  FlashDealRepo({@required this.dioClient});

  Future<ApiResponse> getFlashDeal() async {
    try {
      final response = await dioClient.get(AppConstants.FLASH_DEAL_URI);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getFlashDealList(String productID) async {
    try {
      final response = await dioClient.get('${AppConstants.FLASH_DEAL_PRODUCT_URI}$productID?limit=100&&offset=1');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}