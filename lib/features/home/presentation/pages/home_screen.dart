// import 'dart:async';
// import 'dart:io';
// import 'package:estella/core/navigation/routes.dart';
// import 'package:estella/core/theme/app_text_styles.dart';
// import 'package:estella/core/utils/extensions.dart';
// import 'package:estella/core/utils/size.dart';
// import 'package:estella/core/utils/size_utils.dart';
// import 'package:estella/gen/assets.gen.dart';
// import 'package:estella/shared/widgets/custom_image_view.dart';
// import 'package:estella/shared/widgets/custom_text_form_field.dart';
// import 'package:estella/shared/widgets/loader.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart' as geo;
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../../../../core/services/app_initializer.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/theme/app_spacing.dart';
// import '../../../../core/theme/app_theme.dart';
// import '../../../../shared/data/models/user_model.dart';
// import '../../../../shared/widgets/custom_elevated_button.dart';
// import '../../../../shared/widgets/snackbar_service.dart';
// import '../../../../shared/widgets/spacing.dart';
// import 'dart:ui' as ui;
//
// class HomeScreen extends StatefulWidget {
//   @override
//   State createState() => HomeScreenState();
// }
//
// class HomeScreenState extends State<HomeScreen> {
//   MapboxMap? mapboxMap;
//   var isLight = true;
//   LatLng? latLng;
//   late UserModel user;
//   bool pickManually = false;
//   bool showDescription = false;
//   bool isFetchingLocation = false;
//   PointAnnotationManager? _symbolManager;
//   // late StreamSubscription _positionStream;
//   TextEditingController _searchController = TextEditingController();
//
//   void _grantPermission() async {
//     PermissionStatus status = await Permission.location.request();
//     if (status != PermissionStatus.granted) {
//       SnackBarService.showSnackBar(
//           message: 'Location permission not granted', context: context);
//     }
//     var pos = await geo.Geolocator.getCurrentPosition();
//     latLng = LatLng(pos.latitude, pos.longitude);
//     try {
//       mapboxMap?.easeTo(
//         CameraOptions(
//           center: Point(coordinates: Position(pos.longitude, pos.latitude)),
//           // New York City
//           zoom: 14.0,
//         ),
//         MapAnimationOptions(duration: 1000), // 1-second smooth transition
//       );
//     } catch (e, s) {
//       print(s);
//     }
//     print('object moved');
//     if (mounted) {
//       setState(() {});
//     }
//
//     // _positionStream =
//     //     geo.Geolocator.getPositionStream(locationSettings: const geo.LocationSettings(
//     //       accuracy: geo.LocationAccuracy.bestForNavigation,
//     //       distanceFilter: 3,
//     //     ))
//     //         .listen((pos){
//     //       locationDebouncer.run(() {
//     //         latLng = LatLng(pos.latitude, pos.longitude);
//     //         try {
//     //           mapboxMap?.easeTo(
//     //             CameraOptions(
//     //               center: Point(coordinates: Position(pos.longitude, pos.latitude)), // New York City
//     //               zoom: 14.0,
//     //             ),
//     //             MapAnimationOptions(duration: 1000), // 1-second smooth transition
//     //           );
//     //         } catch (e, s) {
//     //           print(s);
//     //         }
//     //         if(mounted){
//     //           setState(() {});
//     //         }
//     //       });
//     //     });
//   }
//
//   @override
//   void initState() {
//     user =
//         UserModel.fromJson((AppInitializer.maps.get('user').toStringDynamic));
//     MapboxOptions.setAccessToken(
//         'pk.eyJ1IjoiZGVja2xhbm9yaWUiLCJhIjoiY203aHI1YTBnMTRsMzJrcjV3MmYzdjRjdiJ9.vFSFMxzoJwb2A64UnHcsaw');
//     _grantPermission();
//     super.initState();
//   }
//
//   _onMapCreated(MapboxMap controller) {
//     mapboxMap = controller;
//     mapboxMap?.location
//         .updateSettings(LocationComponentSettings(enabled: true));
//     mapboxMap?.location
//         .updateSettings(LocationComponentSettings(puckBearingEnabled: true));
//     mapboxMap?.scaleBar.updateSettings(ScaleBarSettings(
//       enabled: false, // Removes scale bar
//     ));
//     _addMarkerImage();
//   }
//
//   _onStyleLoadedCallback(StyleLoadedEventData data) {}
//
//   @override
//   void dispose() {
//     // _positionStream?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return new AnnotatedRegion<SystemUiOverlayStyle>(
//         value: const SystemUiOverlayStyle(
//           statusBarColor: AppColors.transparent,
//           statusBarIconBrightness: Brightness.dark,
//           systemNavigationBarColor: AppColors.background,
//           systemNavigationBarIconBrightness: Brightness.dark,
//         ),
//         child: Scaffold(
//             body: Stack(
//           children: [
//             Container(
//                 child: Column(
//               children: [
//                 Expanded(
//                   child: latLng == null
//                       ? Container(
//                           color: Colors.white,
//                           child: Center(
//                             child: SizedBox(
//                               width: 40,
//                               height: 40,
//                               child: Loader(),
//                             ),
//                           ),
//                         )
//                       : MapWidget(
//                           key: ValueKey("mapWidget"),
//                           cameraOptions: CameraOptions(
//                               center: Point(
//                                   coordinates: Position(
//                                 latLng!.longitude,
//                                 latLng!.latitude,
//                               )),
//                               zoom: 14),
//                           styleUri: MapboxStyles.LIGHT,
//                           textureView: true,
//                           onMapCreated: _onMapCreated,
//                           onStyleLoadedListener: _onStyleLoadedCallback,
//                           onTapListener: (coordinate){
//                             if(!pickManually)return;
//                             _setMarker(mapContentGestureContext:coordinate);
//                           },
//                         ),
//                 ),
//                 if (!pickManually)
//                   Container(
//                       decoration: const BoxDecoration(
//                         borderRadius: BorderRadius.vertical(
//                             top: Radius.circular(30)),
//                         color: AppColors.lightestGrey,
//                       ),
//                       padding: const EdgeInsets.only(top: 5),
//                       child: Container(
//                         padding: EdgeInsets.only(
//                           bottom: Platform.isIOS ? 20 : 0,
//                           right: 20,
//                           left: 20,
//                         ),
//                         decoration: const BoxDecoration(
//                           borderRadius:
//                               BorderRadius.vertical(top: Radius.circular(20)),
//                           color: Colors.white,
//                         ),
//                         child:
//                             Column(mainAxisSize: MainAxisSize.min, children: [
//                           CustomImageView(
//                             imagePath: Assets.images.carLocation.path,
//                             width: 250,
//                           ),
//                           addVerticalSpacing(
//                             AppSpacing.medium,
//                           ),
//                           addVerticalSpacing(
//                             AppSpacing.small,
//                           ),
//                           SizedBox(
//                               child: Text(
//                             'Welcome ${user.fullName!.split(' ').first}',
//                             style: theme.textTheme.BodyTextSmallRegular
//                                 .copyWith(
//                                     fontWeight: FontWeight.w900,
//                                     fontSize: 18,
//                                     height: 1.7),
//                             textAlign: TextAlign.center,
//                           )),
//                           addVerticalSpacing(
//                             AppSpacing.small,
//                           ),
//                           addVerticalSpacing(
//                             AppSpacing.medium,
//                           ),
//                           SizedBox(
//                               child: Text(
//                             'To get Started, you need to set your location to get your car washed at your convenience.',
//                             style: theme.textTheme.BodyTextSmallRegular
//                                 .copyWith(
//                                     fontWeight: FontWeight.w500,
//                                     height: 1.7,
//                                     fontSize: 13),
//                             textAlign: TextAlign.center,
//                           )),
//                           addVerticalSpacing(
//                             AppSpacing.medium,
//                           ),
//                           addVerticalSpacing(
//                             AppSpacing.medium,
//                           ),
//                           Container(
//                             height: 60,
//                             width: ISize.wh(context),
//                             child: CustomElevatedButton(
//                               text: "Continue with this location",
//                               radius: 1000,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(1000)),
//                               // isLoading: isLoading,
//                               isDisabled: latLng == null,
//                               onPressed: () => context.push(AppRoutes.carInfo),
//                               buttonTextStyle: Theme.of(context)
//                                   .textTheme
//                                   .BodyTextSmallMediumAuto
//                                   .copyWith(color: AppColors.universalWhite),
//                             ),
//                           ),
//                           addVerticalSpacing(
//                             AppSpacing.medium,
//                           ),
//                           Container(
//                             height: 60,
//                             width: ISize.wh(context),
//                             child: CustomElevatedButton(
//                                 radius: 1000,
//                                 backgroundColor: Colors.grey.withOpacity(.2),
//                                 text: "Pick location manually",
//                                 shadowColor: Colors.transparent,
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(1000)),
//                                 // isLoading: isLoading,
//                                 isDisabled: latLng == null,
//                                 onPressed: () async {
//                                  setState(() {
//                                     pickManually = true;
//                                     showDescription = true;
//                                   });
//                                 },
//                                 buttonTextStyle: Theme.of(context)
//                                     .textTheme
//                                     .BodyTextSmallMediumAuto),
//                           ),
//                           addVerticalSpacing(
//                             AppSpacing.medium,
//                           ),
//                         ]),
//                       )),
//               ],
//             )),
//             if (pickManually)
//               Positioned(
//                 top: 0,
//                 child: SafeArea(
//                     child: Container(
//                   width: 50,
//                   height: 50,
//                   margin: const EdgeInsets.symmetric(horizontal: 15),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 2,
//                           blurRadius: 2,
//                           offset: const Offset(0, 0)),
//                     ],
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Center(
//                     child: BackButton(onPressed: (){
//                       setState(() {
//                         pickManually=false;
//                       });
//                     },),
//                   )
//                 )),
//               ),
//               // Positioned(
//               //   top: 0,
//               //   child: SafeArea(
//               //       child: Container(
//               //     width: ISize.wh(context) - 30,
//               //     height: 50,
//               //     margin: const EdgeInsets.symmetric(horizontal: 15),
//               //     decoration: BoxDecoration(
//               //       color: Colors.white,
//               //       boxShadow: [
//               //         BoxShadow(
//               //             color: Colors.grey.withOpacity(0.5),
//               //             spreadRadius: 2,
//               //             blurRadius: 2,
//               //             offset: const Offset(0, 0)),
//               //       ],
//               //       borderRadius: BorderRadius.circular(15),
//               //     ),
//               //     child: Row(
//               //       children: [
//               //         Expanded(
//               //             child: CustomTextFormField(
//               //               controller: _searchController,
//               //           decoration: InputDecoration(
//               //             hintText: "Enter address to search",
//               //             hintStyle: GoogleFonts.poppins(
//               //                 fontSize: 14.fSize,
//               //                 color: const Color.fromARGB(255, 176, 176, 176)),
//               //             contentPadding: const EdgeInsets.symmetric(
//               //                 vertical: 10, horizontal: 16),
//               //             border: InputBorder.none,
//               //             focusedBorder: OutlineInputBorder(
//               //               borderRadius: BorderRadius.circular(10),
//               //               borderSide:
//               //                   const BorderSide(color: AppColors.grey1),
//               //             ),
//               //           ),
//               //         )
//               //         ),
//               //         GestureDetector(
//               //           onTap: (){
//               //             if(isFetchingLocation)return;
//               //             try{
//               //               setState(() {
//               //                 isFetchingLocation = true;
//               //               });
//               //
//               //
//               //               setState(() {
//               //                 isFetchingLocation = false;
//               //               });
//               //             }catch(e){
//               //               setState(() {
//               //                 isFetchingLocation = false;
//               //               });
//               //             }
//               //           },
//               //           child: Container(
//               //             decoration: BoxDecoration(
//               //                 color: AppColors.primary,
//               //                 borderRadius: BorderRadius.circular(10)),
//               //             margin: const EdgeInsets.only(
//               //                 left: 10, right: 5, top: 5, bottom: 5),
//               //             child: Container(
//               //               height: 40,
//               //               width: 50,
//               //               child: Center(
//               //                 child: isFetchingLocation?
//               //                 SizedBox(
//               //                   width: 20,
//               //                   height: 20,
//               //                   child: Loader(),
//               //                 ):Icon(
//               //                   Icons.search,
//               //                   color: Colors.white,
//               //                 ),
//               //               ),
//               //             ),
//               //           ),
//               //         ),
//               //       ],
//               //     ),
//               //   )),
//               // ),
//             if(showDescription && pickManually==true)
//               Positioned(
//                   top: 100,
//                   left: 0,
//                   right: 0,
//                   child: Center(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.blueGrey.withOpacity(.3),
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       padding: EdgeInsets.symmetric(horizontal: 12,vertical: 10),
//                       child: Text('Kindly tap on map to select car location', style: GoogleFonts.poppins(
//                           color: Colors.black,
//                       fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
//                     ),
//                   ))
//           ],
//         ),
//           bottomNavigationBar: pickManually?Container(
//             height: 60,
//             width: ISize.wh(context),
//             padding: EdgeInsets.symmetric(horizontal: 15),
//             child: CustomElevatedButton(
//                 radius: 1000,
//                 backgroundColor: AppColors.primary,
//                 text: "Continue",
//                 shadowColor: Colors.transparent,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(1000)),
//                 onPressed: () => context.push(AppRoutes.carInfo),
//                 buttonTextStyle: Theme.of(context)
//                     .textTheme
//                     .BodyTextSmallMediumAuto.copyWith(
//                   color: Colors.white
//                 )),
//           ):null,
//         )
//     );
//   }
//
//   void _setMarker({MapContentGestureContext? mapContentGestureContext}) async {
//     setState(() {
//       showDescription = false;
//     });
//     mapboxMap?.location
//         .updateSettings(LocationComponentSettings(enabled: false));
//     mapboxMap?.location
//         .updateSettings(LocationComponentSettings(puckBearingEnabled: false));
//
//     Position position = mapContentGestureContext==null? Position(latLng!.longitude, latLng!.latitude)
//         :mapContentGestureContext.point.coordinates;
//     setState(() {
//       latLng = LatLng(position.lat.toDouble(), position.lng.toDouble());
//     });
//     _addMarker(position);
//   }
//
//   /// Setup SymbolManager for handling markers
//   void _setupSymbolManager() async {
//     PointAnnotationManager annotationManager = await mapboxMap!.annotations.createPointAnnotationManager();
//     _symbolManager = annotationManager;
//   }
//
//   /// Adds a marker at the tapped position
//   void _addMarker(Position position) async {
//     _symbolManager?.deleteAll();
//     _symbolManager?.create(PointAnnotationOptions(
//       geometry: Point(coordinates: position),
//       iconImage: "custom-marker",
//       textField: 'car           .',
//       iconSize: 0.2,
//     ));
//   }
//
//   void _addMarkerImage() async {
//       // Load image from assets
//       ByteData bytes = await rootBundle.load("assets/images/marker.png");
//       Uint8List list = bytes.buffer.asUint8List();
//
//       // Decode image to get width & height dynamically
//       final Completer<ImageInfo> completer = Completer();
//       ui.decodeImageFromList(list, (image) {
//         completer.complete(ImageInfo(image: image, scale: 1.0));
//       });
//       ImageInfo imageInfo = await completer.future;
//
//       int width = imageInfo.image.width;
//       int height = imageInfo.image.height;
//
//
//       // Convert Uint8List to MbxImage with correct size
//       MbxImage mbxImage = MbxImage(
//         width: width,
//         height: height,
//         data: list,
//       );
//
//       // Add image to Mapbox style
//       await mapboxMap?.style.addStyleImage(
//         "custom-marker", // Unique image ID
//         1.0, // Scale
//         mbxImage, // MbxImage instance
//         false, // Not an SDF icon
//         [], // No stretchX
//         [], // No stretchY
//         null, // No content
//       );
//
//     _setupSymbolManager();
//   }
// }
//
//
// class Debouncer {
//   final int milliseconds;
//   Timer? _timer;
//
//   Debouncer({required this.milliseconds});
//
//   run(VoidCallback action) {
//     _timer?.cancel(); // Cancel the previous timer if it exists
//     _timer = Timer(Duration(milliseconds: milliseconds), action);
//   }
// }
//
// var locationDebouncer = Debouncer(milliseconds: 2000);