/// Classname JHIPLIB.HTTP.BS.Service
/// Summary   HTTP消息接收字符串通用BS入口封装类<br>
/// Explain	  出参到BP时为JHIPLIB.Util.MSG.JHRequestMsg类型,唯一服务标识（BS名称前6位）会在消息对象的action属性中,可在BP流程设计中作为判断条件使用。<br>
///           接收到的消息会存放在消息类的PARG属性中。
/// Version   1.0<br>
/// Date      2019年08月15日 10:15:39<br>
/// Author    ZBT<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.HTTP.BS.Service Extends EnsLib.SOAP.Service
{

Parameter ADAPTER = "EnsLib.HTTP.InboundAdapter";

Parameter SETTINGS = "TargetConfigNames:Basic:selector?multiSelect=0&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},IsSync:Basic,AsyReturnFormat:Basic,SearchTableClass:Basic:selector?context={Ens.ContextSearch/SearchTableClasses?host=JHIPLIB.SOAP.BS.Service}";

/// 选择对应的SearchTableClass，进行消息搜索
Property SearchTableClass As %String(MAXLEN = 128);

/// 接收消息的目标组件名称
Property TargetConfigNames As Ens.DataType.ConfigName;

/// 设置消息是否是同步发送。异步去勾，同步打勾，默认异步。
Property IsSync As %Boolean [ InitialExpression = 0 ];

/// 设置异步返回值格式,XML为自定义格式,String为字符串格式,JSON为JSON格式。
Property AsyReturnFormat As %String(DISPLAYLIST = ",XML,JSON,String", VALUELIST = ",XML,JSON,String") [ InitialExpression = "XML" ];

Method OnProcessInput(pStreamIn As %CharacterStream, Output pStreamOut As %CharacterStream) As %Status
{
	try{
		If ""=..TargetConfigNames{$$$LOGWARNING("没有选择接收消息的目标名称，请查看BS前台设置属性")}
		Set ReplyStream=##class(%GlobalCharacterStream).%New()
		Set Util=##class(JHIPLIB.Util.ClassAndXML).%New()
		//消息体格式判断,如果没有消息体，那么将自动获取消息头中的参数作为消息传输。
		Set Request=##class(JHIPLIB.Util.MSG.JHRequestMsg).%New()
		Set Request.action=$E(..%ConfigName,1,6)
		Set tSC=Request.pArg.Insert(pStreamIn.Read())
		Set tSC=..BaseSend(Request,.tResponse)
		Set ReplyStream.Attributes("Content-Type")="text/xml"
		Set:..IsSync=1 pOutput=tResponse.StringValue
		If ..IsSync=0{
			IF ..AsyReturnFormat="String"{
				Set pOutput="平台"_..%ConfigName_"接收成功,调用时间为"_$ZDT($H,3)_"."
			}ELSEIF ..AsyReturnFormat="XML"{
				Set pOutput="<RESPONSE><RESULT_CODE>true</RESULT_CODE><RESULT_CONTENT>平台接收"_..%ConfigName_"成功,调用时间为"_$ZDT($H,3)_"</RESULT_CONTENT></RESPONSE>"
			}ELSE{
				Set ReplyStream.Attributes("Content-Type")="text/json"
				Set pOutput="{""Code"":""200"",""Result"":""平台接收"_..%ConfigName_"成功,调用时间为"_$ZDT($H,3)_"}"
			}
	  	} 
	}catch(ex){		
		$$$LOGERROR(ex.DisplayString())
	}
  	Set pOutput=$zcvt(pOutput,"O","UTF8"),pStreamOut=ReplyStream
	Set Stuts=pStreamOut.Write(pOutput)
	Quit $$$OK
}

Method BaseSend(pInput As %RegisteredObject, Output tResponse As %RegisteredObject) As %Status
{
	try{
		For iTarget=1:1:$L(..TargetConfigNames, ","){
			Set Status=..ProcessMessage(pInput,.tResponse,$P(..TargetConfigNames,",",iTarget))
		}
	;Set:$L(^Activity)>0 stuts=$zobjclassmethod("JHIPLIB.HIPP.SaveBase","Activity",..BusinessPartner,pInput.action,..%ConfigName,"I")
	
	}catch(ex){		
		$$$LOGERROR(ex.DisplayString())
	}
	Quit Status
}

Method ProcessMessage(pInput As %RegisteredObject, Output pOutput As %RegisteredObject, ByRef pHint As %String) As %Status
{
	If ..IsSync=0{
	    Set tSC=..SendRequestAsync(pHint,pInput)
	    }else{
		Set tSC=..SendRequestSync(pHint,pInput,.pOutput)
	}
	If ""'=..SearchTableClass {
		TRY{		
			Set tSCStore=$zobjclassmethod(..SearchTableClass,"IndexDoc",Input)
			If $$$ISERR(tSCStore) $$$LOGWARNING("无法为此消息构建SearchTable条目"_Input_"/"_Input.%Id()_"使用的类为 '"_..SearchTableClass_"' "_$$$StatusDisplayString(tSCStore))
		}CATCH errobj { $$$LOGWARNING("调用SearchTable方法失败"_..SearchTableClass_".IndexDoc()输入为: "_Input_"/"_Input.%Id()_"  : "_errobj.AsSystemError()) }
	}
	Quit tSC
}

}
