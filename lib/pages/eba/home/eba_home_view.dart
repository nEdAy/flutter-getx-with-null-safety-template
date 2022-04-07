import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../gen/assets.gen.dart';
import '../../../routes/app_pages.dart';
import 'eba_home_controller.dart';

class EbaHomeView extends GetView<EbaHomeController> {
  const EbaHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EBA - 首页'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    child: const Text('告警'),
                    onPressed: () => Get.toNamed(Routes.ebaAlarm)),
                TextButton(
                    child: const Text('一键巡检'),
                    onPressed: () => Get.toNamed(Routes.ebaReport)),
              ],
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Obx(() => Text(
                  '${controller.count}',
                  style: Theme.of(context).textTheme.headline4,
                )),
            Card(
              margin: const EdgeInsets.all(10.0),
              child: Container(
                height: 150,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10.0),
                child: ListTile(
                  leading: Assets.images.flutterLogo.image(),
                  title: Obx(() => Text(
                        '${controller.hitokoto}',
                        textAlign: TextAlign.left,
                        softWrap: true,
                        style: Theme.of(context).textTheme.bodyLarge,
                      )),
                  subtitle: Obx(() => Text(
                        '—— 「${controller.from}」',
                        textAlign: TextAlign.right,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      )),
                  trailing: IconButton(
                    icon: const Icon(Icons.refresh),
                    color: Colors.blue,
                    onPressed: () => controller.onRefresh(),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    child: const Text('Show Notification'),
                    onPressed: () =>
                        BotToast.showSimpleNotification(title: "init")),
                TextButton(
                    child: const Text('Show Toast'),
                    onPressed: () => BotToast.showText(text: "Text One")),
                OutlinedButton(
                  child: const Text('Jump Page'),
                  onPressed: () => Get.toNamed('/next'),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.increment(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
