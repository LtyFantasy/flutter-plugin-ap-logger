
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../ap_log_defines.dart';
import '../ap_logger.dart';

part 'ap_log_filter_panel.dart';
part 'ap_log_item.dart';

_APLogFilter _filter = _APLogFilter();

/// Search Filter
class _APLogFilter {
  
  List<APLogger> moduleFilter = APLogger.loggers;
  List<APLogLevel> levelFilter = [];
  DateTime filterStartTime;
  DateTime filterEndTime;
  
  _APLogFilter() {
    levelFilter.add(APLogLevel.Info);
    levelFilter.add(APLogLevel.Warning);
    levelFilter.add(APLogLevel.Error);
    levelFilter.add(APLogLevel.Fatal);
  }
}

/// Display all logs
class APLogView extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    return _APLogViewState();
  }
}

class _APLogViewState extends State<APLogView> {
  
  bool pause = false;
  List<APLog> logs = [];
  
  @override
  void initState() {
    
    super.initState();
    
    logs.addAll(APLogger.logs);
    _filterLogs();
    APLogger.newLogCallback = _newLogCallback;
  }
  
  @override
  void dispose() {
    APLogger.newLogCallback = null;
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Color(0xFFDDDDDD),
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text('Logger'),
        actions: [
          _createPauseButton(),
          _createFilterButton(),
        ],
      ),
      body: ListView.builder(
        itemCount: logs.length,
        itemBuilder: _itemBuilder,
      ),
    );
  }
  
  void _newLogCallback(APLog log) {
    
    setState(() {
      bool valid = _checkLog(log, _filter);
      if (valid) {
        logs.insert(0, log);
      }
    });
  }
  
  Widget _createPauseButton() {
    
    return IconButton(
        icon: Icon(pause
            ? Icons.airplanemode_inactive
            : Icons.airplanemode_active
        ),
        onPressed: () {
          
          pause = !pause;
          if (pause) {
            APLogger.newLogCallback = null;
          }
          else {
            logs.clear();
            logs.addAll(APLogger.logs);
            _filterLogs();
            setState(() {});
            APLogger.newLogCallback = _newLogCallback;
          }
          setState(() {});
        }
    );
  }
  
  Widget _createFilterButton() {
    
    return Builder(builder: (context) {
      return IconButton(
          icon: Icon(Icons.apps),
          onPressed: () async {
            
            await showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (ctx) {
                  return _APLogFilterPanel(_filter);
                }
            );
            
            logs.clear();
            logs.addAll(APLogger.logs);
            _filterLogs();
            setState(() {});
          }
      );
    });
  }
  
  Widget _itemBuilder(BuildContext context, int index) {
    APLog log = logs[index];
    return _APLogItem(log: log);
  }
  
  bool _checkLog(APLog log, _APLogFilter filter) {
    
    // Level Filter
    if (!filter.levelFilter.contains(log.level)) return false;
    // Module Filter
    APLogger logger;
    for (APLogger obj in filter.moduleFilter) {
      if (obj.moduleName == log.module) {
        logger = obj;
        break;
      }
    }
    
    if (logger?.filterEnable != true) return false;
    return true;
  }
  
  void _filterLogs() {
    
    List<APLog> originLogs = logs;
    logs = [];
    for (APLog log in originLogs) {
      bool valid = _checkLog(log, _filter);
      if (valid) {
        logs.add(log);
      }
    }
  }
}