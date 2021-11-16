/// Classname JHIPLIB.SOAP.Operation.SOAPOperation<br>
/// Summary   数据库存储操作工具类，可操作CACHE中存储的消息<br>
/// Version   1.0<br>
/// Date      2019年01月21日 15:00<br>
/// Author    马家齐<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.Util.Save.BO.SaveOperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method OnMessage(pInput As JHIPLIB.Util.Save.MSG.SaveMSG, Output pOutput As JHIPLIB.Util.MSG.JHResposeMsg) As %Status
{
	
	Set method=pInput.MethodName,OperationFileTIME=$TRanslate($ZDT($H,3),"-,:, ")
	If method="Insert"{
		Set pOutput=##class(JHIPLIB.Util.MSG.JHResposeMsg).%New()
		Set FileName=pInput.FileName
		Set FileBody=pInput.FileBody
		//用于判断待插入的数据是否已经存在
		Set nFileName=""
		&Sql(SELECT FileName INTO :nFileName FROM JHIPLIB_Util_Save_DB.SaveDB WHERE FileName=:FileName)
		If nFileName=""{
			
			&Sql(INSERT INTO JHIPLIB_Util_Save_DB.SaveDB (FileName,FileBody,OperationFileTIME,FileType) VALUES (:FileName,:FileBody,:OperationFileTIME,:method))
			Set pOutput.ResultCode="AA"
			Set pOutput.ResultContent="添加成功 :"_FileName
		}else{
			Set pOutput.ResultCode="AE"
			Set pOutput.ResultContent="重复插入，添加失败 :"_FileName
			}
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
			Set pOutput.ResultContent="修改成功"_FileName
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
}

}
