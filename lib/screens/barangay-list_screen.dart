import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taguigconnect/configs/request_service.dart';
import 'package:taguigconnect/constants/calculate_constant.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/models/barangay_model.dart';
import 'package:taguigconnect/services/barangay_service.dart';
import 'package:taguigconnect/widgets/barangay/barangay-details_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class BarangayListScreen extends StatefulWidget {
  const BarangayListScreen({super.key});

  @override
  State<BarangayListScreen> createState() => _BarangayListScreenState();
}

class _BarangayListScreenState extends State<BarangayListScreen> {
  double? userLatitude;
  double? userLongitude;
  String? imageUrl;

  Future<List<String>> calculateDistances() async {
    List<String> distances = [];
    bool locationPermission = await RequestService.locationPermission();

    if (locationPermission) {
      try {
        final List<BarangayModel> barangays = await fetchBarangay();
        final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
        final Position position = await geolocator.getCurrentPosition(
          locationSettings: AndroidSettings(accuracy: LocationAccuracy.best),
        );

        userLatitude = position.latitude;
        userLongitude = position.longitude;

        for (BarangayModel barangay in barangays) {
          if (barangay.location != null) {
            Location barangayLocation = barangay.location!;

            final distanceReport = HaversineCalculator.calculateDistance(
              userLatitude!,
              userLongitude!,
              barangayLocation.latitude!,
              barangayLocation.longitude!,
            );

            distances.add(distanceReport);
          }
        }
      } catch (e) {
        print('Error: $e');
        return [];
      }
    } else {
      Navigator.pop(context);
    }

    return distances;
  }

  Future<List<BarangayModel>> fetchBarangay() async {
    try {
      final barangayService = BarangayService();
      final List<BarangayModel> fetchData =
          await barangayService.getbarangays();

      return fetchData;
    } catch (e) {
      print('Error: $e');
    }
    return [];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    fetchBarangay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tcWhite,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: CloseButton(),
        iconTheme: const IconThemeData(color: tcBlack),
        backgroundColor: tcWhite,
        elevation: 0,
        title: Text(
          'BARANGAY',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: tcBlack,
            fontFamily: 'Roboto',
            fontSize: 20.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: fetchBarangay(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: tcViolet,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final data1 = snapshot.data!;

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: .7,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: data1.length,
                        itemBuilder: (context, index) {
                          final item = data1[index];
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return BarangayDetailsWidget(
                                      barangayModel: item,
                                      userLatitude: userLatitude,
                                      userLongitude: userLongitude,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Card(
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(5)),
                                        child: Container(
                                          color: tcAsh,
                                          height: 150.h,
                                          width: double.infinity,
                                          child: item.image != null
                                              ? Image.network(
                                                  item.image!,
                                                  fit: BoxFit.cover,
                                                )
                                              : Center(
                                                  child: Icon(
                                                    Icons.question_mark,
                                                    size: 50,
                                                    color: tcBlack,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name!,
                                              style: TextStyle(
                                                color: tcBlack,
                                                fontFamily: 'PublicSans',
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Text(
                                              'District: ${item.district ?? ''}',
                                              style: TextStyle(
                                                color: tcBlack,
                                                fontFamily: 'PublicSans',
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            Text(
                                              'Contat: ${item.contact!}',
                                              style: TextStyle(
                                                color: tcBlack,
                                                fontFamily: 'PublicSans',
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text('No data available'),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BarangayDetailWidget extends StatelessWidget {
  final BarangayModel barangayModel;
  final double? userLatitude;
  final double? userLongitude;
  const BarangayDetailWidget(
      {super.key,
      required this.barangayModel,
      required this.userLatitude,
      required this.userLongitude});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      height: 600.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                child: barangayModel.image == null
                    ? Center(
                        child: Icon(
                          Icons.question_mark,
                          size: 50,
                          color: tcBlack,
                        ),
                      )
                    : Image.network(
                        barangayModel.image!,
                        fit: BoxFit.cover,
                      ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          barangayModel.name!,
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: tcRed,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'District: ',
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: tcBlack,
                              ),
                            ),
                            Text(
                              barangayModel.district.toString(),
                              style: TextStyle(
                                fontFamily: 'PublicSans',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: tcBlack,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Text(
                      'Contact',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: tcBlack,
                      ),
                    ),
                    Text(
                      barangayModel.contact!,
                      style: TextStyle(
                        fontFamily: 'PublicSans',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: tcBlack,
                      ),
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Text(
                      'Address',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: tcBlack,
                      ),
                    ),
                    Text(
                      barangayModel.address!,
                      style: TextStyle(
                        fontFamily: 'PublicSans',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: tcBlack,
                      ),
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Text(
                      'Response Time',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: tcBlack,
                      ),
                    ),
                    Text(
                      barangayModel.analytics!.responseTime!,
                      style: TextStyle(
                        fontFamily: 'PublicSans',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: tcBlack,
                      ),
                    ),
                    Divider(
                      color: Colors.transparent,
                    ),
                    Text(
                      'Total Resolve Reports',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: tcBlack,
                      ),
                    ),
                    Text(
                      barangayModel.analytics!.totalReports!.toString(),
                      style: TextStyle(
                        fontFamily: 'PublicSans',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: tcBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () async {
                if (userLatitude != null && userLongitude != null) {
                  final Uri launchUri = Uri.parse(
                      'https://www.google.com/maps/dir/$userLatitude, $userLongitude/${barangayModel.location!.latitude!},${barangayModel.location!.longitude!}');
                  await launchUrl(launchUri);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: tcViolet,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              child: Text(
                'View',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PublicSans',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: tcWhite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
