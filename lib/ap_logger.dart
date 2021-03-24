library ap_logger;

import 'dart:developer' as dev;
import 'ap_log_defines.dart';
export './view/ap_log_view.dart';

class APLogger {
  
  /// ------------ Global -------------
  
  /// 最大日志条数
  static const int _Max = 1000;
  
  /// 全局日志组
  static List<APLog> _logs = [];
  static List<APLog> get logs => _logs;
  
  /// 各模块Logger
  static List<APLogger> _loggers = [];
  static List<APLogger> get loggers => _loggers;
  
  /// 添加Log回调
  static Function(APLog log) newLogCallback;
  
  /// 添加Logger回调
  static Function(APLogger logger) newLoggerCallback;
  
  /// ------------- Module Logger --------------
  
  /// 所属模块名
  final String moduleName;
  
  /// 是否搜索启用
  bool filterEnable = true;
  
  APLogger._init(String moduleName)
      : moduleName = moduleName ?? '';
  
  /// 创建Logger时，将其添加进入全局队列
  ///
  /// 如果已经存在，直接返回该logger
  static APLogger build(String moduleName) {
    
    APLogger logger;
    for (APLogger obj in _loggers) {
      if (obj.moduleName == moduleName) {
        logger = obj;
        break;
      }
    }
    
    if (logger == null) {
      logger = APLogger._init(moduleName);
      _loggers.add(logger);
      newLoggerCallback?.call(logger);
    }
    return logger;
  }
  
  /// ----------- Operation ------------
  
  /// 添加日志
  void _addLog({String content, APLogLevel level, bool print}) {
    
    if (print == true) {
      dev.log('[$moduleName - ${apLogLevelName(level)}] $content');
    }
    
    APLog log = APLog(
        level: level,
        module: moduleName,
        content: content,
        time: DateTime.now()
    );
    _logs.insert(0, log);
    // 上限控制
    if (_logs.length > _Max) {
      _logs.removeLast();
    }
    newLogCallback?.call(log);
  }
  
  /// Info级别日志
  void info(String content, {bool print = true}) {
    assert((){
      _addLog(content: content, level: APLogLevel.Info, print: print);
      return true;
    }());
  }
  
  /// Warning级别日志
  void warning(String content, {bool print = true}) {
    assert((){
      _addLog(content: content, level: APLogLevel.Warning, print: print);
      return true;
    }());
  }
  
  /// Error级别日志
  void error(String content, {bool print = true}) {
    assert((){
      _addLog(content: content, level: APLogLevel.Error, print: print);
      return true;
    }());
  }
  
  /// Fatal级别日志
  void fatal(String content, {bool print = true}) {
    assert((){
      _addLog(content: content, level: APLogLevel.Fatal, print: print);
      return true;
    }());
  }
}

/// 日志数据
class APLog {
  
  // 等级
  final APLogLevel level;
  // 所属模块
  final String module;
  // 内容
  final String content;
  // 生成时间
  final DateTime time;
  // 函数栈
  final StackTrace stackTrace;
  // 折叠显示
  bool fold = false;
  
  APLog({
    this.level,
    this.module,
    this.content,
    this.time,
    this.stackTrace
  });
}
