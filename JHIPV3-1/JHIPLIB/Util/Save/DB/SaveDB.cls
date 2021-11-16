/// Classname JHIPLIB.Util.Save.DB.SaveDB<br>
/// Summary   存储容器DB<br>
/// Version   1.0<br>
/// Date      2019年7月18日 10:00<br>
/// Author    ZBT<br>
/// Copyright 北京嘉和美康信息技术有限公司<br>
/// xsl存储表
Class JHIPLIB.Util.Save.DB.SaveDB Extends %Persistent
{

Index FileName On FileName;

/// 名称
Property FileName As %String;

/// 主体
Property FileBody As %String(MAXLEN = "");

/// 最后操作时间
Property OperationFileTIME As %String;

/// 操作类型
Property FileType As %String;

Storage Default
{
<Data name="SaveDBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FileName</Value>
</Value>
<Value name="3">
<Value>FileBody</Value>
</Value>
<Value name="4">
<Value>OperationFileTIME</Value>
</Value>
<Value name="5">
<Value>FileType</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.Util.Save.DB.SaveDBD</DataLocation>
<DefaultData>SaveDBDefaultData</DefaultData>
<IdLocation>^JHIPLIB.Util.Save.DB.SaveDBD</IdLocation>
<IndexLocation>^JHIPLIB.Util.Save.DB.SaveDBI</IndexLocation>
<StreamLocation>^JHIPLIB.Util.Save.DB.SaveDBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
