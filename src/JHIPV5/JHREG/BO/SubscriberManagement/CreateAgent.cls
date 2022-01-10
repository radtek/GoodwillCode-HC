/// Classname JHIPLIB.Util.WSC.CreateAgent
/// Summary   创建代理类封装类，参数一Action为URL地址，参数二Message为创建Web 服务客户端的包名。<br>
/// Summary   返回参数为Web 服务客户端类<br>
/// Version   1.0<br>
/// Date      2019年09月06日 15:15:39<br>
/// Author    ZBT<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.SubscriberManagement.CreateAgent Extends %RegisteredObject
{

ClassMethod CreateAgent(pInput As JHIPLIB.Util.WSC.MSG.URLRequst, ByRef pOutput As JHIPLIB.Util.WSC.MSG.URLResponse) As %Boolean
{
	Try{
		Set WSDL=##class(JHIPLIB.Util.WSC.BaseCLASS).%New()
		Set pOutput=##class(JHIPLIB.Util.WSC.MSG.URLResponse).%New()
		Set URLDB=##class(JHIPLIB.Util.WSC.DB.URLDB).%New()
		Set pOutput.CreatedTime=$ZDT($H,3),URLDB.CreatedTime=$ZDT($H,3)
		Set URL=pInput.URL,URLDB.PackageName=pInput.PackageName,URLDB.ReceiverName=pInput.ReceiverName
		Set:$p(URL,"wsdl")=URL URL=URL_"?wsdl"
		Set TSC=WSDL.Process(URL,pInput.PackageName,.classname),URLDB.URL=URL
		IF $$$ISERR(TSC){
			Set str="输入URL地址不能调通，请验证！" 
			$$$ThrowOnError(str)
			Quit
			}
		Set pOutput.ClassName=classname,URLDB.ClassName=classname,pOutput.Result="Web服务客户端类创建成功！类名如下："
		D URLDB.%Save()
		Set pOutput.ReceiverName=pInput.ReceiverName
		Set pOutput.URL=$p(URL,"?wsdl")
	}catch(ex){		
		 $$$ThrowOnError(ex.DisplayString())
		}
	Quit pOutput
}

}
