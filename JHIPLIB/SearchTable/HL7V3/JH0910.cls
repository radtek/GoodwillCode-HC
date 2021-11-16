/// Classname JHIPLIB.SOAP.SearchTable.SySearchTable
/// Summary   字典通用查询
/// Version   1.0
/// Date      2019年01月225日 11:00
/// Author    马家齐
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPLIB.SearchTable.HL7V3.JH0910 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "JHIPLIB.Util.MSG.JHRequestMsg";

// 字典名称

Property DICTNAME As %String(COLLATION = "EXACT");

Index DICTNAMEIdx On DICTNAME;

// 订阅系统

Property SUBSCRIBER As %String(COLLATION = "EXACT");

Index SUBSCRIBERIdx On SUBSCRIBER;

// 发布系统

Property PUBLISH As %String(COLLATION = "EXACT");

Index PUBLISHIdx On PUBLISH;

/// Callback which <strong>MUST</strong> be implemented by users to populate the CustomSearchTable
/// supplied in <var>pSearchTable</var> based on the source object in <var>pDocObj</var>. Note that
/// the <property>DocId</property> property is prepopulated, so doesn't need to be reset. If the user doesn't
/// want a particular CustomSearchTable instance to be saved, the user can set <var>pSearchTable</var>
/// to the empty string (i.e. "") to prevent the indexing framework from saving an entry to disk.
ClassMethod OnIndexDoc(pDocObj As JHIPLIB.Util.MSG.JHRequestMsg, pSearchTable As JHIPLIB.SearchTable.XML.SySearchTable) As %Status [ SqlProc ]
{
	Set DictMSG=##class(JHIPLIB.JHIPV5.SubScriber.MSG.PSubscribersMSG).%New()
	try{
		
		//将pDocObj转换成JHIPLIB.JHIPV5.SubScriber.MSG.PSubscribersMSG类型
		Set tSC=##class(JHIPLIB.Util.ClassAndXML).Xml2Object(pDocObj.pArg.GetAt(1),"REQUEST","JHIPLIB.JHIPV5.SubScriber.MSG.PSubscribersMSG",.DictMSG)
		Set pSearchTable.DICTNAME=DictMSG.DictName
		Set pSearchTable.SUBSCRIBER=DictMSG.SubscriberSystems
		Set pSearchTable.PUBLISH=DictMSG.PublishSystems
	}catch{
		$$$TRACE("SearchTable运行出错")
	}
	Quit $$$OK
}

Storage Default
{
<Data name="JH0910DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocId</Value>
</Value>
<Value name="3">
<Value>DICTNAME</Value>
</Value>
<Value name="4">
<Value>SUBSCRIBER</Value>
</Value>
<Value name="5">
<Value>PUBLISH</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SearchTable2DF7.JH0910D</DataLocation>
<DefaultData>JH0910DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SearchTable2DF7.JH0910D</IdLocation>
<IndexLocation>^JHIPLIB.SearchTable2DF7.JH0910I</IndexLocation>
<StreamLocation>^JHIPLIB.SearchTable2DF7.JH0910S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
