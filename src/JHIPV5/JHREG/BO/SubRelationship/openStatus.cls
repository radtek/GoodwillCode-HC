/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年11月12日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.SubRelationship.openStatus Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method OnMessage(pRequest As Ens.StringRequest, Output pResponse As Ens.StringResponse) As %Status
{
	TRY{
	SET a1=pRequest.StringValue  //传入json json转object
	set bpArray=##class(%DynamicObject).%New()
	set bpArray= bpArray.%FromJSON(a1)
	//
	set id=bpArray.id
	set status=bpArray.status
	SET NAME=bpArray.bpName

	//获取productionname
	 //&sql(select Name into :productionName from Ens_Config.Production where id not like '%PKG.FoundationProduction%' )
     Set tSC = ##class(Ens.Director).GetProductionStatus(.productionName,.tState,,1)
     Set production = ##class(Ens.Config.Production).%OpenId(productionName)
     SET ITEM= production.Items
	 for i=1:1:ITEM.Count(){
	   if (ITEM.GetAt(i).Name=NAME){
        set ITEM.GetAt(i).Enabled=status
       }	  
	  }   
	  set production.Items=ITEM
	  Set tSC = production.%Save()
	  Set tSC = production.SaveToClass()
	  Do $System.OBJ.Compile(productionName)

	  Set pResponse=##class(Ens.StringResponse).%New()
	Set pResponse.StringValue="1"
	}CATCH(E){
	Set pResponse=##class(Ens.StringResponse).%New()
	Set pResponse.StringValue=E
	}
  Quit $$$OK
}

}
