/// Classname JHIPLIB.SOAP.BS.XmlService
/// Summary   消息接收自定义XML通用BS，参数Message为消息内容
/// Explain	  出参到BP时为EnsLib.EDI.XML.Document类型,唯一服务标识（BS名称前6位）会在XML对象的OriginalDocId属性中,可在BP流程设计中作为判断条件使用。<br>
/// Version   1.0
/// Date      2019年1月15日 09:00
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPLIB.SOAP.BS.XmlService Extends JHIPLIB.SOAP.AESCBC.AESCBCService
{

Parameter ADAPTER;

Parameter SERVICENAME = "XmlService";

Parameter NAMESPACE = "http://bjgoodwillcis.com";

Parameter SETTINGS = "TargetConfigNames:Basic:selector?multiSelect=0&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},IsSync:Basic,SearchTableClass:Basic:selector?context={Ens.ContextSearch/SearchTableClasses?host=JHIPLIB.SOAP.BS.XmlService}";

/// 选择对应的SearchTableClass，进行消息搜索
Property SearchTableClass As %String(MAXLEN = 128);

/// 接收消息的目标组件名称
Property TargetConfigNames As Ens.DataType.ConfigName;

/// 设置消息是否是同步发送。异步去勾，同步打勾，默认异步。
Property IsSync As %Boolean [ InitialExpression = 0 ];

Method XMLMessageServer(Message As %String) As %String [ WebMethod ]
{
	Try{
		Set str="<RESPONSE><RESULT_CODE>false</RESULT_CODE><RESULT_CONTENT>平台接收的"_..%ConfigName_"事件的消息处理出现错误，详情请查看完整跟踪！调用时间为"_$ZDT($H,3)_"</RESULT_CONTENT></RESPONSE>"
		Set Util=##class(JHIPLIB.Util.ClassAndXML).%New()
		Set tResponse=##class(EnsLib.EDI.XML.Document).%New()
		Set target=##class(EnsLib.EDI.XML.Document).ImportFromString(Message,.status)
		Set target.OriginalDocId= $E(..%ConfigName,1,6)
		Set tSC=..BaseSend(target,.tResponse)
		Set str = Util.OutputToString(tResponse)
	}catch(ex){	
	  	If 'status {
			Set err="输入的消息内容不能转化为XML请核对！" $$$LOGERROR(err) 
			Set str="<RESPONSE><RESULT_CODE>false</RESULT_CODE><RESULT_CONTENT>平台接收的"_..%ConfigName_"事件的消息内容不能转化为XML，请核对！调用时间为"_$ZDT($H,3)_"</RESULT_CONTENT></RESPONSE>"
	   	}else{
		   	$$$LOGERROR(str)
	   	}		
	   $$$LOGERROR(ex.DisplayString())
	}
		
	Quit str
}

Method BaseSend(pInput As EnsLib.EDI.XML.Document, Output tResponse As EnsLib.EDI.XML.Document) As %Status
{
	If ""=..TargetConfigNames { $$$LOGWARNING("没有选择接收消息的目标名称，请查看BS前台设置属性") }
	If ..IsAESCBC{
		If ..Verification()'=$$$OK{	
			Quit "鉴权失败无法进行接口调用"
		}	
	}
	try{
		For iTarget=1:1:$L(..TargetConfigNames, ","){
			Set tSC=..ProcessInput(pInput,.tResponse,$P(..TargetConfigNames,",",iTarget))
		}
		Set:'..IsSync tResponse=##class(EnsLib.EDI.XML.Document).ImportFromString("<RESPONSE><RESULT_CODE>true</RESULT_CODE><RESULT_CONTENT>平台接收"_..%ConfigName_"成功,调用时间为"_$ZDT($H,3)_"</RESULT_CONTENT></RESPONSE>")
	}catch(ex){	
		$$$LOGERROR(ex.DisplayString())
		}
	Quit tSC
}

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject, ByRef pHint As %String) As %Status
{
	//判断是否为同步发送
	 If ..IsSync=0{
	    Set tSC=..SendRequestAsync(pHint,pInput)
	    }else{
		Set tSC=..SendRequestSync(pHint,pInput,.pOutput)}
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
