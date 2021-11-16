/// Classname JHIPLIB.SOAP.SearchTable.PermissionsSearchTable
/// Summary   权限消息搜索
/// Version   1.0
/// Date      2019年01月225日 11:00
/// Author    马家齐
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPLIB.SearchTable.XML.PermissionsSearchTable Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "JHIPLIB.Util.MSG.JHRequestMsg";

// 字典名称

Property SYSTEMCODE As %String(COLLATION = "EXACT");

Index SYSTEMCODEIdx On SYSTEMCODE;

/// Callback which <strong>MUST</strong> be implemented by users to populate the CustomSearchTable
/// supplied in <var>pSearchTable</var> based on the source object in <var>pDocObj</var>. Note that
/// the <property>DocId</property> property is prepopulated, so doesn't need to be reset. If the user doesn't
/// want a particular CustomSearchTable instance to be saved, the user can set <var>pSearchTable</var>
/// to the empty string (i.e. "") to prevent the indexing framework from saving an entry to disk.
ClassMethod OnIndexDoc(pDocObj As JHIPLIB.Util.MSG.JHRequestMsg, pSearchTable As JHIPLIB.SearchTable.XML.PermissionsSearchTable) As %Status [ SqlProc ]
{
	Set xml=##class(EnsLib.EDI.XML.Document).%New()
	try{
		
		//将pDocObj转换成JHIPLIB.JHIPV5.SubScriber.MSG.PSubscribersMSG类型
		Set xml=xml.ImportFromString(pDocObj.pArg.GetAt(1),.tSC)
		Set pSearchTable.SYSTEMCODE=xml.GetValueAt("/REQUEST/SYSTEM_CODE")
	}catch{
		$$$TRACE("SearchTable运行出错")
	}
	Quit $$$OK
}

Storage Default
{
<Data name="PermissionsSearchTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocId</Value>
</Value>
<Value name="3">
<Value>SYSTEMCODE</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SeA85C.PermissionsB385D</DataLocation>
<DefaultData>PermissionsSearchTableDefaultData</DefaultData>
<IdLocation>^JHIPLIB.SeA85C.PermissionsB385D</IdLocation>
<IndexLocation>^JHIPLIB.SeA85C.PermissionsB385I</IndexLocation>
<StreamLocation>^JHIPLIB.SeA85C.PermissionsB385S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
