/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年12月20日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.RuleTranslation.addXsltBO1 Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As %CSP.BinaryStream, Output pResponse As Ens.StringResponse) As %Status
{
	$$$TRACE("1234")
    Set request =pRequest.GetAttribute("action")
	//set input=##class(%DynamicObject).%New()
	//set input= input.%FromJSON(request)
	set NameSpaceId=pRequest.GetAttribute("nameSpaceId")
	Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(NameSpaceId)
	
    DO ..Adapter.DSNSet(GetDSN)
	Set method=pRequest.GetAttribute("action"),OperationFileTIME=$TRanslate($ZDT($H,3),"-,:, ")
	
	
	
	If method="addXslt"{
	   
		//Set pOutput=##class(Ens.StringResponse).%New()
		Set FileName=pRequest.FileName
		Set FileBody=pRequest.Read()
		SET RuleName=pRequest.GetAttribute("RuleName")
        set SourceStandard=pRequest.GetAttribute("SourceStandard")
        set TargetStandard=pRequest.GetAttribute("TargetStandard")
		//用于判断待插入的数据是否已经存在
		Set nFileName=""
		
		 Set SqlName="SELECT count(1) as NUM1  FROM JHIPLIB_Util_Save_DB.SaveDB WHERE FileName='"_FileName_"'"
	     Set tSC=..Adapter.ExecuteQuery(.tResult,SqlName)
		 while tResult.%Next(){
			set nFileName=tResult.%Get("NUM1")
	         

	     }
	     	If nFileName=0{
		     //Set SqlName2="INSERT INTO JHIPLIB_Util_Save_DB.SaveDB (FileName,FileBody,FileType) VALUES('1','2','4')"
		    
			Set SqlName2="INSERT INTO JHIPLIB_Util_Save_DB.SaveDB (FileName,FileBody,OperationFileTIME,FileType) VALUES ('"_FileName_"','"_FileBody_"','"_OperationFileTIME_"','INSERT')"
			
			
			Set tSC2=..Adapter.ExecuteUpdateParmArray(.tResult2,SqlName2)
		
			if (tSC2){
			  &sql(insert into JHIPV5_JHREG_DB.RuleTranslationDB (RuleName,RuleType,SourceStandard,TargetStandard,nameSpaceId,FilesName) values(:RuleName,'XSLT',:SourceStandard,:TargetStandard,:NameSpaceId,:FileName))
			} 
			//Set pOutput.ResultCode="AA"
			//Set pOutput.ResultContent="添加成功 :"_FileBody
		}else{
			//Set pOutput.ResultCode="AE"
			//Set pOutput.ResultContent="重复插入，添加失败 :"_FileBody
			}
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
	Quit $$$OK
	  Set pResponse=##class(Ens.StringResponse).%New()
	  Set pResponse.StringValue=Result.TResult("123")
	  Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="%CSP.BinaryStream"> 
		<Method>InvokeHDR</Method>
	</MapItem>
</MapItems>
}

}
