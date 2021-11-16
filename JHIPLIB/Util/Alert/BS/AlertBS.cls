/// Classname JHIPLIB.SOAP.BS.HL7V3Service<br>
/// Summary   HL7V3SOAPBS封装类，参数Message为消息内容。<br>
/// Explain	  出参到BP时为EnsLib.EDI.XML.Document类型,唯一服务标识（BS名称前6位）会在XML对象的OriginalDocId属性中,可在BP流程设计中作为判断条件使用。<br>
/// Version   1.0<br>
/// Date      2019年4月29日 15:15:39<br>
/// Author    ZBT<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.Util.Alert.BS.AlertBS Extends EnsLib.SOAP.Service
{

Parameter ADAPTER;

Parameter SERVICENAME = "HL7V3Service";

Parameter NAMESPACE = "http://goodwillcis.com";

Parameter SETTINGS = "磁盘告警系数:Basic,队列告警数:Basic,TargetConfigNames:Basic:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

/// 接收消息的目标组件名称
Property TargetConfigNames As Ens.DataType.ConfigName;

/// 队列告警数:在监控队列信息中，如果排队数量超过设定的队列告警数，就会发出告警。
Property 队列告警数 As %String;

/// 磁盘告警系数（取值：0-1，如：0.25表示磁盘可用空间 小于 总体空间*0.25则告警）<br>	
/// 在监控磁盘信息中，如果磁盘可用系数小于设定的磁盘告警系数，就会发出告警。
Property 磁盘告警系数 As %String;

/// 队列告警数
/// Property 队列告警数 As %String;
Method HIPMessageServer(Message As %String) As %String [ WebMethod ]
{
	//为所有接口开启告警服务
	//调用队列信息进行告警 入参为告警参数
	Set tSC=..QUEUEInfo(.."队列告警数")
	//获取盘符信息，设置告警
	Set tSC=..Directory(.."磁盘告警系数")
	Set tSC=..MIRRORInfo()
	q tSC
	     ;s a=##class(SYS.History.SysData).GetCPU()
}

// 获取队列信息

Method QUEUEInfo(num As %String) As %Status
{
	
	Set Util=##class(JHIPLIB.Util.ClassAndXML).%New()
	SET mycall = "call  Ens.Queue_Enumerate()"
    SET tStatement = ##class(%SQL.Statement).%New()
    SET qStatus = tStatement.%Prepare(mycall),QueFlag=0
    SET rset =##class(%SQL.StatementResult).%New()
  	SET rset = tStatement.%Execute()
	  WHILE rset.%Next() {
	      SET Count=rset.%Get("Count")
	      SET Name=rset.%Get("Name")
	      IF Count>num {
		     	Set tSC=..GetAlertBody(Name,"队列信息告警","队列信息告警:"_Name_"的队列数目达到"_Count),QueFlag=1
		      	$$$LOGWARNING("队列信息告警:"_Name_"的队列数目达到"_Count)
		      }
	     }
	     IF 'QueFlag {$$$LOGINFO("队列信息正常")}
	 Quit qStatus
}

// 获取镜像信息

Method MIRRORInfo() As %Status
{
	zn "%SYS"
	Set Rset=##class(%ResultSet).%New("%CSP.UI.System.Mirror:MemberStatusList")
	Set qStatus=Rset.Execute(),count=0,ID=0
	zn "JHIPV3_1_0"
	while Rset.Next(){
		&sql(SELECT count(1) into:count FROM JHIPLIB_Util_Alert_DB.MirrorStatus)
		//存储镜像信息
		Set MemberName=Rset.Get("MemberName")
		Set (DatabaseTimeLatency,CurrentStatus,JournalTimeLatency)=""
		if count=0{
			Set MirrorStatus=##class(JHIPLIB.Util.Alert.DB.MirrorStatus).%New()
			Set MirrorStatus.MemberName=MemberName
			Set MirrorStatus.CurrentRole=Rset.Get("CurrentRole")
			Set MirrorStatus.CurrentStatus=Rset.Get("CurrentStatus")
			Set MirrorStatus.JournalTimeLatency=Rset.Get("JournalTimeLatency")
			Set MirrorStatus.DatabaseTimeLatency=Rset.Get("DatabaseTimeLatency")
			Set MirrorStatus.CreatedTime=$ZDT($H,3)
			Set MirrorStatus.IpAddress=..GetIpAddress(Rset.Get("MemberName"))
			D MirrorStatus.%Save()
		}else{
			//对比信息判断是否告警
			&sql(SELECT ID,CurrentStatus,DatabaseTimeLatency,JournalTimeLatency into:ID,:CurrentStatus,:DatabaseTimeLatency,:JournalTimeLatency FROM JHIPLIB_Util_Alert_DB.MirrorStatus where MemberName=:MemberName)
			//判断谁是主备机
			if CurrentStatus'=Rset.Get("CurrentStatus"){
				Set tSC=..GetAlertBody("镜像信息","镜像信息告警","镜像信息告警:镜像发生切换！"_MemberName_"由"_CurrentStatus_"切换至"_Rset.Get("CurrentStatus"))
			  }elseif CurrentStatus="Down"{
				 Set tSC=..GetAlertBody("镜像信息","镜像信息告警","镜像信息告警:镜像信息异常！"_MemberName_"的镜像状态为Down")
			  }else{
				 if CurrentStatus="主"{
					Set:Rset.Get("DatabaseTimeLatency")'="无" tSC=..GetAlertBody("镜像信息","镜像信息告警","镜像信息告警:"_MemberName_"镜像数据库信息异常！"_Rset.Get("DatabaseTimeLatency"))
				  	Set:Rset.Get("JournalTimeLatency")'="无" tSC=..GetAlertBody("镜像信息","镜像信息告警","镜像信息告警:"_MemberName_"镜像Journal信息同步异常！"_Rset.Get("JournalTimeLatency"))
				  }elseif CurrentStatus="备份"{
					Set:Rset.Get("DatabaseTimeLatency")'="已捕获" tSC=..GetAlertBody("镜像信息","镜像信息告警","镜像信息告警:"_MemberName_"镜像数据库信息异常！"_Rset.Get("DatabaseTimeLatency"))
				  	Set:Rset.Get("JournalTimeLatency")'="活动" tSC=..GetAlertBody("镜像信息","镜像信息告警","镜像信息告警:"_MemberName_"镜像Journal信息同步异常！"_Rset.Get("JournalTimeLatency"))
				  }
				}
			//更新数据库存储信息
			Set MirrorStatus=##class(JHIPLIB.Util.Alert.DB.MirrorStatus).%OpenId(ID)
			Set MirrorStatus.MemberName=MemberName
			Set MirrorStatus.CurrentRole=Rset.Get("CurrentRole")
			Set MirrorStatus.CurrentStatus=Rset.Get("CurrentStatus")
			Set MirrorStatus.JournalTimeLatency=Rset.Get("JournalTimeLatency")
			Set MirrorStatus.DatabaseTimeLatency=Rset.Get("DatabaseTimeLatency")
			Set MirrorStatus.CreatedTime=$ZDT($H,3)
			Set MirrorStatus.IpAddress=..GetIpAddress(Rset.Get("MemberName"))
			D MirrorStatus.%Save()
		 }
	}
	D Rset.Close()
	Quit qStatus
}

// 获取磁盘信息

Method Directory(num As %String) As %Status
{
	//c系统盘符
	Set tSC=##class(%File).GetDirectorySpace("c:/",.Space,.Total,2),DirectoryFlag=0
	Set Used=Space/Total
	IF Used<num {
		  Set tSC=..GetAlertBody("磁盘信息","磁盘信息告警","磁盘信息告警:C盘的可用系数不足"_num),DirectoryFlag=1
		  $$$LOGWARNING("磁盘信息告警:C盘的可用系数不足"_num)
		}
	//安装盘符
	Set tSC=##class(%File).GetDirectorySpace($System.Util.InstallDirectory(),.Space,.Total,2),DirectoryFlag=0
	Set Used=Space/Total
	IF Used<num {
		  Set tSC=..GetAlertBody("磁盘信息","磁盘信息告警","磁盘信息告警:安装目录所在"_$e($System.Util.InstallDirectory(),":",1)_"盘的可用系数不足"_num),DirectoryFlag=1
		  $$$LOGWARNING("磁盘信息告警:安装目录所在"_$e($System.Util.InstallDirectory(),":",1)_"盘的可用系数不足"_num)
		}
	//journal盘符
	Set (one,two,DATA)="C"
	zn "%sys"
	Set CONFIG=##Class(Config.config).%OpenId("CACHE||Journal||Journal")
	Set one=CONFIG.bbsiz,two=CONFIG.Asyncwij
	Set CONFIG=##Class(Config.config).%OpenId("CACHE||Databases||JHIPMSG")
	Set DATA=CONFIG.AsyncwijPresent
	ZN "JHIPV3_1_0"
	IF two=one{$$$LOGWARNING("journal目录：一级与二级一致，请修改！都为"_one)}
	//journal一级目录监控
	Set tSC=##class(%File).GetDirectorySpace(one,.Space,.Total,2),DirectoryFlag=0
	Set Used=Space/Total
	IF Used<num {
		  Set tSC=..GetAlertBody("磁盘信息","磁盘信息告警","磁盘信息告警:journal一级目录所在"_$e(one,":",1)_"盘的可用系数不足"_num),DirectoryFlag=1
		  $$$LOGWARNING("磁盘信息告警:journal一级目录所在"_$e(one,":",1)_"盘的可用系数不足"_num)
		}
	//journal二级目录监控
	Set tSC=##class(%File).GetDirectorySpace(two,.Space,.Total,2),DirectoryFlag=0
	Set Used=Space/Total
	IF Used<num {
		  Set tSC=..GetAlertBody("磁盘信息","磁盘信息告警","磁盘信息告警:journal二级目录所在"_$e(two,":",1)_"盘的可用系数不足"_num),DirectoryFlag=1
		  $$$LOGWARNING("磁盘信息告警:journal二级目录所在"_$e(two,":",1)_"盘的可用系数不足"_num)
		}
	//MSG数据库监控
	Set tSC=##class(%File).GetDirectorySpace(DATA,.Space,.Total,2),DirectoryFlag=0
	Set Used=Space/Total
	IF Used<num {
		  Set tSC=..GetAlertBody("磁盘信息","磁盘信息告警","磁盘信息告警:数据库目录所在"_$e(DATA,":",1)_"盘的可用系数不足"_num),DirectoryFlag=1
		  $$$LOGWARNING("磁盘信息告警:数据库目录所在"_$e(DATA,":",1)_"盘的可用系数不足"_num)
		}	
		
	    IF 'DirectoryFlag {$$$LOGINFO("磁盘信息正常")}
	 Quit tSC
}

// 该方法拼成告警信息发送给告警组件：

// ConfigName组件名称；AlertLevel告警等级查询联系人与告警级别；AlertText告警描述

Method GetAlertBody(ConfigName As %String, AlertLevel As %String, AlertText As %String) As %Status
{
	
	Set pInput=##class(EnsLib.EDI.XML.Document).%New()
	&Sql(SELECT FileBody INTO :FileBody  FROM JHIPLIB_Util_Save_DB.SaveDB WHERE FileName='告警消息体')
	If $L(FileBody)=0 {$$$LOGERROR("告警消息体模版未在库中存储，请先进行存储！") }
	Set Level=^Ens.LookupTable("AlertLevel",AlertLevel)
	Set ContactPerson=^Ens.LookupTable("AlertContactINFO",Level)
	Set pInput=pInput.ImportFromString(FileBody,.statu)
	Set tSC=pInput.SetValueAt(ConfigName,"/AlertRequest/SourceConfigName")
	Set tSC=pInput.SetValueAt(ContactPerson,"/AlertRequest/ContactPerson")
	Set tSC=pInput.SetValueAt(AlertText,"/AlertRequest/AlertText")
	Set tSC=pInput.SetValueAt($ZDT($H,3),"/AlertRequest/AlertTime")
	Set tSC=pInput.SetValueAt(Level,"/AlertRequest/AlertLevel")
	Set tSC=..SendRequestAsync("Ens.Alert",pInput)
	Quit tSC
}

// 获取镜像对应的IP

Method GetIpAddress(MirrorName As %String) As %String
{
	
	zn "%sys"
	d ##Class(Config.MapMirrors).Get("JHIPMIRROR",MirrorName,.Properties)
	zn "JHIPV3_1_0"
	Quit Properties("MirrorAddress")
}

}
