/// Classname:	JHIPV5.JHREG.DB.StructureManagement
/// Summary:	结构管理-files表
/// TODO:		结构管理-files表
/// Version:	1.0;
/// Date:		
/// Author:		
/// Copyright:	北京嘉和美康信息技术有限公司;
Class JHIPV5.JHREG.DB.StructureManagementFilesDB Extends %Persistent
{

/// 导入文件名
Property FileName As %String;

/// 文件类别
Property FileType As %String;

/// 服务器ip
Property ipAdress As %String;

Storage Default
{
<Data name="StructureManagementFilesDBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StandardName</Value>
</Value>
<Value name="3">
<Value>FileName</Value>
</Value>
<Value name="4">
<Value>StandardType</Value>
</Value>
<Value name="5">
<Value>openStatus</Value>
</Value>
<Value name="6">
<Value>ManagerTime</Value>
</Value>
<Value name="7">
<Value>FileType</Value>
</Value>
<Value name="8">
<Value>ipAdress</Value>
</Value>
</Data>
<DataLocation>^JHIPV5.JHRCB30.StructureMaBFE6D</DataLocation>
<DefaultData>StructureManagementFilesDBDefaultData</DefaultData>
<IdLocation>^JHIPV5.JHRCB30.StructureMaBFE6D</IdLocation>
<IndexLocation>^JHIPV5.JHRCB30.StructureMaBFE6I</IndexLocation>
<StreamLocation>^JHIPV5.JHRCB30.StructureMaBFE6S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
