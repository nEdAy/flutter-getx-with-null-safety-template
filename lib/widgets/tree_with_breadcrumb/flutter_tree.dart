library packages;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'utils/data_util.dart';
import 'utils/util.dart';

enum DataType {
  dataList,
  dataMap,
}

/// @desc  参数类型配置
class Config {
  ///数据类型
  final DataType dataType;

  ///父级id key
  final String parentId;

  final String label;

  final String id;

  final String children;

  final String allCheckedNodeName;

  final String? nullCheckedNodeName;

  final String breadcrumbRootName;

  const Config(
      {this.dataType = DataType.dataList,
      this.parentId = 'parentId',
      this.label = 'name',
      this.id = 'id',
      this.children = 'children',
      this.allCheckedNodeName = '全部',
      this.nullCheckedNodeName,
      this.breadcrumbRootName = '根'});
}

/// @desc components
class FlutterTreePro extends StatefulWidget {
  /// source data type Map
  final Map<String, dynamic> treeData;

  /// source data type List
  final List<Map<String, dynamic>> listData;

  /// Config
  final Config config;

  final bool isNullCheckedNodeChecked;

  final Function(Map<String, dynamic>, List<Map<String, dynamic>>, bool)
      onChecked;

  final bool Function(Map<String, dynamic>, Config) isNotRootNode;

  const FlutterTreePro({
    Key? key,
    this.treeData = const <String, dynamic>{},
    this.listData = const <Map<String, dynamic>>[],
    this.config = const Config(),
    this.isNullCheckedNodeChecked = false,
    required this.isNotRootNode,
    required this.onChecked,
  }) : super(key: key);

  @override
  State<FlutterTreePro> createState() => _FlutterTreeProState();
}

enum CheckStatus {
  unChecked,
  partChecked,
  checked,
}

class _FlutterTreeProState extends State<FlutterTreePro> {
  Map<String, dynamic> sourceTreeMap = {};

  bool checkedBox = false;

  /// @desc expand map tree to map
  Map<String, dynamic> treeMap = {};

  List<Map<String, dynamic>> checkedList = [];

  Map<String, dynamic> allCheckedNode = {};

  Map<String, dynamic> nullCheckedNode = {};

  List<Map<String, dynamic>> _breadcrumbList = [];

  @override
  initState() {
    super.initState();
    // set default select
    if (widget.treeData.isEmpty) {
      sourceTreeMap.assignAll(DataUtil.transformListToMap(
          widget.listData, widget.config, widget.isNotRootNode));
    } else {
      sourceTreeMap.assignAll(widget.treeData);
    }
    _factoryTreeData(sourceTreeMap);

    _breadcrumbList.clear();
    _breadcrumbList.add(sourceTreeMap);

    allCheckedNode = {
      'name': widget.config.allCheckedNodeName,
      'checked': CheckStatus.checked,
    };
    if (widget.config.nullCheckedNodeName != null) {
      nullCheckedNode = {
        'name': widget.config.nullCheckedNodeName,
        'checked': widget.isNullCheckedNodeChecked
            ? CheckStatus.checked
            : CheckStatus.unChecked,
      };
    }

    _getCheckedItems();
  }

  /// @desc expand tree data to map
  _factoryTreeData(treeModel) {
    if (treeModel['checked'] == null) {
      treeModel['checked'] = CheckStatus.unChecked;
    }
    treeMap.putIfAbsent(treeModel[widget.config.id], () => treeModel);
    (treeModel[widget.config.children] ?? []).forEach((element) {
      _factoryTreeData(element);
    });
  }

  final ScrollController _treeNodeController = ScrollController();

  _treeNodeListToTop() {
    Timer(const Duration(milliseconds: 0), () {
      if (_treeNodeController.hasClients) {
        _treeNodeController
            .jumpTo(_treeNodeController.position.minScrollExtent);
      }
    });
  }

  _buildTreeRootList() {
    final children = _breadcrumbList.last[widget.config.children];
    if (children == null || children.length == 0) {
      return const Expanded(child: SizedBox.shrink());
    }
    return Expanded(
      child: ListView.separated(
        controller: _treeNodeController,
        itemBuilder: (context, index) {
          final treeNode = children[index];
          if (treeNode != null) {
            if (_breadcrumbList.length == 1) {
              if (index == 0) {
                return Column(
                  children: [
                    _buildTreeNode(allCheckedNode),
                    _buildListDivider(),
                    _buildTreeNode(treeNode),
                  ],
                );
              } else if (index == children.length - 1 &&
                  widget.config.nullCheckedNodeName != null) {
                return Column(
                  children: [
                    _buildTreeNode(treeNode),
                    _buildListDivider(),
                    _buildTreeNode(nullCheckedNode),
                  ],
                );
              } else {
                return _buildTreeNode(treeNode);
              }
            }
            return _buildTreeNode(treeNode);
          } else {
            return const SizedBox.shrink();
          }
        },
        separatorBuilder: (context, index) {
          return _buildListDivider();
        },
        itemCount: children.length,
      ),
    );
  }

  _buildListDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF0F0F0),
      indent: 20,
      endIndent: 20,
    );
  }

  _buildTreeNode(Map<String, dynamic> treeNode) {
    return GestureDetector(
      onTap: () => _onOpenNode(treeNode),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => _selectCheckedBox(treeNode),
                  child: _buildCheckBoxIcon(treeNode),
                ),
                const SizedBox(width: 8),
                _buildCheckBoxLabel(treeNode),
                const SizedBox(width: 8),
                (treeNode[widget.config.children] ?? []).isNotEmpty
                    ? const Icon(
                        Icons.keyboard_arrow_right,
                        size: 24,
                        color: Color(0xFF767676),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// @desc render icon by checked type
  _buildCheckBoxIcon(Map<String, dynamic> treeNode) {
    if (treeNode['checked'] != null && treeNode['checked'] is CheckStatus) {
      switch (treeNode['checked'] as CheckStatus) {
        case CheckStatus.unChecked:
          return const Icon(
            Icons.check_box_outline_blank,
            color: Color(0XFF737373),
            size: 24,
          );
        case CheckStatus.partChecked:
          return const Icon(
            Icons.indeterminate_check_box,
            color: Color(0XFFDE7F02),
            size: 24,
          );
        case CheckStatus.checked:
          return const Icon(
            Icons.check_box,
            color: Color(0XFFDE7F02),
            size: 24,
          );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  _buildCheckBoxLabel(Map<String, dynamic> treeNode) {
    final isChecked = treeNode['checked'] != CheckStatus.unChecked;
    return Expanded(
      child: Text(
        '${treeNode[widget.config.label]}',
        maxLines: 2,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 16,
            color:
                isChecked ? const Color(0xFFD97F00) : const Color(0xFF434343),
            fontWeight: isChecked ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }

  /// @desc expand item if has item has children
  _onOpenNode(Map<String, dynamic> treeNode) {
    if ((treeNode[widget.config.children] ?? []).isEmpty) return;
    setState(() {
      _breadcrumbList.add(treeNode);
    });
    _treeNodeListToTop();
  }

  /// @desc set current treeNode checked/unChecked
  _deepChangeCheckStatus(Map<String, dynamic> treeNode, bool checked) {
    var stack = MStack();
    stack.push(treeNode);
    while (stack.top > 0) {
      Map<String, dynamic> node = stack.pop();
      for (var item in node[widget.config.children] ?? []) {
        stack.push(item);
      }
      node['checked'] = checked ? CheckStatus.checked : CheckStatus.unChecked;
    }
  }

  /// @desc 选中选框
  _selectCheckedBox(Map<String, dynamic> treeNode) {
    CheckStatus checked = treeNode['checked'];
    if (treeNode == allCheckedNode) {
      if (checked == CheckStatus.unChecked) {
        if ((sourceTreeMap[widget.config.children] ?? []).isNotEmpty) {
          _deepChangeCheckStatus(sourceTreeMap, false);
        }
        if (nullCheckedNode['checked'] == CheckStatus.checked) {
          setState(() {
            nullCheckedNode['checked'] = CheckStatus.unChecked;
          });
        }
      }
    } else if (treeNode == nullCheckedNode) {
      setState(() {
        nullCheckedNode['checked'] = checked == CheckStatus.checked
            ? CheckStatus.unChecked
            : CheckStatus.checked;
      });
      if (nullCheckedNode['checked'] == CheckStatus.checked) {
        if ((sourceTreeMap[widget.config.children] ?? []).isNotEmpty) {
          _deepChangeCheckStatus(sourceTreeMap, false);
        }
      }
    } else {
      _deepChangeCheckStatus(
          treeNode, treeNode['checked'] != CheckStatus.checked);
      // 有父节点
      if (widget.isNotRootNode(treeNode, widget.config)) {
        _updateParentNode(treeNode);
      }
    }
    setState(() {
      sourceTreeMap = sourceTreeMap;
    });
    _getCheckedItems();
  }

  /// @desc 获取选中的条目
  _getCheckedItems() {
    var stack = MStack();
    var checkedList = <Map<String, dynamic>>[];
    stack.push(sourceTreeMap);
    while (stack.top > 0) {
      var node = stack.pop();
      for (var item in (node[widget.config.children] ?? [])) {
        stack.push(item);
      }
      if (node['checked'] == CheckStatus.checked) {
        checkedList.add(node);
      }
    }

    final hasCheckedNode = checkedList.isNotEmpty;
    final isNullChecked = nullCheckedNode['checked'] == CheckStatus.checked;
    setState(() {
      if (hasCheckedNode) {
        nullCheckedNode['checked'] = CheckStatus.unChecked;
      }
      if (hasCheckedNode || isNullChecked) {
        allCheckedNode['checked'] = CheckStatus.unChecked;
      } else {
        allCheckedNode['checked'] = CheckStatus.checked;
      }
    });
    this.checkedList = checkedList;
  }

  _updateParentNode(Map<String, dynamic> dataModel) {
    var par = treeMap[dataModel[widget.config.parentId]];
    if (par == null) return;
    int checkLen = 0;
    bool partChecked = false;
    for (var item in (par[widget.config.children] ?? [])) {
      if (item['checked'] == CheckStatus.checked) {
        checkLen++;
      } else if (item['checked'] == CheckStatus.partChecked) {
        partChecked = true;
        break;
      }
    }

    // 如果子孩子全都是选择的，父节点就全选
    if (checkLen == (par[widget.config.children] ?? []).length) {
      par['checked'] = CheckStatus.checked;
    } else if (partChecked ||
        (checkLen < (par[widget.config.children] ?? []).length &&
            checkLen > 0)) {
      par['checked'] = CheckStatus.partChecked;
    } else {
      par['checked'] = CheckStatus.unChecked;
    }

    // 如果还有父节点 解析往上更新
    if (widget.isNotRootNode(par, widget.config)) {
      _updateParentNode(par);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 468,
      color: Colors.white,
      child: Column(
        children: [
          _buildBreadcrumb(),
          _buildTreeRootList(),
          _buildToolBar(),
        ],
      ),
    );
  }

  final ScrollController _breadcrumbController = ScrollController();

  _buildBreadcrumb() {
    if (_breadcrumbList.isNotEmpty) {
      Timer(const Duration(milliseconds: 0), () {
        if (_treeNodeController.hasClients) {
          _breadcrumbController
              .jumpTo(_breadcrumbController.position.maxScrollExtent);
        }
      });
    } else {
      return const SizedBox.shrink();
    }
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: ListView.separated(
              controller: _breadcrumbController,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return _buildBreadcrumbNode(index);
              },
              separatorBuilder: (context, index) {
                return const SizedBox(width: 4);
              },
              itemCount: _breadcrumbList.length,
            ),
          ),
        ],
      ),
    );
  }

  _buildBreadcrumbNode(int index) {
    final treeNode = _breadcrumbList[index];
    if (index == 0) {
      return _buildBreadcrumbNodeText(widget.config.breadcrumbRootName, index);
    }
    return Row(
      children: [
        const Icon(
          Icons.keyboard_arrow_right,
          size: 16,
          color: Color(0xFFABABAB),
        ),
        const SizedBox(width: 4),
        _buildBreadcrumbNodeText(treeNode[widget.config.label], index),
      ],
    );
  }

  _buildBreadcrumbNodeText(String label, int index) {
    final isLast = _breadcrumbList.length - 1 == index;
    return GestureDetector(
      child: Text(label,
          style: TextStyle(
              color: isLast ? Colors.black : const Color(0xFF434343),
              fontSize: 14,
              fontWeight: isLast ? FontWeight.bold : FontWeight.normal)),
      onTap: () {
        setState(() {
          _breadcrumbList = _breadcrumbList.take(index + 1).toList();
        });
        _treeNodeListToTop();
      },
    );
  }

  _buildToolBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1,
            color: Color(0xFFF0F0F0),
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(10, 16, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: allCheckedNode['checked'] == CheckStatus.unChecked
                ? () {
                    _selectCheckedBox(allCheckedNode);
                    if (widget.config.nullCheckedNodeName != null) {
                      if (nullCheckedNode['checked'] == CheckStatus.checked) {
                        nullCheckedNode['checked'] = CheckStatus.unChecked;
                      }
                    }
                    setState(() {
                      _breadcrumbList = _breadcrumbList.take(1).toList();
                    });
                  }
                : null,
            style: TextButton.styleFrom(padding: const EdgeInsets.all(10)),
            child: Text(
              '重置',
              style: TextStyle(
                  color: allCheckedNode['checked'] == CheckStatus.unChecked
                      ? const Color(0xFF767676)
                      : const Color(0xFFAAAAAA),
                  fontWeight: allCheckedNode['checked'] == CheckStatus.unChecked
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontSize: 18),
            ),
          ),
          ElevatedButton(
            onPressed: () => widget.onChecked(sourceTreeMap, checkedList,
                nullCheckedNode['checked'] == CheckStatus.checked),
            style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.5, horizontal: 63),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                backgroundColor: const Color(0xFFFF9F08)),
            child: const Text(
              '确定',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
