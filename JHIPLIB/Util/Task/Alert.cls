Class JHIPLIB.Util.Task.Alert Extends %SYS.Task.Definition
{

Method OnTask() As %Status
{
	Set tSC=##class(Ens.Director).CreateBusinessService("告警测试服务",.tService)
	Set tSC=tService.HIPMessageServer("CESHI")

	Quit tSC
}

}
