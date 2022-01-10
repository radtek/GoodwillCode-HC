/// Classname 
/// Summary   jhipv5 订阅关系初始化
/// Version   1.0
/// Date      2021年11月12日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.SubRelationship.initialization Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{

	        set RESULT=##class(%DynamicArray).%New()
	        //set RESULTArray=##class(%DynamicArray).%New()
            set NameSpaceID=666
         
        	Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(NameSpaceID)
	
            DO ..Adapter.DSNSet(GetDSN)
            
           
             //
	     	 Set SqlName="call JHIPV5_JH503UTIL_SubRelation.SubRelationUtil_initialization()"
	     	 
	         Set tSC=..Adapter.ExecuteQuery(.tResult,SqlName)
	         $$$TRACE(tSC)
		     while tResult.%Next(){
			     $$$TRACE("???")
			   //Set name = $REPLACE($E(tResult.%Get("Name"),16,*-1),"""","")
		      // Do RESULT.%Push(name)
		       set Name=tResult.%Get("Name")
		       set className=tResult.%Get("FilesName")
		       set boName=tResult.%Get("Sub")
		       set openStatus=tResult.%Get("openStatus")
		       set Category=tResult.%Get("Category")
		        set bsName=tResult.%Get("Pub")
		       $$$TRACE(Name_className_boName_openStatus_Category)
		       &sql(insert into JHIPV5_JHREG_DB.SupRelation (Name,className,ifInitialization,boName,nameSpaceId,openStatus,Category,bsId) values(:Name,:className,1,:boName,:NameSpaceID,:openStatus,:Category,:bsName))
	       
	         }
	       
	         

	 Set Result   =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	 Set pResponse=##class(Ens.StringResponse).%New()
	 Set pResponse.StringValue=Result.TResult("初始化完成") 
     Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="JHIPLIB.Util.MSG.JHRequestMsg"> 
		<Method>InvokeHDR</Method>
	</MapItem>
</MapItems>
}

}
