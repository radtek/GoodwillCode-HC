/// Classname JHIPLIB.Util.HIPPUtil.HIPPUtil
/// Summary   系统监控大屏相关信息获取工具类
/// Version   1.0
/// Date      2020年7月30日
/// Author    李健2020年4月29日优化
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPLIB.Util.HIPPUtil.HIPPUtil Extends EnsLib.SOAP.Service
{

Parameter ADAPTER;

/// Name of the WebService
Parameter SERVICENAME = "HIPPUtil";

/// TODO: Change this to actual network address
/// URL for invoking the WebService
/// Parameter LOCATION = "http://127.0.0.1:8972/csp/ensemble";
/// TODO: Change this to actual SOAP namespace
/// SOAP namespace for the WebService
Parameter NAMESPACE = "http://goodwillcis.com";

/// MethodName：util<br>
/// Summary: 工具类方法<br>
/// In Parameter:pInput %String<br>
/// Out parameter: <br>
/// Return： %Status 返回执行结果<br>
/// Date： 2020年7月29日 18:00 <br>
/// Author： 李健<br>
Method util(pInput As %String) As %String [ WebMethod ]
{
	Try{
		Set target=##class(EnsLib.EDI.XML.Document).ImportFromString(pInput,.status)
		Set method = target.GetValueAt("/HIPP/method")
		if method = "partent"{
			Set partentIdList = target.GetValueAt("/HIPP/parms")
			Set partentNameList = ..GetPartentList(partentIdList)
			Set tResponse = partentNameList
		}elseif method = "serviceType"{
			Set serviceNameList = target.GetValueAt("/HIPP/parms")
			Set serviceTypeList = ..GetServiceType(serviceNameList)
			Set tResponse = serviceTypeList
		}
	}catch(ex){
		
	}
	Quit tResponse
}

/// MethodName：GetPartentList<br>
/// Summary: 获取业务合作伙伴方法<br>
/// In Parameter:partentIdList %String<br>
/// Out parameter: <br>
/// Return： %String 返回业务合作伙伴名称集合<br>
/// Date： 2020年7月30日 11:00 <br>
/// Author： 李健<br>
Method GetPartentList(partentIdList As %String) As %String
{
	
	Set nameList = "" 
	Set IDList = partentIdList
	Set length = $L(IDList,",")
	for i=1:1:length{
		Set ID = $P(IDList,",",i)
		Set Parter =""
		Set item = $Get(^Ens.Config.ItemD(ID),"")
		if (item '= ""){
			for index=1:1:$LISTLENGTH($ListGet(item,9)){
				if ($ListGet($ListGet($ListGet($ListGet(item,9),index),1),1)="BusinessPartner")&&($ListGet($ListGet($ListGet($ListGet(item,9),index),1),2)="Host"){
					Set Parter =$ListGet($ListGet($ListGet($ListGet(item,9),index),1),3)
				}
			}
		}
		Set nameList = nameList_Parter_","
	}
	Set nameList = $EXTRACT(nameList,1,*-1)
	Quit nameList
}

/// MethodName：GetServiceType<br>
/// Summary: 获取组件类别方法<br>
/// In Parameter:partentIdList %String<br>
/// Out parameter: <br>
/// Return： %String 返回业务合作伙伴名称集合<br>
/// Date： 2020年7月30日 11:00 <br>
/// Author： 李健<br>
Method GetServiceType(serviceNameList As %String) As %String
{

	
	Set typeList = "" 
	Set serviceList = serviceNameList
	Set length = $L(serviceList,",")
	Set config = ##class(Ens.Config.Item).%New()
	for i=1:1:length{
		Set serviceName = $P(serviceList,",",i)
		Set IOType = config.GetBusinessType(serviceName)
		Set typeList = typeList_IOType_","
	}
	Set typeList = $EXTRACT(typeList,1,*-1)
	Quit typeList
}

}
