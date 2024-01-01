import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fix_masters/auth/auth_service.dart';
import 'package:fix_masters/customwidgets/bottom_sheet.dart';
import 'package:fix_masters/customwidgets/drawer.dart';
import 'package:fix_masters/pages/all_services_page.dart';
import 'package:fix_masters/pages/filter_page.dart';
import 'package:fix_masters/pages/login_page.dart';
import 'package:fix_masters/pages/show_worker_page.dart';
import 'package:fix_masters/pages/user_profile_and_update.dart';
import 'package:fix_masters/providers/theme_provider.dart';
import 'package:fix_masters/providers/user_provider.dart';
import 'package:fix_masters/providers/worker_provider.dart';
import 'package:fix_masters/utils/constants.dart';
import 'package:fix_masters/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late WorkerProvider _workerProvider;
  late UserProvider _userProvider;
  var _dotPosition = 0;
  String _searchQuery = '';
  String? image;

  void didChangeDependencies() {
    _workerProvider = Provider.of<WorkerProvider>(context);
    _userProvider = Provider.of<UserProvider>(context);
    _workerProvider.init();
    _userProvider.getCurrentUser(AuthService.currentUser!.uid).then((user) {
      if (user != null) {
        image = user.picture;
        setState(() {});
      }
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        backgroundColor: themeProvider.themeModeType == ThemeModeType.Dark
            ? Colors.black26
            : Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: themeProvider.themeModeType == ThemeModeType.Dark
                    ? Colors.white
                    : Colors.black,
              )),
        ),
        title: Text(
          "Fix Masters",
          style: TextStyle(color: btncolor),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, UserProfileandUpdatePage.routeName);
            },
            child: CircleAvatar(
              backgroundColor: Colors.black12,
              radius: 20.r,
              backgroundImage: NetworkImage(image == null ? "" : image!),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: CustomScrollView(
          slivers: [
            // sliver app bar
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 50.h,
              backgroundColor: themeProvider.themeModeType == ThemeModeType.Dark
                  ? Colors.black26
                  : Colors.white,

              floating: true,

              title: Padding(
                padding: EdgeInsets.only(left: 10.0.w),
                child: Row(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r)),
                      elevation: 10,
                      child: Container(
                        width: 300.w,
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.grey.shade200,
                            filled: false,
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide(color: Colors.grey)),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 5.h),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                                borderSide: BorderSide(color: Colors.grey)),
                            suffixIcon: Icon(
                              Icons.search,
                            ),
                            hintText: 'Search Need Your Service',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0.w),
                      child: Card(
                        elevation: 10,
                        child: Container(
                          width: 50.w,
                          child: IconButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, DropDownPage.routeName);
                              },
                              icon: Icon(
                                Icons.filter_list,
                                color: themeProvider.themeModeType ==
                                        ThemeModeType.Dark
                                    ? Colors.white
                                    : Colors.black,
                                size: 30,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // flexibleSpace: FlexibleSpaceBar(
              //   title: Text('F A N C Y A P P B A R'),
              //   background: Container(color: Colors.deepPurple[700]),
              // ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0.w),
                child: Column(
                  children: [
                    _searchQuery.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: _searchQuery.isEmpty
                                ? 0
                                : _workerProvider.typeAndImageList.length,
                            itemBuilder: (context, index) {
                              final worker =
                                  _workerProvider.typeAndImageList[index];
                              if (worker.name!
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase())) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, ShowWorkerPage.routeName,
                                        arguments: [
                                          worker.name,
                                        ]);
                                  },
                                  child: Card(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            "${worker.imageDownloadUrl}"),
                                      ),
                                      title: Text("${worker.name}"),
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            },
                          )
                        : Container(
                            height: 150.h,
                            width: 400.w,
                            child: CarouselSlider(
                                items: _workerProvider.carouselSliderimg
                                    .map((item) => Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                          ),
                                          width: 400.w,
                                          height: 200.h,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20.r),
                                            child: CachedNetworkImage(
                                              imageUrl: item,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  SpinKitFadingCircle(
                                                color: Colors.greenAccent,
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                options: CarouselOptions(
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    viewportFraction: 1,
                                    enlargeStrategy:
                                        CenterPageEnlargeStrategy.height,
                                    onPageChanged:
                                        (val, carouselPageChangedReason) {
                                      setState(() {
                                        _dotPosition = val;
                                      });
                                    })),
                          ),
                    _searchQuery.isEmpty
                        ? DotsIndicator(
                            dotsCount:
                                _workerProvider.carouselSliderimg.length == 0
                                    ? 1
                                    : _workerProvider.carouselSliderimg.length,
                            position: _dotPosition,
                            decorator: DotsDecorator(
                                activeColor: btncolor,
                                color: btncolor.withOpacity(0.5),
                                spacing: EdgeInsets.all(2),
                                activeSize: Size(8.w, 8.h),
                                size: Size(6.w, 6.h)),
                          )
                        : SizedBox(),
                    _searchQuery.isEmpty
                        ? Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Services",
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        barrierColor: Colors.black87,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20),
                                                topLeft: Radius.circular(20))),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return BottomSheetPage();
                                        },
                                      );
                                      // Navigator.pushNamed(
                                      //     context, AllServicesPage.routeName);
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          "See all",
                                        ),
                                        Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 25,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Container(
                                width: double.infinity,
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: 9,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, ShowWorkerPage.routeName,
                                            arguments: [
                                              _workerProvider
                                                  .typeAndImageList[index].name
                                            ]);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                          color: Colors.blueGrey,
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              _workerProvider
                                                  .typeAndImageList[index]
                                                  .imageDownloadUrl!,
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: btncolor,
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(15.r),
                                                  bottomLeft:
                                                      Radius.circular(15.r),
                                                ),
                                              ),
                                              child: Center(
                                                  child: Text(_workerProvider
                                                      .typeAndImageList[index]
                                                      .name!)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    crossAxisCount: 3,
                                    childAspectRatio: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                    _searchQuery.isEmpty
                        ? Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Popular",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.sp),
                                    ),
                                    Icon(Icons.arrow_forward)
                                  ],
                                ),
                              ),
                              Container(
                                height: 180.h,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        _workerProvider.popularList.length,
                                    itemBuilder: (context, index) {
                                      final indx =
                                          _workerProvider.popularList[index];
                                      return Padding(
                                        padding: EdgeInsets.only(right: 20.0.w),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20.r)),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                  ShowWorkerPage.routeName,
                                                  arguments: [indx.name]);
                                            },
                                            child: Container(
                                              width: 250.w,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.r)),
                                              child: Image.network(
                                                "${indx.imageDownloadUrl}",
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          )
                        : SizedBox()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
