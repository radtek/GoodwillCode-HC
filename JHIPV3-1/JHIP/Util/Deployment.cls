/// Classname JHIP.Util.Deployment
/// Summary   部署类
/// Version   1.0
/// Date      2020年02月10日 10:00
/// Author    ZBT
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIP.Util.Deployment
{

ClassMethod Entrance() As %Status
{
	w "开始部署！",!
	zn "%sys"
	//设置_system  账户永不过期
	Set sys=##Class(Security.Users).%OpenId("_system")
	Set sys.PasswordNeverExpires=1
	Set tsc= sys.%Save()
	w:tsc "_system密码已设置为永不过期！",!
	
	w "----------------------------------------------",!
	Set Namespace="JHIP"
	//设置Globals映射
	Set Properties("Database")="JHIPMSG"
	Set NameList=$LISTFROMSTRING("Ens.Util.IOLog*,Ens.Util.Log*,EnsLib.H.Message*,Ens.Message*,ERRORS,EnsLib.EDI.XML.*,EnsEDI.XML.Content",",")
	For i=1:1:($LISTLENGTH(NameList)){
		Set Name=$ZSTRIP(($LISTGET(NameList,i)),"<>W")
		w Name_"已经加载Globals映射，请确认！",!
		Set Status=##Class(Config.MapGlobals).Create(Namespace,Name,.Properties)
	}
	w "----------------------------------------------",!
	//设置Routines映射
	Set Properties("Database")="JHIPLIB"
	Set Name="JHIPLIB.*"
	w Name_"已经加载Routines映射，请确认！",!
	Set Status=##Class(Config.MapRoutines).Create(Namespace,Name,.Properties)
	w "----------------------------------------------",!
	//设置数据包映射
	Set Properties("Database")="JHIPLIB"
	Set Name="JHIPLIB"
	w Name_"已经加载数据包映射，请确认！",!
	Set Status=##Class(Config.MapPackages).Create(Namespace,Name,.Properties)
	zn "JHIP"
	//编译jhip.Production
	Set tSC =$system.OBJ.CompilePackage("jhip.Production")
	Do $system.OBJ.Export("ZAUTHENTICATE.mac",$System.Util.InstallDirectory()_"/ZAUTHENTICATE.xml")
	w:tSC "Production编译成功！",!
	//设置自启动Production
	Set tSC = $ClassMethod("EnsPortal.AutoStartProduction","ApplyID","JHIP.Production.JHIPV3")
	w:tSC "已设置自启动Production！",!
	w "----------------------------------------------",!
	
	//打补丁
	D $system.OBJ.Load("C:\EnsembleUpdate17272.xml","cbrpsuy")
	D $system.OBJ.Load("C:\EnsembleUpdate17320.xml","cbrpsuy")
	w "补丁配置完成",!
	w "----------------------------------------------",!
	zn "%sys"
	//配置内存与高级内存
	//设置启用长字符串
	Set Propert("EnableLongStrings") = 1
	Set tSC = ##Class(Config.Miscellaneous).Modify(.Propert)
	//为 8KB 数据库缓存分配的内存 (MB)--为 Routine 缓存分配的内存 (MB)
	READ "请选择此服务器安装模式（1.正式生产;2.故障转移;3.测试），选择序号：",MODE,!
	Set ^%SYS("SystemMode")=$CASE(MODE,"1":"LIVE","3":"TEST","2":"FAILOVER")
	zn "%sys"
	READ "请输入此服务器安装内存（单位:G）：",RAM,!
	Set RAM=RAM*1024
	Set Obj=##Class(Config.config).Open()
	Set Obj.routines=$P(RAM*0.05,".",1)+1
	Set Obj.globals8kb=$P(RAM*0.55,".",1)+1
	READ "请输入此服务器处理器核数：",NUM,!
	Set Obj.gmheap = NUM*64*1024
	Set Obj.locksiz = NUM*64*512*1000
	Set Obj.errlog = 10000
	Set Status=Obj.%Save()
	i 'Status w !,"Error="_$SYSTEM.Status.GetErrorText(Status)
	w:Status "内存与高级内存配置完成！",!
	w "----------------------------------------------",!
	//配置匿名访问功能
	//新建角色并配置角色到用户
	Set tSC = $ClassMethod("Security.Roles","Create","service_soap","","","")
	Set tSC = $ClassMethod("Security.Users","AddRoles","unknownuser","service_soap",1)
	//更改默认应用程序
	Set Application=##Class(Security.Applications).%OpenId("/csp/healthshare/jhip")
	Set Application.IsNameSpaceDefault=0
	Set Application.AutheEnabled=32
	Set Application.InbndWebServicesEnabled=1
	Set tsc= Application.%Save()
	//创建应用程序
	Set sc("AutheEnabled")=64,sc("IsNameSpaceDefault")=1,sc("MatchRoles")="service_soap:%EnsRole_Developer",sc("GroupById")="%ISCMgtPortal",sc("NameSpace")="JHIP",sc("DeepSeeEnabled")=1
	Set tSC=##Class(Security.Applications).Create("/soap",.sc)
	w:tSC "匿名访问配置完成",!
	w "----------------------------------------------",!
	//设置服务验证为委托
	Set bindings=##Class(Security.Services).%OpenId("%service_bindings")
	Set bindings.AutheEnabled=8192
	d bindings.%Save()
	//开启审计事件日志
	Set Event=##Class(Security.Events).%OpenId("%system||%login||login")
	Set Event.Enabled=1
	d Event.%Save()
	
	D $system.OBJ.Load($System.Util.InstallDirectory()_"/ZAUTHENTICATE.xml","cbrpsuy")
	//配置JHIP定时代码备份任务
	Set tSC = $ClassMethod("%SYS.TaskSuper","ImportTasks","C:\BackUpTASK.xml")
	w:tSC "代码定时备份任务配置完成",!
	Set tOK = ##class(%File).Delete($System.Util.InstallDirectory()_"/ZAUTHENTICATE.xml")
	w "部署完成！",!
	q tSC
}

}
