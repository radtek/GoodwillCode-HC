/// Classname JHIPV5.JHREG.BO.MesRretr.MessageRetrievalBO
/// Summary   消息检索——根据不同类型消息进行检索
/// Explain	  根据 搜索条件 进行消息检索
/// Version   1.0<br>
/// Date      2021年11月23日 
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.BO.MesRretr.MessageRetrievalBO Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InvokeHDR(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	Set pResponse=##class(Ens.StringResponse).%New()
	Set tStatment = ##class(%SQL.Statement).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Set Result =##class(JHIPV5.JH503UTIL.Result.JosnResult).%New()
	Set jsonObject = ##class(%DynamicObject).%New()
	try{
		Set request =pRequest.pArg.GetAt(1)
		#Dim json As %DynamicObject =##class(%DynamicObject).%FromJSON(request)
		/*-----参数------*/
		Set NameSpace = json.%Get("NameSpace")			/* 域       */
		Set nameCode = json.%Get("Code")				/* 主题编码 */
		Set nameValue = json.%Get("Value")				/* 主题名称 */
		Set SearchValue = json.%Get("SearchValue")		/* 搜索内容 */
		Set SearchType = json.%Get("SearchType")		/* 搜索条件 */
		Set SearchContent = json.%Get("MessageValue")   /* 消息内容 */
		Set MessageType = json.%Get("MessageType")   	/* 消息类型 */
		Set MessageStatus = json.%Get("MessageStatus")  /* 消息状态 */
		Set ThemeName2 = json.%Get("ThemeName")  		/* 主题名称 活动主题收藏跳转 */
		Set StartTime = json.%Get("StartTime") 			/* 开始时间 */
		Set EndTime = json.%Get("EndTime") 				/* 结束时间 */
		Set Size=json.%Get("Size")						/* 每页条数 */
		Set Page=json.%Get("Page")						/* 第几页   */
		
		// 获取完整主题名称
		Set ThemeName=nameCode_nameValue
		/** 暂时未使用 **/
		Set:$L(ThemeName2)'=0 ThemeName=ThemeName2
		// 页码
		Set PageNumber = Size*(Page-1)+1
		Set PageSize = Size * Page
		// 设置 DSN 
		Set GetDSN =##class(JHIPV5.JHREG.Common.NameSpace).ConfigDSN(NameSpace)
		Set tSC= ..Adapter.DSNSet(GetDSN)
		//  通用条件 
		IF (SearchType '=2)&(SearchType '=8){
			// 获取 Searchatbel 表名
			DO ..GetSearchTableBySearchType(SearchType,NameSpace,SearchContent,.TableSql,.SearchTypeName)
			Set i =0
			Set tSC=..Adapter.ExecuteQuery(.TableResult,TableSql)
			kill ^JHIPV5.JHRCB30.MessageRetrCE11D		
			// 遍历不同的Searchtable
			While TableResult.%Next(){
		 		Set ClassName=TableResult.Get("ClassName")
		 		Set cName=$p(ClassName,".",*)
		 		// 获取到 SearchTable 表名
			 	Set tableName = $Translate($e(ClassName,0,*-$L(cName)-1),".","_")_"."_cName
			  	Set MessageSql = "SELECT id, Type,SessionId, Status, SourceConfigName,TargetConfigName,TimeCreated  ,TimeProcessed ,SourceBusinessType,TargetBusinessType FROM Ens.MessageHeader Where SessionId in (SELECT SessionId FROM Ens.MessageHeader WHERE MessageBodyId in (SELECT DocId FROM "_tableName_" WHERE "_SearchTypeName_"='"_SearchValue_"' "
			 	Set:$L(SearchContent)'=0 MessageSql=MessageSql_" and SearchContent like '"_SearchContent_"%' "
			 	Set MessageSql = MessageSql_" ))"
#;				$$$LOGINFO("MessageSql: "_MessageSql)
				Set tSC=..Adapter.ExecuteQuery(.MessageResult,MessageSql)	
				// 遍历消息
				While MessageResult.%Next(){
					Set i= i+1
					Set ^JHIPV5.JHRCB30.MessageRetrCE11D(i)	=	$lb("",MessageResult.%Get("SessionId"),MessageResult.%Get("SourceConfigName"),MessageResult.%Get("TargetConfigName"),MessageResult.%Get("Status"),MessageResult.%Get("TimeCreated")_"",MessageResult.%Get("TimeProcessed"),MessageResult.%Get("Type"),MessageResult.%Get("id"),MessageResult.%Get("SourceBusinessType"),MessageResult.%Get("TargetBusinessType"))
				}
			}
			Set ^JHIPV5.JHRCB30.MessageRetrCE11D=i
			Set SelectSqlDB="SELECT %VID AS ContentID ,* FROM (select TOP all count(1) total,id,SortID, SessionId, SourceConfigName,TargetConfigName ,  Status,TimeCreated ,TimeProcessed  ,Type from  JHIPV5_JHREG_DB.MessageRetrievalDB  where 1=1 "
			// 主题（BS 名称）
			Set:$L(nameValue)'=0 SelectSqlDB=SelectSqlDB_" and (SourceConfigName='"_ThemeName_"' or TargetConfigName ='"_ThemeName_"' )" 
			// 消息状态
			Set:$L(MessageStatus)'=0 SelectSqlDB=SelectSqlDB_" and Status = '"_MessageStatus_"' " 			
			// 消息类型
			Set:$L(MessageType)'=0 SelectSqlDB=SelectSqlDB_" and Type = '"_MessageType_"' " 			
			// 时间范围
			Set:$L(StartTime)'=0 SelectSqlDB=SelectSqlDB_" and TimeCreated Between '"_StartTime_"' and '"_EndTime_"'" 			
			Set SelectSqlDB=SelectSqlDB_" and (SourceBusinessType='1'or TargetBusinessType='1') order by SortID desc )  WHERE %VID BETWEEN '"_PageNumber_"' AND '"_PageSize_"'"
#;			$$$LOGINFO("sqldb"_SelectSqlDB)
			Do ..GetCommonMessage(SelectSqlDB,.dataArr,.total)
		}ElseIF SearchType =2{
			// 根据主题检索
			Do ..GetMessageByTheme(SearchValue, ThemeName, SearchContent, MessageStatus, MessageType, StartTime, EndTime, Size , Page , .dataArr, .total)
		}ElseIF SearchType =8{
			// 根据 消息ID 检索
			Set SessionIDSql="SELECT %VID AS ContentID ,* FROM ( SELECT count(1) total, ID, MessageBodyId, SessionId, SourceConfigName,Status,TargetConfigName,TimeCreated, TimeProcessed, Type FROM Ens.MessageHeader where SessionId='"_SearchValue_"' and (SourceBusinessType='1'or TargetBusinessType='1') "
			// 消息状态
			Set:$L(MessageStatus)'=0 SessionIDSql=SessionIDSql_" and Status = '"_MessageStatus_"'"
			// 消息类型
			Set:$L(MessageType)'=0 SessionIDSql=SessionIDSql_" and Type = '"_MessageType_"' " 			
			// 主题（BS 名称）
			Set:$L(nameValue)'=0 SessionIDSql=SessionIDSql_" and (SourceConfigName='"_ThemeName_"' or TargetConfigName ='"_ThemeName_"' )" 
			// 时间范围
			Set:$L(StartTime)'=0 SessionIDSql=SessionIDSql_" and TimeCreated Between '"_StartTime_"' and '"_EndTime_"'" 			
			Set SessionIDSql=SessionIDSql_" ) WHERE %VID BETWEEN '"_PageNumber_"' AND '"_PageSize_"' "
			Do ..GetMessageBySessionID(SessionIDSql,.dataArr,.total)
		}
		Set jsonObject.rows = dataArr
		Set jsonObject.total = total	
		Set str=Result.STResult(jsonObject)
	}Catch(e){
		$$$LOGERROR(e.DisplayString())
		Set str=Result.FResult()
	 	Set tSC=e.AsStatus()
   }
	Set pResponse.StringValue=$REPLACE(str,"\u0000","")
	Quit $$$OK
}

/// 根据 搜索条件 获取 Searchtable 除 SearchType =2 和 8
Method GetSearchTableBySearchType(SearchType As %String, NameSpace As %String, SearchContent As %String, Output pResponse As %RegisteredObject, Output SearchTypeName As %RegisteredObject) As %Status
{
	
	// 	通过命名空间来判断 Searchtable 表名 
	Set:NameSpace=1 STableName="JHIPLIB_SearchTable%"				/* JHIP */
	Set:NameSpace=2 STableName="HII_Util_SearchTable%"	    		/* HII	*/
	Set:NameSpace=3 STableName="JHIPLIB_SearchTable%"				/*      */ 
	// 通过 SearchType 来决定SearchTable字段名称
	Set:SearchType=0 SearchTypeName="PatientID"   				/* 患者ID   */				
	Set:SearchType=1 SearchTypeName="PatientName"				/* 患者姓名 */
	Set:SearchType=3 SearchTypeName="ApplicationID"				/* 申请单号 */
	Set:SearchType=4 SearchTypeName="OrderID"					/* 医嘱号   */
	Set:SearchType=5 SearchTypeName="HospitalizationID"			/* 住院号   */
	Set:SearchType=6 SearchTypeName="OutpatientID"				/* 门诊号   */
	Set:SearchType=7 SearchTypeName="Search1"					/* 字典内容 */
	Set:SearchType=9 SearchTypeName="Search2"					/* 其他信息 */
	iF NameSpace=2{
		Set:SearchType=0 SearchTypeName="PID"   				/* 患者ID   */				
		Set:SearchType=1 SearchTypeName="PName"					/* 患者姓名 */
	}
	IF $L(SearchContent)'=0{
		Set TableSql="Select distinct substring(parent,0,charindex('||',parent)) as ClassName  FROM %Dictionary.CompiledStorageDataValue where parent in ( select distinct parent  FROM %Dictionary.CompiledStorageDataValue where  value = '"_SearchTypeName_"'  and parent like '"_STableName_"') and value ='SearchContent'"
	}ELSE{
		Set TableSql = "Select distinct substring(parent,0,charindex('||',parent)) as ClassName FROM %Dictionary.CompiledStorageDataValue where  value = '"_SearchTypeName_"' and parent like '"_STableName_"'"
	}
	Set pResponse=TableSql
	Quit $$$OK
}

/// 通用  检索本地 JHIPV5.ESB.DB.MessageRetr 表 消息
Method GetCommonMessage(SQL As %String, Output DataArr As %DynamicObject, Output Total As %DynamicObject) As %Status
{
	Set tStatment = ##class(%SQL.Statement).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Set total=0
	Set tSC = tStatment.%Prepare(SQL)		
	Set tResult = tStatment.%Execute()				
	While tResult.%Next(){
		Set NewFiled = ##class(%DynamicObject).%New()
		Do NewFiled.%Set("ID",tResult.%Get("SortID"))
		Do NewFiled.%Set("SessionId",tResult.%Get("SessionId"))
		Set Type=tResult.%Get("Type")
		IF Type=1{
			Set SourceConfigName=tResult.%Get("SourceConfigName")
			Set TargetConfigName=tResult.%Get("TargetConfigName")
		} Else{
			Set SourceConfigName=tResult.%Get("TargetConfigName")
			Set TargetConfigName=tResult.%Get("SourceConfigName")
		}
		Do NewFiled.%Set("ThemeName",SourceConfigName)
		Do NewFiled.%Set("TargetConfigName",TargetConfigName)				
		Do NewFiled.%Set("MessageStatus",tResult.%Get("Status"))
	    Set TimeProcessed=$TRanslate(tResult.%Get("TimeProcessed"),"-, ,:,.")
		Set TimeCreated=$TRanslate(tResult.%Get("TimeCreated"),"-, ,:,.")
		Set total=tResult.%Get("total")
		Set SpendTime=TimeProcessed-TimeCreated
		Do NewFiled.%Set("StartTime",tResult.%Get("TimeCreated"))
		Do NewFiled.%Set("SpendTime",SpendTime)
		Do NewFiled.%Set("MessageType",tResult.%Get("Type"))
		Do dataArr.%Push(NewFiled)
	}
	Set DataArr = dataArr
	Set Total = total
}

/// 根据 主题  检索消息
/// SearchValue     搜索内容      ThemeName      主题名称      SearchContent   消息内容 
/// MessageStatus   消息状态      MessageType    消息类型      StartTime       开始时间
/// EndTime         结束时间      pResponse      结果集        Total           结果数
Method GetMessageByTheme(SearchValue As %String, ThemeName As %String, SearchContent As %String, MessageStatus As %String, MessageType As %String, StartTime As %String, EndTime As %String, Size As %String, Page As %String, Output pResponse As %DynamicObject, Output Total As %DynamicObject) As %Status
{
	/** 页码，每页条数，计算分页 **/
	Set PageNumber = Size*(Page-1)+1
	Set PageSize = Size * Page
	Set tStatment = ##class(%SQL.Statement).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Set total=0
	// 通过适配器 dsn 查询 判断是否查询 消息内容 若查询，则遍历SearchTable
	IF $L(SearchContent) '=0{
		// 根据消息内容检索
		Set TableSql=" Select distinct substring(parent,0,charindex('||',parent)) as ClassName FROM %Dictionary.CompiledStorageDataValue where  value = 'SearchContent' and parent like '%SearchTable%'"
		Set i =0
		Set tSC=..Adapter.ExecuteQuery(.TableResult,TableSql)
		kill ^JHIPV5.JHRCB30.MessageRetrCE11D
		// 遍历不同的Searchtable
		While TableResult.%Next(){
		 	Set ClassName=TableResult.Get("ClassName")
		 	Set cName=$p(ClassName,".",*)
		 	// 获取到 SearchTable 表名
			Set tableName = $Translate($e(ClassName,0,*-$L(cName)-1),".","_")_"."_cName
			Set MessageSql = "SELECT id, Type,SessionId, Status, SourceConfigName,TargetConfigName,TimeCreated  ,TimeProcessed ,SourceBusinessType,TargetBusinessType FROM Ens.MessageHeader Where SessionId in (SELECT SessionId FROM Ens.MessageHeader WHERE MessageBodyId in (SELECT DocId FROM "_tableName_" WHERE 1=1 and SearchContent like '"_SearchContent_"%' )) and  (SourceConfigName='"_ThemeName_"' or TargetConfigName ='"_ThemeName_"' ) "
			Set tSC=..Adapter.ExecuteQuery(.MessageResult,MessageSql)	
			// 遍历消息
			While MessageResult.%Next(){
				Set i= i+1
				Set ^JHIPV5.JHRCB30.MessageRetrCE11D(i)	=	$lb("",MessageResult.%Get("SessionId"),MessageResult.%Get("SourceConfigName"),MessageResult.%Get("TargetConfigName"),MessageResult.%Get("Status"),MessageResult.%Get("TimeCreated")_"",MessageResult.%Get("TimeProcessed"),MessageResult.%Get("Type"),MessageResult.%Get("id"),MessageResult.%Get("SourceBusinessType"),MessageResult.%Get("TargetBusinessType"))
			}
		}
		Set ^JHIPV5.JHRCB30.MessageRetrCE11D=i
		// 通过查询 Ens.MessageHeader 将结果集放到  JHIPV5.ESB.DB.MessageRetr 中	
		Set SelectSqlDB="SELECT %VID AS ContentID ,* FROM (select TOP all count(1) total,id,SortID, SessionId, SourceConfigName,TargetConfigName ,  Status,TimeCreated ,TimeProcessed  ,Type from  JHIPV5_JHREG_DB.MessageRetrievalDB where 1=1 and (SourceBusinessType='1' or TargetBusinessType ='1' ) "
		// 消息状态  
		Set:$L(MessageStatus)'=0 SelectSqlDB = SelectSqlDB_" and Status = '"_MessageStatus_"'"
		// 消息类型 ：请求 响应
		Set:$L(MessageType)'=0 SelectSqlDB = SelectSqlDB_" and Type = '"_MessageType_"' "
		// 时间筛选
		Set:$L(StartTime)'=0 SelectSqlDB = SelectSqlDB_" and TimeCreated Between '"_StartTime_"' and '"_EndTime_"' "
		Set SelectSqlDB= SelectSqlDB_" order by SortID desc )WHERE %VID BETWEEN '"_PageNumber_"' AND '"_PageSize_"'"
		// 查询 JHIPV5.ESB.DB.MessageRetr 表数据 
		// 查询本地 JHIPV5.ESB.DB.MessageRetr
		Do ..GetCommonMessage(SelectSqlDB,.dataArr,.total)
	}Else{
		IF $L(StartTime)'=0{
			/** 根据时间筛选 ，选出该时间段内的最大最小ID **/
			Set tSC=..GetExtremeTime(StartTime,EndTime,.MAXID,.MINID)
			/** 通过最大最小ID来代替时间筛选 若最大ID为0，只查询大于最小值 **/
			Set TotalSQL="Select count(1) total from Ens.MessageHeader Where ID between '"_MINID_"' AND '"_MAXID_"' And (SourceConfigName='"_ThemeName_"' or TargetConfigName ='"_ThemeName_"' ) "
			Set:MAXID=0 TotalSQL="Select count(1) total from Ens.MessageHeader Where ID > '"_MINID_"'  And (SourceConfigName='"_ThemeName_"' or TargetConfigName ='"_ThemeName_"' ) "
			/** 消息状态 **/  
			Set:$L(MessageStatus)'=0 TotalSQL = TotalSQL_" and Status = '"_MessageStatus_"'"
			/** 消息类型 ：请求 响应 **/ 
			Set:$L(MessageType)'=0 TotalSQL = TotalSQL_" and Type = '"_MessageType_"' "
			/**  计算总条数 **/
			Set tSC=..Adapter.ExecuteQuery(.totalResult,TotalSQL)
			IF totalResult.%Next(){
				Set total=totalResult.%Get("total")
			}
			/** 二分法 计算总行数,根据页码数来选择最优Top **/
			Set half=total/2
			/** 避免因total太小走反向代码 **/
			if (half>PageSize)||(total<50){
				Set SelectSqlDB="SELECT %VID AS ContentID ,* FROM (Select TOP '"_PageSize_"'  ID,SessionId, SourceConfigName,TargetConfigName,Status,TimeCreated ,TimeProcessed ,Type From Ens.MessageHeader Where ID between '"_MINID_"' AND '"_MAXID_"' And (SourceConfigName='"_ThemeName_"' or TargetConfigName ='"_ThemeName_"' ) "
				Set:MAXID=0 SelectSqlDB="SELECT %VID AS ContentID ,* FROM (Select TOP '"_PageSize_"'  ID,SessionId, SourceConfigName,TargetConfigName,Status,TimeCreated ,TimeProcessed ,Type From Ens.MessageHeader Where ID > '"_MINID_"'  And (SourceConfigName='"_ThemeName_"' or TargetConfigName ='"_ThemeName_"' ) "
				/** 消息状态 **/  
				Set:$L(MessageStatus)'=0 SelectSqlDB = SelectSqlDB_" and Status = '"_MessageStatus_"' " 
				/** 消息类型 ：请求 响应 **/ 
				Set:$L(MessageType)'=0 SelectSqlDB = SelectSqlDB_" and Type = '"_MessageType_"' " 
				Set SelectSqlDB=SelectSqlDB_" Order by id DESC )WHERE %VID BETWEEN '"_PageNumber_"' AND '"_PageSize_"'"
			}Else{
				/** 计算页码数 反向 **/
				Set PageSize = total-PageSize 
				Set PageNumber = PageSize-Size+1 
				Set:PageNumber<1 PageNumber=1 
				Set SelectSqlDB="SELECT %VID AS ContentID ,* FROM (Select TOP '"_PageSize_"'  ID,SessionId, SourceConfigName,TargetConfigName,Status,TimeCreated ,TimeProcessed ,Type From Ens.MessageHeader Where ID between '"_MINID_"' AND '"_MAXID_"' And (SourceConfigName='"_ThemeName_"' or TargetConfigName ='"_ThemeName_"' ) "
				Set:MAXID=0 SelectSqlDB="SELECT %VID AS ContentID ,* FROM (Select TOP '"_PageSize_"'  ID,SessionId, SourceConfigName,TargetConfigName,Status,TimeCreated ,TimeProcessed ,Type From Ens.MessageHeader Where ID > '"_MINID_"' And (SourceConfigName='"_ThemeName_"' or TargetConfigName ='"_ThemeName_"' ) "
				Set:$L(MessageStatus)'=0 SelectSqlDB = SelectSqlDB_" and Status = '"_MessageStatus_"' " 
				/** 消息类型 ：请求 响应 **/ 
				Set:$L(MessageType)'=0 SelectSqlDB = SelectSqlDB_" and Type = '"_MessageType_"' " 
				Set SelectSqlDB=SelectSqlDB_"  )WHERE %VID BETWEEN '"_PageNumber_"' AND '"_PageSize_"' Order By ID desc"
			}
		}Else{
			/** 根据主题检索 无时间筛选 **/
			Set TotalSQL="Select count(1) total From Ens.MessageHeader Where (SourceConfigName='"_ThemeName_"' or TargetConfigName ='"_ThemeName_"' ) "
			/** 消息状态 **/  
			Set:$L(MessageStatus)'=0 TotalSQL = TotalSQL_" and Status = '"_MessageStatus_"'"
			/** 消息类型 ：请求 响应 **/ 
			Set:$L(MessageType)'=0 TotalSQL = TotalSQL_" and Type = '"_MessageType_"' "
			/**  计算总条数 **/
			Set tSC=..Adapter.ExecuteQuery(.totalResult,TotalSQL)
			IF totalResult.%Next(){
				Set total=totalResult.%Get("total")
			}
			/** 二分法 计算总行数,根据页码数来选择最优Top **/
			Set half=total/2
			/** 避免因total太小走反向代码 **/
			if half>PageSize||(total<50){
				Set SelectSqlDB="SELECT %VID AS ContentID ,* FROM (Select TOP '"_PageSize_"' ID,SessionId, SourceConfigName,TargetConfigName,Status,TimeCreated ,TimeProcessed ,Type From Ens.MessageHeader Where (SourceConfigName='"_ThemeName_"' or TargetConfigName ='"_ThemeName_"' ) "
				Set:$L(MessageStatus)'=0 SelectSqlDB = SelectSqlDB_" and Status = '"_MessageStatus_"' " 
				/** 消息类型 ：请求 响应 **/ 
				Set:$L(MessageType)'=0 SelectSqlDB = SelectSqlDB_" and Type = '"_MessageType_"' " 			
				Set SelectSqlDB=SelectSqlDB_" Order by id DESC )WHERE %VID BETWEEN '"_PageNumber_"' AND '"_PageSize_"'"
			}Else{
				/** 计算页码数 反向 **/
				Set PageSize = total-PageSize 
				Set PageNumber = PageSize-Size+1
				/** 排除最后一页页码为负数 **/
				Set:PageNumber<1 PageNumber=1 
				Set SelectSqlDB="SELECT %VID AS ContentID ,* FROM (Select TOP '"_PageSize_"' ID,SessionId, SourceConfigName,TargetConfigName,Status,TimeCreated ,TimeProcessed ,Type From Ens.MessageHeader Where (SourceConfigName='"_ThemeName_"' or TargetConfigName ='"_ThemeName_"' ) "
				Set:$L(MessageStatus)'=0 SelectSqlDB = SelectSqlDB_" and Status = '"_MessageStatus_"' " 
				/** 消息类型 ：请求 响应 **/ 
				Set:$L(MessageType)'=0 SelectSqlDB = SelectSqlDB_" and Type = '"_MessageType_"' " 			
				Set SelectSqlDB=SelectSqlDB_"  )WHERE %VID BETWEEN '"_PageNumber_"' AND '"_PageSize_"' Order By ID desc"
			}
		}
		Set tSC=..Adapter.ExecuteQuery(.tResult,SelectSqlDB)
		While tResult.%Next(){
			Set NewFiled = ##class(%DynamicObject).%New()
			Do NewFiled.%Set("ID",tResult.%Get("ID"))
			Do NewFiled.%Set("SessionId",tResult.%Get("SessionId"))
			Set Type=tResult.%Get("Type")
			// 通过类型来判断源和目标,来保证主题为BS
			IF Type=1{
				Set SourceConfigName=tResult.%Get("SourceConfigName")
				Set TargetConfigName=tResult.%Get("TargetConfigName")
			} Else{
				Set SourceConfigName=tResult.%Get("TargetConfigName")
				Set TargetConfigName=tResult.%Get("SourceConfigName")
			}
			Do NewFiled.%Set("ThemeName",SourceConfigName)
			Do NewFiled.%Set("TargetConfigName",TargetConfigName)
			Do NewFiled.%Set("MessageStatus",tResult.%Get("Status"))
			/** 计算耗时 **/ 
			Set TimeProcessed=$TRanslate(tResult.%Get("TimeProcessed"),"-, ,:,.")
			Set TimeCreated=$TRanslate(tResult.%Get("TimeCreated"),"-, ,:,.")
			Set SpendTime=TimeProcessed-TimeCreated
			Do NewFiled.%Set("StartTime",tResult.%Get("TimeCreated"))
			Do NewFiled.%Set("SpendTime",SpendTime)
			Do NewFiled.%Set("MessageType",tResult.%Get("Type"))
			Do dataArr.%Push(NewFiled)
		}
	}
	Set pResponse=dataArr
	Set Total=total
}

/// 根据会话ID查询 通过适配器 DSN 方式
Method GetMessageBySessionID(SQL As %String, Output DataArr As %DynamicObject, Output Total As %DynamicObject) As %Status
{
	Set tStatment = ##class(%SQL.Statement).%New()
	Set dataArr = ##class(%DynamicArray).%New()
	Set tSC=..Adapter.ExecuteQuery(.tResult,SQL)
	Set total=0
	While tResult.%Next(){
		Set NewFiled = ##class(%DynamicObject).%New()
		Do NewFiled.%Set("ID",tResult.%Get("ID"))
		Do NewFiled.%Set("SessionId",tResult.%Get("SessionId"))
		Set Type=tResult.%Get("Type")
		// 通过类型来判断源和目标
		IF Type=1{
			Set SourceConfigName=tResult.%Get("SourceConfigName")
			Set TargetConfigName=tResult.%Get("TargetConfigName")
		} Else{
			Set SourceConfigName=tResult.%Get("TargetConfigName")
			Set TargetConfigName=tResult.%Get("SourceConfigName")
		}
		Do NewFiled.%Set("ThemeName",SourceConfigName)
		Do NewFiled.%Set("TargetConfigName",TargetConfigName)
		Do NewFiled.%Set("MessageStatus",tResult.%Get("Status"))
		Set TimeProcessed=$TRanslate(tResult.%Get("TimeProcessed"),"-, ,:,.")
	   	Set TimeCreated=$TRanslate(tResult.%Get("TimeCreated"),"-, ,:,.")
		Set total=tResult.%Get("total")
		Set SpendTime=TimeProcessed-TimeCreated
		Do NewFiled.%Set("StartTime",tResult.%Get("TimeCreated"))
		Do NewFiled.%Set("SpendTime",SpendTime)
		Do NewFiled.%Set("MessageType",tResult.%Get("Type"))
		Do dataArr.%Push(NewFiled)
	}
	Set DataArr=dataArr
	Set Total=total
}

/// 根据时间段内获取ID的最大最小值
Method GetExtremeTime(StartTime As %String, EndTime As %String, Output MaxID As %String, Output MinID As %String) As %Status
{
	
	Set MaxID=0,MinID=0
	/** 获取最大ID **/
	Set MaxSQL = "Select top 1 ID From Ens.MessageHeader Where TimeCreated >='"_EndTime_"' "
	Set tSC=..Adapter.ExecuteQuery(.MaxResult,MaxSQL)
	IF MaxResult.%Next(){
		Set MaxID=MaxResult.%Get("ID")
	}
	/** 获取最小ID **/
	Set MinSQL = "Select top 1 ID From Ens.MessageHeader Where TimeCreated >='"_StartTime_"' "
	Set tSC=..Adapter.ExecuteQuery(.MinResult,MinSQL)
	IF MinResult.%Next(){
		Set MinID=MinResult.%Get("ID")
	}
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
