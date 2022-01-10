/// Classname JHIPV5.JHREG.Rest.SubscriptionPublicationRest
/// Summary   订阅发布rest
/// Version   1.0
/// Date      2021年11月29日
/// Author    
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.Rest.SubscriptionPublicationRest Extends %CSP.REST
{

Parameter HandleCorsRequest = "true";

XData UrlMap [ XMLNamespace = "http://www.bjgoodwill.com/urlmap" ]
{
<Routes>
  <Route Url="/*" Method="OPTIONS" Call="GetStatus"/>
  <Route Url="/SubscriptRelate/:Method" Method="POST" Call="GetSubscriptRelate"/>
  <!--  消息检索 -->
  <Route Url="/MessageQuery/:Method" Method="POST" Call="MessageQuery"/>
  <!--  域管理   -->
  <Route Url="/Domain/:Method" Method="POST" Call="Domain"/>
  <!--  适配器管理   -->
  <Route Url="/Adapter/:Method" Method="POST" Call="Adapter"/>
  <!--  消息监控 -->
  <Route Url="/MessageMonitor/:Method" Method="POST" Call="MessageMonitor"/>
  <!--  运行监控 -->
  <Route Url="/OperationMonitor/:Method" Method="POST" Call="OperationMonitor"/>
  <!--  结构管理 -->
  <Route Url="/StructureManagement/:Method" Method="POST" Call="StructureManagement"/>
   <!-- 主题管理 -->
  <Route Url="/ThemeManagement/:Method" Method="POST" Call="ThemeManagement"/>
   <!-- 订户管理 -->
  <Route Url="/SubscriberManagement/:Method" Method="POST" Call="SubscriberManagement"/>
   <!-- 规则转换 -->
  <Route Url="/RuleTranslation/:Method" Method="POST" Call="RuleTranslation"/>
</Routes>
}

ClassMethod GetStatus(ser As %String) As %Status
{
     Quit $$$OK
}

ClassMethod GetSubscriptRelate(Method As %String) As %Status
{
	
	Set SubscribeBS =##class(JHIPV5.JHREG.BS.SubPubBS).%New()
	Set Request=##class(JHIPLIB.Util.MSG.JHRequestMsg).%New()
	Do %response.SetHeader("Content-Type", "application/json;charset=UTF8")
	Try{
	    Set tSC=##class(Ens.Director).CreateBusinessService("订阅发布分派BS",.SubscribeBS)

		Set Request.action=Method
		//W %request.Content.Read()
	    Set content=$zcvt(%request.Content.Read(),"I","UTF8")
	  
	 	Set tSC=Request.pArg.Insert(content) 
	 	//W Request.pArg.Insert(content) 
	   	Set tSC1=SubscribeBS.SubscriptioPublication("订阅关系bp",Request,.out)
	   	set message=out.StringValue
	   	
		}Catch(e){
		Set message="{""code"":500,""data"":"""",""success"":0,""msg"":""操作失败""}"
	}
    w $zcvt(message,"O","UTF8")
    Quit $$$OK
}

/// 消息检索
ClassMethod MessageQuery(Method As %String) As %Status
{
	Set SubscribeBS =##class(JHIPV5.JHREG.BS.SubPubBS).%New()
	Set Request=##class(JHIPLIB.Util.MSG.JHRequestMsg).%New()
	Do %response.SetHeader("Content-Type", "application/json;charset=UTF-8")
	Try{
		Set content=""
	    Set tSC=##class(Ens.Director).CreateBusinessService("订阅发布分派BS",.SubscribeBS)
		Set Request.action=Method
		Set:$L(%request.Content)'=0 content=$zcvt(%request.Content.Read(),"I","UTF8")
	 	Set tSC=Request.pArg.Insert(content) 
	   	Set tSC1=SubscribeBS.SubscriptioPublication("消息检索分发BP",Request,.out)
	   	set message=out.StringValue
	}Catch(e){
		Set message="{""code"":500,""data"":"""",""success"":0,""msg"":""操作失败""}"
	}
    w $zcvt(message,"O","UTF8")
    Quit $$$OK
}

/// 域管理
ClassMethod Domain(Method As %String) As %Status
{
	Set SubscribeBS =##class(JHIPV5.JHREG.BS.SubPubBS).%New()
	Set Request=##class(JHIPLIB.Util.MSG.JHRequestMsg).%New()
	Do %response.SetHeader("Content-Type", "application/json;charset=UTF-8")
	Try{
		Set content=""
	    Set tSC=##class(Ens.Director).CreateBusinessService("订阅发布分派BS",.SubscribeBS)
		Set Request.action=Method
		Set:$L(%request.Content)'=0 content=$zcvt(%request.Content.Read(),"I","UTF8")
	 	Set tSC=Request.pArg.Insert(content) 
	   	Set tSC1=SubscribeBS.SubscriptioPublication("域管理分发BP",Request,.out)
	   	set message=out.StringValue
	}Catch(e){
		Set message="{""code"":500,""data"":"""",""success"":0,""msg"":""操作失败""}"
	}
    w $zcvt(message,"O","UTF8")
    Quit $$$OK
}

/// 适配器管理
ClassMethod Adapter(Method As %String) As %Status
{
	Set SubscribeBS =##class(JHIPV5.JHREG.BS.SubPubBS).%New()
	Set Request=##class(JHIPLIB.Util.MSG.JHRequestMsg).%New()
	Do %response.SetHeader("Content-Type", "application/json;charset=UTF-8")
	Try{
		Set content=""
	    Set tSC=##class(Ens.Director).CreateBusinessService("订阅发布分派BS",.SubscribeBS)
		Set Request.action=Method
		Set:$L(%request.Content)'=0 content=$zcvt(%request.Content.Read(),"I","UTF8")
	 	Set tSC=Request.pArg.Insert(content) 
	   	Set tSC1=SubscribeBS.SubscriptioPublication("适配器管理分发BP",Request,.out)
	   	set message=out.StringValue
	}Catch(e){
		Set message="{""code"":500,""data"":"""",""success"":0,""msg"":""操作失败""}"
	}
    w $zcvt(message,"O","UTF8")
    Quit $$$OK
}

/// 消息监控
ClassMethod MessageMonitor(Method As %String) As %Status
{
	Set SubscribeBS =##class(JHIPV5.JHREG.BS.SubPubBS).%New()
	Set Request=##class(JHIPLIB.Util.MSG.JHRequestMsg).%New()
	Do %response.SetHeader("Content-Type", "application/json;charset=UTF-8")
	Try{
		Set content=""
	    Set tSC=##class(Ens.Director).CreateBusinessService("订阅发布分派BS",.SubscribeBS)
		Set Request.action=Method
		Set:$L(%request.Content)'=0 content=$zcvt(%request.Content.Read(),"I","UTF8")
	 	Set tSC=Request.pArg.Insert(content) 
	   	Set tSC1=SubscribeBS.SubscriptioPublication("消息监控分发BP",Request,.out)
	   	set message=out.StringValue
	}Catch(e){
		Set message="{""code"":500,""data"":"""",""success"":0,""msg"":""操作失败""}"
	}
    w $zcvt(message,"O","UTF8")
    Quit $$$OK
}

/// 运行监控
ClassMethod OperationMonitor(Method As %String) As %Status
{
	Set SubscribeBS =##class(JHIPV5.JHREG.BS.SubPubBS).%New()
	Set Request=##class(JHIPLIB.Util.MSG.JHRequestMsg).%New()
	Do %response.SetHeader("Content-Type", "application/json;charset=UTF-8")
	Try{
		Set content=""
	    Set tSC=##class(Ens.Director).CreateBusinessService("订阅发布分派BS",.SubscribeBS)
		Set Request.action=Method
		Set:$L(%request.Content)'=0 content=$zcvt(%request.Content.Read(),"I","UTF8")
	 	Set tSC=Request.pArg.Insert(content) 
	   	Set tSC1=SubscribeBS.SubscriptioPublication("运行监控分发BP",Request,.out)
	   	set message=out.StringValue
	}Catch(e){
		Set message="{""code"":500,""data"":"""",""success"":0,""msg"":""操作失败""}"
	}
    w $zcvt(message,"O","UTF8")
    Quit $$$OK
}

/// 结构管理
ClassMethod StructureManagement(Method As %String) As %Status
{
	Set SubscribeBS =##class(JHIPV5.JHREG.BS.SubPubBS).%New()
	Set Request=##class(JHIPLIB.Util.MSG.JHRequestMsg).%New()
	Do %response.SetHeader("Content-Type", "application/json;charset=UTF-8")

		if (Method="xmlImport"){
		
			Set content=%request.MimeData("file",1)
			set Target="结构管理上传所选文件BO"
		
			set type=%request.Data("Type",1)
	     	Do content.SetAttribute("type",type)
	     
			Set tSC=##class(Ens.Director).CreateBusinessService("订阅发布分派BS",.SubscribeBS)
	
	        //Set content=$zcvt(%request.Content.Read(),"I","UTF8")
	 
	   	    Set tSC1=SubscribeBS.SubscriptioPublicationFile(Target,content,.out)
	   	
			//w Request.pArg.GetAt(1).Read()
	    }else{
		    Set content=$zcvt(%request.Content.Read(),"I","UTF8")
			set Target="结构管理分发BP"
		    Set tSC=Request.pArg.Insert(content) 
		    Set Request.action=Method
		    Set tSC=##class(Ens.Director).CreateBusinessService("订阅发布分派BS",.SubscribeBS)
	
	    //Set content=$zcvt(%request.Content.Read(),"I","UTF8")
	 
	   	Set tSC1=SubscribeBS.SubscriptioPublication(Target,Request,.out)
		 }
	
	   	set message=out.StringValue
	
    w $zcvt(message,"O","UTF8")
    Quit $$$OK
}

/// 主题管理
ClassMethod ThemeManagement(Method As %String) As %Status
{
	Set SubscribeBS =##class(JHIPV5.JHREG.BS.SubPubBS).%New()
	Set Request=##class(JHIPLIB.Util.MSG.JHRequestMsg).%New()
	Do %response.SetHeader("Content-Type", "application/json;charset=UTF-8")
	Try{
		Set content=""
	    Set tSC=##class(Ens.Director).CreateBusinessService("订阅发布分派BS",.SubscribeBS)
		Set Request.action=Method
		Set:$L(%request.Content)'=0 content=$zcvt(%request.Content.Read(),"I","UTF8")
	 	Set tSC=Request.pArg.Insert(content) 
	   	Set tSC1=SubscribeBS.SubscriptioPublication("主题管理分发BP",Request,.out)
	   	set message=out.StringValue
	}Catch(e){
		Set message="{""code"":500,""data"":"""",""success"":0,""msg"":""操作失败""}"
	}
    w $zcvt(message,"O","UTF8")
    Quit $$$OK
}

/// 订户管理
ClassMethod SubscriberManagement(Method As %String) As %Status
{
	Set SubscribeBS =##class(JHIPV5.JHREG.BS.SubPubBS).%New()
	Set Request=##class(JHIPLIB.Util.MSG.JHRequestMsg).%New()
	Do %response.SetHeader("Content-Type", "application/json;charset=UTF-8")
	Try{
		Set content=""
	    Set tSC=##class(Ens.Director).CreateBusinessService("订阅发布分派BS",.SubscribeBS)
		Set Request.action=Method
		Set:$L(%request.Content)'=0 content=$zcvt(%request.Content.Read(),"I","UTF8")
	 	Set tSC=Request.pArg.Insert(content) 
	   	Set tSC1=SubscribeBS.SubscriptioPublication("订户管理分发BP",Request,.out)
	   	set message=out.StringValue
	}Catch(e){
		Set message="{""code"":500,""data"":"""",""success"":0,""msg"":""操作失败了！""}"
	}
    w $zcvt(message,"O","UTF8")
    Quit $$$OK
}

/// 规则转换
ClassMethod RuleTranslation(Method As %String) As %Status
{
	Set SubscribeBS =##class(JHIPV5.JHREG.BS.SubPubBS).%New()
	Set Request=##class(JHIPLIB.Util.MSG.JHRequestMsg).%New()
	Do %response.SetHeader("Content-Type", "application/json;charset=UTF-8")
	
		
		if (Method="getXsltDetail"){
			Set content=%request.MimeData("file",1)
			set filename=content.FileName
			//set message=content.Read()
			set result=##class(%DynamicObject).%New()
		
			set result.code=200
			set result.data=content.Read()
			set result.success=1
			set result.msg=""
			
			set message=$zcvt(result.%ToJSON(),"I","UTF8")
			}else{
				
		/*if (Method="addXslt"){
			

			
			
			
			Set content=%request.MimeData("file",1)
			set filename=content.FileName
			set data=%request.Data("data",1)
			w data
			set a1=##class(%DynamicObject).%New()
			set a1=a1.%FromJSON(data)
			
			set iter=a1.%GetIterator()
			
			while iter.%GetNext(.key, .value){
			
			Do content.SetAttribute(key,value)
		    }
		    w content
	     	//Do content.SetAttribute("wwww",data)
	     	Do content.SetAttribute("action",Method)
			set Target="规则转换添加xslt文件BO"
	        Set tSC=##class(Ens.Director).CreateBusinessService("订阅发布分派BS",.SubscribeBS)
	        //Set content=$zcvt(%request.Content.Read(),"I","UTF8")
	       	Set tSC1=SubscribeBS.SubscriptioPublicationFile(Target,content,.out)   
	       	w tSC1
	       	set message=out.StringValue
	      }else{*/
		  Set tSC=##class(Ens.Director).CreateBusinessService("订阅发布分派BS",.SubscribeBS)
		  Set Request.action=Method
		//W %request.Content.Read()
	     Set content=$zcvt(%request.Content.Read(),"I","UTF8")
	     
	 	  Set tSC=Request.pArg.Insert(content) 
	 
     
	   	   Set tSC1=SubscribeBS.SubscriptioPublication("规则转换分发BP",Request,.out)
      
	    	set message=out.StringValue
		      
		   } 
		    
		// }
	    
	   

    w $zcvt(message,"O","UTF8")
    Quit $$$OK
}

}
