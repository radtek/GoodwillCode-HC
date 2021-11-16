Class JHIPLIB.Util.Task.BackUp Extends %SYS.Task.Definition
{

/// 备份的路径
Property Path As %String;

/// 需要导出的代码所在包名
Property PackageName As %String;

Method OnTask() As %Status
{
	Set tSC=$system.OBJ.ExportPackage(..PackageName,..Path)
	Quit tSC
}

}
