/// Classname JHIPLIB.TCP.BS.HL7V3Service<br>
/// Summary   XMLService封装类。<br>
/// Explain	  出参到BP时为EnsLib.EDI.XML.Document类型,唯一服务标识（BS名称前6位）会在XML对象的OriginalDocId属性中,可在BP流程设计中作为判断条件使用。<br>
/// Version   1.0<br>
/// Date      2019年12月24日 15:15:39<br>
/// Author    ZBT<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.TCP.BS.Service Extends (EnsLib.EDI.XML.Service.Standard, EnsLib.TCP.Framed.PassthroughService) [ ProcedureBlock, System = 4 ]
{

Parameter ADAPTER = "JHIPLIB.TCP.Adapter.InAdapter";

Parameter SETTINGS = "TargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},AsyReturnFormat:Basic,IsSync:Basic,SearchTableClass:Basic:selector?context={Ens.ContextSearch/SearchTableClasses?host=JHIPLIB.SOAP.Service.HL7V3SOAPService},DocSchemaCategory:Basic:selector?context={Ens.ContextSearch/SchemaCategories?host=EnsLib.EDI.XML.Service.Standard},Validation,-SendAcknowledgement,-SyncCall,-SyncCallTimeout";

/// 选择对应的SearchTableClass，进行消息搜索
Property SearchTableClass As %String(MAXLEN = 128);

/// 接收消息的目标组件名称
Property TargetConfigNames As Ens.DataType.ConfigName;

/// 设置消息是否是同步发送。异步去勾，同步打勾，默认异步。
Property IsSync As %Boolean [ InitialExpression = 0 ];

/// 设置异步返回值格式,XML为自定义格式,String为字符串格式,JSON为JSON格式。
Property AsyReturnFormat As %String(DISPLAYLIST = ",XML,JSON,String", VALUELIST = ",XML,JSON,String") [ InitialExpression = "XML" ];

Method OnProcessInput(pInput As %Stream.Object, tResponse As Ens.StringResponse) As %Status
{
	Set tSC=$$$OK, pOutput = $$$NULLOREF
	Set message=pInput.Read()
	Set Input=##class(JHIPLIB.Util.MSG.JHRequestMsg).%New()
	Set Input.action=$E(..%ConfigName,1,6)
	Set tSC=Input.pArg.Insert(message)
	Set Util=##class(JHIPLIB.Util.ClassAndXML).%New()
	Set tResponse=##class(Ens.StringResponse).%New()
	If $$$ISOK(tSC)&&(""'=..TargetConfigNames) {
		If '..IsSync {
			;  异步处理
			For iTarget=1:1:$L(..TargetConfigNames, ",") { Set tOneTarget=$ZStrip($P(..TargetConfigNames,",",iTarget),"<>W")  Continue:""=tOneTarget
				Set tSC1=..SendRequestAsync(tOneTarget,Input)
			}
			//异步返回值设定
			IF ..AsyReturnFormat="String"{
				Set pOutput="平台"_..%ConfigName_"接收成功,调用时间为"_$ZDT($H,3)_"."
			}ELSEIF ..AsyReturnFormat="XML"{
				Set pOutput="<RESPONSE><RESULT_CODE>true</RESULT_CODE><RESULT_CONTENT>平台接收"_..%ConfigName_"成功,调用时间为"_$ZDT($H,3)_"</RESULT_CONTENT></RESPONSE>"
			}ELSE{
				Set pOutput="{""Code"":""200"",""Result"":""平台接收"_..%ConfigName_"成功,调用时间为"_$ZDT($H,3)_"}"
			}
			Set tResponse.StringValue=pOutput
  		} Else { ;  同步处理
			If 1'=$L(..TargetConfigNames, ",") $$$LOGWARNING("为同步转发指定了多个目标配置名称: "_..TargetConfigNames)
			Set tSC=..SendRequestSync(..TargetConfigNames,Input,.tResponse) Quit:$$$ISERR(tSC) tSC
		}
	} Else { ; 由于错误或没有目标而不转发
		If ""=..TargetConfigNames { $$$LOGWARNING("没有选择接收消息的目标名称，请查看BS前台设置属性") }
	}
	
	Quit tSC
}

ClassMethod OnGetConnections(Output pArray As %String, pItem As Ens.Config.Item)
{
	Do ##super(.pArray,pItem)
	If pItem.GetModifiedSetting("ReplyTargetConfigNames",.tValue) {
		For i=1:1:$L(tValue,",") { Set tOne=$ZStrip($P(tValue,",",i),"<>W")  Continue:""=tOne  Set pArray(tOne)="" }
	}
}

// 初始化方法

Method OnInit() As %Status
{
	Set tSC = $$$OK
	Try {
		Set:(..IsSync=0) ..SendAcknowledgement = 0
		#; 如果不发送回确认，则无需转换
		Quit:'..SendAcknowledgement
		#; 将ACK/NACK设置转换为字符
		Set ..AckOKAsChars = ..Adapter.AsciiOrHexAsChars(..AckOK)
		Set ..AckNotOKAsChars = ..Adapter.AsciiOrHexAsChars(..AckNotOK)
	} Catch { Set tSC = $$$SystemError}
	Quit tSC
}

}
