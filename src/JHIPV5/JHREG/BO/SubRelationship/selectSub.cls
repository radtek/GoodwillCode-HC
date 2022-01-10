/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年11月16日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.SubRelationship.selectSub Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method OnMessage(pRequest As Ens.StringRequest, Output pResponse As Ens.StringResponse) As %Status
{
	//获取订阅关系表格  

		set a1=pRequest.StringValue
	    set bpArray=##class(%DynamicObject).%New()
	    set bpArray= bpArray.%FromJSON(a1)
	    SET RESULT=##class(%DynamicArray).%New()
	    set tDiagram=##class(Ens.BPL.UI.Diagram).%New()
        Set tStatus = ##class(Ens.BPL.UI.Diagram).Open(bpArray.bpName,.tDiagram)	
        SET A3=tDiagram //读取的
        SET A2=tDiagram.ShapeList
        set num=A2.Count()
        set i=0
        for i=1:1:num{
	      if (A2.GetAt(i).Type="call"){
		      set resultOb=##class(%DynamicObject).%New()
		      set resultOb.Sub=A2.GetAt(i).PropertyBag.GetAt("Target")
		      set resultOb.Status=A2.GetAt(i).PropertyBag.GetAt("Async")
		      Do RESULT.%Push(resultOb)   
	      }  
	    }
	    Set pResponse=##class(Ens.StringResponse).%New()
	    Set pResponse.StringValue=$ZCVT(RESULT.%ToJSON(),"O","UTF8")
	
	  Quit $$$OK
}

}
