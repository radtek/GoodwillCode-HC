/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年11月12日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.SubRelationship.EditBp Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method OnMessage(pRequest As Ens.StringRequest, Output pResponse As Ens.StringResponse) As %Status
{
   

	set a1=pRequest.StringValue
	set bpArray=##class(%DynamicObject).%New()
	set bpArray= bpArray.%FromJSON(a1)
   set iterBo = bpArray.boName.%GetIterator()

	
	//
	
     
	  set tDiagram=##class(Ens.BPL.UI.Diagram).%New()
      Set tStatus = ##class(Ens.BPL.UI.Diagram).Open(bpArray.bsID,.tDiagram)
     
      SET A3=tDiagram //读取的
      Set tProxy = ##class(%ZEN.proxyObject).%New()
      Set tProxy.BPLClass=bpArray.bsID ////class名包括前面的包
      Set tProxy.Name=bpArray.bpName
      Set tProxy.Width=3000    //长宽 后面算
      Set tProxy.Height=2000  //
      Set tProxy.Layout=A3.Layout //布局?
    
      Set tProxy.Language=A3.Language
      Set tProxy.Request=A3.Request
      Set tProxy.Response=A3.Response
      Set tProxy.LastModified=A3.LastModified  ///上次时间？
      Set tProxy.Version=A3.Version  ///版本
      Set tProxy.Includes=A3.Includes ///？？？包括文件的可选列表
      Set tProxy.Annotation=A3.Annotation  
      Set tProxy.ContextSuperClass=A3.ContextSuperClass  ///？
    
      Set tProxy.Timestamp="2021/11/12"   //当前时间
      Set tProxy.ReadOnly=A3.ReadOnly  //只读
	  Set tProxy.Annotation=A3.Annotation ////注释
	 
	  set tProxy.ShowAnnotation=A3.ShowAnnotation
	  set tProxy.HasErrors=A3.HasErrors
	  set tProxy.Component=A3.Component
	 

       set tProxy.Context=A3.Context
       
         set mylist=##class(%ListOfDataTypes).%New()

       ///tProxyShapeList  bp里面的活动块 可循环  至少需要start和end

      set a1=##class(%DynamicArray).%New()
       
       
       
       set result= ##class(%DynamicObject).%New()
       set status=..creatStart(1,"","",.result)
       Do a1.%Push(result)
      set result2= ##class(%DynamicObject).%New()
       set status=..creatFlow(2,"",.result2)
       Do a1.%Push(result2)
      

       set result8= ##class(%DynamicObject).%New()
       set status=..creatJoin(3,"",.result8)
       Do a1.%Push(result8)
       set result7= ##class(%DynamicObject).%New()
       set status=..creatEnd(4,"","",.result7)
       Do a1.%Push(result7)
       	set mylistCC=##class(%ListOfDataTypes).%New()
        set CC=##class(%DynamicArray).%New()
        set STATUS=..creatConnect(1,2,.tProxyConnectors)
        Do CC.%Push(tProxyConnectors)
        set STATUS=..creatConnect(3,4,.tProxyConnectors)
        Do CC.%Push(tProxyConnectors)
        set i=5
        while iterBo.%GetNext(.key, .value) { 
     
       set result3= ##class(%DynamicObject).%New()
       set status=..creatSequence(i,value.id,.result3)
       Do a1.%Push(result3)
       
       set STATUS=..creatConnect(2,i,.tProxyConnectors)
        Do CC.%Push(tProxyConnectors)
       
       set STATUS=..creatConnect(i,3,.tProxyConnectors)
        Do CC.%Push(tProxyConnectors)
       
       set result9= ##class(%DynamicObject).%New()
       set status=..creatStart(i+1,i,"",.result9)
       Do a1.%Push(result9)
 
       
       set result9= ##class(%DynamicObject).%New()
       set codeDetailtsc=..CodeDetail(value.transRules,value.transRulesType,.codeDetail)
      
       set status=..creatCode(i+2,i,codeDetail,.result9)
       Do a1.%Push(result9)
        set STATUS=..creatConnect(i+1,i+2,.tProxyConnectors)
        Do CC.%Push(tProxyConnectors)
       set result9= ##class(%DynamicObject).%New()
       set status=..creatCall(i+3,i,value,.result9)
       Do a1.%Push(result9)
        set STATUS=..creatConnect(i+2,i+3,.tProxyConnectors)
        Do CC.%Push(tProxyConnectors)
       set result10= ##class(%DynamicObject).%New()
       set status=..creatEnd(i+4,i,"",.result10)
       Do a1.%Push(result3)
       set STATUS=..creatConnect(i+3,i+4,.tProxyConnectors)
        Do CC.%Push(tProxyConnectors)
        
        
        set i=i+5
        }
        
         set iter = a1.%GetIterator()
        while iter.%GetNext(.key, .value) { 
          do mylist.Insert(value) 
        }
        Set tProxy.ShapeList=mylist
	   ///connect

       

       

        

        
        set iterCC = CC.%GetIterator()
         while iterCC.%GetNext(.key, .value) { 
         do mylistCC.Insert(value)
       }
       Set tProxy.Connectors=mylistCC
       
        

	 
	 
	 //调用方法去创建
	 
	  // &sql(select Name into :productionName from Ens_Config.Production where id not like '%PKG.FoundationProduction%' )
	 Set tSC = ##class(Ens.Director).GetProductionStatus(.productionName,.tState,,1)
	 
	 
	  s tSC=##class("JHIPV5.JH503UTIL.bptCreatuUtil").a1(tProxy,1)   //0 新建 1 编辑
	 Do $System.OBJ.Compile(productionName)
	
	
	 
	Set pResponse=##class(Ens.StringResponse).%New()
	Set pResponse.StringValue="1"
	

  Quit $$$OK
}

ClassMethod creatCall(index As %Numeric, parentindex As %Numeric, pRequest As %DynamicObject, ByRef pShapeIndex As %DynamicObject, Output pResponse As Ens.StringResponse) As %Status
{
	 
	
	   Set tProxyShapeList4 = ##class(%DynamicObject).%New() 
       set tProxyShapeList4.ParentShape=parentindex
       set tProxyShapeList4.Index=index
       set tProxyShapeList4.Name=pRequest.id
       set tProxyShapeList4.Type="call"
       set tProxyShapeList4.xPos=(index-1)*200
       set tProxyShapeList4.yPos=350
       set tProxyShapeList4.Annotation="1"
       set tProxyShapeList4.Disabled=0
       set tProxyShapeList4.Code=""
       Set tProxyTEMP3 = ##class(%ZEN.proxyObject).%New() ///为空
       set tProxyTEMP3.Async=pRequest.status
       set tProxyTEMP3.Target=pRequest.id
       set tProxyTEMP3.Timeout=""
       Set tProxyTEMP2 = ##class(%ZEN.proxyObject).%New() ///为空
       
       set tProxyShapeList4.PropertyBag=tProxyTEMP3
       set tProxyShapeList4.Parameters=tProxyTEMP2
       
       Set tProxyRequest = ##class(%ZEN.proxyObject).%New() ///为空
       Set tProxyRequest.Type ="Ens.Request"
        Set tProxyRequest.activityType ="Assign"
      
       
        Set tProxyTEMPActivities = ##class(%ZEN.proxyObject).%New() ///为空
        Set tProxyTEMPActivities.activityType="Assign"
        Set tProxyTEMPActivities.Name=""
         Set tProxyTEMPActivities.XPos=""
         Set tProxyTEMPActivities.YPos=""
          Set tProxyTEMPActivities.Annotation=""
          Set tProxyTEMPActivities.Disabled=0
          Set tProxyTEMPActivities.Property="callrequest"
         Set tProxyTEMPActivities.Value="request"
         Set tProxyTEMPActivities.Action="set"
          Set tProxyTEMPActivities.Key=""""""
         
       set tProxyActivities=##class(%ListOfDataTypes).%New()
      do tProxyActivities.Insert(tProxyTEMPActivities)
         
      //Do tProxyActivities.%Push(tProxyTEMPActivities)
       
       
       Set tProxyRequest.Activities =tProxyActivities
       
       
       
       set tProxyShapeList4.Request=tProxyRequest
       
        Set tProxyResponse = ##class(%ZEN.proxyObject).%New() ///为空
       Set tProxyResponse.Type ="Ens.Response"
         Set tProxyResponse.activityType ="Assign"
              
        Set tProxyTEMPActivities = ##class(%ZEN.proxyObject).%New() ///为空
        Set tProxyTEMPActivities.activityType="Assign"
        Set tProxyTEMPActivities.Name=""
         Set tProxyTEMPActivities.XPos=""
         Set tProxyTEMPActivities.YPos=""
          Set tProxyTEMPActivities.Annotation=""
          Set tProxyTEMPActivities.Disabled=0
          Set tProxyTEMPActivities.Property="response"
         Set tProxyTEMPActivities.Value="callresponse"
         Set tProxyTEMPActivities.Action="set"
          Set tProxyTEMPActivities.Key=""""""
         
       set tProxyActivities=##class(%ListOfDataTypes).%New()
      do tProxyActivities.Insert(tProxyTEMPActivities)
       
       Set tProxyResponse.Activities =tProxyActivities
       
       
       // Set tProxyActivities = ##class(%DynamicArray).%New() 
       //Set tProxyRequest.Activities =tProxyActivities
       set tProxyShapeList4.Response=tProxyResponse
       
	   SET pShapeIndex =tProxyShapeList4
	   Set pResponse=##class(Ens.StringResponse).%New()
	   Set pResponse.StringValue="2"
       Quit $$$OK
}

ClassMethod creatCode(index As %Numeric, parentindex As %Numeric, pRequest As %String, ByRef pShapeIndex As %DynamicObject, Output pResponse As Ens.StringResponse) As %Status
{
	 
	
	   Set tProxyShapeList4 = ##class(%DynamicObject).%New() 
       set tProxyShapeList4.ParentShape=parentindex
       set tProxyShapeList4.Index=index
       set tProxyShapeList4.Name=""
       set tProxyShapeList4.Type="code"
       set tProxyShapeList4.xPos=200
       set tProxyShapeList4.yPos=350
       set tProxyShapeList4.Annotation=""
       set tProxyShapeList4.Disabled=0
       set tProxyShapeList4.Code=pRequest
       Set tProxyTEMP3 = ##class(%ZEN.proxyObject).%New() ///为空
    
       Set tProxyTEMP2 = ##class(%ZEN.proxyObject).%New() ///为空
       
       set tProxyShapeList4.PropertyBag=tProxyTEMP3
       set tProxyShapeList4.Parameters=tProxyTEMP2
       
       Set tProxyRequest = ##class(%ZEN.proxyObject).%New() ///为空
       Set tProxyRequest.Type ="Ens.Request"
       // Set tProxyActivities = ##class(%DynamicArray).%New() 
       //Set tProxyRequest.Activities =tProxyActivities
       set tProxyShapeList4.Request=tProxyRequest
	   SET pShapeIndex =tProxyShapeList4
	   Set pResponse=##class(Ens.StringResponse).%New()
	   Set pResponse.StringValue="2"
       Quit $$$OK
}

ClassMethod creatStart(index As %Numeric, parentindex As %Numeric, pRequest As %String, ByRef pShapeIndex As %DynamicObject, Output pResponse As Ens.StringResponse) As %Status
{
	 
	
	   Set tProxyShapeList4 = ##class(%DynamicObject).%New() 
       set tProxyShapeList4.ParentShape=parentindex
       set tProxyShapeList4.Index=index
       set tProxyShapeList4.Name=""
       set tProxyShapeList4.Type="start"
       set tProxyShapeList4.xPos=200
       set tProxyShapeList4.yPos=150
       set tProxyShapeList4.Annotation=""
       set tProxyShapeList4.Disabled=0
       set tProxyShapeList4.Code="这里写code"
       Set tProxyTEMP3 = ##class(%ZEN.proxyObject).%New() ///为空
    
       Set tProxyTEMP2 = ##class(%ZEN.proxyObject).%New() ///为空
       
       set tProxyShapeList4.PropertyBag=tProxyTEMP3
       set tProxyShapeList4.Parameters=tProxyTEMP2


	   SET pShapeIndex =tProxyShapeList4
	   Set pResponse=##class(Ens.StringResponse).%New()
	   Set pResponse.StringValue="2"
       Quit $$$OK
}

ClassMethod creatEnd(index As %Numeric, parentindex As %Numeric, pRequest As %String, ByRef pShapeIndex As %DynamicObject, Output pResponse As Ens.StringResponse) As %Status
{
	 
	
	   Set tProxyShapeList4 = ##class(%DynamicObject).%New() 
       set tProxyShapeList4.ParentShape=parentindex
       set tProxyShapeList4.Index=index
       set tProxyShapeList4.Name=""
       set tProxyShapeList4.Type="end"
       set tProxyShapeList4.xPos=200
       set tProxyShapeList4.yPos=450
       set tProxyShapeList4.Annotation=""
       set tProxyShapeList4.Disabled=0
       set tProxyShapeList4.Code=""
       Set tProxyTEMP3 = ##class(%ZEN.proxyObject).%New() ///为空
    
       Set tProxyTEMP2 = ##class(%ZEN.proxyObject).%New() ///为空
       
       set tProxyShapeList4.PropertyBag=tProxyTEMP3
       set tProxyShapeList4.Parameters=tProxyTEMP2


	   SET pShapeIndex =tProxyShapeList4
	   Set pResponse=##class(Ens.StringResponse).%New()
	   Set pResponse.StringValue="2"
       Quit $$$OK
}

ClassMethod creatSequence(index As %Numeric, pRequest As %String, ByRef pShapeIndex As %DynamicObject, Output pResponse As Ens.StringResponse) As %Status
{
	 
	
	   Set tProxyShapeList4 = ##class(%DynamicObject).%New() 
       set tProxyShapeList4.ParentShape=""
       set tProxyShapeList4.Index=index
       set tProxyShapeList4.Name=pRequest
       set tProxyShapeList4.Type="sequence"
       set tProxyShapeList4.xPos=200
       set tProxyShapeList4.yPos=450
       set tProxyShapeList4.Annotation=""
       set tProxyShapeList4.Disabled=0
       set tProxyShapeList4.Code="这里写code"
       Set tProxyTEMP3 = ##class(%ZEN.proxyObject).%New() ///为空
    
       Set tProxyTEMP2 = ##class(%ZEN.proxyObject).%New() ///为空
       
       set tProxyShapeList4.PropertyBag=tProxyTEMP3
       set tProxyShapeList4.Parameters=tProxyTEMP2


	   SET pShapeIndex =tProxyShapeList4
	   Set pResponse=##class(Ens.StringResponse).%New()
	   Set pResponse.StringValue="2"
       Quit $$$OK
}

ClassMethod creatFlow(index As %Numeric, pRequest As %String, ByRef pShapeIndex As %DynamicObject, Output pResponse As Ens.StringResponse) As %Status
{
	 
	
	   Set tProxyShapeList4 = ##class(%DynamicObject).%New() 
       set tProxyShapeList4.ParentShape=""
       set tProxyShapeList4.Index=index
       set tProxyShapeList4.Name=""
       set tProxyShapeList4.Type="flow"
       set tProxyShapeList4.xPos=200
       set tProxyShapeList4.yPos=450
       set tProxyShapeList4.Annotation=""
       set tProxyShapeList4.Disabled=0
       set tProxyShapeList4.Code=""
       Set tProxyTEMP3 = ##class(%ZEN.proxyObject).%New() ///为空
    
       Set tProxyTEMP2 = ##class(%ZEN.proxyObject).%New() ///为空
       
       set tProxyShapeList4.PropertyBag=tProxyTEMP3
       set tProxyShapeList4.Parameters=tProxyTEMP2


	   SET pShapeIndex =tProxyShapeList4
	   Set pResponse=##class(Ens.StringResponse).%New()
	   Set pResponse.StringValue="2"
       Quit $$$OK
}

ClassMethod creatJoin(index As %Numeric, pRequest As %String, ByRef pShapeIndex As %DynamicObject, Output pResponse As Ens.StringResponse) As %Status
{
	 
	
	   Set tProxyShapeList4 = ##class(%DynamicObject).%New() 
       set tProxyShapeList4.ParentShape=""
       set tProxyShapeList4.Index=index
       set tProxyShapeList4.Name=""
       set tProxyShapeList4.Type="join"
       set tProxyShapeList4.xPos=200
       set tProxyShapeList4.yPos=500
       set tProxyShapeList4.Annotation=""
       set tProxyShapeList4.Disabled=0
       set tProxyShapeList4.Code=""
       Set tProxyTEMP3 = ##class(%ZEN.proxyObject).%New() ///为空
    
       Set tProxyTEMP2 = ##class(%ZEN.proxyObject).%New() ///为空
       
       set tProxyShapeList4.PropertyBag=tProxyTEMP3
       set tProxyShapeList4.Parameters=tProxyTEMP2


	   SET pShapeIndex =tProxyShapeList4
	   Set pResponse=##class(Ens.StringResponse).%New()
	   Set pResponse.StringValue="2"
       Quit $$$OK
}

ClassMethod creatConnect(fromindex As %Numeric, toindex As %Numeric, ByRef pShapeIndex As %DynamicObject, Output pResponse As Ens.StringResponse) As %Status
{
	 
	
	    Set tProxyConnectors = ##class(%DynamicObject).%New() 
        set tProxyConnectors.Type="connector"
        set tProxyConnectors.ConnectType=""
        set tProxyConnectors.Name=""
        set tProxyConnectors.Condition=""
        set tProxyConnectors.Disabled=0
        set tProxyConnectors.FromShape=fromindex
        set tProxyConnectors.ToShape=toindex
   

	   SET pShapeIndex =tProxyConnectors
	   Set pResponse=##class(Ens.StringResponse).%New()
	   Set pResponse.StringValue="2"
       Quit $$$OK
}

ClassMethod CodeDetail(code As %String, codeType As %String, ByRef codeDDetail As %String, Output pResponse As Ens.StringResponse) As %Status
{
	 
	  if (codeType="XSLT"){
		//这里插入xslt的code  
		  set codeDDetail="    //这里插入xslt的code "
		  
		}elseif (codeType="DT"){
			
			set codeDDetail="   // 这里插入dt的code "
	   }elseif (codeType=""){
			
			set codeDDetail="   // 这里没有code "
	   }


	   Set pResponse=##class(Ens.StringResponse).%New()
	   Set pResponse.StringValue=""
       Quit $$$OK
}

}
