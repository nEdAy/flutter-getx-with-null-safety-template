import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../api/http_manager.dart';
import '../../api/response/hitokoto/hitokoto_response.dart';
import '../../gen/assets.gen.dart';
import '../../routes/app_pages.dart';

part 'home.g.dart';

// @riverpod
// int count(Ref ref) {
//   return 0;
// }

/// Annotating a class by `@riverpod` defines a new shared state for your application,
/// accessible using the generated [counterProvider].
/// This class is both responsible for initializing the state (through the [build] method)
/// and exposing ways to modify it (cf [increment]).
@riverpod
class Counter extends _$Counter {
  /// Classes annotated by `@riverpod` **must** define a [build] function.
  /// This function is expected to return the initial state of your shared state.
  /// It is totally acceptable for this function to return a [Future] or [Stream] if you need to.
  /// You can also freely define parameters on this method.
  @override
  int build() => 0;

  void increment() => state++;
}

@riverpod
Future<HitokotoResponse> hitokoto(Ref ref) async {
  // try {
  return HttpManager().client.getHitokoto('json', 'utf-8');
  // } catch (error) {
  //   // non-200 error goes here.
  //   switch (error.runtimeType) {
  //     case DioException _:
  //       // Here's the sample to get the failed response error code and message
  //       final res = (error as DioException).response;
  //       talker.error('Got error : ${res?.statusCode} -> ${res?.statusMessage}');
  //       break;
  //     default:
  //       break;
  //   }
  //   return null;
  // }
}

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = useState(0);
    final AsyncValue<HitokotoResponse> hitokoto = ref.watch(hitokotoProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You have pushed the button this many times:'),
              Text(
                '${ref.watch(counterProvider)} + ${counter.value}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Card(
                margin: const EdgeInsets.all(10.0),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10.0),
                  child: switch (hitokoto) {
                    AsyncData(:final value) => ListTile(
                      leading: Assets.images.flutterLogo.image(),
                      title: Text(
                        '${value.hitokoto}',
                        textAlign: TextAlign.left,
                        softWrap: true,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      subtitle: Text(
                        '—— 「${value.from}」',
                        textAlign: TextAlign.right,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.refresh),
                        color: Colors.blue,
                        onPressed: () => ref.refresh(hitokotoProvider.future),
                      ),
                    ),
                    AsyncError() => ListTile(
                      title: const Text('Oops, something unexpected happened'),
                      trailing: IconButton(
                        icon: const Icon(Icons.refresh),
                        color: Colors.blue,
                        onPressed: () => ref.refresh(hitokotoProvider.future),
                      ),
                    ),
                    _ => const CircularProgressIndicator(),
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    child: const Text('Show Notification'),
                    onPressed: () =>
                        BotToast.showSimpleNotification(title: "init"),
                  ),
                  TextButton(
                    child: const Text('Show Toast'),
                    onPressed: () => BotToast.showText(text: "Text One"),
                  ),
                ],
              ),
              OutlinedButton(
                child: const Text('Go Image Page'),
                onPressed: () => context.go(Paths.image),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).increment(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
