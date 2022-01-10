/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年12月20日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.RuleTranslation.addXsltBO Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	
    Set request =pRequest.pArg.GetAt(1)
	set input=##class(%DynamicObject).%New()
	set input= input.%FromJSON(pRequest.pArg.GetAt(1))
    set NameSpaceId=input.NameSpaceId
   	set time=$zdt($h,3)
   
	Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(NameSpaceId)
	
    DO ..Adapter.DSNSet(GetDSN)
	Set method=pRequest.action,OperationFileTIME=$TRanslate($ZDT($H,3),"-,:, ")
	
	 Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	
	If method="addXslt"{
	   
		//Set pOutput=##class(Ens.StringResponse).%New()
		Set FileName=input.RuleName
		Set FileBody=input.FileBody
		SET RuleName=input.RuleName
        set SourceStandard=input.SourceMessage
        set TargetStandard=input.TargetMessage
        
        
     set SourceStandName=$p(SourceStandard,":",1)
    set TargetStandName=$p(TargetStandard,":",1)
    set SourceDocType=$p(SourceStandard,":",2)
    set TargetDocType=$p(TargetStandard,":",2)
        
		//用于判断待插入的数据是否已经存在
		Set nFileName=""
		
    &sql(select count(1) into :Num from JHIPV5_JHREG_DB.RuleTranslationDB where RuleName=:RuleName and NameSpaceId =:NameSpaceId )
     if (Num){
	  	Set pResponse=##class(Ens.StringResponse).%New()
	    Set pResponse.StringValue=Result.Result("400","",1,"该域下已存在同名规则，请重新填写")   
	    Quit $$$OK   
	 }
	     
		     //Set SqlName2="INSERT INTO JHIPLIB_Util_Save_DB.SaveDB (FileName,FileBody,FileType) VALUES('1','2','4')"
		    
			Set SqlName2="INSERT INTO JHIPLIB_Util_Save_DB.SaveDB (FileName,FileBody,OperationFileTIME,FileType) VALUES ('"_FileName_"',?,'"_OperationFileTIME_"','INSERT')"
			//&sql(INSERT INTO JHIPLIB_Util_Save_DB.SaveDB (FileName,FileBody,OperationFileTIME,FileType) VALUES (:FileName,:FileBody,:OperationFileTIME,'INSERT'))
			 &sql(select ID into :SourceID from JHIPV5_JHREG_DB.StructureManagement where NameSpaceID =:NameSpaceId and StandardName = :SourceStandName)
             &sql(select ID into :TargetID from JHIPV5_JHREG_DB.StructureManagement where NameSpaceID =:NameSpaceId and StandardName = :TargetStandName)
          
			Set tSC2=..Adapter.ExecuteUpdate(.tResult2,SqlName2,FileBody)
	
			if (tSC2){
				$$$TRACE(RuleName_",'XSLT',"_SourceStandard_","_TargetStandard_","_NameSpaceId_","_RuleName_","_SourceID_","_TargetID)
				&sql(insert into JHIPV5_JHREG_DB.RuleTranslationDB (RuleName,RuleType,SourceStandardMessage,TargetStandardMessage,nameSpaceId,FilesName,SourceStandard,TargetStandard,OperaTime) values(:RuleName,'XSLT',:SourceStandard,:TargetStandard,:NameSpaceId,:RuleName,:SourceID,:TargetID,:time))
	
				
	  Set pResponse=##class(Ens.StringResponse).%New()
	  Set pResponse.StringValue=Result.TResult("添加成功")
			  //&sql(insert into JHIPV5_JHREG_DB.RuleTranslationDB (RuleName,RuleType,SourceStandard,TargetStandard,nameSpaceId,FilesName) values(:RuleName,'XSLT',:SourceStandard,:TargetStandard,:NameSpaceId,:FileName))
			} else{
					Set pResponse=##class(Ens.StringResponse).%New()
	    Set pResponse.StringValue=Result.Result("400","",1,"添加失败")   
	    Quit $$$OK 
				
				}
			//Set pOutput.ResultCode="AA"
			//Set pOutput.ResultContent="添加成功 :"_FileBody
		
		//&Sql(SELECT FileName INTO :nFileName FROM JHIPLIB_Util_Save_DB.SaveDB WHERE FileName=:FileName)

	}ElseIf method="Update"{
		Set pOutput=##class(JHIPLIB.Util.MSG.JHResposeMsg).%New()
		Set FileName=pInput.FileName
		Set FileBody=pInput.FileBody
		//用于判断待插入的数据是否已经存在
		Set count=""
		&Sql(SELECT count(1) INTO :count FROM JHIPLIB_Util_Save_DB.SaveDB WHERE FileName=:FileName)
		If count'=0{
			&Sql(UPDATE JHIPLIB_Util_Save_DB.SaveDB SET FileName=:FileName,FileBody=:FileBody ,OperationFileTIME=:OperationFileTIME ,FileType=:method WHERE FileName=:FileName) 
			Set pOutput.ResultCode="AA"
			Set pOutput.ResultContent="修改成功"_FileBody
		}else{
			Set pOutput.ResultCode="AE"
			Set pOutput.ResultContent="xsl不存在，修改失败 :"_FileName
			}
	}ElseIf method="Delete"{
		Set pOutput=##class(JHIPLIB.Util.MSG.JHResposeMsg).%New()
		Set FileName=pInput.FileName
		Try{
			&Sql(DELETE FROM JHIPLIB_Util_Save_DB.SaveDB WHERE FileName=:FileName)
			Set pOutput.ResultCode="AA"
			Set pOutput.ResultContent="删除成功"	
		}Catch{
			Set pOutput.ResultCode="AE"
			Set pOutput.ResultContent="操作失败xsl:"_FileName_"不存在"
		}	
	}ElseIf method="Query"{
		$$$TRACE("进入查询")
		Set pOutput=##class(JHIPLIB.Util.MSG.JHResposeMsg).%New()
		Set FileName=pInput.FileName
		Try{
			&Sql(SELECT FileBody INTO :FileBody FROM JHIPLIB_Util_Save_DB.SaveDB WHERE FileName=:FileName)
			Set pOutput.ResultCode="AA"
			Set pOutput.ResultContent=FileBody
		}Catch{
			Set pOutput.ResultCode="AE"
			Set pOutput.ResultContent="操作失败xsl:"_FileName_"不存在"
		}		
	}else{
		Set pOutput=##class(JHIPLIB.Util.MSG.JHResposeMsg).%New()
		Set pOutput.ResultCode="AE"
		Set pOutput.ResultContent=method_"方法不存在！！请按Insert，Delete，Update，Query输入方法名称！！"
		}
		 DO ..Adapter.Disconnect()

	  
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
