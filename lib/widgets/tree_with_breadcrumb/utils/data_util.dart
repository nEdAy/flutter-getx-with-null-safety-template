// ignore_for_file: require_trailing_commas

import '../flutter_tree.dart';

class DataUtil {
  /// @desc  List to map
  static Map<String, dynamic> transformListToMap(
      List<Map<String, dynamic>> dataList,
      Config config,
      bool Function(Map<String, dynamic> treeNode, Config config)
          isNotRootNode) {
    final Map obj = {};
    String? rootId;
    for (final v in dataList) {
      if (v.containsKey([config.id])) {
        v[config.id] = v[config.id].toString();
      }
      // 根节点
      if (v.containsKey(config.parentId)) {
        v[config.parentId] = v[config.parentId].toString();
        if (isNotRootNode(v, config)) {
          final parentId = v[config.parentId];
          if (obj[parentId] != null) {
            if (obj[parentId][config.children] != null) {
              obj[parentId][config.children].add(v);
            } else {
              obj[parentId][config.children] = [v];
            }
          } else {
            obj[parentId] = {
              config.children: [v],
            };
          }
        } else {
          rootId ??= v[config.id];
        }
      } else {
        rootId ??= v[config.id];
      }
      if (v.containsKey(config.id) && obj[v[config.id]] != null) {
        v[config.children] = obj[v[config.id]][config.children];
      }
      obj[v[config.id]] = v;
    }
    return obj[rootId] ?? {};
  }
}
