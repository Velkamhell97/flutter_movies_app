import 'package:flutter/material.dart';

//-La explicacion de creacion y una documentacion mas detallada en el archivo de animation_app / samples / stack_swipper

class StackSwipperOld extends StatefulWidget {
  final List<Widget>? children;
  final IndexedWidgetBuilder itemBuilder; 
  final int itemCount; 
  final int visualizedItems; 
  final double itemWidth; 
  final double? itemHeight; 
  final double minScale;
  final int initialIndex;
  final EdgeInsetsGeometry padding;
  final Function(int index)? onTap;

  const StackSwipperOld({
    Key? key,
    this.children,
    required this.itemBuilder,
    required this.itemCount,
    required this.visualizedItems,
    required this.itemWidth,
    this.onTap, 
    this.minScale = 0.2,
    this.itemHeight,
    this.initialIndex = 0,
    this.padding = const EdgeInsets.all(0.0)
  }) : super(key: key);

  @override
  _StackSwipperOldState createState() => _StackSwipperOldState();
}

class _StackSwipperOldState extends State<StackSwipperOld> {
  late final PageController _pageController;
  
  late int _currentPage;
  late int _frontPage;

  final ValueNotifier<double> _percentNotifier = ValueNotifier(0.0); 

  late final int _offsetIndex; 

  @override
  void initState() {
    super.initState();

    _offsetIndex = widget.itemCount - (999 % widget.itemCount) + widget.initialIndex;
    
    _pageController = PageController(initialPage: 999);

    _pageController.addListener(_pageListener);

    _currentPage = widget.initialIndex;
    _frontPage = widget.initialIndex;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _pageListener() {
    final pageCeil = _pageController.page!.ceil();
    // final pageRound = _pageController.page!.round();
    _currentPage = (pageCeil + _offsetIndex) % widget.itemCount;
    _percentNotifier.value = (_pageController.page! - pageCeil).abs();
  }

  @override
  Widget build(BuildContext context) {
    // print(_frontPage);

    return Stack(
      children: [
        //-------------------------
        // Stacked List
        //-------------------------
        Padding(
          padding: widget.padding,
          child: ValueListenableBuilder<double>(
            valueListenable: _percentNotifier,
            builder: (context, value, child) {
              return _StackedList(
                children: widget.children,
                itemBuilder: widget.itemBuilder,
                currentIndex: _currentPage,
                percent: value,
                generateItems: widget.visualizedItems - 1,
                itemCount: widget.itemCount,
                itemWidth: widget.itemWidth,
                itemHeight: widget.itemHeight,
                minScale: widget.minScale,
              );
            },
          ),
        ),

        //-------------------------
        // Fake PageView
        //-------------------------
        PageView.builder(
          physics: BouncingScrollPhysics(),
          controller: _pageController,
          onPageChanged: (value) {
            setState(() {
              _frontPage = (value + _offsetIndex) % widget.itemCount;
            });
          },
          itemBuilder: (context, index) {
            return const SizedBox();
          },
        ),

        //-------------------------
        // Front Card Tap
        //-------------------------
        Align(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: widget.onTap == null ? null : () => widget.onTap!(_frontPage),
            child: SizedBox(
              height: widget.itemHeight,
              width: widget.itemWidth,
            ),
          ),
        )

      ],
    );
  }
}


class _StackedList extends StatelessWidget {
  final List<Widget>? children;
  final IndexedWidgetBuilder itemBuilder;
  final int currentIndex;
  final double percent;
  final int generateItems;
  final int itemCount;
  final double itemWidth;
  final double? itemHeight;
  final double minScale;

  const _StackedList({
    Key? key,
    this.children,
    required this.itemBuilder,
    required this.currentIndex,
    required this.percent,
    required this.generateItems, 
    required this.itemCount,
    required this.itemWidth,
    this.itemHeight,
    required this.minScale
  }) : super(key: key);

  @override
  Widget build(BuildContext context) { 
    // print('rebuild stack');
    // print('------------------------------');

    return LayoutBuilder(
      builder: (context, constraints) {
        final remaingSpace = constraints.maxWidth / 2 - itemWidth / 2;
        final outSpace = itemWidth + remaingSpace  + 80;

        return Stack(
          fit: StackFit.expand,
          children: List.generate(generateItems, (index) {
            final invertedIndex = generateItems - 1 - index;
          
            final itemIndex =  (currentIndex - invertedIndex - 1) % itemCount;

            final scaleFactor = ((invertedIndex + 1) - percent) / generateItems;
            final scaleValue = (scaleFactor * minScale);

            final traslateValue = (scaleFactor * remaingSpace) + (scaleValue * itemWidth);

            final opacityValue = ((invertedIndex - percent) / (generateItems - 1)).clamp(0.0, 1.0);

            // print("scale: $scaleValue - traslate: $traslateValue - opacity: $opacityValue");

            // print(itemIndex);
            
            return _TransformedItem(
              scale: 1 - scaleValue, 
              translate: -traslateValue, 
              opacity: 1 - opacityValue, 
              itemWidth: itemWidth, 
              itemHeight: itemHeight,
              child: children == null ? itemBuilder(context, itemIndex) : children![itemIndex]
            );
          })
          ..add(
            _TransformedItem(
              translate: outSpace * percent,
              itemWidth: itemWidth, 
              itemHeight: itemHeight,
              child: children == null ? itemBuilder(context, currentIndex) : children![currentIndex]
            )
          ),
        );
      },
    );
  }
}

class _TransformedItem extends StatelessWidget {
  final double scale;
  final double translate;
  final double opacity;
  final double itemWidth;
  final Widget child;
  final double? itemHeight;

  const _TransformedItem({
    Key? key,
    this.scale = 1.0,
    this.translate = 0.0,
    this.opacity = 1.0,
    required this.itemWidth,
    required this.child,
    this.itemHeight
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale:  scale,
      child: Transform.translate(
        offset: Offset(translate, 0.0),
        child: Opacity(
          opacity: opacity,
          child: Align(
            child: SizedBox(
              height: itemHeight,
              width: itemWidth,
              child: child
            ),
          ),
        ),
      ),
    );
  }
}