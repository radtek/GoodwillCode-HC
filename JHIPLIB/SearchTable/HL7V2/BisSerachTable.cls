/// Classname JHIPLIB.SOAP.SerachTable.BisSerachTable
/// Summary   血库消息搜索
/// Version   1.0
/// Date      2019年01月225日 11:00
/// Author    马家齐
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPLIB.SearchTable.HL7V2.BisSerachTable Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "JHIPLIB.Util.MSG.JHRequestMsg";

// 住院ID

Property BINGRENZYID As %String(COLLATION = "EXACT");

Index BINGRENZYIDIdx On BINGRENZYID;

// 住院号

Property ZHUYUANHAO As %String(COLLATION = "EXACT");

Index ZHUYUANHAOIdx On ZHUYUANHAO;

// 病人ID

Property BINGRENID As %String(COLLATION = "EXACT");

Index BINGRENIDIdx On BINGRENID;

/// Callback which <strong>MUST</strong> be implemented by users to populate the CustomSearchTable
/// supplied in <var>pSearchTable</var> based on the source object in <var>pDocObj</var>. Note that
/// the <property>DocId</property> property is prepopulated, so doesn't need to be reset. If the user doesn't
/// want a particular CustomSearchTable instance to be saved, the user can set <var>pSearchTable</var>
/// to the empty string (i.e. "") to prevent the indexing framework from saving an entry to disk.
ClassMethod OnIndexDoc(pDocObj As JHIPLIB.Util.MSG.JHRequestMsg, pSearchTable As JHIPLIB.SearchTable.HL7V2.BisSerachTable) As %Status [ SqlProc ]
{
	Set xml=##class(EnsLib.EDI.XML.Document).%New()
	try{
		Set xml=##class(EnsLib.EDI.XML.Document).%New()
		//将pDocObj转换成JHIPLIB.JHIPV5.SubScriber.MSG.PSubscribersMSG类型
		Set xml=xml.ImportFromString(pDocObj.pArg.GetAt(1),.tSC)
		if pDocObj.action="JH0311"{
			Set pSearchTable.BINGRENID=xml.GetValueAt("/BLOOD_TRANSFUSION/BINGRENID")
			Set pSearchTable.ZHUYUANHAO=xml.GetValueAt("/BLOOD_TRANSFUSION/BINGRENZYID")
			Set pSearchTable.BINGRENZYID=xml.GetValueAt("/BLOOD_TRANSFUSION/ZHUYUANHAO")
		}elseif pDocObj.action="JH0603"{
			Set pSearchTable.BINGRENID=xml.GetValueAt("/Request/datas/name")
			Set pSearchTable.ZHUYUANHAO=xml.GetValueAt("/BLOOD_CHARGE/BINGRENID")
		}
	}catch{
		$$$TRACE("SearchTable运行出错")
	}
	Quit $$$OK
}

Storage Default
{
<Data name="BisSerachTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocId</Value>
</Value>
<Value name="3">
<Value>BINGRENZYID</Value>
</Value>
<Value name="4">
<Value>ZHUYUANHAO</Value>
</Value>
<Value name="5">
<Value>BINGRENID</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SeaED36.BisSerachTableD</DataLocation>
<DefaultData>BisSerachTableDefaultData</DefaultData>
<IdLocation>^JHIPLIB.SeaED36.BisSerachTableD</IdLocation>
<IndexLocation>^JHIPLIB.SeaED36.BisSerachTableI</IndexLocation>
<StreamLocation>^JHIPLIB.SeaED36.BisSerachTableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
