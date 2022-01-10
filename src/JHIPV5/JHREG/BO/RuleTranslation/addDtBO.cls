/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年11月16日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.RuleTranslation.addDtBO Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method bpSelect(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	
	  
	 
	 
	set time=$H
    Set request =pRequest.pArg.GetAt(1)
	set input=##class(%DynamicObject).%New()
	set input= input.%FromJSON(pRequest.pArg.GetAt(1))
	set NameSpaceId=input.NameSpaceId
	Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(NameSpaceId)
   Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
    DO ..Adapter.DSNSet(GetDSN)
    set time=$zdt($h,3)
	//Set Status=rc.InstantiateQuery(.rs,"%SYSTEM.License","Summary") break:'Status
	
    SET RuleName=input.RuleName
    set SourceMessage=input.SourceMessage
    //set des=input.des
    set TargetMessage=input.TargetMessage
    set SourceStandName=$p(SourceMessage,":",1)
    set TargetStandName=$p(TargetMessage,":",1)
    set SourceDocType=$p(SourceMessage,":",2)
    set TargetDocType=$p(TargetMessage,":",2)
     &sql(select count(1) into :Num from JHIPV5_JHREG_DB.RuleTranslationDB where RuleName=:RuleName and NameSpaceId =:NameSpaceId )
     if (Num'=0){
	  	Set pResponse=##class(Ens.StringResponse).%New()
	    Set pResponse.StringValue=Result.Result("400","",1,"该域下已存在同名规则，请重新填写")   
	    Quit $$$OK   
	 }
    &sql(select StandardType,ID into :SourceStandard,:SourceID from JHIPV5_JHREG_DB.StructureManagement where NameSpaceID =:NameSpaceId and StandardName = :SourceStandName)
    &sql(select StandardType,ID into :TargetStandard,:TargetID from JHIPV5_JHREG_DB.StructureManagement where NameSpaceID =:NameSpaceId and StandardName = :TargetStandName)
    set FilesName="JHIPV5DT.DT"_$TRanslate($ZDT($H,3),"-,:, ")
   
    if (SourceStandard=2){
	    set SourceStandard="EnsLib.HL7.Message"
	}else {
		set SourceStandard="EnsLib.EDI.XML.Document"
    }
    if (TargetStandard=2){
	    set TargetStandard="EnsLib.HL7.Message"
	}else {
		set TargetStandard="EnsLib.EDI.XML.Document"
    }
    //set fileName="JHIPV5DT.DT"_$TRanslate($ZDT($H,3),"-,:, ")
    Set SqlName="call JHIPV5_JH503UTIL_RuleTranslation.RuleTranslationUtil_AddRule('"_FilesName_"','','"_SourceStandard_"','"_SourceMessage_"','"_TargetStandard_"','"_TargetMessage_"')"

    Set tSC=..Adapter.ExecuteQuery(.tResult,SqlName)

    if tResult.%Next(){
		set tsc=tResult.%Get("name")
		
	 }
	 if (tsc=""){
		&sql(insert into JHIPV5_JHREG_DB.RuleTranslationDB (RuleName,RuleType,SourceStandardMessage,TargetStandardMessage,nameSpaceId,FilesName,SourceStandard,TargetStandard,OperaTime) values(:RuleName,'DT',:SourceMessage,:TargetMessage,:NameSpaceId,:FilesName,:SourceID,:TargetID,:time))
	&sql(SELECT IpAdderss,NameSpace into :IpAdderss,:NameSpace FROM JHIPV5_JHREG_DB.DomainDB Where DomainID =:NameSpaceId) //
	set resultOb=##class(%DynamicObject).%New()
	set resultOb.ipAdress=IpAdderss  //虚拟ip
	set resultOb.DtName=FilesName
	set resultOb.NameSpaceName=NameSpace
	Set pResponse=##class(Ens.StringResponse).%New()
	Set pResponse.StringValue=Result.TResult(resultOb)	 
	}else{
    Set pResponse=##class(Ens.StringResponse).%New()
    Set pResponse.StringValue=Result.Result("400","",1,"添加失败")	 
	}

	Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="JHIPLIB.Util.MSG.JHRequestMsg"> 
		<Method>bpSelect</Method>
	</MapItem>
</MapItems>
}

}
