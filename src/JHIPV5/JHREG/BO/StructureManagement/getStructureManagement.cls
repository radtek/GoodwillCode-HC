/// Classname 
/// Summary   jhipv5 结构管理-获取目录下所有文件
/// Version   1.0
/// Date      2021年11月12日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.StructureManagement.getStructureManagement Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set Result1     =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
    set Result=##class(%DynamicArray).%New()
    set sql   =""
    set input =##class(%DynamicObject).%New()
    set input =input.%FromJSON(pRequest.pArg.GetAt(1))
    set size  =input.Size
	set page  =input.Page
	set num   =(page-1)*size
	set num2  =num+size
	if (input.StandardName'=""){
	   set sql=sql_"and StandardName = '"_input.StandardName_"'"
	}
	if (input.StandardType'=""){
	   set sql=sql_"and StandardType = '"_input.StandardType_"'"
	}
    set myquery ="SELECT %VID as id1,*  FROM (SELECT COUNT(1) AS Total,* FROM JHIPV5_JHREG_DB.StructureManagement where 1=1 "_sql_" ) where %VID<="_num2_" and %VID>"_num_""
    $$$TRACE(myquery)
    SET rset    =##class(%ResultSet).%New()
    SET qStatus =rset.Prepare(myquery)
    IF qStatus '=1 {WRITE "Prepare failed:" DO $System.Status.DisplayError(qStatus) QUIT}
    SET sc      =rset.Execute()
    set total=0
    WHILE rset.Next() {
	     set resultOb=##class(%DynamicObject).%New()
	     set resultOb.id          =rset.Data("ID")
	     set resultOb.StandardName=rset.Data("StandardName")
	     set resultOb.StandardType=rset.Data("StandardType")_""
	     set resultOb.openStatus  =rset.Data("openStatus")+0
	     &sql(select NameSpace into :NameSpace from JHIPV5_JHREG_DB.DomainDB where DomainID =:rset.Data("NameSpaceID"))
	     set resultOb.nameSpace=NameSpace
	     set resultOb.ManagerTime =rset.Data("ManagerTime")
	     set total=rset.Data("Total")
	     Do Result.%Push(resultOb)    
    }
    set ResponseOb=##class(%DynamicObject).%New()
    set ResponseOb.rows=Result
    set ResponseOb.total=total
    set pResponse=##class(Ens.StringResponse).%New()
    	Set pResponse.StringValue=Result1.Result("200",ResponseOb,1,"")
    //set pResponse.StringValue=Result1.TResult(ResponseOb) 
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
