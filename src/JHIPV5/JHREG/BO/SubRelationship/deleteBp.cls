/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年11月12日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.SubRelationship.deleteBp Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method OnMessage(pRequest As Ens.StringRequest, Output pResponse As Ens.StringResponse) As %Status
{
   
      set a1=pRequest.StringValue
	  set bpArray1=##class(%DynamicObject).%New()
	  set bpArray1= bpArray1.%FromJSON(a1)
	  set bpArray=##class(%DynamicObject).%New()
	  set iter = bpArray1.bsName.%GetIterator()
	  Set tSC = ##class(Ens.Director).GetProductionStatus(.productionName,.tState,,1)
	  Set production = ##class(Ens.Config.Production).%OpenId(productionName)
	  SET ITEM= production.Items
	  set num=ITEM.Count()
	  Set production1 = ##class(Ens.Config.Production).%New()
	  SET ITEM1= production1.Items
      while iter.%GetNext(.key, .value) {
	 
       set name1=value
     
      //&sql(select Name into :productionName from Ens_Config.Production where id not like '%PKG.FoundationProduction%' )
      for i=1:1:num{      
	    if (ITEM.GetAt(i)){
		     
		         if (ITEM.GetAt(i).Name=name1){
		        
		        //set ITEM.GetAt(i)=0
		        
		  
		        
		        Do $System.OBJ.Delete(ITEM.GetAt(i).ClassName,"-d")
                Do $System.OBJ.Delete(ITEM.GetAt(i).ClassName_".V1.Context","-d")
                Do $System.OBJ.Delete(ITEM.GetAt(i).ClassName_".V1.Thread1","-d")
                Do ITEM.RemoveAt(i)
      	        set i=i+num
	        }
		 }
	 }   
     
     //调用方法去创建
	 //s tSC=##class("JHIPV5.JHREG.Util.bptCreatuUtil").a1(tProxy,1)   //0 新建 1 编辑
	 //Do $System.OBJ.Compile(productionName)

	 }
	
	  for i=1:1:num{
	    if (ITEM.GetAt(i)){
		     
      	      Do ITEM1.Insert(ITEM.GetAt(i))	
		 }
	 
	 } 	  
	 set production.Items=ITEM1
	 Set tSC = production.%Save()
	 Set tSC = production.SaveToClass()
	 Do $System.OBJ.Compile(productionName)
     Set pResponse=##class(Ens.StringResponse).%New()
	 Set pResponse.StringValue="1"
	
  Quit $$$OK
}

}
