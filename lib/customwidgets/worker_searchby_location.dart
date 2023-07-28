import 'package:cached_network_image/cached_network_image.dart';
import 'package:fix_masters/models/worker_form_model.dart';
import 'package:fix_masters/pages/worker_details_page.dart';
import 'package:fix_masters/providers/theme_provider.dart';
import 'package:fix_masters/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class WorkerSearchByLocation extends StatefulWidget {
  WorkerSearchByLocation(this.worker);
  final WorkerFormModel worker;
  @override
  State<WorkerSearchByLocation> createState() => _WorkerSearchByLocationState();
}

class _WorkerSearchByLocationState extends State<WorkerSearchByLocation> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, WorkerDetailsPage.routeName,
            arguments: [widget.worker.id, widget.worker.name]);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        elevation: 7,
        child: Column(
          children: [
            widget.worker.imageDownloadUrl == null
                ? Expanded(
                    child: Image.asset(
                    'images/wait.jpg',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ))
                : Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: CachedNetworkImage(
                        imageUrl: widget.worker.imageDownloadUrl!,
                        width: double.infinity,
                        height: 250.h,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => SpinKitFadingCircle(
                          color: Colors.greenAccent,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                widget.worker.name!,
                style: TextStyle(
                    fontSize: 16.sp,
                    color: themeProvider.themeModeType == ThemeModeType.Dark
                        ? Colors.white
                        : Colors.black),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(4.0),
            //   child: Text(
            //     '${widget.worker.location}',
            //     style: TextStyle(fontSize: 20.sp, color: Colors.black),
            //   ),
            // ),
            CircleAvatar(
              backgroundColor: Colors.black12,
              child: IconButton(
                  onPressed: () {
                    contactCall(context, '${widget.worker.phone}');
                  },
                  icon: Icon(
                    Icons.call,
                    color: Colors.green,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
