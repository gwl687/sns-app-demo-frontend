import 'dart:typed_data';

import 'package:demo10/pages/web_view_page.dart';
import 'package:demo10/route/route_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../common_ui/smart_refresh/smart_refresh_widget.dart';
import '../../repository/datas/home_list_data.dart';
import '../../route/routes.dart';
import 'home_vm.dart';

///路由管理类
class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  HomeViewModel viewModel = HomeViewModel();
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    viewModel.getBanner();
    viewModel.initListData(false);
  }

  void refreshOrLoad(bool loadMore) {
    viewModel.initListData(
      loadMore,
      callback: (loadMore) {
        if (loadMore) {
          refreshController.loadComplete();
        } else {
          refreshController.refreshCompleted();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (context) {
        return viewModel;
      },
      child: Scaffold(
        body: SafeArea(
          child: SmartRefreshWidget(
            controller: refreshController,
            onLoading: () {
              refreshOrLoad(true);
            },
            onRefresh: () {
              viewModel.getBanner().then((value) {
                refreshOrLoad(false);
              });
            },
            child: SingleChildScrollView(
              child: Column(children: [_banner(), _homeListView()]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _banner() {
    return Consumer<HomeViewModel>(
      builder: (context, vm, child) {
        return SizedBox(
          height: 150.h,
          width: double.infinity,
          child: Swiper(
            indicatorLayout: PageIndicatorLayout.NONE,
            autoplay: true,
            pagination: const SwiperPagination(),
            control: const SwiperControl(),
            itemCount: vm.bannerList?.length ?? 0,
            itemBuilder: (context, index) {
              return Container(
                height: 150.h,
                color: Colors.lightBlue,
                child: Image.network(
                  vm.bannerList?[index]?.imagePath ?? "",
                  fit: BoxFit.fill,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _homeListView() {
    return Consumer<HomeViewModel>(
      builder: (context, vm, child) {
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _listItemView(vm.listData?[index], index);
          },
          itemCount: vm.listData?.length ?? 0,
        );
      },
    );
  }

  Widget _listItemView(HomeListItemData? item, int index) {
    var name;
    if (item?.author?.isNotEmpty == true) {
      name = item?.author ?? "";
    } else {
      name = item?.shareUser ?? "";
    }
    return GestureDetector(
      onTap: () {
        RouteUtils.pushForNamed(
          context,
          RoutePath.webViewPage,
          arguments: {"name": "使用路由传值"},
        );
        //  Navigator.pushNamed(context, RoutePath.webViewPage);
      },
      child: Container(
        margin: EdgeInsets.only(top: 5.h, bottom: 5.h, left: 10.w, right: 10.w),
        padding: EdgeInsets.only(
          top: 15.h,
          bottom: 15.h,
          left: 10.w,
          right: 10.w,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 0.5.r),
          borderRadius: BorderRadius.all(Radius.circular(6.r)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: Image.network(
                    "https://www.dogsforgood.org/wp-content/uploads/2020/06/Dogs-For-Good-October-22-2019-308.jpg",
                    width: 30.r,
                    height: 30.r,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(width: 5.w),
                Text(name, style: TextStyle(color: Colors.black)),
                Expanded(child: SizedBox()),
                Text(
                  item?.niceShareDate ?? "",
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(width: 5.w),
                item?.type?.toInt() == 1
                    ? Text(
                        "置顶",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : SizedBox(),
              ],
            ),
            SizedBox(height: 5.h),
            Text(
              item?.title ?? "",
              style: TextStyle(color: Colors.black, fontSize: 14.sp),
            ),
            SizedBox(height: 5.h),
            Row(
              children: [
                Text(
                  item?.chapterName ?? "",
                  style: TextStyle(color: Colors.green, fontSize: 12.sp),
                ),
                Expanded(child: SizedBox()),
                GestureDetector(
                  onTap: () {
                    var isCollect;
                    if (item?.collect == true) {
                      isCollect = false;
                    } else {
                      isCollect = true;
                    }
                    viewModel.collectOrNo(isCollect, "${item?.id}", index);
                  },
                  child: Image.asset(
                    item?.collect == true
                        ? "assets/images/img_collect.png"
                        : "assets/images/img_collect_grey.png",
                    width: 30.r,
                    height: 30.r,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
