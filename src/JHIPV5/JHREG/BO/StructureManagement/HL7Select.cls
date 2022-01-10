/// Classname 
/// Summary   jhipv5 结构管理导入
/// Version   1.0
/// Date      2021年11月12日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.StructureManagement.HL7Select Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method OnMessage(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
  
       //hl7_2查询
       Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
       SET A1     =pRequest.pArg.GetAt(1)
       SET RESULT =##class(%DynamicArray).%New()
       SET REQUEST=##class(%DynamicObject).%New()
       SET REQUEST=REQUEST.%FromJSON(A1)
       if (REQUEST.Type="Base"){//
	    set queryStr ="call %Library.Global_Get('"_$NAMESPACE_"','^EnsHL7.Schema()')"
		Set statement= ##class(%SQL.Statement).%New()
		Set qStatus  = statement.%Prepare(queryStr)
		Set rset     = statement.%Execute()
	    while rset.%Next(){	
		   	Set name = $REPLACE($E(rset.%Get("Name"),16,*-1),"""","")
		   	Do RESULT.%Push(name)
	     }
       }
      if (REQUEST.Type="MTALL"){//消息类型所有
	    set name      =REQUEST.Name
	    set queryStr  ="call %Library.Global_Get('"_$NAMESPACE_"','^EnsHL7.Schema("_name_",MT,)')"
	    Set statement = ##class(%SQL.Statement).%New()
		Set qStatus   = statement.%Prepare(queryStr)
		Set rset      = statement.%Execute()
	    while rset.%Next(){	
		   	Set name  = rset.%Get("Value")
		   	Do RESULT.%Push($p(name,":",2))
	     }
      }
      if (REQUEST.Type="MT"){//消息类型详情
	      SET RESYLTOb =##class(%DynamicObject).%New()
	      set name     =REQUEST.Name1
	      set name2    =REQUEST.Name2
	      SET MS       =^EnsHL7.Schema(name,"MT",name2)
	      Set RMT      =""
	      set queryStr ="call %Library.Global_Get('"_$NAMESPACE_"','^EnsHL7.Schema("_name_",MT,"_name2_",rettype)')"
	      Set statement= ##class(%SQL.Statement).%New()
		  Set qStatus  = statement.%Prepare(queryStr)
		  Set rset     = statement.%Execute()
	      while rset.%Next(){	
		   	Set RMT    = rset.%Get("Value")
		  }
	      set RESYLTOb.MS =MS
	      set RESYLTOb.RMT=RMT
	      Do RESULT.%Push(RESYLTOb)
          //$$$TRACE(MS_","_RMT)
      }
      if (REQUEST.Type="MS"){//DocType详情
	      set name=REQUEST.Name1
	      set name2=REQUEST.Name2
	      SET MS=^EnsHL7.Schema(name,"MS",name2)
	      Do RESULT.%Push(MS)
	      //$$$TRACE(MS)
	      
      }
       if (REQUEST.Type="MSALL"){ ///DocType全部
	    set name=REQUEST.Name
	    set queryStr="call %Library.Global_Get('"_$NAMESPACE_"','^EnsHL7.Schema("_name_",MS,)')"
		Set statement = ##class(%SQL.Statement).%New()
		Set qStatus = statement.%Prepare(queryStr)
		Set rset = statement.%Execute()
	    while rset.%Next(){	
		   	Set name = rset.%Get("Name")
		   	//$$$TRACE($REPLACE($REPLACE($P(name,",",3),"""",""),")",""))
		   	Do RESULT.%Push($REPLACE($REPLACE($P(name,",",3),"""",""),")",""))
	     }
	      
       }
        if (REQUEST.Type="SSALL"){ //段结构全部
	    set name=REQUEST.Name
	    set queryStr="call %Library.Global_Get('"_$NAMESPACE_"','^EnsHL7.Schema("_name_",SS,)')"
	    Set statement = ##class(%SQL.Statement).%New()
		Set qStatus = statement.%Prepare(queryStr)
		Set rset = statement.%Execute()
	    while rset.%Next(){	
		   	Set name = rset.%Get("Name")
		   	Do RESULT.%Push($REPLACE($REPLACE($P(name,",",3),"""",""),")",""))
	     }
      }
      
      
      if (REQUEST.Type="SS"){   //段结构详情
	      set name =REQUEST.Name1
	      set name2=REQUEST.Name2
	      SET A1   =^EnsHL7.Schema(name,"SS",name2)
	      set A2   =$LG(A1)
	      set ll   =$ll(A1) 
	      SET i    =0
	      for i    =1:1:ll{
		    set table(i) =""
		    set temp2    =name_",SS,"_name2_",tables,"_i
	        set queryStr ="call %Library.Global_Get('"_$NAMESPACE_"','^EnsHL7.Schema("_temp2_")')"
		    Set statement= ##class(%SQL.Statement).%New()
		    Set qStatus  = statement.%Prepare(queryStr)
	        Set rset     = statement.%Execute()
	        while rset.%Next(){	
		       Set index = rset.%Get("Value")
		       set table(i)=index
            }
		  }
	     SET TEMP     =name_",SS,"_name2_",names,"
	     set queryStr ="call %Library.Global_Get('"_$NAMESPACE_"','^EnsHL7.Schema("_TEMP_")')"
		 Set statement= ##class(%SQL.Statement).%New()
		 Set qStatus  = statement.%Prepare(queryStr)
	     Set rset     = statement.%Execute()
	     while rset.%Next(){	
		   	Set index = rset.%Get("Value")
		   	Set Name  = $replace($replace($p(rset.%Get("Name"),",",5),"""",""),")","")
		    set a(index)=Name
	     }
         for i=1:1:ll{
		    TRY {
			   SET DES(i)=^EnsHL7.Description(name,"SS",name2,i)
			}CATCH(E){
			   SET DES(i)=""  
		    }
		    //SET A3=$LG(A2,2)
		    set RESYLTOb              =##class(%DynamicObject).%New()
		    set RESYLTOb.Name         =a(i)
	        set RESYLTOb.table        =table(i)
	        set RESYLTOb.des          =DES(i)
	        set RESYLTOb.dataStructure=$LG(A2,1)
	        set RESYLTOb.Symbol       =$LG(A2,2)
	        set RESYLTOb.RepeatCount  =$LG(A2,3)
	        set RESYLTOb.minLength    =$LG(A2,7)
	        set RESYLTOb.maxLength    =$LG(A2,4)
	        set RESYLTOb.ifmust       =$LG(A2,5)
	        set RESYLTOb.Repeat       =$LG(A2,6)
	        Do RESULT.%Push(RESYLTOb)
		    //$$$TRACE(a(i)_table(i)_","_DES(i)_A3)
		  }
       }
        if (REQUEST.Type="CTALL"){ //代码表全部
	      set name      =REQUEST.Name
	      set queryStr  ="call %Library.Global_Get('"_$NAMESPACE_"','^EnsHL7.Schema("_name_",CT,)')"
		  Set statement = ##class(%SQL.Statement).%New()
		  Set qStatus   = statement.%Prepare(queryStr)
		  Set rset      = statement.%Execute()
	      while rset.%Next(){	
		   	Set name    = rset.%Get("Name")
		   	Do RESULT.%Push($REPLACE($REPLACE($P(name,",",3),"""",""),")",""))
	      }
      }
       if (REQUEST.Type="CT"){ //代码表详情
	     set name      =REQUEST.Name1
	     set name2     =REQUEST.Name2
	     SET TEMP      =name_",CT,"_name2_","
	     set queryStr  ="call %Library.Global_Get('"_$NAMESPACE_"','^EnsHL7.Schema("_TEMP_")')"
		 Set statement = ##class(%SQL.Statement).%New()
		 Set qStatus   = statement.%Prepare(queryStr)
		 Set rset      = statement.%Execute()
	     while rset.%Next(){	
	      set RESYLTOb =##class(%DynamicObject).%New()
		  Set index    = rset.%Get("Value")
		  Set Name     = $p(rset.%Get("Name"),",",4)
		  SET Name     =$REPLACE(Name,"""","")
		  set Name     =$E(Name,1,*-1)
		  TRY{
			  SET DES  =  ^EnsHL7.Description(name,"CT",name2,Name)
			 }CATCH{
			   SET DES =""
		  }
		  set RESYLTOb.Name=Name
		  set RESYLTOb.Des =DES
		  Do RESULT.%Push(RESYLTOb)
	     }  
      }
        if (REQUEST.Type="DTALL"){ //数据结构全部
	    set name=REQUEST.Name
	    set queryStr="call %Library.Global_Get('"_$NAMESPACE_"','^EnsHL7.Schema("_name_",DT,)')"
	  
		Set statement = ##class(%SQL.Statement).%New()
		Set qStatus = statement.%Prepare(queryStr)
		Set rset = statement.%Execute()
	    while rset.%Next(){	
		   	Set name = rset.%Get("Name")
		   	Do RESULT.%Push($REPLACE($REPLACE($P(name,",",3),"""",""),")",""))
	     }
      }
       if (REQUEST.Type="DT"){ //DS 数据结构
	      set name     =REQUEST.Name1
	      set name2    =REQUEST.Name2
	      SET A1       =^EnsHL7.Schema(name,"DT",name2)
	      set A2       =$LG(A1)
	      set ll       =$ll(A1)
	      SET i        =0
	      for i        =1:1:ll{  
		  set table(i) =""
		  set temp2    =name_",DT,"_name2_",tables,"_i
	      set queryStr ="call %Library.Global_Get('"_$NAMESPACE_"','^EnsHL7.Schema("_temp2_")')"
		  Set statement= ##class(%SQL.Statement).%New()
		  Set qStatus  = statement.%Prepare(queryStr)
		  Set rset = statement.%Execute()
	      while rset.%Next(){	
		   	Set index = rset.%Get("Value")
		   	set table(i)=index
	      }
		  }
	     SET TEMP=name_",DT,"_name2_",names,"
	     set queryStr="call %Library.Global_Get('"_$NAMESPACE_"','^EnsHL7.Schema("_TEMP_")')"
		 Set statement = ##class(%SQL.Statement).%New()
		 Set qStatus = statement.%Prepare(queryStr)
	     Set rset = statement.%Execute()
	    while rset.%Next(){	
		   	Set index = rset.%Get("Value")
		   	Set Name = $REPLACE($REPLACE($p(rset.%Get("Name"),",",5),"""",""),")","")
		    
		   	
		   set a(index)=Name
	     }
 
	   for i=1:1:ll{
		    
		   TRY {
			   SET DES(i)=^EnsHL7.Description(name,"DT",name2,i)
			   
			   
			   }CATCH(E){
				 SET DES(i)=""  
		    }
		   // SET A3=$LG(A2,1)
		     set RESYLTOb=##class(%DynamicObject).%New()
		     SET RESYLTOb.Name=a(i)
		     SET RESYLTOb.table=table(i)
		     SET RESYLTOb.des=DES(i)
		     SET RESYLTOb.dataStructure=$LG(A2,1)
		     SET RESYLTOb.minLength=$LG(A2,2)
		     SET RESYLTOb.maxLength=$LG(A2,3)
		     SET RESYLTOb.ifmust=$LG(A2,4)
		     Do RESULT.%Push(RESYLTOb)
		    //$$$TRACE(a(i)_table(i)_","_DES(i)_A3)
		  }
	     
      }
      
	   Set pResponse=##class(Ens.StringResponse).%New()
	   Set pResponse.StringValue=Result.TResult(RESULT)  
       Quit $$$OK
}

}
