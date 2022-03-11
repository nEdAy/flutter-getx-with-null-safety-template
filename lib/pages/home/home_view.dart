import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../res.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                  leading: const ImageIcon(
                    AssetImage(Res.flutter_logo),
                    color: Colors.blue,
                  ),
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
