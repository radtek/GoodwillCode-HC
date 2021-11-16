/// Classname JHIPLIB.HTTP.BS.XMLService
/// Summary   HTTPXMLService封装类。<br>
/// Explain	  出参到BP时为EnsLib.EDI.XML.Document类型,唯一服务标识（BS名称前6位）会在XML对象的OriginalDocId属性中,可在BP流程设计中作为判断条件使用。<br>
///            入参及出参编码格式为UTF-8
/// Version   1.0<br>
/// Date      2019年11月20日 10:15:39<br>
/// Author    ZBT<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.HTTP.BS.XMLService Extends EnsLib.SOAP.Service
{

Parameter ADAPTER = "EnsLib.HTTP.InboundAdapter";

Parameter SETTINGS = "TargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},IsSync:Basic,SearchTableClass:Basic:selector?context={Ens.ContextSearch/SearchTableClasses?host=JHIPLIB.HTTP.BS.HL7V3Service}";

/// 接收消息的目标组件名称
Property TargetConfigNames As Ens.DataType.ConfigName;

/// 设置消息是否是同步发送。异步去勾，同步打勾，默认异步。
Property IsSync As %Boolean [ InitialExpression = 0 ];

/// 选择对应的SearchTableClass，进行消息搜索
Property SearchTableClass As %String;

Method OnProcessInput(pStreamIn As %CharacterStream, Output pStreamOut As %CharacterStream) As %Status
{
	Set tResponse = ##class(EnsLib.EDI.XML.Document).%New()
	Set ReplyStream=##class(%GlobalCharacterStream).%New()
	Set Util=##class(JHIPLIB.Util.ClassAndXML).%New()
	Try{
		Set str="<RESPONSE><RESULT_CODE>false</RESULT_CODE><RESULT_CONTENT>平台接收的"_..%ConfigName_"事件的消息处理出现错误，详情请查看完整跟踪！调用时间为"_$ZDT($H,3)_"</RESULT_CONTENT></RESPONSE>"
		Set ReplyStream.Attributes("Content-Type")="text/xml"
		Set pStreamOut=ReplyStream
	  	Set HL7V3xml = ##class(EnsLib.EDI.XML.Document).%New()
	  	//将消息体转换成标准V3XML
		Set HL7V3xml=HL7V3xml.ImportFromString(pStreamIn.Read(),.status)
		Set HL7V3xml.OriginalDocId=$E(..%ConfigName,1,6)
		IF 'status {$$$LOGERROR("Body不能转为XML，请确认！")}
		;D Util.Activity(..BusinessPartner,HL7V3xml.OriginalDocId,..%ConfigName,"I")
		Set tSC=..BaseSend(HL7V3xml,.tResponse)
		Set str = Util.OutputToString(tResponse)
	}catch(ex){	
	  		If 'status {
			Set err="输入的消息内容不能转化为XML请核对！" $$$LOGERROR(err) 
			Set str="<RESPONSE><RESULT_CODE>false</RESULT_CODE><RESULT_CONTENT>平台接收的"_..%ConfigName_"事件的消息内容不能转化为XML，请核对！调用时间为"_$ZDT($H,3)_"</RESULT_CONTENT></RESPONSE>"
	   	}else{
		   	$$$LOGERROR(str)
	   	}	$$$LOGERROR(ex.DisplayString())
	}	
	//出参编码设定		
	Set str=$zcvt(str,"O","UTF8")
	Set Stuts=pStreamOut.Write(str)
 	Quit $$$OK
}

Method BaseSend(pInput As EnsLib.EDI.XML.Document, Output tResponse As EnsLib.EDI.XML.Document) As %Status
{
	If ""=..TargetConfigNames{$$$LOGWARNING("没有选择接收消息的目标名称，请查看BS前台设置属性")}
	try{
		For iTarget=1:1:$L(..TargetConfigNames, ","){
			Set Status=..ProcessMessage(pInput,.tResponse,$P(..TargetConfigNames,",",iTarget))
		}
		Set:'..IsSync tResponse=##class(EnsLib.EDI.XML.Document).ImportFromString("<RESPONSE><RESULT_CODE>true</RESULT_CODE><RESULT_CONTENT>平台接收"_..%ConfigName_"成功,调用时间为"_$ZDT($H,3)_"</RESULT_CONTENT></RESPONSE>")
	}catch(ex){		
		$$$LOGERROR(ex.DisplayString())
	}
	Quit Status
}

Method ProcessMessage(pInput As %RegisteredObject, Output pOutput As %RegisteredObject, ByRef pHint As %String) As %Status
{
	if ..IsSync=0{
		Set tSC = ..SendRequestAsync(pHint,pInput)
	}else{
		Set tSC = ..SendRequestSync(pHint,pInput,.pOutput)
	}
	;Set:$L(^Activity)>0 stuts=$zobjclassmethod("JHIPLIB.HIPP.SaveBase","Activity",..BusinessPartner,pInput.OriginalDocId,..%ConfigName,"I")
	If ""'=..SearchTableClass {
		TRY {		
			Set tSCStore=$zobjclassmethod(..SearchTableClass,"IndexDoc",pInput)
			If $$$ISERR(tSCStore) $$$LOGWARNING("无法为此消息构建SearchTable条目"_pInput_"/"_pInput.%Id()_" 类型为'"_pInput.%ClassName(1)_"' 使用的类为'"_..SearchTableClass_"' "_$$$StatusDisplayString(tSCStore))
			} CATCH errobj { $$$LOGWARNING("调用SearchTable方法失败"_..SearchTableClass_".IndexDoc() 输入为:"_pInput_"/"_pInput.%Id()_" 并且 DocType='"_pInput.%ClassName(1)_"' : "_errobj.AsSystemError()) 
		}
	}	
	Quit tSC
}

}
