import 'package:flutter/material.dart';
import 'package:debts_app/src/widgets/index.dart';
import 'package:debts_app/src/utils/index.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  AnimationController _animationController;
  Animation<double> _scaleAnimation;
  Animation<Offset> _cardsOffset;
  Animation<double> _cardsOpacity;
  Animation<Offset> _fabOffset;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _animationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1400)
    )..addListener((){
      setState(() {});
    });

    _scaleAnimation = Tween<double>(begin: 3.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.6, 1.0,
          curve: Curves.easeInOut
        )
      )
    );
    _fabOffset = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.6, 1.0,
          curve: Curves.easeInOut
        )
      )
    );
    _cardsOffset = Tween<Offset>(begin: Offset(0.0, -0.20), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.2, 0.5,
          curve: Curves.easeInOut
        )
      )
    );
    _cardsOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          0.2, 0.44,
          curve: Curves.easeInOut
        )
      )
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(
            scaleAnimation: _scaleAnimation,
          ),
          SafeArea(
            child: FadeTransition(
              opacity: _cardsOpacity,
              child: SlideTransition(
                position: _cardsOffset,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    DebtResumeCard(
                      theme: DebtCardTheme.light,
                      title: 'Me deben',
                      value: '\$ 200.000',
                      label: '1 persona',
                      onPressed: () {},
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    DebtResumeCard(
                      theme: DebtCardTheme.dark,
                      title: 'Debo',
                      value: '\$ 0.00',
                      label: 'a 0 personas',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: SlideTransition(
        position: _fabOffset,
        child: Container(
          margin: EdgeInsets.only(bottom: 30.0),
          child: AddButton(
            onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=>HomePage()));
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
