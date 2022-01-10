/// Classname 
/// Summary   jhipv5 结构管理导入
/// Version   1.0
/// Date      2021年11月12日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.StructureManagement.select Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method OnMessage(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	
  	 SET A1           =pRequest.pArg.GetAt(1)
	 set request      =##class(%DynamicArray).%New()
     set result       =##class(%DynamicArray).%New()
      //xml查询
     SET REQUEST      =##class(%DynamicObject).%New()
     SET REQUEST      =REQUEST.%FromJSON(A1)
     if (REQUEST.Type ="Base"){
	    set queryStr  ="call %Library.Global_Get('"_$NAMESPACE_"','^EnsEDI.XML.Schema()')"
		Set statement = ##class(%SQL.Statement).%New()
		Set qStatus   = statement.%Prepare(queryStr)
		Set rset      = statement.%Execute()
	    while rset.%Next(){	
		   	Set name  = rset.%Get("Name")
		   	Do result.%Push($e(name,21,*-2))
	     }
	 }elseif(REQUEST.Type="DS"){
	    set TYPE      ="DS"
		SET NAME      =REQUEST.Name
		//"COCT_HD060000UV01"
		set queryStr  ="call %Library.Global_Get('"_$NAMESPACE_"','^EnsEDI.XML.Schema("""_NAME_""","""_TYPE_""",)')"
	    Set statement = ##class(%SQL.Statement).%New()
		Set qStatus   = statement.%Prepare(queryStr)
		Set rset      = statement.%Execute()
	    while rset.%Next(){	
		   	Set name  = rset.%Get("Name")
		   	Do result.%Push($e($p(name,"^EnsEDI.XML.Schema("""_NAME_""","""_TYPE_""",",2),2,*-2))
	    }       
	 }
	 elseif(REQUEST.Type="DS1"){
		set TYPE      ="DS"
		SET NAME      =REQUEST.Name1
		SET NAME2     =REQUEST.Name2
		set a1        = ^EnsEDI.XML.Schema(NAME,"DS",NAME2,"meta")
        SET i         =0
	    FOR i=1:1:a1
	    {
	       set a1(i)  = ""
		}
		set temp      = "^EnsEDI.XML.Schema("""_NAME_""",""DS"","""_NAME2_""",""meta"",""dnames"""
	    set queryStr  = "call %Library.Global_Get('"_$NAMESPACE_"','"_temp_",)')"
		Set statement = ##class(%SQL.Statement).%New()
		Set qStatus   = statement.%Prepare(queryStr)
		Set rset      = statement.%Execute()
		while rset.%Next(){	
		  Set index   = rset.%Get("Value")
		  set Name    =$E($p(rset.%Get("Name"),temp_",",2),2,*-2)
		  set a1(index)=Name
	    } 
	    set a1        = ^EnsEDI.XML.Schema(NAME,"DS",NAME2,"meta")
        SET i         = 0
	    FOR i=1:1:a1
	    {
	       set resultOb=##class(%DynamicObject).%New()
	       set resultOb.name =^EnsEDI.XML.Schema(NAME,"DS",NAME2,"meta",i,"name")
	       set resultOb.type =^EnsEDI.XML.Schema(NAME,"DS",NAME2,"meta",i,"type")
	       set resultOb.ifreq=^EnsEDI.XML.Schema(NAME,"DS",NAME2,"meta",i,"req")
	       if (a1(i)=""){
		       if (resultOb.name="nullFlavor")||(resultOb.name="classCode"){
			        set resultOb.ele="@"_resultOb.name 
			   }else{
				    set resultOb.ele="$3:"_$replace($replace(resultOb.name,"(","["),")","]")
			   }
		   }else{
		       set resultOb.ele=a1(i)    
		   }
		   Do result.%Push(resultOb)
		}
		      
	 }
	 elseif(REQUEST.Type="choice"){
		 set TYPE ="DS"
		 SET NAME=REQUEST.Name1
		 SET NAME2=REQUEST.Name2
		 SET Index=REQUEST.index
		 set a1 = ^EnsEDI.XML.Schema(NAME,"DS",NAME2,"meta")
         SET i=0
	     FOR i=1:1:a1
	     {
	        set a1(i)=""
		 }
	     set temp     ="^EnsEDI.XML.Schema("""_NAME_""",""DS"","""_NAME2_""",""meta"","_Index_",""dnames"""
	     set queryStr ="call %Library.Global_Get('"_$NAMESPACE_"','"_temp_",)')"
		 Set statement= ##class(%SQL.Statement).%New()
		 Set qStatus  = statement.%Prepare(queryStr)
		 Set rset     = statement.%Execute()
	     while rset.%Next(){	
		    set Name  =rset.%Get("Name")
		   	set index =rset.%Get("Value")
		   	SET LENGTH=$L(Name,",")
		   	set Name=$P(Name,",",LENGTH)
		   	set a1(index)=Name
	     } 
	     //长度
	     set temp      ="^EnsEDI.XML.Schema("""_NAME_""",""DS"","""_NAME2_""",""meta"","_Index_")"
	     set queryStr  ="call %Library.Global_Get('"_$NAMESPACE_"','"_temp_"')"
         Set statement = ##class(%SQL.Statement).%New()
	 	 Set qStatus   = statement.%Prepare(queryStr)
		 Set rset      = statement.%Execute()
		 while rset.%Next(){	
		   set l1      = rset.%Get("Value")
	     }
	     SET i         =0
	     FOR i=1:1:l1
	     {
	      set temp     ="^EnsEDI.XML.Schema("""_NAME_""",""DS"","""_NAME2_""",""meta"","_Index_","_i_",)"
	      set queryStr ="call %Library.Global_Get('"_$NAMESPACE_"','"_temp_"')"
          Set statement= ##class(%SQL.Statement).%New()
		  Set qStatus  = statement.%Prepare(queryStr)
		  Set rset     = statement.%Execute()
		  while rset.%Next(){	
	        if ($E($P(rset.%Get("Name"),$E(temp,1,*-1),2),2,*-2)="name"){
			   set n1  =rset.%Get("Value")
		    }elseif($E($P(rset.%Get("Name"),$E(temp,1,*-1),2),2,*-2)="type"){
			   set t1  =rset.%Get("Value")
			}elseif($E($P(rset.%Get("Name"),$E(temp,1,*-1),2),2,*-2)="req"){
			   set r1  =rset.%Get("Value")
			}
	      } 
	      set resultOb =##class(%DynamicObject).%New()
	      set resultOb.name =n1
	      set resultOb.type =t1
	      set resultOb.ifreq=r1
	      if (a1(i)=""){
		     if (resultOb.name="nullFlavor")||(resultOb.name="classCode")||(resultOb.name="determinerCode"){
			     set resultOb.ele="@"_resultOb.name 
			 }else{
				 set resultOb.ele="$3:"_$replace($replace(resultOb.name,"(","["),")","]") 
			 }
		  }else{
		     set resultOb.ele=a1(i)    
		  }
		  Do result.%Push(resultOb)
	    }      
	 }
     Set Result   =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	 Set pResponse=##class(Ens.StringResponse).%New()
	 Set pResponse.StringValue=Result.TResult(result)  
     Quit $$$OK
}

}
