/// Classname JHIPLIB.Util.Save.BS.GetService<br/>
/// Summary   消息存储通用BS，此组件可存储消息模版，XSL文件...会存储在CACHE中，可通过MethodName参数对存储内容进行操作<br/>
/// Version   1.0<br>
/// Date      2019年4月29日 15:15:39<br>
/// Author    ZBT<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.Util.Save.BS.GetService Extends EnsLib.SOAP.Service
{

Parameter ADAPTER = "EnsLib.File.InboundAdapter";

Parameter SETTINGS = "MethodName:Basic";

/// 根据要进行的操作进行设置，如需在本地数据库中添加文件设置为Insert，更新已有文件设置为Update，删除文件时设置为Delete，更新和删除操作时文件名应于数据库中存储的文件名称相同。
Property MethodName As %String(DISPLAYLIST = ",Insert,Update,Delete", VALUELIST = ",Insert,Update,Delete") [ InitialExpression = "Insert" ];

Method OnProcessInput(pInput As %FileCharacterStream, pOutput As JHIPLIB.Util.Save.MSG.SaveMSG) As %Status
{
	
	Set pOutput=##class(JHIPLIB.Util.Save.MSG.SaveMSG).%New()
	Set pOutput.MethodName=..MethodName,Body=""
	Set pOutput.FileName=$p($p(pInput.Filename,"\",*),".",1)
	while pInput.AtEnd=0{Set Body=Body_pInput.Read()}
	Set pOutput.FileBody=Body
	Set tsc=..SendRequestSync("JHIP文件存储工具",pOutput)
	Quit $$$OK
}

}
