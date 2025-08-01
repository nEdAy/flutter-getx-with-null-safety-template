// import 'package:extended_image/extended_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../../gen/assets.gen.dart';
// import 'image_controller.dart';
//
// class ImageView extends ConsumerWidget {
//   const ImageView({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Obx(() {
//           final titles = controller.titles;
//           final pageIndex = controller.pageIndex.value;
//           return Text(
//             titles == null ? '' : titles[pageIndex],
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           );
//         }),
//         centerTitle: true,
//         backgroundColor: Colors.black,
//         iconTheme: const IconThemeData(color: Colors.white),
//         leading: IconButton(
//           onPressed: Get.back,
//           icon: ImageIcon(Assets.images.common.iconArrowBack.image().image),
//           iconSize: 24,
//         ),
//       ),
//       body: Material(color: Colors.black, child: _choiceImageStack()),
//     );
//   }
//
//   RenderObjectWidget _choiceImageStack() {
//     final urlsLength = controller.urls?.length ?? 0;
//     final filesLength = controller.files?.length ?? 0;
//     if (urlsLength > 0) {
//       return _networkImageStack(urlsLength);
//     } else if (filesLength > 0) {
//       return _fileImageStack(filesLength);
//     } else {
//       return const SizedBox.shrink();
//     }
//   }
//
//   Stack _networkImageStack(int urlsLength) {
//     return Stack(
//       alignment: AlignmentDirectional.bottomCenter,
//       children: [
//         ExtendedImageGesturePageView.builder(
//           controller: controller.pageController,
//           itemCount: urlsLength,
//           canScrollPage: (GestureDetails? gestureDetails) => urlsLength > 1,
//           onPageChanged: (int index) => controller.pageIndex.value = index,
//           itemBuilder: (BuildContext context, int index) {
//             final urls = controller.urls;
//             if (urls != null) {
//               final imageUrl = urls[index];
//               if (imageUrl.isNotEmpty) {
//                 return ExtendedImage.network(
//                   imageUrl,
//                   fit: BoxFit.contain,
//                   mode: ExtendedImageMode.gesture,
//                   headers: controller.headers,
//                   cache: controller.enableMemoryCache ?? true,
//                   clearMemoryCacheWhenDispose:
//                       controller.clearMemoryCacheWhenDispose ?? false,
//                   initGestureConfigHandler: (ExtendedImageState state) =>
//                       _buildGestureConfig(),
//                 );
//               }
//             }
//             return const SizedBox.shrink();
//           },
//         ),
//         _buildIndicator(urlsLength),
//       ],
//     );
//   }
//
//   Stack _fileImageStack(int fileLength) {
//     return Stack(
//       alignment: AlignmentDirectional.bottomCenter,
//       children: [
//         ExtendedImageGesturePageView.builder(
//           controller: controller.pageController,
//           itemCount: fileLength,
//           canScrollPage: (GestureDetails? gestureDetails) => fileLength > 1,
//           onPageChanged: (int index) => controller.pageIndex.value = index,
//           itemBuilder: (BuildContext context, int index) {
//             final dynamic files = controller.files;
//             if (files != null) {
//               final file = files[index];
//               if (file != null && file.existsSync() == true) {
//                 return ExtendedImage.file(
//                   file,
//                   fit: BoxFit.contain,
//                   mode: ExtendedImageMode.gesture,
//                   clearMemoryCacheWhenDispose:
//                       controller.clearMemoryCacheWhenDispose ?? true,
//                   initGestureConfigHandler: (ExtendedImageState state) =>
//                       _buildGestureConfig(),
//                 );
//               }
//             }
//             return const SizedBox.shrink();
//           },
//         ),
//         _buildIndicator(fileLength),
//       ],
//     );
//   }
//
//   GestureConfig _buildGestureConfig() {
//     return GestureConfig(
//       // you must set inPageView true if you want to use ExtendedImageGesturePageView
//       inPageView: true,
//       minScale: 0.9,
//       animationMinScale: 0.7,
//       maxScale: 4,
//       animationMaxScale: 4.5,
//       reverseMousePointerScrollDirection: true,
//     );
//   }
//
//   SingleChildRenderObjectWidget _buildIndicator(int length) {
//     return length > 1
//         ? Padding(
//             padding: const EdgeInsets.only(bottom: 25),
//             child: Obx(
//               () => Indicator(
//                 pageIndex: controller.pageIndex.value,
//                 itemCount: length,
//               ),
//             ),
//           )
//         : const SizedBox.shrink();
//   }
// }
//
// class Indicator extends StatelessWidget {
//   const Indicator({
//     super.key,
//     required this.pageIndex,
//     required this.itemCount,
//   });
//
//   /// PageView的当前Index
//   final int pageIndex;
//
//   /// 指示器的个数
//   final int itemCount;
//
//   /// 普通的颜色
//   final Color normalColor = const Color(0x66FFFFFF);
//
//   /// 选中的颜色
//   final Color selectedColor = const Color(0xE6FFFFFF);
//
//   /// 点的大小
//   final double size = 8;
//
//   /// 点的间距
//   final double spacing = 4;
//
//   /// 点的Widget
//   Widget _buildIndicator(
//     int index,
//     int pageCount,
//     double dotSize,
//     double spacing,
//   ) {
//     // 是否是当前页面被选中
//     final bool isCurrentPageSelected = index == pageIndex.round();
//     return SizedBox(
//       height: size,
//       width: size + (2 * spacing),
//       child: Center(
//         child: Material(
//           color: isCurrentPageSelected ? selectedColor : normalColor,
//           type: MaterialType.circle,
//           child: SizedBox(width: dotSize, height: dotSize),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: List<Widget>.generate(itemCount, (int index) {
//         return _buildIndicator(index, itemCount, size, spacing);
//       }),
//     );
//   }
// }
