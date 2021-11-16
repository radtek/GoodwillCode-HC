/// Classname JHIPLIB.SOAP.BS.HL7V3Service<br>
/// Summary   HL7V3SOAPBS封装类，参数Message为消息内容。<br>
/// Explain	  出参到BP时为EnsLib.EDI.XML.Document类型,唯一服务标识（BS名称前6位）会在XML对象的OriginalDocId属性中,可在BP流程设计中作为判断条件使用。<br>
/// Version   1.0<br>
/// Date      2019年4月29日 15:15:39<br>
/// Author    ZBT<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.SOAP.BS.HL7V3Service Extends (EnsLib.SOAP.Service, JHIPLIB.SOAP.AESCBC.AESCBCService)
{

Parameter ADAPTER;

Parameter SERVICENAME = "HL7V3Service";

Parameter NAMESPACE = "http://goodwillcis.com";

Parameter SETTINGS = "TargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},IsSync:Basic,SearchTableClass:Basic:selector?context={Ens.ContextSearch/SearchTableClasses?host=JHIPLIB.SOAP.Service.HL7V3SOAPService}";

/// 接收消息的目标组件名称
Property TargetConfigNames As Ens.DataType.ConfigName;

/// 设置消息是否是同步发送。异步去勾，同步打勾，默认异步。
Property IsSync As %Boolean [ InitialExpression = 0 ];

/// 选择对应的SearchTableClass，进行消息搜索
Property SearchTableClass As %String;

Method HIPMessageServer(Message As %String) As %String [ WebMethod ]
{
	Set Util=##class(JHIPLIB.Util.ClassAndXML).%New()
	Set tResponse=##class(EnsLib.EDI.XML.Document).%New()
	Try{
		Set str = "出现错误，详情请查看完整跟踪！"
		Set Message=$replace(Message,$c(0),"")
		Set target=##class(EnsLib.EDI.XML.Document).ImportFromString(Message,.status)
		Set target.OriginalDocId= $E(..%ConfigName,1,6)
		Set tSC=..BaseSend(target,.tResponse)
		Set str = Util.OutputToString(tResponse)
	}catch(ex){	
		Set guid=##class(%SYSTEM.Util).CreateGUID()
			Set CreateTime=$TRanslate($ZDT($H,3),"-,:, "),FileBody=""
	  		&Sql(SELECT FileBody INTO :FileBody  FROM JHIPLIB_Util_Save_DB.SaveDB WHERE FileName='统一答复模版')
	  		If $L(FileBody)=0 {$$$LOGERROR("统一答复模版未在库中存储，请先进行存储！") }
			Set tResponse=tResponse.ImportFromString(FileBody,.statu)
		   	Set tSC=tResponse.SetValueAt(guid,"/MCCI_IN000002UV01/id/@extension")
	  		Set tSC=tResponse.SetValueAt(CreateTime,"/MCCI_IN000002UV01/creationTime/@value")
	  			
		If 'status {Set str="输入的消息内容不能转化为XML请核对！" $$$LOGERROR(str) 
			Set tSC=tResponse.SetValueAt("平台接收的"_..%ConfigName_"事件的消息内容不能转化为XML，请核对！","/MCCI_IN000002UV01/acknowledgement/acknowledgementDetail/text")
	   	}else{
		   	$$$LOGERROR(str)
	   		Set tSC=tResponse.SetValueAt("平台接收的"_..%ConfigName_"事件的消息处理"_str,"/MCCI_IN000002UV01/acknowledgement/acknowledgementDetail/text")
	   	}		
	   	Set str = Util.OutputToString(tResponse)
	   	
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
		If ..IsSync=0{
			Set MsgId=pInput.GetValueAt("/"_pInput.Name_"/id/@extension")
			Set guid=##class(%SYSTEM.Util).CreateGUID()
			Set CreateTime=$TRanslate($ZDT($H,3),"-,:, "),FileBody=""
  			Set tResponse=##class(EnsLib.EDI.XML.Document).%New()
  			&Sql(SELECT FileBody INTO :FileBody  FROM JHIPLIB_Util_Save_DB.SaveDB WHERE FileName='统一答复模版')
  			If $L(FileBody)=0 {$$$LOGERROR("统一答复模版未在库中存储，请先进行存储！") }
			Set tResponse=tResponse.ImportFromString(FileBody,.status)
	   		Set tSC=tResponse.SetValueAt(guid,"/MCCI_IN000002UV01/id/@extension")
  			Set tSC=tResponse.SetValueAt(CreateTime,"/MCCI_IN000002UV01/creationTime/@value")
  			Set tSC=tResponse.SetValueAt(MsgId,"/MCCI_IN000002UV01/acknowledgement/targetMessage/id/@extension")
  			Set tSC=tResponse.SetValueAt("集成平台成功接收"_..%ConfigName_"事件","/MCCI_IN000002UV01/acknowledgement/acknowledgementDetail/text")
   			Set tSC=tResponse.SetValueAt("AA","/MCCI_IN000002UV01/acknowledgement/@typeCode")
  			}
	}catch(ex){	
		
		$$$LOGERROR(ex.DisplayString())
		}
	Quit tSC
}

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject, ByRef pHint As %String) As %Status
{
	
	//判断是否为YI步发送
    If ..IsSync=0{
	    Set tSC=..SendRequestAsync(pHint,pInput)
	    }else{
		Set tSC=..SendRequestSync(pHint,pInput,.pOutput)}
	;Set:$L(^OutInpatient)>0 stuts=$zobjclassmethod("JHIPLIB.HIPP.SaveBase","OutInpatient",pInput)
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
