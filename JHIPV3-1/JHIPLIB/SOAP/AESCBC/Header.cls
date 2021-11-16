/// Classname JHIPLIB.SOAP.AESCBC.Header
/// Summary   AESCBC 加密服务消息头
/// Version   1.0
/// Date      2019年01月11日 15:15:39
/// Author    liuwenyi
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPLIB.SOAP.AESCBC.Header Extends %SOAP.Header
{

Parameter NAMESPACE = "http://goodwillcis.com";

Parameter XMLNAME = "JiaheSecurity";

/// 用户名
Property UserName As %String(MAXLEN = "");

/// 密码
Property Password As %String(MAXLEN = "");

/// 时间戳
Property Timestamp As %String(MAXLEN = "");

/// 发送系统--明文
Property FromSYS As %String(MAXLEN = "");

/// 偏移量-未使用
Property IV As %String(MAXLEN = "");

}
