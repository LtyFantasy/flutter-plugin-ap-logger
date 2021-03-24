
part of 'ap_log_view.dart';

class _APLogItem extends StatefulWidget {
  
  final APLog log;
  _APLogItem({
    this.log,
  });
  
  @override
  State<StatefulWidget> createState() {
    return _APLogItemState();
  }
}

class _APLogItemState extends State<_APLogItem> {
  
  @override
  Widget build(BuildContext context) {
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      color: Color(0xFFDDDDDD),
      child: GestureDetector(
        onTap: () {
          /// fold
          setState(() {
            widget.log.fold = !widget.log.fold;
          });
        },
        onLongPress: () {
          /// copy
          Clipboard.setData(ClipboardData(text: widget.log.content));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Copy Success', textAlign: TextAlign.center,)
          ));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _createModuleAndTime(),
              _createContent(),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _createModuleAndTime() {
    
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  '[${widget.log.module}] ',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87
                  )
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: apLogLevelColor(widget.log.level),
                ),
                child: Text(
                  apLogLevelName(widget.log.level),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: Text(
              timeString(),
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _createContent() {
    
    return Container(
      constraints: BoxConstraints(
          maxHeight: widget.log.fold ? 28 : double.infinity
      ),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Text(
        widget.log.content,
        overflow: TextOverflow.fade,
        style: TextStyle(
            fontSize: 13,
            color: Colors.black87
        ),
      ),
    );
  }
  
  String timeString() {
    
    String _twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }
    
    String _threeDigits(int n) {
      if (n >= 100) return "$n";
      if (n >= 10) return "0$n";
      return "00$n";
    }
    
    DateTime time = widget.log.time;
    String h = _twoDigits(time.hour);
    String min = _twoDigits(time.minute);
    String sec = _twoDigits(time.second);
    String ms = _threeDigits(time.millisecond);
    return '$h:$min:$sec.$ms';
  }
}