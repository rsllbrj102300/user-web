import 'package:flutter/material.dart';
import 'package:djr_shopping/helper/responsive_helper.dart';
import 'package:djr_shopping/localization/language_constrants.dart';
import 'package:djr_shopping/provider/location_provider.dart';
import 'package:djr_shopping/provider/splash_provider.dart';
import 'package:djr_shopping/utill/color_resources.dart';
import 'package:djr_shopping/utill/dimensions.dart';
import 'package:djr_shopping/view/base/custom_app_bar.dart';
import 'package:djr_shopping/view/base/custom_button.dart';
import 'package:djr_shopping/view/base/custom_loader.dart';
import 'package:djr_shopping/view/screens/address/widget/location_search_dialog.dart';
import 'package:djr_shopping/view/base/web_app_bar/web_app_bar.dart';
import 'package:djr_shopping/view/screens/address/widget/permission_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SelectLocationScreen extends StatefulWidget {
  final GoogleMapController googleMapController;
  SelectLocationScreen({@required this.googleMapController});

  @override
  _SelectLocationScreenState createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  GoogleMapController _controller;
  TextEditingController _locationController = TextEditingController();
  CameraPosition _cameraPosition;
  LatLng _initialPosition;

  @override
  void initState() {
    super.initState();
    _initialPosition = LatLng(
      double.parse(Provider.of<SplashProvider>(context, listen: false).configModel.branches[0].latitude ),
      double.parse(Provider.of<SplashProvider>(context, listen: false).configModel.branches[0].longitude),
    );
    if(Provider.of<LocationProvider>(context, listen: false).position != null ) {
      Provider.of<LocationProvider>(context, listen: false).setPickData();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _openSearchDialog(BuildContext context, GoogleMapController mapController) async {
    showDialog(context: context, builder: (context) => LocationSearchDialog(mapController: mapController));
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<LocationProvider>(context).address != null) {
      _locationController.text = Provider.of<LocationProvider>(context).address ?? '';
    }

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120)): CustomAppBar(title: getTranslated('select_delivery_address', context), isCenter: true),
      body: Center(
        child: Container(
          width: 1170,
          child: Consumer<LocationProvider>(
            builder: (context, locationProvider, child) => Stack(
              clipBehavior: Clip.none,
              children: [
                GoogleMap(
                  minMaxZoomPreference: MinMaxZoomPreference(0, 16),
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 15,
                  ),
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  indoorViewEnabled: true,
                  mapToolbarEnabled: true,
                  onCameraIdle: () {
                    locationProvider.updatePosition(_cameraPosition, false, null, context,false);
                  },
                  onCameraMove: ((_position) => _cameraPosition = _position),
                  // markers: Set<Marker>.of(locationProvider.markers),
                  onMapCreated: (GoogleMapController controller) {
                    Future.delayed(Duration(milliseconds: 600)).then((value) {
                      _controller = controller;
                      _controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
                          target:  locationProvider.pickPosition.longitude.toInt() == 0 &&  locationProvider.pickPosition.latitude.toInt() == 0 ? _initialPosition : LatLng(
                        locationProvider.pickPosition.latitude, locationProvider.pickPosition.longitude,
                      ), zoom: 17)));
                    });

                  },
                ),
                locationProvider.pickAddress != null
                    ? InkWell(
                  onTap: () => _openSearchDialog(context, _controller),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 18.0),
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 23.0),
                          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL)),
                          child: Builder(
                            builder: (context) {
                              _locationController.text = locationProvider.pickAddress;

                              return Row(children: [
                                Expanded(child: Text(
                                  locationProvider.pickAddress ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                                )),

                                Icon(Icons.search, size: 20),
                              ]);
                            }
                          ),
                        ),
                    )
                    : SizedBox.shrink(),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => _checkPermission((){
                          locationProvider.getCurrentLocation(context, false, mapController: _controller);
                        }, context),
                        child: Container(
                          width: 50,
                          height: 50,
                          margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                            color: ColorResources.getCardBgColor(context),
                          ),
                          child: Icon(
                            Icons.my_location,
                            color: Theme.of(context).primaryColor,
                            size: 35,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                          child: CustomButton(
                            buttonText: getTranslated('select_location', context),
                            onPressed: locationProvider.loading ? null : () {
                              if(widget.googleMapController != null) {
                                widget.googleMapController.setMapStyle('[]');
                                widget.googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                                  locationProvider.pickPosition.latitude, locationProvider.pickPosition.longitude,
                                ), zoom: 16)));

                                if(ResponsiveHelper.isWeb()) {
                                  locationProvider.setAddAddressData(true);
                                }
                              }
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                    child: Icon(
                      Icons.location_on,
                      color: Theme.of(context).primaryColor,
                      size: 50,
                    )),
                locationProvider.loading
                    ? Center(child: CustomLoader(color: Theme.of(context).primaryColor))
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _checkPermission(Function callback, BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }else if(permission == LocationPermission.deniedForever) {
      showDialog(context: context, barrierDismissible: false, builder: (context) => PermissionDialog());
    }else {
      callback();
    }
  }
}
