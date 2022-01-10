/// Classname HIPPVue.Rest.HippVueRestAPI
/// Summary   嘉和美康系统运维监控大屏分派类
/// Version   1.0
/// Date      2020年12月17日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.Rest.SubRelationship.BPRestApi Extends %CSP.REST
{

Parameter HandleCorsRequest = "true";

XData UrlMap [ XMLNamespace = "http://www.bjgoodwill.com/urlmap" ]
{
<Routes>
  <Route Url="/*" Method="OPTIONS" Call="GetStatus"/>
  <Route Url="/BP/:ser" Method="Post" Call="GetApplication"/>

</Routes>
}

ClassMethod GetStatus(ser As %String) As %Status
{
     Quit $$$OK
}

ClassMethod GetApplication(ser As %String) As %Status
{
    
     
   
	
	if (ser="subrelation"){
		Set request =##class(Ens.StringRequest).%New()
	
        set request.StringValue=%request.Data("VALUE",1)
		 // w %request.Content.Read()
		

	}
	else{
	Set request =##class(Ens.StringRequest).%New()
       set request.StringValue=ser
	} 
		
		
	   Set DemoHelloBS =##class(JHIPV5.JHREG.BS.SubRelationship.RestBs).%New()
       Set tSC=##class(Ens.Director).CreateBusinessService("订阅关系分派BS",.DemoHelloBS)
 
        set output =##class(Ens.StringResponse).%New()
       Set tSC1=DemoHelloBS.ProcessInput(request,.output)
       Do %response.SetHeader("Content-Type", "application/json;charset=UTF-8")
       set message =output.StringValue   
       w message
	  
  
     Quit $$$OK
}

}
