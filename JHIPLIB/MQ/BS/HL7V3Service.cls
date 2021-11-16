/// Classname JHIPLIB.MQ.BS.HL7V3Service<br>
/// Summary   HL7V3SOAPBS封装类，参数Message为消息内容。<br>
/// Explain	  出参到BP时为EnsLib.EDI.XML.Document类型,唯一服务标识（BS名称前6位）会在XML对象的OriginalDocId属性中,可在BP流程设计中作为判断条件使用。<br>
/// Version   1.0<br>
/// Date      2019年4月29日 15:15:39<br>
/// Author    ZBT<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.MQ.BS.HL7V3Service Extends Ens.BusinessService
{

Parameter ADAPTER = "EnsLib.MQSeries.InboundAdapter";

/// 接收消息的目标组件名称
Property TargetConfigNames As Ens.DataType.ConfigName;

Parameter SETTINGS = "TargetConfigNames:Basic";

Method OnProcessInput(pInput As EnsLib.MQSeries.Message, Output pOutput As %RegisteredObject, ByRef pHint As %String) As %Status
{
	
	
	
	;Set String=$F(pInput.Body,"</jms>")
	Set reqstr=pInput.Body
  	Set request=##class(EnsLib.EDI.XML.Document).ImportFromString($replace(pInput.Body,$c(0),""),.status)
  	//打印消息
	;d ..Log(reqstr,"","ceshi")
   	$$$TRACE("消息为："_pInput.Body)
  	$$$TRACE("BodySize"_pInput.BodySize)
    Set tsc=..SendRequestAsync(..TargetConfigNames,request)
    Quit tsc
}

ClassMethod Log(logStr As %String, serviceName As %String, logType As %String = "info") As %Status
{
	
	set fileName=$TRanslate($ZDate($H,3),"-")
	set fileName="c:\V2TOXML"_fileName_".log"
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=fileName
	do stream.MoveToEnd()
	do stream.WriteLine("["_$ZDateTime($zts,3)_"] 日志级别:【"_logType_"】日志信息如下：服务名称"_serviceName)
	do stream.WriteLine(logStr)
	do stream.WriteLine()
	do stream.SaveStream()
	q $$$OK
}

}
