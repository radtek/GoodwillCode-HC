/// Classname HDR.Util.ClassAndXML
/// Summary   将XML转换为对象的工具类
/// Version   1.0
/// Date      2013年10月28日 10:00
/// Author    潘状
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPLIB.ClassAndXML Extends %RegisteredObject
{

/// MethodName：Xml2Object<br>
/// Summary:    把XML串转换成对应的message object<br>
/// Parameter： pInput需要转换的源字符串数据   pRootNode要转换的源字符根节点名称  pOutput转换好的类实例
/// Return：    返回转换的结果是否成功<br>
/// Date：      2013年11月5日 10:00 <br>
/// Author：    潘状<br>
ClassMethod Xml2Object(pInput As %String, pRootNode As %String, pObjectName As %String, Output pOutput As %RegisteredObject) As %Status
{
	set tTSC = $$$OK
	try{
		//Do ##class(Ens.Util.Log).LogTrace("JH.Util.ClassAndXML","Xml2Object","Xml2Object 1111")
		set reader=##class(%XML.Reader).%New()
    	set status=reader.OpenString(pInput)	$$$ThrowOnError(status)
		//Do ##class(Ens.Util.Log).LogTrace("JH.Util.ClassAndXML","Xml2Object",pRootNode_"  "_pObjectName)
    	do reader.Correlate(pRootNode,pObjectName)
    	if reader.Next(.pOutput,.status){
   			set status = pOutput.%Save()		$$$ThrowOnError(status)
    	}
   		else{
	   		$$$ThrowOnError(status)
   		}
    	do reader.Close()
		//Do ##class(Ens.Util.Log).LogTrace("JH.Util.ClassAndXML","Xml2Object","Xml2Object 2222")
	}
	catch errobj{
	//	Do ##class(Ens.Util.Log).LogError("JH.Util.ClassAndXML","Xml2Object",errobj.DisplayString())
		Set errStr="集成平台Error：XML解析失败，请检查内容是否符合标准，错误信息："_errobj.DisplayString()
	//	Set errStr=errStr_"--->被解析的XML为："_pInput
		Set tTSC=$$$ERROR(5001,errStr)
	}		
	Quit tTSC
}

/// MethodName：Stream2Object<br>
/// Summary:    把Stream转换成对应的message object<br>
/// Parameter： pInput需要转换的源字符串数据   pRootNode要转换的源字符根节点名称  pOutput转换好的类实例
/// Return：    返回转换的结果是否成功<br>
/// Date：      2013年11月5日 10:00 <br>
/// Author：    潘状<br>
ClassMethod Stream2Object(pInput As %AbstractStream, pRootNode As %String, pObjectName As %String, Output pOutput As %RegisteredObject) As %Status
{
	set tTSC = $$$OK
	try{
		//Do ##class(Ens.Util.Log).LogTrace("JH.Util.ClassAndXML","Xml2Object","Xml2Object 1111")
		set reader=##class(%XML.Reader).%New()
    	set status=reader.OpenStream(pInput)	$$$ThrowOnError(status)
		//Do ##class(Ens.Util.Log).LogTrace("JH.Util.ClassAndXML","Xml2Object",pRootNode_"  "_pObjectName)
    	do reader.Correlate(pRootNode,pObjectName)
    	if reader.Next(.pOutput,.status){
   			set status = pOutput.%Save()		$$$ThrowOnError(status)
    	}
   		else{
	   		$$$ThrowOnError(status)
   		}
    	do reader.Close()
		//Do ##class(Ens.Util.Log).LogTrace("JH.Util.ClassAndXML","Xml2Object","Xml2Object 2222")
	}
	catch errobj{
	//	Do ##class(Ens.Util.Log).LogError("JH.Util.ClassAndXML","Xml2Object",errobj.DisplayString())
		Set errStr="集成平台Error：XML解析失败，请检查内容是否符合标准，错误信息："_errobj.DisplayString()
	//	Set errStr=errStr_"--->被解析的XML为："_pInput
		Set tTSC=$$$ERROR(5001,errStr)
	}		
	Quit tTSC
}

/// MethodName：Xml2Object<br>
/// Summary:    把相应的message object转换成XML串<br>
/// Parameter：	pInput需要转换的源对象类   pRootNode要转换成XML的目标字符根节点名称  pOutput转换好的字符串
/// Return：    返回转换的结果是否成功<br>
/// Date：      2013年11月5日 10:00 <br>
/// Author：    潘状<br>
ClassMethod Object2Xml(pInput As %RegisteredObject, pRootNode As %String, Output pOutput As %String) As %Status
{
	set tTSC = $$$OK
	try{
		//Do ##class(Ens.Util.Log).LogTrace("JH.Util.ClassAndXML","Object2Xml","Object2Xml 1111")
		set writer=##class(%XML.Writer).%New()
		//set writer.OutputTypeAttribute = 1
		set status=writer.OutputToString() $$$ThrowOnError(status)
		Set status=writer.RootObject(pInput,pRootNode) $$$ThrowOnError(status)
		set pOutput=writer.GetXMLString()
		//Do ##class(Ens.Util.Log).LogTrace("JH.Util.ClassAndXML","Object2Xml","Object2Xml 2222")
	}
	catch errobj{
		Do ##class(Ens.Util.Log).LogError("JH.Util.ClassAndXML","Object2Xml",errobj.DisplayString())
		Set tTSC=$$$ERROR(5001,errobj.DisplayString())
	}		
	Quit tTSC
}

/// MethodName：LogInFile<br>
/// Summary:    把相应的类转换为json字符串<br>
/// Parameter：	obj需要转换为json的类<br>
/// Return：    返回转换后的json字符串<br>
/// Date：      2014年11月11日 15:35 <br>
/// Author：    liuwenyi<br>
ClassMethod GetJson(obj As %RegisteredObject) As %String
{
	s json=""
    s tt=##class(%ZEN.Auxiliary.jsonProvider).%WriteJSONStreamFromObject(.stream,obj,,,,"i")
    Set newstream=##class(%GlobalCharacterStream).%New()
	Do newstream.CopyFrom(stream)
	While 'newstream.AtEnd{
		s json=json_newstream.Read(1024,.sc)
		if $$$ISERR(sc){
			w "ERROR : Read Stream Error!"
			Quit
		}  
	}
	Quit json
}

/// MethodName：Xslt2String<br>
/// Summary:    把xml object经过xslt转换成相应的XML串<br>
/// Parameter：	pInput需要转换的源对象类  xslType文件名称  pOutput转换好的字符串
/// Return：    返回转换的结果是否成功<br>
/// Date：      2019年07月07日 16:00 <br>
ClassMethod Xslt2String(pInput As EnsLib.EDI.XML.Document, xslType As %String, Output pOutput As %String) As %Status
{
	set tSC = $$$OK
	try{
		Set FileBody=""
		&Sql(SELECT FileBody INTO :FileBody  FROM JHIPLIB_Util_Save_DB.SaveDB WHERE FileName=:xslType)
		Set SourceXML=..OutputToString(pInput)
		Set num=$F(SourceXML,">")
		Set SourceXML=$e(SourceXML,num,*)
		Set SourceXML="<"_pInput.Name_">"_SourceXML
		Set SourceXML = $replace(SourceXML,"xsi:","")
		Set msgStream = ##class(%Stream.GlobalCharacter).%New()
		Set status= msgStream.Write(FileBody)
		Set tSC = ##class(%XML.XSLT.CompiledStyleSheet).CreateFromStream(msgStream,.pXSL)
    	Set tSC=##class(%XML.XSLT.Transformer).TransformStringWithCompiledXSL(SourceXML,pXSL,.pOutput,.tError,) $$$ThrowOnError(tSC)
		Set pOutput = $replace(pOutput,"<?xml version=""1.0"" encoding=""UTF-8""?>","")
		Set pOutput = $zcvt(pOutput,"I","UTF8")
		
	}
	catch errobj{
		Do ##class(Ens.Util.Log).LogError("JH.Util.ClassAndXML","Xslt2String",errobj.DisplayString())
		Set tTSC=$$$ERROR(5001,errobj.DisplayString())
	}		
	Quit tSC
}

/// MethodName：EDIXml2String<br>
/// Summary:    把xml 转换成相应的XML串<br>
/// Parameter：	pInput需要转换的源对象类    pOutput转换好的字符串
/// Return：    返回转换的结果是否成功<br>
ClassMethod OutputToString(Request As EnsLib.EDI.XML.Document) As %String
{
	Set tIOStream=##Class(%IO.StringStream).%New()
	Set tIOStream.CharEncoding="Native" ;
	Set pStatus = Request.OutputToIOStream(tIOStream,"q")
	Do tIOStream.Rewind()
	Set tIOStream.CharEncoding="Native" ; show the translated content
	Quit tIOStream.Read()
}

/// MethodName：Xslt2StringBySql<br>
/// Summary:    把xml object经过xslt转换成相应的XML串<br>
/// Parameter：	pInput需要转换的源对象类    pOutput转换好的字符串
/// Return：    返回转换的结果是否成功<br>
/// Date：      2019年01月21日 15:00 <br>
/// Author：    Majiaqi<br>
ClassMethod Xslt2StringBySql(pInput As EnsLib.EDI.XML.Document, FileName As %String, Output pOutput As %String) As %Status
{
	set tSC = $$$OK
	Try{
		Set status=pInput.XMLExportToString(.SourceXML)
		&Sql(SELECT FileBody INTO :FileBody FROM JHIPLIB_Util_Save_DB.SaveDB WHERE FileName=:FileName)
		Set pXSL=FileBody
		s tSC=##class(%XML.XSLT.Transformer).TransformStringWithCompiledXSL(SourceXML,pXSL,.pOutput,.tError,) $$$ThrowOnError(tSC)
		s pOutput = $replace(pOutput,"<?xml version=""1.0"" encoding=""UTF-8""?>","")
		s pOutput = $zcvt(pOutput,"I","UTF8")
	}Catch errobj{
		Do ##class(Ens.Util.Log).LogError("JH.Util.ClassAndXML","Xslt2String",errobj.DisplayString())
		Set tTSC=$$$ERROR(5001,errobj.DisplayString())
	}
	Quit tSC
}

/// MethodName：HL7V2ToXML串<br>
/// Summary:    把HL7V2经过转换成相应的XML串<br>
/// Parameter：	pInput需要转换的对象类  
/// Return：    返回结果是否转化完成的XML串<br>
/// Date：      2019年08月12日 16:00 <br>
/// Author：    ZBT<br>
ClassMethod HL7V2ToXML(pInput As EnsLib.HL7.Message) As %String
{
	
	try{
		Set tMessageXML=pInput.OutputToString(pInput.Separators,,.tSC,"EnsLib.HL7.Util.FormatDSXMLv2")
		Set tMessageXML=$replace(tMessageXML," xmlns:hl7='urn:hl7-org:v2xml' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'","")
   		Set tMessageXML=$replace(tMessageXML,"hl7:","")
   				
	}
	catch errobj{
		Do ##class(Ens.Util.Log).LogError("JH.Util.ClassAndXML","HL7V2ToXML",errobj.DisplayString())
		Set tTSC=$$$ERROR(5001,errobj.DisplayString())
	}		
	Quit tMessageXML
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

/// MethodName：NodeToDynObj<br>
/// Summary:    //xml转json通用基类  在下面方法中调用<br>
/// Parameter：	入参为xml串
/// Return：    返回结果是json对象<br>
/// Date：      2019年10月12日 16:00 <br>
/// Author：    ZBT<br>
ClassMethod NodeToDynObj(Node As %XML.Node) As %DynamicObject
{
	 
	 Set cun=""
	 #dim res As %DynamicObject = {}
	 
	 Do Node.MoveToFirstChild(1)
	 IF (Node.NodeType = $$$xmlTEXTNODE) {
		Set val = Node.NodeData
	  	Do Node.MoveToParent(1)
	  	Set propertyName = Node.LocalName
	  	IF Node.FirstAttributeName()'=""{
		  		
				Set AttributeName=Node.FirstAttributeName()
				Set req=Node.GetAttributeValue(AttributeName)
				Do res.%Set(AttributeName,req)
				Set NextAttributeName=Node.NextAttributeName(AttributeName)
				While NextAttributeName'=""{
					Set req=Node.GetAttributeValue(NextAttributeName)
					Do res.%Set(NextAttributeName,req)
					Set NextAttributeName=Node.NextAttributeName(NextAttributeName)
				}
			Do res.%Set("#text",val)
		}else{
	  	s res = val}
	    Quit res
	   }
	 
	 Do {
		Set propertyName = Node.LocalName
		 //如果为空的话 跳过
		Continue:propertyName=""
		IF ( (Node.HasChildNodes(1)) && (Node.NodeType '= $$$xmlWHITESPACENODE ) && (Node.NodeType '= $$$xmlTEXTNODE) ){
		  	//有子后代，需要迭代
		  	#dim resopn As %DynamicObject = {}
		  	Set resopn = ..NodeToDynObj(Node)
		  	IF Node.FirstAttributeName()'=""{
				
				Set AttributeName=Node.FirstAttributeName()
				Set req=Node.GetAttributeValue(AttributeName)
				Do resopn.%Set(AttributeName,req)
				Set NextAttributeName=Node.NextAttributeName(AttributeName)
				While NextAttributeName'=""{
					Set req=Node.GetAttributeValue(NextAttributeName)
					Do resopn.%Set(NextAttributeName,req)
					Set NextAttributeName=Node.NextAttributeName(NextAttributeName)
				}
			
		}
			Set value=resopn
		  	
		  	
		}Else{
			IF Node.FirstAttributeName()'=""{
				#dim njson As %DynamicObject = {}
				Set AttributeName=Node.FirstAttributeName()
				Set req=Node.GetAttributeValue(AttributeName)
				Do njson.%Set(AttributeName,req)
				Set NextAttributeName=Node.NextAttributeName(AttributeName)
				While NextAttributeName'=""{
					Set req=Node.GetAttributeValue(NextAttributeName)
					Do njson.%Set(NextAttributeName,req)
					Set NextAttributeName=Node.NextAttributeName(NextAttributeName)
				}
				Set value=njson
					
			 }else{
				 d Node.GetText(.value)
				 }
		}
		 //删除控制字符，如\r\n等.
		Set:("string" = [(value)].%GetTypeOf(0)) value = $ZSTRIP(value,"*C")
		IF "" '= value{
			 Set exNode = res.%Get(propertyName)
		  	 IF cun '=$P(cun,propertyName){
				//命名对象已作为对象存在
				//将现有的对象引用更改为数组
			 	IF $CLASSNAME(exNode)="%Library.DynamicArray" {
					 #dim exArray As %DynamicArray = exNode
				     Do exArray.%Push(value)
				     Do res.%Set(propertyName,exArray)
				}else{
					 //否则它应该是一个现有数组
					 //将新成员插入其中
					#dim newArray As %DynamicArray = []
					 Do newArray.%Push(exNode)
					 Do newArray.%Push(value)
					 Do res.%Set(propertyName,newArray)
				    			
			   	}
		 	  }else{
				 Do res.%Set(propertyName,value)
		      }
		 }
		 Set cun=cun_","_propertyName
	 }While Node.MoveToNextSibling(1)
	 DO Node.MoveToParent(1)
	 Quit res
}

/// MethodName：XMLTOJSON<br>
/// Summary:    //xml转json通用方法<br>
/// Parameter：	入参为xml串
/// Return：    返回结果是json串<br>
/// Date：      2019年10月12日 16:00 <br>
/// Author：    ZBT<br>
ClassMethod XMLTOJSON(pInput As EnsLib.EDI.XML.Document) As %String
{
 Set SourceXML=..OutputToString(pInput)
 Set num=$F(SourceXML,">")
 Set SourceXML=$e(SourceXML,num,*)
 Set SourceXML="<"_pInput.Name_">"_SourceXML
 Set SourceXML = $replace(SourceXML,"xsi:","")	
 set reader=##class(%XML.Reader).%New()
    set status=reader.OpenString(SourceXML)
    if $$$ISERR(status) {do $System.Status.DisplayError(status) quit $$$NULLOREF}
 
    #dim document As %XML.Document =reader.Document
    #dim obj AS %DynamicObject = ..NodeToDynObj(document.GetNode(1))
    q obj.%ToJSON()
}

/// MethodName：Activity<br>
/// Summary:    大屏活动量存储<br>
/// Parameter：	入参为
/// Return：    <br>
/// Date：      2019年10月15日 16:00 <br>
/// Author：    ZBT<br>
ClassMethod Activity(BusinessPartner As %String, EventType As %String, ConfigName As %String, Type As %String) As %Status
{
	Set date=$TRanslate($ZDate($H,3),"-"),Number=""
	
	&Sql(SELECT Number INTO :Number FROM JHIPLIB_HIPP_DB.ActivityDB WHERE EventType=:EventType AND "Date"=:date AND Type=:Type)
		If Number=""{
			Set Number=1
			IF Type="O"{
				&Sql(SELECT ConfigName INTO :NConfigName FROM JHIPLIB_HIPP_DB.ActivityDB WHERE Type='I' AND "Date"=:date AND EventType=:EventType)
				&Sql(INSERT INTO JHIPLIB_HIPP_DB.ActivityDB ("Date",BusinessPartner,Number,EventType,ConfigName,Type) VALUES (:date,:BusinessPartner,:Number,:EventType,:NConfigName,:Type))
			
			}ELSE{
			&Sql(INSERT INTO JHIPLIB_HIPP_DB.ActivityDB ("Date",BusinessPartner,Number,EventType,ConfigName,Type) VALUES (:date,:BusinessPartner,:Number,:EventType,:ConfigName,:Type))
				
				}
		}else{
			Set Number=Number+1
			&Sql(UPDATE  JHIPLIB_HIPP_DB.ActivityDB SET Number=:Number WHERE ConfigName=:ConfigName AND "Date"=:date)
			
			}
}

/// MethodName：DictTRanslate<br>
/// Summary:    院内字典对照转换基类<br>
/// Parameter： pInput转换前字典内容 dictcode为LookupTable名称 反参→code转换后字典code,value为转换后字典的value
/// Return：    返回转换的结果是否成功<br>
/// Date：      2019年11月08日 10:00 <br>
/// Author：    ZBT<br>
ClassMethod DictTRanslate(pInput As %String, dictcode As %String, Output code As %String, Output value As %String) As %Status
{
	Set tSC = $$$NO
	Set DataValue=""
	if pInput '= ""{
		Set pInput="%,"_pInput_",%"
		&sql(Select DataValue INTO :DataValue from Ens_Util.LookupTable where KeyName like :pInput and TableName = :dictcode)
		if DataValue '= ""{
			Set code=$PIECE(DataValue,",",1)
			Set value=$PIECE(DataValue,",",2)
			Set tSC = $$$OK
			Quit tSC
		}else{
			Quit tSC
		}
	}
}

/// MethodName：StringReversal<br>
/// Summary:    字符串反转工具方法<br>
/// Parameter： pInput反转前字符串 
/// Return：    反转后字符串<br>
/// Date：      2020年05月11日 10:00 <br>
/// Author：    ZBT<br>
ClassMethod StringReversal(pInput As %String) As %String
{
	Set out=""
	for i=$l(pInput):-1:1 d
	.Set out=out_$e(pInput,i)
	Quit out
}

}
