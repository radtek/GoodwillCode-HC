/// Classname JHIPV5.JHREG.BO.MessageMonitor.SubpubChart
/// Summary   消息监控 -订阅关系
/// Explain	  展示订阅关系图表
/// Version   1.0<br>
/// Date      2021年12月1日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.MessageMonitor.SubpubChart Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set tStatment = ##class(%SQL.Statement).%New()
	Set nameArr = ##class(%DynamicArray).%New()
	Set linksArr = ##class(%DynamicArray).%New()
	Set resultObject = ##class(%DynamicObject).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()

	try{
		// 获取源 发布系统
		Set SourceSql="Select distinct Publish from JHIPV5_JHREG_DB.SubscriptionDB  where Publish !='' "
		Set tSC = tStatment.%Prepare(SourceSql)
		Set SourceResult = tStatment.%Execute()
		While SourceResult.%Next(){
			Set josnObject = ##class(%DynamicObject).%New()
			Set Publish=SourceResult.%Get("Publish")
			Set josnObject.name  = Publish_"->"
			do nameArr.%Push(josnObject)

		}
		// 获取目标 订阅系统
		Set targetSql="Select distinct Subscribe from JHIPV5_JHREG_DB.SubscriptionDB where Subscribe !='' "
		Set tSC = tStatment.%Prepare(targetSql)
		Set targetResult = tStatment.%Execute()
		While targetResult.%Next(){ 
			Set josnObject = ##class(%DynamicObject).%New()
			Set Subscribe=targetResult.%Get("Subscribe")
			Set josnObject.name = "->"_Subscribe
			do nameArr.%Push(josnObject)
		}	
		// 获取集成场景
		Set ServiceTypeSql="Select distinct ServiceType from JHIPV5_JHREG_DB.SubscriptionDB where (Publish !='' or Subscribe !='') "
		Set tSC = tStatment.%Prepare(ServiceTypeSql)
		Set ServiceTypeSqlResult = tStatment.%Execute()
		While ServiceTypeSqlResult.%Next(){
			Set josnObject = ##class(%DynamicObject).%New()
			Set ServiceType=ServiceTypeSqlResult.%Get("ServiceType")
			IF $L(ServiceType) '=0{
				 Set josnObject.name = ServiceType
				 do nameArr.%Push(josnObject)
			}
		}	
		//获取订阅系统、发布系统、关系
		Set Sql="Select distinct Publish, Subscribe, ServiceType from JHIPV5_JHREG_DB.SubscriptionDB where (Publish !='' or Subscribe !='')"
		Set tSC = tStatment.%Prepare(Sql)
		Set tResult = tStatment.%Execute()		
		While tResult.%Next(){
			Set linkObject = ##class(%DynamicObject).%New()
			Set linkObject1 = ##class(%DynamicObject).%New()
			Set Publish=tResult.%Get("Publish")
			Set Subscribe=tResult.%Get("Subscribe")
			Set ServiceType=tResult.%Get("ServiceType")
			// 源（发布系统） 到 集成场景
			IF $A(Publish) '=0{
				Set linkObject.source=Publish_"->"
				Set linkObject.target=ServiceType
				Set linkObject.value=1
				do linksArr.%Push(linkObject)
			}
			// 集成场景 到 目标（订阅系统）
			IF $A(Subscribe) '=0{
				Set linkObject1.source=ServiceType
				Set linkObject1.target="->"_Subscribe
				Set linkObject1.value=1
				do linksArr.%Push(linkObject1)
			}		
		}
		Set resultObject.data=nameArr
		Set resultObject.links=linksArr		
		Set str=Result.STResult(resultObject)
	}Catch(e){
		Set str=Result.FResult()
	 	Set tSC=e.AsStatus()
   }
	Set pResponse.StringValue=$REPLACE(str,"\u0000","")
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
