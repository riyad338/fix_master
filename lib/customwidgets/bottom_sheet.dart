import 'package:cached_network_image/cached_network_image.dart';
import 'package:fix_masters/pages/show_worker_page.dart';
import 'package:fix_masters/providers/theme_provider.dart';
import 'package:fix_masters/providers/worker_provider.dart';
import 'package:fix_masters/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class BottomSheetPage extends StatefulWidget {
  const BottomSheetPage({Key? key}) : super(key: key);

  @override
  State<BottomSheetPage> createState() => _BottomSheetPageState();
}

class _BottomSheetPageState extends State<BottomSheetPage> {
  late WorkerProvider _workerProvider;

  void didChangeDependencies() {
    _workerProvider = Provider.of<WorkerProvider>(context);
    _workerProvider.init();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      height: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 5.h,
              ),
              Container(
                color: themeProvider.themeModeType == ThemeModeType.Dark
                    ? Colors.white
                    : Colors.black,
                height: 4.h,
                width: 30.w,
              ),
              SizedBox(
                height: 8.h,
              ),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _workerProvider.typeAndImageList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, ShowWorkerPage.routeName,
                          arguments: [
                            _workerProvider.typeAndImageList[index].name
                          ]);
                    },
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            color: Colors.greenAccent,
                            child: CachedNetworkImage(
                              imageUrl: _workerProvider
                                  .typeAndImageList[index].imageDownloadUrl!,
                              fit: BoxFit.cover,
                              height: 40.h,
                              width: 85.w,
                              placeholder: (context, url) =>
                                  SpinKitFadingCircle(
                                color: Colors.greenAccent,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Container(
                            child: Center(
                                child: FittedBox(
                              child: Text(_workerProvider
                                  .typeAndImageList[index].name!),
                            )),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 15,
                  crossAxisCount: 4,
                  childAspectRatio: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
