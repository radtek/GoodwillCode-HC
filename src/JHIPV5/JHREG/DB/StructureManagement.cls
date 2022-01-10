/// Classname:	JHIPV5.JHREG.DB.StructureManagement
/// Summary:	结构管理表
/// TODO:		结构管理表
/// Version:	1.0;
/// Date:		
/// Author:		
/// Copyright:	北京嘉和美康信息技术有限公司;
Class JHIPV5.JHREG.DB.StructureManagement Extends %Persistent
{

/// 标准名称
Property StandardName As %String;

/// 导入文件名
Property FileName As %String;

/// 标准类别
Property StandardType As %String;

/// 启用状态
Property openStatus As %String;

/// 操作时间
Property ManagerTime As %String;

/// 域ID
Property NameSpaceID As %String;

/// 是否为标准schema 只有hl7_2
Property standard As %String;

Storage Default
{
<Data name="StructureManagementDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StructureName</Value>
</Value>
<Value name="3">
<Value>StructureType</Value>
</Value>
<Value name="4">
<Value>openStatus</Value>
</Value>
<Value name="5">
<Value>ManagerTime</Value>
</Value>
<Value name="6">
<Value>StandardName</Value>
</Value>
<Value name="7">
<Value>StandardType</Value>
</Value>
<Value name="8">
<Value>FileName</Value>
</Value>
<Value name="9">
<Value>NameSpaceID</Value>
</Value>
<Value name="10">
<Value>standard</Value>
</Value>
</Data>
<DataLocation>^JHIPV5.JHRCB30.StructureMa86BAD</DataLocation>
<DefaultData>StructureManagementDefaultData</DefaultData>
<IdLocation>^JHIPV5.JHRCB30.StructureMa86BAD</IdLocation>
<IndexLocation>^JHIPV5.JHRCB30.StructureMa86BAI</IndexLocation>
<StreamLocation>^JHIPV5.JHRCB30.StructureMa86BAS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
