/// Classname JHIPLIB.Util.Lookup.BS.Service<br>
/// Summary   Service封装类，参数Message为消息内容，参数Type为对消息进行的增删改<br>
/// Explain	  出参到BP时为EnsLib.EDI.XML.Document类型,唯一服务标识（BS名称前6位）会在XML对象的OriginalDocId属性中,可在BO流程设计中作为判断条件使用。<br>
/// Version   1.0<br>
/// Date      2020年5月14日 15:15:39<br>
/// Author    GWH<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.Util.Lookup.BS.Service Extends (EnsLib.SOAP.Service, JHIPLIB.SOAP.AESCBC.AESCBCService)
{

/// 搜索表添加的	
/// Parameter SETTINGS = "SearchTableClass:Basic";
/// Property SearchTableClass As %String [ InitialExpression = "JHIP.MyCustomSearchTable" ];
/// Parameter相当与常量
/// Property相当于某一类型
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

Method HIPMessageServer(Type As %String, Message As %String) As %String [ WebMethod ]
{
	Set Util=##class(JHIPLIB.Util.ClassAndXML).%New()
	Set tResponse=##class(EnsLib.EDI.XML.Document).%New()
	Try{
		Set str = "出现错误，详情请查看完整跟踪！"
		Set target=##class(EnsLib.EDI.XML.Document).ImportFromString(Message,.status)
		$$$TRACE("status"_status)
		Set target.OriginalDocId = Type  
		Set tSC=..BaseSend(target,.tResponse)
		Set str = Util.OutputToString(tResponse)
		
	}catch(ex){	
		$$$TRACE("抛出异常")
		//消息未成功发送返回的消息
		
		If 'status {
			Set str ="<RESPONSE><RESULT_CODE>false</RESULT_CODE><RESULT_CONTENT>传入的消息不是标准的XML</RESULT_CONTENT></RESPONSE>"
	   	}else{
	   		Set str ="<RESPONSE><RESULT_CODE>false</RESULT_CODE><RESULT_CONTENT>消息处理失败，详情查看流程</RESULT_CONTENT></RESPONSE>"
	   	}		
	   
	   	
	
		
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
		//BS发送给多个BP，..TargetConfigNames可以有多个，用逗号隔开，$L是以逗号为分隔符，一个逗号长度为1
		For iTarget=1:1:$L(..TargetConfigNames, ","){
			//ProcessInput将消息传送给BP，输入消息PInput,$P(..TargetConfigNames,",",iTarget)是为了获得BP名字，因..TargetConfigNames是一长串以逗号分割的串，所以$P是为了依次分别取出每个名字，..tResponse是返回的结果，异步就不将返回结果给BS了，同步将它给BS
					Set tSC=..ProcessInput(pInput,.tResponse,$P(..TargetConfigNames,",",iTarget))
				}
		
		If ..IsSync=0{
			//异步发送消息成功，输出的消息
			Set tResult="<RESPONSE><RESULT_CODE> true</RESULT_CODE><RESULT_CONTENT>消息成功传入</RESULT_CONTENT></RESPONSE>"
			Set tResponse=##class(EnsLib.EDI.XML.Document).ImportFromString(tResult,.status)
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
