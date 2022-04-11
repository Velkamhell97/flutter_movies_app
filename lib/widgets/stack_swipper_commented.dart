import 'package:flutter/material.dart';

enum SwiperDirection {
  nextToRight,
  nextToLeft,
}

class StackSwipperCommented extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder; //-Children for builder
  final int itemCount; //-No. items
  final int visualizedItems; //-Visualized items
  final double itemWidth; //-Item width
  final double? itemHeight; //-Item height
  final double minScale; //-max Scale factor decrement
  final int initialIndex; //Initial index
  final EdgeInsetsGeometry padding; //Swipper padding
  final SwiperDirection swiperDirection; //Direction of swiper elements
  final Function(int index)? onTap;

  const StackSwipperCommented({
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
    this.swiperDirection = SwiperDirection.nextToRight
  }) : super(key: key);

  @override
  State<StackSwipperCommented> createState() => _StackSwipperCommentedState();
}

class _StackSwipperCommentedState extends State<StackSwipperCommented> {
  late final PageController _pageController;
  late int _currentPage;

  final ValueNotifier<double> _pagePercent = ValueNotifier(0.0);

  @override
  void initState() {
    super.initState();
    
    //Al parecer debe ser un multiplo de 10 o de widget.itemCount (20 elementos)
    _pageController = PageController(initialPage: 1000);
    _pageController.addListener(_pageListener);

    _currentPage = widget.initialIndex;
  }

  void _pageListener() {
    final page = _pageController.page!;
    final ceil = page.ceil();

    //-Tambien funciona pero on la direccion invertida (el elemento saliente a la izquierda)
    //-la pagina se maniente hasta pasar al siguiente elemento por encima
    // final floor = page.floor();
    // _currentPage = (floor) % widget.itemCount;
    // _pagePercent.value = page - floor;

    //-la pagina se maniente hasta pasar al siguiente elemento por encima
    _currentPage = (ceil) % widget.itemCount;
    _pagePercent.value = ceil - page;
    
    // print("page: $page - floor: $floor - ceil: $ceil - current: $_currentPage - percent: ${_pagePercent.value}");
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  static const _outOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    //-Lo que determina la direccion es la forma en que se haga la operacion currentIndex +- reversedIndex
    //-En el stackedList, cuando queremos que el siguiente venga de la derecha el curentIndex no se 
    //-modifica y cuando es a la izquierda se debe restar este valor al itemCount, se hace la evaluacion
    //-aqui porque al final es una constante y no evaluar la condicion en cada rebuild
    final indexOffset = widget.swiperDirection == SwiperDirection.nextToRight ? 0 : widget.itemCount;

    //-No se pudo lograr que el tap de lo elementos del itemBuilder, pasaran el gesture del pageview
    //-en el stack, el problema es que el stack prioriza su hit a el elemento del frente por lo tanto
    //-la unica forma de que pase para el de atras es con un ignore pointer pero esto hace que el
    //-pageview ya no pueda hacer swipe, se intento con customGesture pero tampoco funciono, la 
    //-solucion fue asignar el onTap a un gesture ubicado en el pageView directametne
    return Stack(
      fit: StackFit.expand,
      children: [
        //-----------------------------------------
        // Stacked List
        //-----------------------------------------
        //-Se establecen aqui las propiedades que no cambian, para optimizar un poco
        LayoutBuilder(
          builder: (context, constraints) {
            //-Espacio detras del elemento al frente donde se repartiran los demas
            final leftSpace =  (constraints.maxWidth - widget.itemWidth) / 2;
        
            //-Espacio por el que se multiplica el percent para que el elemento al frente salga si se
            //-coloca el maxWidth con el 0.5 del percent el elemento al frente saldra media pantalla
            //- se puede agregar un offset para aumentar la velocidad de salida del elemento frontal
            final outSpace = constraints.maxWidth + _outOffset;
        
            return ValueListenableBuilder<double>(
              valueListenable: _pagePercent, 
              builder: (_, percent, __) {
                return _StackedList(
                  percent: percent, 
                  itemBuilder: widget.itemBuilder, 
                  //-Se calcula aqui el current con la direccion implicita
                  currentIndex:  (indexOffset  - _currentPage).abs(), 
                  generateItems: widget.visualizedItems - 1, 
                  itemCount: widget.itemCount, 
                  itemWidth: widget.itemWidth,
                  itemHeight: widget.itemHeight, 
                  minScale: widget.minScale, 
                  behindSpace: leftSpace, 
                  outSpace: outSpace,
                  maxHeight: constraints.maxHeight,
                  //-Ademas de la operacion del current es necesario cambiar el signo de una operacion
                  //-dependiendo de la direccion
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
                  
                  if(widget.onTap != null){
                    widget.onTap!(current);
                  }
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
  final double maxHeight;
  final int direction;

  const _StackedList({
    Key? key,
    required this.percent,
    required this.itemBuilder,
    required this.currentIndex,
    required this.generateItems, //n elementos atras y 1 adelante (visuzalized - 1)
    required this.itemCount,
    required this.itemWidth,
    this.itemHeight,
    required this.minScale,
    required this.behindSpace, //-Espacio libre a la izquierda del elementos al frente
    required this.outSpace,
    required this.maxHeight,
    this.direction = 0
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ...List.generate(generateItems, (index) {
          //-El index de mayor a menor para que ubicarlos al frente en el stack
          final reversedIndex = generateItems - index;

          //-El indice del elemento que se le pasa el itemBuilder, la direccion cambia con el signo
          //-se calcula el modulo para que no haya error de desborde
          final itemIndex = (currentIndex + (reversedIndex * direction)) % itemCount;
          // print("currentIndex: $currentIndex - reversedIndex: $reversedIndex - itemIndex: $itemIndex");

          //-El factor es el porcentaje por el cual se multiplica una propiedad (traslacion o escala) 
          //-para obtener valores equitativos e.j para 3 elementos: (1.0, 0.66, 0.33), ahora cuando
          //-se le empieza a restar el porcentaje, cada elemento pasa de su valor anterior al siguiente
          //-y se consigue el efecto de que los elementos anteriores ocupen las propiedades del actual
          final factor = (reversedIndex - percent) / generateItems;

          //con itemWidth o itemWidth / 2 se veran diferentes efectos de traslacion (probar mas)
          // final offset = itemWidth; //-Se podria pasar como parametro ya que no cambia
          // final traslationValue = (behindSpace * factor) + (offset * scaleValue);

          //-La escala tendra unos saltos equitativos en el rango de 0 a 0.3
          final scaleValue = minScale * factor;

          //-La traslacion tendra unos saltos equitativos en el rango de 0 a behindSpace, se le agrega
          //-un offset para compensar el efecto del escalamiento sobre los elementos
          final traslationValue = (behindSpace * factor) + (itemWidth * scaleValue);

          //-Con la opacidad el primer elemento tendra 0 y el ultimo 1, por lo que se hace coindir el 
          //-numerador con denominador, los demas elementos se repartiran equitativamente, ej: n=3
          //-(0, 1, 2) : (0.0, 0.5, 1.0), al sumarle el percent cada elemento pasa del anterior al siguietne
          final opacityValue = (index + percent) / (generateItems - 1);

          // print("index: $index - scale: $scaleValue  - traslation: $traslationValue - opacity: $opacityValue");

          return _TransformedItem(
            translate: -traslationValue,
            scale: 1 - scaleValue,
            opacity: opacityValue.clamp(0.0, 1.0),
            itemWidth: itemWidth, 
            itemHeight: itemHeight,
            child: itemBuilder(context, itemIndex),
          );
        })
        ..add( //Elemento al frente
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
    //-El scale antes o despues del traslate afecta el desplazamiento de los elementos, si se pone despues
    //-se debe multiplicar el factor de la escala por el itemWidth y la separacion no sera equitativa, los
    //-promero se desplazaran mas que los anteriores, sin embargo este efecto aveces es conveniente (como en este caso)
    //-Por otra parte si se pone despues hay dos escenarios el primero es cuando el factor se multiplica por itemWidth
    //-en este caso los elementos se trasladan ocupando correctamente el espacio disponible a la izquierda pero el ultimo
    //-elemento saldra de la pantalla, por otra parte si el factor se multiplica por itemWidth / 2 tambien se ocupara
    //-todo el espacio pero si se incluira el ultimo elemento
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