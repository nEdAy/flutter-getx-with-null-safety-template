// ignore_for_file: require_trailing_commas

library packages;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../gen/assets.gen.dart';
import '../highlight_text.dart';
import '../search_widget.dart';
import 'utils/data_util.dart';
import 'utils/util.dart';

enum DataType {
  dataList,
  dataMap,
}

/// @desc  参数类型配置
class Config {
  const Config(
      {this.dataType = DataType.dataList,
      this.parentId = 'parentId',
      this.label = 'name',
      this.id = 'id',
      this.searchHintTextSuffix,
      this.children = 'children',
      this.allCheckedNodeName = '全部',
      this.nullCheckedNodeName,
      this.breadcrumbRootName = '根'});

  ///数据类型
  final DataType dataType;

  ///父级id key
  final String parentId;

  final String label;

  final String id;

  final String? searchHintTextSuffix;

  final String children;

  final String allCheckedNodeName;

  final String? nullCheckedNodeName;

  final String breadcrumbRootName;
}

/// @desc components
class FlutterTreePro extends StatefulWidget {
  const FlutterTreePro({
    super.key,
    this.treeData = const <String, dynamic>{},
    this.listData = const <Map<String, dynamic>>[],
    this.config = const Config(),
    this.isNullCheckedNodeChecked = false,
    required this.isNotRootNode,
    required this.onChecked,
  });

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
  List<Map<String, dynamic>> checkLeafNodeList = [];

  List<Map<String, dynamic>> leafNodeList = [];
  List<Map<String, dynamic>> searchFilteredItems = [];

  Map<String, dynamic> allCheckedNode = {};

  Map<String, dynamic> nullCheckedNode = {};

  Map<String, dynamic>? commonCheckedNode;

  List<Map<String, dynamic>> _breadcrumbList = [];

  final TextEditingController searchController = TextEditingController();

  String? projectSearchKeyword;

  final ScrollController _breadcrumbController = ScrollController();

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

      commonCheckedNode = _breadcrumbList.first[widget.config.children][0];
      if (widget.isNullCheckedNodeChecked == false &&
          commonCheckedNode != null) {
        _selectCheckedBox(commonCheckedNode!);
      }
    }

    _getCheckedItems();
  }

  /// @desc expand tree data to map
  _factoryTreeData(treeModel) {
    if (treeModel['checked'] == null) {
      treeModel['checked'] = CheckStatus.unChecked;
    }
    treeMap.putIfAbsent(treeModel[widget.config.id], () => treeModel);
    (treeModel[widget.config.children] ?? []).forEach(_factoryTreeData);
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

  Expanded _buildTreeRootList() {
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
                if (widget.config.nullCheckedNodeName != null) {
                  return Column(
                    children: [
                      _buildTreeNode(treeNode),
                      _buildListDivider(),
                      _buildTreeNode(nullCheckedNode),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _buildTreeNode(allCheckedNode),
                      _buildListDivider(),
                      _buildTreeNode(treeNode),
                    ],
                  );
                }
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

  Divider _buildListDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF0F0F0),
      indent: 20,
      endIndent: 20,
    );
  }

  GestureDetector _buildTreeNode(Map<String, dynamic> treeNode) {
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
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _selectCheckedBox(treeNode);
                  },
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
  Widget _buildCheckBoxIcon(Map<String, dynamic> treeNode) {
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

  Expanded _buildCheckBoxLabel(Map<String, dynamic> treeNode) {
    final isChecked = treeNode['checked'] != CheckStatus.unChecked;
    return Expanded(
      child: HighlightText(
        text: '${treeNode[widget.config.label]}',
        textStyle: TextStyle(
          color: isChecked ? const Color(0xFFD97F00) : const Color(0xFF434343),
          fontWeight: isChecked ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
        ),
        lightText: projectSearchKeyword ?? '',
        lightStyle: const TextStyle(
          color: Color(0xFFD97F00),
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
      ),
    );
  }

  /// @desc expand item if has item has children
  void _onOpenNode(Map<String, dynamic> treeNode) {
    if ((treeNode[widget.config.children] ?? []).isEmpty) return;
    setState(() {
      _breadcrumbList.add(treeNode);
    });
    _treeNodeListToTop();
  }

  /// @desc set current treeNode checked/unChecked
  _deepChangeCheckStatus(Map<String, dynamic> treeNode, bool checked) {
    final stack = MStack();
    stack.push(treeNode);
    while (stack.top > 0) {
      final Map<String, dynamic> node = stack.pop();
      for (final item in node[widget.config.children] ?? []) {
        stack.push(item);
      }
      node['checked'] = checked ? CheckStatus.checked : CheckStatus.unChecked;
    }
  }

  /// @desc 选中选框
  _selectCheckedBox(Map<String, dynamic> treeNode) {
    if (projectSearchKeyword?.isNotEmpty == true) {
      searchController.clear();
      setState(() {
        projectSearchKeyword = null;
      });
    }
    final CheckStatus checked = treeNode['checked'];
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
    } else if (treeNode == commonCheckedNode) {
      if (checked != CheckStatus.checked) {
        if ((sourceTreeMap[widget.config.children] ?? []).isNotEmpty) {
          _deepChangeCheckStatus(sourceTreeMap, true);
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
    final stack = MStack();
    final checkedList = <Map<String, dynamic>>[];
    stack.push(sourceTreeMap);
    leafNodeList.clear();
    while (stack.top > 0) {
      final node = stack.pop();
      for (final item in (node[widget.config.children] ?? [])) {
        stack.push(item);
      }
      if (node['checked'] == CheckStatus.checked) {
        checkedList.add(node);
      }

      if (node.containsKey('projectId') &&
          node.containsKey('type') &&
          node['type'] == 2 &&
          node['projectId'] != 'null') {
        leafNodeList.add(node);
      }
    }

    final hasCheckedNode = checkedList.isNotEmpty;
    final isNullChecked = nullCheckedNode['checked'] == CheckStatus.checked;
    setState(() {
      if (commonCheckedNode != null) {
        if (hasCheckedNode) {
          allCheckedNode['checked'] = CheckStatus.unChecked;
          nullCheckedNode['checked'] = CheckStatus.unChecked;
        }
        if (isNullChecked) {
          allCheckedNode['checked'] = CheckStatus.unChecked;
          commonCheckedNode!['checked'] = CheckStatus.unChecked;
        }
      } else {
        if (hasCheckedNode) {
          allCheckedNode['checked'] = CheckStatus.unChecked;
        } else {
          allCheckedNode['checked'] = CheckStatus.checked;
        }
      }
    });
    this.checkedList = checkedList;
    checkLeafNodeList.clear();
    for (var element in checkedList) {
      if (element.containsKey('projectId') &&
          element.containsKey('type') &&
          element['type'] == 4 &&
          element['projectId'] != 'null') {
        checkLeafNodeList.add(element);
      }
    }
  }

  void _updateParentNode(Map<String, dynamic> dataModel) {
    final par = treeMap[dataModel[widget.config.parentId]];
    if (par == null) return;
    int checkLen = 0;
    bool partChecked = false;
    for (final item in (par[widget.config.children] ?? [])) {
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
    final searchHintText = widget.config.searchHintTextSuffix;
    return searchHintText != null
        ? Column(
            children: [
              SearchWidget(
                hintText: '搜索$searchHintText',
                searchController: searchController,
                onSearchInputChanged: (value) => _onSearchValueChanged(value),
                onSearchInputSubmitted: (value) => _onSearchValueChanged(value),
                onClearTap: () {
                  searchController.clear();
                  setState(() {
                    projectSearchKeyword = null;
                  });
                },
              ),
              Container(
                height: 398,
                color: Colors.white,
                child: IndexedStack(
                  index: projectSearchKeyword?.isNotEmpty == true ? 1 : 0,
                  children: <Widget>[
                    Column(
                      children: [
                        _buildBreadcrumb(),
                        _buildTreeRootList(),
                        _buildToolBar(),
                      ],
                    ),
                    Column(
                      children: [
                        _buildSearchList(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
        : Container(
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

  Widget _buildBreadcrumb() {
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

  Widget _buildBreadcrumbNode(int index) {
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

  GestureDetector _buildBreadcrumbNodeText(String label, int index) {
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

  Container _buildToolBar() {
    final searchMode = widget.config.searchHintTextSuffix?.isNotEmpty == true;
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
          Row(
            children: [
              searchMode
                  ? _clickableDropDownButton(
                      checkLeafNodeList.isEmpty
                          ? '已选 全部 '
                          : '已选 ${checkLeafNodeList.length}',
                      Get.isBottomSheetOpen ?? false,
                      checkLeafNodeList.isNotEmpty,
                      () => checkLeafNodeList.isEmpty
                          ? null
                          : _showCalendarBottomSheet(),
                    )
                  : const SizedBox.shrink(),
              (!searchMode || checkLeafNodeList.isNotEmpty)
                  ? Row(
                      children: [
                        _buildResetButton(),
                      ],
                    )
                  : const SizedBox.shrink(),
            ],
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

  _buildResetButton() {
    final isNeedReset = (commonCheckedNode == null &&
            allCheckedNode['checked'] == CheckStatus.unChecked) ||
        (commonCheckedNode != null && !checkedList.contains(commonCheckedNode));
    return TextButton(
      onPressed: isNeedReset
          ? () {
              if (commonCheckedNode != null) {
                nullCheckedNode['checked'] = CheckStatus.unChecked;
                _selectCheckedBox(commonCheckedNode!);
              } else {
                _selectCheckedBox(allCheckedNode);
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
            color:
                isNeedReset ? const Color(0xFF767676) : const Color(0xFFAAAAAA),
            fontWeight: isNeedReset ? FontWeight.bold : FontWeight.normal,
            fontSize: 18),
      ),
    );
  }

  _clickableDropDownButton(
    String value,
    bool isOpen,
    bool isNotNull,
    GestureTapCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isOpen || isNotNull
                    ? const Color(0xFFD97F00)
                    : const Color(0xFFAAAAAA),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            isOpen
                ? Assets.images.common.iconArrowDropDownActive
                    .image(width: 16, height: 16)
                : Assets.images.common.iconArrowDropDown
                    .image(width: 16, height: 16),
          ],
        ),
      ),
    );
  }

  _buildSearchList() {
    return Expanded(
      flex: 3,
      child: searchFilteredItems.isEmpty == true
          ? Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.only(top: 120),
              child: Text(
                '未找到相关${widget.config.searchHintTextSuffix}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF767676), fontSize: 16),
              ),
            )
          : ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return _buildTreeNode(searchFilteredItems[index]);
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F0F0),
                  indent: 20,
                  endIndent: 20,
                );
              },
              itemCount: searchFilteredItems.length,
            ),
    );
  }

  _onSearchValueChanged(String value) {
    setState(() {
      projectSearchKeyword = value;
      if (value.isBlank ?? true) {
        searchFilteredItems.assignAll(leafNodeList);
      } else {
        final newFilteredItems = <Map<String, dynamic>>[];
        for (final element in leafNodeList) {
          if (element[widget.config.label].contains(value) ?? false) {
            newFilteredItems.add(element);
          }
        }
        searchFilteredItems.assignAll(newFilteredItems);
      }
    });
  }

  _showCalendarBottomSheet() {
    Get.bottomSheet(
      StatefulBuilder(builder: (context, setBottomSheetState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCheckedLabelWidget(),
            _buildCheckedListViewWidget(setBottomSheetState),
          ],
        );
      }),
      backgroundColor: Colors.white,
      barrierColor: const Color(0xB3000000),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      isScrollControlled: true,
    );
  }

  _buildCheckedLabelWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '已选 ${checkLeafNodeList.length}',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: Get.back,
            icon: ImageIcon(Assets.images.common.iconClose.image().image),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            iconSize: 24,
            color: const Color(0xFF777777),
          ),
        ],
      ),
    );
  }

  _buildCheckedListViewWidget(StateSetter setBottomSheetState) {
    return SizedBox(
      height: 0.75.sh,
      child: ListView.separated(
          itemBuilder: (BuildContext context, int index) =>
              _buildCheckedListViewItemWidget(index, setBottomSheetState),
          separatorBuilder: (BuildContext context, int index) =>
              _buildListDivider(),
          itemCount: checkLeafNodeList.length),
    );
  }

  _buildCheckedListViewItemWidget(int index, StateSetter setBottomSheetState) {
    final nodeItem = checkLeafNodeList[index];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '${nodeItem[widget.config.label]}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF434343),
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              _selectCheckedBox(nodeItem);
              setBottomSheetState(() {});
            },
            behavior: HitTestBehavior.translucent,
            child: const Padding(
              padding: EdgeInsets.all(2.0),
              child: Text(
                '移除',
                style: TextStyle(
                  color: Color(0xFF767676),
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
