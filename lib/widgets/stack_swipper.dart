import 'package:flutter/material.dart';

enum SwiperDirection {
  nextToRight,
  nextToLeft,
}

class StackSwipper extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder; //-Children for builder
  final int itemCount; //-No. items
  final int visualizedItems; //-Visualized items
  final double itemWidth; //-Item width
  final double? itemHeight; //-Item height
  final double minScale; //-max Scale factor decrement
  final int initialIndex; //Initial index
  final EdgeInsetsGeometry padding; //Swipper padding
  final SwiperDirection swiperDirection; //Direction of swiper elements
  final Function(int index)? onTap; //onTap function

  const StackSwipper({
    Key? key,
    required this.itemBuilder,
    required this.itemCount,
    this.visualizedItems = 4,
    required this.itemWidth,
    this.onTap,
    this.minScale = 0.2,
    this.itemHeight,
    this.initialIndex = 0,
    this.padding = const EdgeInsets.all(0.0),
    this.swiperDirection = SwiperDirection.nextToLeft
  }) : super(key: key);

  @override
  State<StackSwipper> createState() => _StackSwipperState();
}

class _StackSwipperState extends State<StackSwipper> {
  late final PageController _pageController;
  late int _currentPage;

  final ValueNotifier<double> _pagePercent = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    
    _pageController = PageController(initialPage: 1000);
    _pageController.addListener(_pageListener);

    _currentPage = widget.initialIndex;
  }

  void _pageListener() {
    final page = _pageController.page!;
    final ceil = page.ceil();

    _currentPage = (ceil) % widget.itemCount;
    _pagePercent.value = ceil - page;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  static const _outOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    final indexOffset = widget.swiperDirection == SwiperDirection.nextToRight ? 0 : widget.itemCount;

    return Stack(
      fit: StackFit.expand,
      children: [
        //-----------------------------------------
        // Stacked List
        //-----------------------------------------
        LayoutBuilder(
          builder: (context, constraints) {
            final leftSpace =  (constraints.maxWidth - widget.itemWidth) / 2;
            final outSpace = constraints.maxWidth + _outOffset;
        
            return ValueListenableBuilder<double>(
              valueListenable: _pagePercent, 
              builder: (_, percent, __) {
                return _StackedList(
                  percent: percent, 
                  itemBuilder: widget.itemBuilder, 
                  currentIndex:  (indexOffset  - _currentPage).abs(), 
                  generateItems: widget.visualizedItems - 1, 
                  itemCount: widget.itemCount, 
                  itemWidth: widget.itemWidth,
                  itemHeight: widget.itemHeight, 
                  minScale: widget.minScale, 
                  behindSpace: leftSpace, 
                  outSpace: outSpace,
                  direction: widget.swiperDirection == SwiperDirection.nextToRight ? -1 : 1
                );
              }
            );
          }
        ),

        //-----------------------------------------
        // Fake PageView
        //-----------------------------------------
        PageView.builder(
          controller: _pageController,
          itemBuilder: (_, index){
            return Align(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  final current = (indexOffset - _currentPage).abs() % widget.itemCount;
                  if(widget.onTap != null) widget.onTap!(current);
                },
                child: SizedBox(
                  height: double.infinity,
                  width: widget.itemWidth,
                ),
              ),
            );
          }
        ),
      ],
    );
  }
}

class _StackedList extends StatelessWidget {
  final double percent;
  final IndexedWidgetBuilder itemBuilder;
  final int currentIndex;
  final int generateItems;
  final int itemCount;
  final double itemWidth;
  final double? itemHeight;
  final double minScale;
  final double behindSpace;
  final double outSpace;
  final int direction;

  const _StackedList({
    Key? key,
    required this.percent,
    required this.itemBuilder,
    required this.currentIndex,
    required this.generateItems, 
    required this.itemCount,
    required this.itemWidth,
    this.itemHeight,
    required this.minScale,
    required this.behindSpace,
    required this.outSpace,
    this.direction = 1
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ...List.generate(generateItems, (index) {
          final reversedIndex = generateItems - index;
          final itemIndex = (currentIndex + (reversedIndex * direction)) % itemCount;
          final factor = (reversedIndex - percent) / generateItems;

          final scaleValue = minScale * factor;
          final traslationValue = (behindSpace * factor) + (itemWidth * scaleValue);
          final opacityValue = (index + percent) / (generateItems - 1);

          return _TransformedItem(
            translate: -traslationValue,
            scale: 1 - scaleValue,
            opacity: opacityValue.clamp(0.0, 1.0),
            itemWidth: itemWidth, 
            itemHeight: itemHeight,
            child: itemBuilder(context, itemIndex),
          );
        })
        ..add(
          _TransformedItem(
            translate: outSpace * percent,
            itemWidth: itemWidth, 
            itemHeight: itemHeight,
            child: itemBuilder(context, currentIndex % itemCount),
          ),
        ),
      ],
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
      scale: scale,
      child: Transform.translate(
        offset: Offset(translate, 0.0),
        child: Transform.scale(
          scale: 1,
          child: Opacity(
            opacity: opacity,
            child: Align(
              child: SizedBox(
                width: itemWidth,
                height: itemHeight,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}