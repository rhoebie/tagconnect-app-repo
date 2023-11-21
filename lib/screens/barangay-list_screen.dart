import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:taguigconnect/configs/request_service.dart';
import 'package:taguigconnect/constants/calculate_constant.dart';
import 'package:taguigconnect/constants/color_constant.dart';
import 'package:taguigconnect/models/barangay_model.dart';
import 'package:taguigconnect/services/barangay_service.dart';
import 'package:taguigconnect/widgets/barangay/barangay-details_widget.dart';

class BarangayListScreen extends StatefulWidget {
  const BarangayListScreen({super.key});

  @override
  State<BarangayListScreen> createState() => _BarangayListScreenState();
}

class _BarangayListScreenState extends State<BarangayListScreen> {
  String? imageUrl;

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
