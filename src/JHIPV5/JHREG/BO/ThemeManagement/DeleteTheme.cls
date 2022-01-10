/// Summary   主题删除<br>
/// Version   1.0<br>
/// Date      2021年12月07日 10:15:39<br>
/// Author    LHX<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.ThemeManagement.DeleteTheme Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method RemoveItem(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set ResultJson =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(pRequest.pArg.GetAt(1))
	Set jsonObject = ##class(%DynamicObject).%New()
	Set pResponse = ##class(Ens.StringResponse).%New()
	Set tSC = $$$OK
	Try{
		Set array = json.%Get("array")
		Set production = "JHIPV5d3PKG.FoundationProduction"
		#Dim prodConf As Ens.Config.Production = ##class(Ens.Config.Production).%OpenId(production)
		set iter = array.%GetIterator() 
		while iter.%GetNext(.key , .value ) {
			Set ID = value.%Get("ID")
			Set ThemeCode = value.%Get("ThemeCode")
			Set ThemeName = value.%Get("ThemeName")
			Set Name = ThemeCode_ThemeName  
			Set sql="SELECT ID,bsId FROM JHIPV5_JHREG_DB.SupRelation "
			$$$LOGINFO(sql)
			Set qStatement = ##class(%SQL.Statement).%New()
			Set tSC = qStatement.%Prepare(.sql)
			#Dim tResult As %SQL.StatementResult = qStatement.execute()
			Set ams = "no"
			while (tResult.%Next()){
				Set bsId = tResult.%Get("bsId")
				If ID =bsId{
						Set ams = "ok"
						Set res = ResultJson.STResult("存在订阅关系，请先删除")
						;$$$LOGINFO(res)
						Quit 
					}
				}
			$$$LOGINFO(tSC)
			;$$$LOGINFO(tResult.%Get("bsId"))
			;$$$LOGINFO(bsId)
			$$$LOGINFO("2")
			If ams ="ok"{
				Set res = ResultJson.Result("400","","失败","存在订阅关系，请先删除")
				$$$LOGINFO(res)
				Quit 
				}else{
						Set sql="SELECT ID FROM Ens_Config.Item where Production = '"_production_"' and Name = '"_Name_"'"
						Set qStatement = ##class(%SQL.Statement).%New()
						Set tSC = qStatement.%Prepare(.sql)
						#Dim rtn As %SQL.StatementResult = qStatement.execute()
						While (rtn.%Next()){
						Set confItem = ##Class(Ens.Config.Item).%OpenId(rtn.%Get("ID"))
						}
						Set tSC = ##class(EnsPortal.Template.prodConfigSCPage).CallProductionUpdateAndSaveToClass(prodConf,confItem,"RemoveItem")
   						Set tSC = ##class(Ens.Director).UpdateProduction()
   						Set deleteSQL = "DELETE  FROM JHIPV5_JHREG_DB_Theme.ThemeDB WHERE ThemeCode='"_ThemeCode_"'and ThemeName='"_ThemeName_"'"
   						Set tSC=..Adapter.ExecuteUpdate(.Result,deleteSQL)
					}
					Set res = ResultJson.TResult("Item删除完成！！！")			
			}
		Set pResponse.StringValue = res
	}Catch(ex){
		Set tSC=ex.AsStatus()
		Set res = ResultJson.FResult()
	}
	;Set pResponse.StringValue = res
	Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="JHIPLIB.Util.MSG.JHRequestMsg"> 
		<Method>RemoveItem</Method>
	</MapItem>
</MapItems>
}

}
