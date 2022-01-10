/// Classname 
/// Summary   jhipv5 结构管理-获取目录下所有文件
/// Version   1.0
/// Date      2021年11月12日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.StructureManagement.getFiles Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	    Set Result     =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
      //获取 
        set ResultArray=##class(%DynamicArray).%New()
        set input      =##class(%DynamicObject).%New()
        set input      =input.%FromJSON(pRequest.pArg.GetAt(1))
        set size       =input.Size
	    set page       =input.Page
	    set num        =(page-1)*size
	    set num2       =num+size 
	    set sql        =""
	    IF (input.Type){
		  set sql= sql_"and FileType = '"_input.Type_"'" 
		}
        set queryStr   ="SELECT %VID as id1,*  FROM (select COUNT(1) AS Total,* from JHIPV5_JHREG_DB.StructureManagementFilesDB where 1=1  "_sql_") where  %VID<="_num2_" and %VID>"_num_"" 		
		Set statement  = ##class(%SQL.Statement).%New()
		Set qStatus    = statement.%Prepare(queryStr)
		Set rset       = statement.%Execute()
	    while rset.%Next(){	
	      set resultOb      =##class(%DynamicObject).%New()
	      Set resultOb.ID   =rset.%Get("ID")
		  Set resultOb.name = rset.%Get("FileName")
		  Set resultOb.Type = rset.%Get("FileType")
		  Do ResultArray.%Push(resultOb)   
	    }
       set ResponseOb       =##class(%DynamicObject).%New()
       set ResponseOb.rows  =ResultArray
       set ResponseOb.total =ResultArray.%Size()
       set pResponse=##class(Ens.StringResponse).%New()
	   //Set pResponse.StringValue=Result.TResult(ResponseOb)   
	   	Set pResponse.StringValue=Result.Result("200",ResponseOb,1,"")

       Quit $$$OK
}

ClassMethod getFiles(type)
{
	set Result=##class(%DynamicArray).%New()
    set stmt = ##class(%SQL.Statement).%New()
    set status = stmt.%PrepareClassQuery("%File", "FileSet")
    
    if $$$ISERR(status) { 
        do $system.OBJ.DisplayError(status)
        quit  
    }
    
    set resultSet = stmt.%Execute("/usr/workspace/", "*.*", "Name") 

    while resultSet.%Next() {
        Do Result.%Push(resultSet.%Get("Name"))
        
    }

      set pResponse=##class(Ens.StringResponse).%New()
      set pResponse.StringValue=Result.%ToJSON()
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
