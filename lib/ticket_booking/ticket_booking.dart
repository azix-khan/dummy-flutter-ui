import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const transitionDuration = Duration(milliseconds: 500);

class TicketBooking extends StatefulWidget {
  @override
  _TicketBookingState createState() => _TicketBookingState();
}

class _TicketBookingState extends State<TicketBooking>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late PageController _backgroundPageController;
  int _selectedIndex = 0;
  late Movie selectedMovie;
  bool _showPosterListView = true;
  final double _moviesPageViewportFraction = .8;
  late AnimationController _animationController;
  late Animation<double> _posterAnimation;
  late Animation<RelativeRect> _cardAnimation;

  void onBook() {
    _animationController.forward(from: 0.0);
  }

  @override
  void initState() {
    super.initState();
    _backgroundPageController = PageController();
    _pageController = PageController(
      viewportFraction: _moviesPageViewportFraction,
    );
    selectedMovie = _movies.first;

    _animationController = AnimationController(
      vsync: this,
      duration: transitionDuration,
    );

    _animationController.addListener(() {
      if (_animationController.isCompleted && _showPosterListView) {
        setState(() => _showPosterListView = false);
      } else if (_animationController.value < 1.0 && !_showPosterListView) {
        setState(() => _showPosterListView = true);
      }
    });

    _posterAnimation = Tween<double>(begin: 0.0, end: 90).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  void onBackPressed() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.of(context).size;
    final maxCardTopMargin = size.height * .26;
    final double cardMargin = 40;

    _cardAnimation = RelativeRectTween(
      begin: RelativeRect.fromLTRB(
        cardMargin,
        maxCardTopMargin,
        cardMargin,
        cardMargin,
      ),
      end: RelativeRect.fromLTRB(0, 80, 0, 0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _backgroundPageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        if (_animationController.isCompleted) {
          onBackPressed();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            PageView.builder(
              itemCount: _movies.length,
              controller: _backgroundPageController,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = _movies[index];
                return ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                  child: Image.network(item.imageUrl, fit: BoxFit.cover),
                );
              },
            ),
            AnimatedBuilder(
              animation: _cardAnimation,
              builder: (context, child) {
                return Positioned.fromRelativeRect(
                  rect: RelativeRect.fromLTRB(
                    _cardAnimation.value.left,
                    _cardAnimation.value.top,
                    _cardAnimation.value.right,
                    _cardAnimation.value.bottom,
                  ),
                  child: _MovieDetailsContent(
                    selectedMovie: selectedMovie,
                    animationValue: _animationController.value,
                    onBookMovie: onBook,
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _cardAnimation,
              child: BackButton(color: Colors.white, onPressed: onBackPressed),
              builder: (_, child) {
                return Positioned(
                  top: 26,
                  left: 0,
                  child: Visibility(
                    visible: _cardAnimation.isCompleted,
                    child: child ?? SizedBox(),
                  ),
                );
              },
            ),
            NotificationListener<ScrollUpdateNotification>(
              onNotification: (notification) {
                if (notification.depth == 0) {
                  if (_backgroundPageController.page != _pageController.page) {
                    _backgroundPageController.position.jumpTo(
                      _pageController.position.pixels /
                          _moviesPageViewportFraction,
                    );
                  }
                }
                return false;
              },
              child: Positioned.fill(
                bottom: size.height * .4,
                child: Visibility(
                  visible: _showPosterListView,
                  maintainState: true,
                  child: PageView.builder(
                    itemCount: _movies.length,
                    controller: _pageController,
                    onPageChanged: (i) {
                      selectedMovie = _movies[i];
                      setState(() => _selectedIndex = i);
                    },
                    itemBuilder: (context, index) {
                      return AnimatedBuilder(
                        animation: _posterAnimation,
                        child: UnconstrainedBox(
                          constrainedAxis: Axis.horizontal,
                          child: Container(
                            height: 400,
                            margin: EdgeInsets.symmetric(horizontal: 24),
                            decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 26),
                                  color: Colors.black54,
                                  blurRadius: 16,
                                  spreadRadius: -12,
                                ),
                              ],
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(_movies[index].imageUrl),
                              ),
                            ),
                          ),
                        ),
                        builder: (context, child) {
                          if (index != _selectedIndex) {
                            final padding = _animationController.value * 32.0;
                            return Padding(
                              padding: EdgeInsets.only(
                                left: index > _selectedIndex ? padding : 0,
                                right: index < _selectedIndex ? padding : 0,
                              ),
                              child: child,
                            );
                          }
                          return Transform(
                            transform:
                                Matrix4.identity()
                                  ..setEntry(3, 2, 0.0015)
                                  ..rotateX(
                                    -(_posterAnimation.value.clamp(0, 90) *
                                        math.pi /
                                        180),
                                  ),
                            alignment: FractionalOffset(
                              0.5,
                              _animationController.value.clamp(0.0, 0.22),
                            ),
                            child: child,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// MOVIE MODEL
class Movie {
  final String name;
  final String theaterName;
  final String imageUrl;
  final DateTime? date;
  final int totalTickets;
  final double ticketPrice;

  Movie({
    required this.name,
    required this.theaterName,
    required this.imageUrl,
    this.date,
    this.totalTickets = 30,
    this.ticketPrice = 26.8,
  });
}

// MOVIE LIST
final List<Movie> _movies = [
  Movie(
    name: 'The Naked Gun (2025)',
    imageUrl: 'https://www.joblo.com/wp-content/uploads/2025/01/IMG_3636.jpeg',
    theaterName: 'Max Cinemas',
  ),
  Movie(
    name: 'Another Simple Favor',
    imageUrl:
        'https://www.joblo.com/wp-content/uploads/2025/02/another-simple-favor-poster-1.jpg',
    theaterName: 'Wat Cinemas',
  ),
  Movie(
    name: 'Mortal Kombat',
    imageUrl:
        'https://oyster.ignimgs.com/wordpress/stg.ign.com/2021/02/MK_VERT_MAIN_2764x4096_INTL.jpg',
    theaterName: 'Cinemax',
  ),
  Movie(
    name: 'Godzilla vs Kong',
    imageUrl:
        'https://cdn.flickeringmyth.com/wp-content/uploads/2021/03/Godzilla-vs-Kong-Dolby-600x889.jpg',
    theaterName: 'Zap Cinemas',
  ),
  Movie(
    name: 'Heads of State Posters',
    imageUrl: 'https://www.joblo.com/wp-content/uploads/2023/04/IMG_4229.jpeg',
    theaterName: 'Zap Cinemas',
  ),
];

// MOVIE DETAILS CONTENT WIDGET
class _MovieDetailsContent extends StatefulWidget {
  final Movie selectedMovie;
  final double animationValue;
  final VoidCallback onBookMovie;

  _MovieDetailsContent({
    required this.selectedMovie,
    required this.animationValue,
    required this.onBookMovie,
  });

  @override
  _MovieDetailsContentState createState() => _MovieDetailsContentState();
}

class _MovieDetailsContentState extends State<_MovieDetailsContent>
    with SingleTickerProviderStateMixin {
  Movie get selectedMovie => widget.selectedMovie;
  double get animationValue => widget.animationValue;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    final isMovieDetailsMode = animationValue >= 0.5;

    return Container(
      padding: EdgeInsets.only(top: 16 * animationValue),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8 - 8 * animationValue),
      ),
      child: Column(
        children: [
          AnimatedOpacity(
            opacity: animationValue,
            duration: Duration.zero,
            child: Column(
              children: [
                Text(
                  "SCREEN",
                  style: textTheme.titleLarge!.copyWith(
                    fontSize: 32,
                    color: Colors.grey.withOpacity(.5),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: _SeatsCard(rows: 8, seatCount: 12),
                ),
                _SeatsCard(rows: 3, seatCount: 14),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, animationValue * 32, 40, 0),
            child: Column(
              children: [
                Text(
                  selectedMovie.name,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium!.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 8),
                AnimatedOpacity(
                  opacity: 1 - animationValue,
                  duration: Duration.zero,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_on, color: Colors.red),
                      SizedBox(width: 4),
                      Text(
                        selectedMovie.theaterName,
                        style: textTheme.bodyMedium!.copyWith(
                          color: Colors.grey,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Spacer(),
          SizedBox(height: 100),
          SizedBox(
            width: size.width * .7,
            child: AnimatedCrossFade(
              crossFadeState:
                  animationValue > 0.0
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              duration: transitionDuration,
              firstChild: SizedBox(
                height: 95,
                child: CupertinoTheme(
                  data: CupertinoThemeData(
                    textTheme: CupertinoTextThemeData(
                      dateTimePickerTextStyle: TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  child: CupertinoDatePicker(
                    maximumDate: DateTime(2025, 12, 30),
                    minimumDate: DateTime.now(),
                    use24hFormat: true,
                    onDateTimeChanged: (date) {},
                  ),
                ),
              ),
              secondChild: _BookInfo(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16, bottom: 24 * animationValue),
            child: SizedBox(
              height: 54,
              width: size.width * .62,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed:
                    () =>
                        !isMovieDetailsMode
                            ? widget.onBookMovie()
                            : () {
                              // Pay button pressed
                            },
                child: Text(
                  isMovieDetailsMode ? 'Pay' : 'Book',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// SEATS
class _SeatsCard extends StatelessWidget {
  final int rows;
  final int seatCount;

  const _SeatsCard({required this.rows, required this.seatCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(rows, (index) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(seatCount, (index) {
            return Container(
              height: 10,
              width: 10,
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      }),
    );
  }
}

// BOOKING SUMMARY
class _BookInfo extends StatelessWidget {
  Widget _row(String title, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: Colors.grey)),
        Text(
          data,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _row("DATE", "JUL 18"),
        Divider(),
        _row("CINEMA", "Zap Cinemas"),
        Divider(),
        _row("QUANT.", "2 Tickets"),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '\$25.00',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }
}
