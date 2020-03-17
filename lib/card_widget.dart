import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardWidget extends StatefulWidget {
  
  final String title;
  final IconData icon;
  final Color color;
  final int value;

  const CardWidget({Key key, this.title, this.icon, this.color, this.value}) : super(key: key);


  
  @override
  _CardWidgetState createState() => _CardWidgetState();
}


class _CardWidgetState extends State<CardWidget> {

final formatter = new NumberFormat("#,###");

int _value = 0;

@override
void initState() {
    // TODO: implement setState
    super.initState();
    Future.delayed(Duration(milliseconds: 300),(){

      setState(() {
        _value = widget.value.round();

      });

    });

}

  @override
  Widget build(BuildContext context) {

    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now().subtract(Duration(minutes: 10)));
    return   Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      color: widget.color,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
        child: ListTile(
          leading: Icon(widget.icon, size: 70),
          title: Text(widget.title,
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
               AnimatedCount(count: widget.value.round(), duration: Duration(seconds: 2),),
                SizedBox(height: 5),
                Text(formattedDate.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class AnimatedCount extends ImplicitlyAnimatedWidget {
  final int count;

  AnimatedCount({
    Key key,
    @required this.count,
    @required Duration duration,
    Curve curve = Curves.linear
  }) : super(duration: duration, curve: curve, key: key);

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() => _AnimatedCountState();
}

class _AnimatedCountState extends AnimatedWidgetBaseState<AnimatedCount> {
  IntTween _count;
  final formatter = new NumberFormat("#,###");
  @override
  Widget build(BuildContext context) {
    return new Text(formatter.format(_count.evaluate(animation)).toString(), style: TextStyle(color: Colors.white, fontSize: 29));
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    _count = visitor(_count, widget.count, (dynamic value) => new IntTween(begin: value));
  }
}