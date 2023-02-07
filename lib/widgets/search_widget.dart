import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../gen/assets.gen.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
    required this.hintText,
    required this.searchController,
    this.keyboardType = TextInputType.text,
    this.horizontal = 20.0,
    this.onSearchInputChanged,
    this.onSearchInputSubmitted,
    this.prefix,
    this.autofocus,
    required this.onClearTap,
  });

  final String hintText;
  final TextEditingController searchController;
  final TextInputType? keyboardType;
  final double horizontal;
  final ValueChanged<String>? onSearchInputChanged;
  final ValueChanged<String>? onSearchInputSubmitted;
  final GestureTapCallback onClearTap;
  final Widget? prefix;
  final bool? autofocus;

  @override
  State<StatefulWidget> createState() {
    return _SearchWidgetState();
  }
}

class _SearchWidgetState extends State<SearchWidget> {
  bool isShowClearIcon = false;
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final onSearchInputChanged = widget.onSearchInputChanged;
    final onSearchInputSubmitted = widget.onSearchInputSubmitted;
    return Container(
      width: context.width,
      alignment: Alignment.center,
      height: 70.h,
      padding: EdgeInsets.symmetric(horizontal: widget.horizontal),
      color: Colors.white,
      child: TextField(
        controller: widget.searchController,
        keyboardType: widget.keyboardType,
        autofocus: widget.autofocus ?? false,
        focusNode: _focusNode,
        style: const TextStyle(
          color: Color(0xFF434343),
          fontSize: 16,
          fontWeight: FontWeight.bold,
          textBaseline: TextBaseline.alphabetic,
        ),
        textAlignVertical: TextAlignVertical.bottom,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          isDense: true,
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 12),
              widget.prefix ?? const SizedBox.shrink(),
              Assets.images.common.iconSearchLeading
                  .image(width: 16, height: 16),
              const SizedBox(width: 8),
            ],
          ),
          suffixIcon: isShowClearIcon
              ? GestureDetector(
                  child: Assets.images.common.iconSearchDelete
                      .image(width: 16, height: 16),
                  onTap: () {
                    setState(() {
                      isShowClearIcon = false;
                    });
                    FocusScope.of(context).requestFocus(_focusNode);
                    widget.onClearTap();
                  },
                )
              : null,
          prefixIconConstraints: const BoxConstraints(minWidth: 40),
          suffixIconConstraints: const BoxConstraints(minWidth: 40),
          fillColor: Colors.white,
          filled: true,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE6E6E6)),
          ),
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF767676),
            fontSize: 16,
            fontWeight: FontWeight.normal,
            textBaseline: TextBaseline.alphabetic,
          ),
          hintMaxLines: 1,
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFE6E6E6)),
          ),
        ),
        textInputAction: TextInputAction.search,
        onChanged: (value) {
          setState(() {
            isShowClearIcon = value.isNotEmpty;
          });
          if (onSearchInputChanged != null) {
            onSearchInputChanged(value);
          }
        },
        onSubmitted: onSearchInputSubmitted,
      ),
    );
  }
}
