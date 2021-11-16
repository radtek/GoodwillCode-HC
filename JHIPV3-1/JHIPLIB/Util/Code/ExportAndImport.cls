/// Classname JHIPLIB.Util.Code.ExportAndImport
/// Summary   代码导出/导入工具，参数一ClassName为需要操作的类名，参数二FilePath为需要操作的路径。<br>
/// Summary   返回参数为导出/导入状态 <br>
/// Version   1.0<br>
/// Date      2020年05月11日 15:15:39<br>
/// Author    ZBT<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPLIB.Util.Code.ExportAndImport Extends Ens.BusinessOperation
{

Method ExportAndImport(pInput As JHIPLIB.Util.Code.MSG.Requst, ByRef pOutput As Ens.StringResponse) As %Boolean
{
	Try{
		Set pOutput=##class(Ens.StringResponse).%New()
		IF ..%ConfigName="JHIP代码导出工具"{
			Set tSC= $system.OBJ.Export(pInput.ClassName_".cls",pInput.FilePath_"\"_$p(pInput.ClassName,".",*)_".xml")
			Set str=pInput.ClassName_"导出成功，请验证！导出路径为："_pInput.FilePath_"\"_$p(pInput.ClassName,".",*)_".xml"
		}ELSEIF ..%ConfigName="JHIP代码导入工具" {
			Set tSC= $system.OBJ.Load(pInput.FilePath,"cbrpsuy")
			Set str=pInput.ClassName_"导入成功，请验证！"
		}ELSE{
			Set str="系统级管理请不要随意添加修改！"_..%ConfigName_"组件异常！"
			$$$LOGERROR(str)
			}
		
		
		IF $$$ISERR(tSC){
			Set str="输入类名或者路径有误，请验证！" 
			$$$LOGERROR(str)
			Quit
		}ELSE{
			 
			Set pOutput.StringValue=str	
			}
	}catch(ex){		
		 $$$LOGERROR(ex.DisplayString())
		}
	Quit tSC
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="JHIPLIB.Util.Code.MSG.Requst"> 
		<Method>ExportAndImport</Method>
	</MapItem>
	
</MapItems>
}

}
