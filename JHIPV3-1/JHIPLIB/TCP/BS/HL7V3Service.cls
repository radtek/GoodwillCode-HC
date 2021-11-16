/// Classname JHIPLIB.TCP.BS.HL7V3Service<br>
/// Summary   HL7V3Service封装类。<br>
/// Explain	  出参到BP时为EnsLib.EDI.XML.Document类型,唯一服务标识（BS名称前6位）会在XML对象的OriginalDocId属性中,可在BP流程设计中作为判断条件使用。<br>
/// Version   1.0<br>
/// Date      2019年12月24日 15:15:39<br>
/// Author    ZBT<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.TCP.BS.HL7V3Service Extends (EnsLib.EDI.XML.Service.Standard, EnsLib.TCP.Framed.PassthroughService) [ ProcedureBlock, System = 4 ]
{

Parameter ADAPTER = "JHIPLIB.TCP.Adapter.InAdapter";

Parameter SETTINGS = "TargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},IsSync:Basic,SearchTableClass:Basic:selector?context={Ens.ContextSearch/SearchTableClasses?host=JHIPLIB.SOAP.Service.HL7V3SOAPService},DocSchemaCategory:Basic:selector?context={Ens.ContextSearch/SchemaCategories?host=EnsLib.EDI.XML.Service.Standard},Validation,-SendAcknowledgement,-SyncCall,-SyncCallTimeout";

/// 接收消息的目标组件名称
Property TargetConfigNames As Ens.DataType.ConfigName;

/// 设置消息是否是同步发送。异步去勾，同步打勾，默认异步。
Property IsSync As %Boolean [ InitialExpression = 0 ];

/// 选择对应的SearchTableClass，进行消息搜索
Property SearchTableClass As %String;

Method OnProcessInput(pInput As %Stream.Object, tResponse As EnsLib.EDI.XML.Document) As %Status
{
	Set tSC=$$$OK, pOutput = $$$NULLOREF
	Set tDocIn=##class(EnsLib.EDI.XML.Document).%New(),message=pInput.Read()
	Set tDocIn=tDocIn.ImportFromString(message,.status)
	If 'status {Set str="输入的消息内容不能转化为XML请核对！"_message $$$LOGERROR(str)}
	Set tDocIn.OriginalDocId=$E(..%ConfigName,1,6)
	If tDocIn="" Quit %objlasterror
	Set tResponse=$$$NULLOREF,tSCVal=1
	If $$$ISOK(tSC)&&$$$ISOK(tSCVal)&&(""'=..TargetConfigNames) {
		Set tDocIn.IsMutable=0
		If '..IsSync {
			;  异步处理
			For iTarget=1:1:$L(..TargetConfigNames, ",") { Set tOneTarget=$ZStrip($P(..TargetConfigNames,",",iTarget),"<>W")  Continue:""=tOneTarget
				Set tSC1=..SendRequestAsync(tOneTarget,tDocIn)
			}
			//异步返回值设定
				Set MsgId=tDocIn.GetValueAt("/"_tDocIn.Name_"/id/@extension")
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
  			
		} Else { ;  同步处理
			If 1'=$L(..TargetConfigNames, ",") $$$LOGWARNING("为同步转发指定了多个目标配置名称: "_..TargetConfigNames)
			Set tSC=..SendRequestSync(..TargetConfigNames,tDocIn,.tResponse) Quit:$$$ISERR(tSC) tSC
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
