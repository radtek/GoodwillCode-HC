/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年11月16日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.RuleTranslation.editRuleBO Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method bpSelect(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	
    set time=$zdt($h,3)
    Set request =pRequest.pArg.GetAt(1)
	set input=##class(%DynamicObject).%New()
	set input= input.%FromJSON(pRequest.pArg.GetAt(1))
	Set ID=input.ID   

	
	&sql(select nameSpaceId,RuleName,RuleType,FilesName into :NameSpaceId,:oldRuleName,:RuleType,:oldFilesName from JHIPV5_JHREG_DB.RuleTranslationDB where ID =:ID)
    //set NameSpaceId=input.NameSpaceId
	Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(NameSpaceId)
    DO ..Adapter.DSNSet(GetDSN)
	Set method=pRequest.action,OperationFileTIME=$TRanslate($ZDT($H,3),"-,:, ")

    //set FileBody=input.FileBody
    SET RuleName=input.RuleName
    set SourceMessage=input.SourceMessage
    set TargetMessage=input.TargetMessage
    //&sql(select RuleName,RuleType into :FilesName,:RuleType from JHIPV5_JHREG_DB.RuleTranslationDB where ID = :ID)
   set SourceStandName=$p(SourceMessage,":",1)
    set TargetStandName=$p(TargetMessage,":",1)
    set SourceDocType=$p(SourceMessage,":",2)
    set TargetDocType=$p(TargetMessage,":",2)
    &sql(select StandardType,ID into :SourceStandard,:SourceID from JHIPV5_JHREG_DB.StructureManagement where NameSpaceID =:NameSpaceId and StandardName = :SourceStandName)
    &sql(select StandardType,ID into :TargetStandard,:TargetID from JHIPV5_JHREG_DB.StructureManagement where NameSpaceID =:NameSpaceId and StandardName = :TargetStandName)
 
    if (RuleType="XSLT"){
	   Set FileBody=input.FileBody
	   Set SqlName="UPDATE JHIPLIB_Util_Save_DB.SaveDB SET FileBody=?,FileName='"_RuleName_"' ,OperationFileTIME='"_OperationFileTIME_"' ,FileType='UPDATE' WHERE FileName='"_oldRuleName_"'"
    	Set tSC=..Adapter.ExecuteUpdate(.tResult,SqlName,FileBody)
	}ELSEIF(RuleType="DT"){
	   


	   
	   

	   
   //set FilesName=input.RuleName
   
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
	   
	   
	   
	    Set SqlName=" call JHIPV5_JH503UTIL_RuleTranslation.RuleTranslationUtil_AddRule('"_oldFilesName_"','','"_SourceStandard_"','"_SourceMessage_"','"_TargetStandard_"','"_TargetMessage_"')"
    
	   //Set SqlName="call HIPPtest_BO.RemoteConnection_License('JHIPW."_oldRuleName_"','"_des_"','"_SourceStandard_"','"_SourceDocType_"','"_TargetStandard_"','"_TargetDocType_"')"
	   Set tSC=..Adapter.ExecuteQuery(.tResult,SqlName)

		
    }
    
 
	if (tSC){
		 set SourceStandName=$p(SourceStandard,":",1)
         set TargetStandName=$p(TargetStandard,":",1)
		&sql(select ID into :SourceID from JHIPV5_JHREG_DB.StructureManagement where NameSpaceID =:NameSpaceId and StandardName = :SourceStandName)
        &sql(select ID into :TargetID from JHIPV5_JHREG_DB.StructureManagement where NameSpaceID =:NameSpaceId and StandardName = :TargetStandName)
        &sql(UPDATE JHIPV5_JHREG_DB.RuleTranslationDB SET RuleName=:RuleName,RuleType=:RuleType,SourceStandard=:SourceID,TargetStandard=:TargetID,SourceStandardMessage=:SourceMessage,TargetStandardMessage=:TargetMessage,OperaTime=:time WHERE ID = :ID)
	}
	 Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
   	  Set pResponse=##class(Ens.StringResponse).%New()
	  Set pResponse.StringValue=Result.TResult("修改成功")
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
