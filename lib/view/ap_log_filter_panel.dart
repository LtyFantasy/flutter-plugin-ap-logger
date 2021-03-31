
part of 'ap_log_view.dart';

class _APLogFilterPanel extends StatefulWidget {
  
  final _APLogFilter filter;
  _APLogFilterPanel(this.filter);
  
  @override
  State<StatefulWidget> createState() {
    return _APLogFilterPanelState();
  }
}

class _APLogFilterPanelState extends State<_APLogFilterPanel> {
  
  @override
  Widget build(BuildContext context) {
    
    return Container(
      padding: EdgeInsets.all(20),
      height: 400,
      decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)
          )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _createTitle('Level Filter'),
          _createLevelFilter(),
          _createTitle('Module Filter'),
          _createModuleFilter(),
          Container(
            margin: EdgeInsets.only(top: 40),
            alignment: Alignment.center,
            child: Text(
              '-- 更多功能，充值解锁 --',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        ],
      ),
    );
  }
  
  Widget _createTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        color: Colors.white.withOpacity(0.9),
        fontWeight: FontWeight.w700,
      ),
    );
  }
  
  Widget _createLevelFilter() {
    
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 20),
      child: Row(
        children: [
          _levelTag(APLogLevel.Info),
          SizedBox(width: 10,),
          _levelTag(APLogLevel.Warning),
          SizedBox(width: 10,),
          _levelTag(APLogLevel.Error),
          SizedBox(width: 10,),
          _levelTag(APLogLevel.Fatal),
        ],
      ),
    );
  }
  
  Widget _levelTag(APLogLevel level) {
    
    bool enable = widget.filter.levelFilter.contains(level);
    return GestureDetector(
        onTap: () {
          if (widget.filter.levelFilter.contains(level) == true) {
            widget.filter.levelFilter.remove(level);
          }
          else {
            widget.filter.levelFilter.add(level);
          }
          setState(() {});
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
              color: apLogLevelColor(level).withOpacity(
                  enable ? 1.0 : 0.2
              ),
              borderRadius: BorderRadius.circular(8)
          ),
          child: Text(
            apLogLevelName(level),
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white.withOpacity(
                    enable ? 1.0 : 0.2
                )
            ),
          ),
        )
    );
  }
  
  Widget _createModuleFilter() {
    
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 20),
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _filter.moduleFilter.length,
        itemBuilder: (context, index) {
          return _moduleTag(index);
        },
      ),
    );
  }
  
  Widget _moduleTag(int index) {
    
    APLogger logger = _filter.moduleFilter[index];
    Color color = logger.filterEnable ? Colors.lightGreen : Colors.white.withOpacity(0.2);
    return GestureDetector(
        onTap: () {
          logger.filterEnable = !logger.filterEnable;
          setState(() {});
        },
        child: Container(
          margin: EdgeInsets.only(right: 10),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color)
          ),
          child: Text(
            logger.moduleName,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color
            ),
          ),
        )
    );
  }
}