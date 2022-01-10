/// Classname HIPPOPD.BS.HippOPDBS
/// Summary   嘉和美康系统门诊数据大屏分派BS
/// Version   1.0
/// Date      2021年11月23日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BS.SubRelationship.RestBs Extends Ens.BusinessService
{

Method OnProcessInput(pInput As Ens.StringRequest, Output pOutput As %RegisteredObject) As %Status
{

	set bpArray=##class(%DynamicObject).%New()
    
	set bpArray= bpArray.%FromJSON(pInput.StringValue)
	//set pInput.StringValue=$ZCVT(pInput.StringValue,"I","UTF8")
	Set t1=##class(Ens.StringRequest).%New()
	Set t1.StringValue=pInput.StringValue
	if (bpArray.type="addSubRelate"){
	  Set tSC= ..SendRequestSync("订阅关系创建BO",t1,.pOutput)	
	  	 SET TSC=##class(Ens.Director).UpdateProduction(10,0,0)
	}elseif(bpArray.type="editSubRelate"){
	  Set tSC= ..SendRequestSync("订阅关系编辑BO",t1,.pOutput)	
	   SET TSC=##class(Ens.Director).UpdateProduction(10,0,0)
	}elseif(bpArray.type="deleteSubRelate"){
	  Set tSC= ..SendRequestSync("订阅关系删除BO",t1,.pOutput)	
	  	 SET TSC=##class(Ens.Director).UpdateProduction(10,0,0)
	}elseif(bpArray.type="StopOrOpenSubRelate"){
	  Set tSC= ..SendRequestSync("订阅关系启用停用BO",t1,.pOutput)	
	  	 SET TSC=##class(Ens.Director).UpdateProduction(10,0,0)
	}elseif(bpArray.type="selectSub"){
	  Set tSC= ..SendRequestSync("订阅关系查询订户BO",t1,.pOutput)	
	}
	

	
    
	Quit $$$OK
}

}
