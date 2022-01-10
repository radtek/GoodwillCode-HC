/// Classname HIPPOPD.BS.HippOPDBS
/// Summary   嘉和美康系统门诊数据大屏分派BS
/// Version   1.0
/// Date      2021年11月23日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BS.StructureManagement.importBS Extends Ens.BusinessService
{

Parameter ADAPTER = "EnsLib.HTTP.InboundAdapter";

Method OnProcessInput(pInput As %Stream.Object, Output pOutput As Ens.StringResponse) As %Status
{

	
	$$$TRACE("wwww")
	set a1=pInput.Read()
	$$$TRACE(a1)

	 set pOutput=##class(Ens.StringResponse).%New()
	set pOutput="1234"
    
	Quit $$$OK
}

}
