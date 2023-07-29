import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:fix_masters/auth/auth_service.dart';
import 'package:fix_masters/customwidgets/drawer.dart';
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
              expandedHeight: 50,
              backgroundColor: themeProvider.themeModeType == ThemeModeType.Dark
                  ? Colors.black26
                  : Colors.white,

              floating: true,

              title: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Container(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 10,
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
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
              ),
              // flexibleSpace: FlexibleSpaceBar(
              //   title: Text('F A N C Y A P P B A R'),
              //   background: Container(color: Colors.deepPurple[700]),
              // ),
            ),

            SliverToBoxAdapter(
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
                      : AspectRatio(
                          aspectRatio: 3.5,
                          child: CarouselSlider(
                              items: _workerProvider.carouselSliderimg
                                  .map((item) => Padding(
                                        padding: const EdgeInsets.only(
                                            left: 3, right: 3),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(item),
                                                  fit: BoxFit.fitWidth)),
                                        ),
                                      ))
                                  .toList(),
                              options: CarouselOptions(
                                  autoPlay: true,
                                  enlargeCenterPage: true,
                                  viewportFraction: 0.8,
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
                            activeSize: Size(8, 8),
                            size: Size(6, 6),
                          ),
                        )
                      : SizedBox(),
                  _searchQuery.isEmpty
                      ? Container(
                          width: double.infinity,
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _workerProvider.typeAndImageList.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      ShowWorkerPage.routeName, arguments: [
                                    _workerProvider.typeAndImageList[index].name
                                  ]);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.blueGrey,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        _workerProvider.typeAndImageList[index]
                                            .imageDownloadUrl!,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: btncolor,
                                          borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(15),
                                            bottomLeft: Radius.circular(15),
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
                        )
                      : SizedBox()
                ],
              ),
            ),
          ],
        ),
      ),
      // body: Container(
      //   padding: EdgeInsets.symmetric(horizontal: 10),
      //   width: double.infinity,
      //   child: SingleChildScrollView(
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         Container(
      //           child: Card(
      //             shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(20)),
      //             elevation: 10,
      //             child: TextFormField(
      //               onChanged: (value) {
      //                 setState(() {
      //                   _searchQuery = value;
      //                 });
      //               },
      //               decoration: InputDecoration(
      //                   fillColor: Colors.grey.shade200,
      //                   filled: true,
      //                   enabledBorder: OutlineInputBorder(
      //                       borderRadius: BorderRadius.circular(15.r),
      //                       borderSide: BorderSide(color: Colors.grey)),
      //                   contentPadding:
      //                       EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      //                   focusedBorder: OutlineInputBorder(
      //                       borderRadius: BorderRadius.circular(15.r),
      //                       borderSide: BorderSide(color: Colors.grey)),
      //                   suffixIcon: Icon(
      //                     Icons.search,
      //                     color: Colors.black,
      //                   ),
      //                   hintText: 'Search Need Your Service',
      //                   hintStyle: TextStyle(
      //                       color: themeProvider.themeModeType ==
      //                               ThemeModeType.Dark
      //                           ? Colors.black54
      //                           : Colors.grey)),
      //             ),
      //           ),
      //         ),
      //         SizedBox(
      //           height: 10,
      //         ),
      //         _searchQuery.isNotEmpty
      //             ? ListView.builder(
      //                 shrinkWrap: true,
      //                 itemCount: _searchQuery.isEmpty
      //                     ? 0
      //                     : _workerProvider.typeAndImageList.length,
      //                 itemBuilder: (context, index) {
      //                   final worker = _workerProvider.typeAndImageList[index];
      //                   if (worker.name!
      //                       .toLowerCase()
      //                       .contains(_searchQuery.toLowerCase())) {
      //                     return InkWell(
      //                       onTap: () {
      //                         Navigator.pushNamed(
      //                             context, ShowWorkerPage.routeName,
      //                             arguments: [
      //                               worker.name,
      //                             ]);
      //                       },
      //                       child: Card(
      //                         child: ListTile(
      //                           leading: CircleAvatar(
      //                             backgroundImage: NetworkImage(
      //                                 "${worker.imageDownloadUrl}"),
      //                           ),
      //                           title: Text("${worker.name}"),
      //                         ),
      //                       ),
      //                     );
      //                   } else {
      //                     return Container();
      //                   }
      //                 },
      //               )
      //             : AspectRatio(
      //                 aspectRatio: 3.5,
      //                 child: CarouselSlider(
      //                     items: _workerProvider.carouselSliderimg
      //                         .map((item) => Padding(
      //                               padding: const EdgeInsets.only(
      //                                   left: 3, right: 3),
      //                               child: Container(
      //                                 decoration: BoxDecoration(
      //                                     image: DecorationImage(
      //                                         image: NetworkImage(item),
      //                                         fit: BoxFit.fitWidth)),
      //                               ),
      //                             ))
      //                         .toList(),
      //                     options: CarouselOptions(
      //                         autoPlay: true,
      //                         enlargeCenterPage: true,
      //                         viewportFraction: 0.8,
      //                         enlargeStrategy: CenterPageEnlargeStrategy.height,
      //                         onPageChanged: (val, carouselPageChangedReason) {
      //                           setState(() {
      //                             _dotPosition = val;
      //                           });
      //                         })),
      //               ),
      //         SizedBox(
      //           height: 10.h,
      //         ),
      //         _searchQuery.isEmpty
      //             ? DotsIndicator(
      //                 dotsCount: _workerProvider.carouselSliderimg.length == 0
      //                     ? 1
      //                     : _workerProvider.carouselSliderimg.length,
      //                 position: _dotPosition,
      //                 decorator: DotsDecorator(
      //                   activeColor: btncolor,
      //                   color: btncolor.withOpacity(0.5),
      //                   spacing: EdgeInsets.all(2),
      //                   activeSize: Size(8, 8),
      //                   size: Size(6, 6),
      //                 ),
      //               )
      //             : SizedBox(),
      //         _searchQuery.isEmpty
      //             ? Container(
      //                 width: double.infinity,
      //                 child: GridView.builder(
      //                   physics: NeverScrollableScrollPhysics(),
      //                   shrinkWrap: true,
      //                   itemCount: _workerProvider.typeAndImageList.length,
      //                   itemBuilder: (context, index) {
      //                     return InkWell(
      //                       onTap: () {
      //                         Navigator.pushNamed(
      //                             context, ShowWorkerPage.routeName,
      //                             arguments: [
      //                               _workerProvider.typeAndImageList[index].name
      //                             ]);
      //                       },
      //                       child: Container(
      //                         decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(15),
      //                           color: Colors.blueGrey,
      //                           image: DecorationImage(
      //                             image: NetworkImage(
      //                               _workerProvider.typeAndImageList[index]
      //                                   .imageDownloadUrl!,
      //                             ),
      //                             fit: BoxFit.cover,
      //                           ),
      //                         ),
      //                         child: Column(
      //                           mainAxisAlignment: MainAxisAlignment.end,
      //                           children: [
      //                             Container(
      //                               decoration: BoxDecoration(
      //                                 color: btncolor,
      //                                 borderRadius: BorderRadius.only(
      //                                   bottomRight: Radius.circular(15),
      //                                   bottomLeft: Radius.circular(15),
      //                                 ),
      //                               ),
      //                               child: Center(
      //                                   child: Text(_workerProvider
      //                                       .typeAndImageList[index].name!)),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                     );
      //                   },
      //                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //                     crossAxisSpacing: 10,
      //                     mainAxisSpacing: 10,
      //                     crossAxisCount: 3,
      //                     childAspectRatio: 1.5,
      //                   ),
      //                 ),
      //               )
      //             : SizedBox()
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
