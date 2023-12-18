import 'package:cached_network_image/cached_network_image.dart';
import 'package:fix_masters/pages/show_worker_page.dart';
import 'package:fix_masters/providers/theme_provider.dart';
import 'package:fix_masters/providers/worker_provider.dart';
import 'package:fix_masters/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AllServicesPage extends StatefulWidget {
  static const String routeName = '/allservicespage';

  @override
  State<AllServicesPage> createState() => _AllServicesPageState();
}

class _AllServicesPageState extends State<AllServicesPage> {
  late WorkerProvider _workerProvider;

  void didChangeDependencies() {
    _workerProvider = Provider.of<WorkerProvider>(context);

    _workerProvider.init();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: themeProvider.themeModeType == ThemeModeType.Dark
              ? Colors.white
              : Colors.black,
        ),
        backgroundColor: themeProvider.themeModeType == ThemeModeType.Dark
            ? Colors.black26
            : Colors.white,
        title: Text(
          "All Services",
          style: TextStyle(
            color: themeProvider.themeModeType == ThemeModeType.Dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: _workerProvider.typeAndImageList.length,
          itemBuilder: (context, index) {
            return InkWell(
              child: Padding(
                padding: EdgeInsets.only(bottom: 5.h),
                child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, ShowWorkerPage.routeName,
                          arguments: [
                            _workerProvider.typeAndImageList[index].name
                          ]);
                    },
                    tileColor: themeProvider.themeModeType == ThemeModeType.Dark
                        ? Colors.white12
                        : Colors.black12,
                    leading: CachedNetworkImage(
                      imageUrl: _workerProvider
                          .typeAndImageList[index].imageDownloadUrl!,
                      fit: BoxFit.cover,
                      height: 45.h,
                      width: 60.w,
                      placeholder: (context, url) => SpinKitThreeInOut(
                        color: Colors.greenAccent,
                        size: 15,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    // Image.network(
                    //   _workerProvider.typeAndImageList[index].imageDownloadUrl!,
                    //   height: 45,
                    //   width: 60,
                    //   fit: BoxFit.cover,
                    // ),
                    title: Text(_workerProvider.typeAndImageList[index].name!)),
              ),
            );
          }),
    );
  }
}
