/// Classname JHIPLIB.SearchTable.XML.BaseSearchTable20
/// Summary   XML通用查询20,请在数据查找表中建立SearchTablePath表,添加查询路径,具体操作见操作文档.
/// Version   1.0
/// Date      2019年11月28日 11:00
/// Author    ZBT
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPLIB.SearchTable.XML.BaseSearchTable20 Extends Ens.CustomSearchTable
{

Parameter DOCCLASS = "EnsLib.EDI.XML.Document";

Property Search1 As %String(COLLATION = "EXACT", MAXLEN = 200);

Index Search1Idx On Search1;

Property Search2 As %String(COLLATION = "EXACT", MAXLEN = 200);

Index Search2Idx On Search2;

Property Search3 As %String(COLLATION = "EXACT", MAXLEN = 200);

Index Search3Idx On Search3;

Property Search4 As %String(COLLATION = "EXACT", MAXLEN = 200);

Index Search4Idx On Search4;

Property Search5 As %String(COLLATION = "EXACT", MAXLEN = 200);

Index Search5Idx On Search5;

Property Search6 As %String(COLLATION = "EXACT", MAXLEN = 200);

Index Search6Idx On Search6;

Property Search7 As %String(COLLATION = "EXACT", MAXLEN = 200);

Index Search7Idx On Search7;

Property Search8 As %String(COLLATION = "EXACT", MAXLEN = 200);

Index Search8Idx On Search8;

Property Search9 As %String(COLLATION = "EXACT", MAXLEN = 200);

Index Search9Idx On Search9;

Property Search10 As %String(COLLATION = "EXACT", MAXLEN = 200);

Index Search10Idx On Search10;

ClassMethod OnIndexDoc(pDocObj As EnsLib.EDI.XML.Document, pSearchTable As JHIPLIB.SearchTable.XML.BaseSearchTable20) As %Status [ SqlProc ]
{
	
	try{
		Set Type=pDocObj.OriginalDocId
		//查询LookupTable中
		&sql(SELECT DataValue Into :SearchPath FROM Ens_Util.LookupTable WHERE KeyName =:Type AND TableName='SearchTablePath')
		IF $L(SearchPath)=0 {$$$LOGWARNING("SearchTable运行在数据查找表SearchTablePath中,没有找到"_ALIASNAME_"的搜索路径配置信息,请确认!")}
		//将Value里的属性值存入SearchTable表
		Set:$L($p(SearchPath,",",1))'=0 pSearchTable.Search1=pDocObj.GetValueAt($p(SearchPath,",",1))
		Set:$L($p(SearchPath,",",2))'=0 pSearchTable.Search2=pDocObj.GetValueAt($p(SearchPath,",",2))
		Set:$L($p(SearchPath,",",3))'=0 pSearchTable.Search3=pDocObj.GetValueAt($p(SearchPath,",",3))
		Set:$L($p(SearchPath,",",4))'=0 pSearchTable.Search4=pDocObj.GetValueAt($p(SearchPath,",",4))
		Set:$L($p(SearchPath,",",5))'=0 pSearchTable.Search5=pDocObj.GetValueAt($p(SearchPath,",",5))
		Set:$L($p(SearchPath,",",6))'=0 pSearchTable.Search6=pDocObj.GetValueAt($p(SearchPath,",",6))
		Set:$L($p(SearchPath,",",7))'=0 pSearchTable.Search7=pDocObj.GetValueAt($p(SearchPath,",",7))
		Set:$L($p(SearchPath,",",8))'=0 pSearchTable.Search8=pDocObj.GetValueAt($p(SearchPath,",",8))
		Set:$L($p(SearchPath,",",9))'=0 pSearchTable.Search9=pDocObj.GetValueAt($p(SearchPath,",",9))
		Set:$L($p(SearchPath,",",10))'=0 pSearchTable.Search10=pDocObj.GetValueAt($p(SearchPath,",",10))
	}catch{
		$$$LOGERROR("SearchTable运行出错")
	}
	Quit $$$OK
}

Storage Default
{
<Data name="BaseSearchTable20DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DocId</Value>
</Value>
<Value name="3">
<Value>Search2</Value>
</Value>
<Value name="4">
<Value>Search3</Value>
</Value>
<Value name="5">
<Value>Search4</Value>
</Value>
<Value name="6">
<Value>Search5</Value>
</Value>
<Value name="7">
<Value>Search6</Value>
</Value>
<Value name="8">
<Value>Search7</Value>
</Value>
<Value name="9">
<Value>Search8</Value>
</Value>
<Value name="10">
<Value>Search9</Value>
</Value>
<Value name="11">
<Value>Search10</Value>
</Value>
<Value name="12">
<Value>Search1</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.SeA85C.BaseSearchT6AD2D</DataLocation>
<DefaultData>BaseSearchTable20DefaultData</DefaultData>
<IdLocation>^JHIPLIB.SeA85C.BaseSearchT6AD2D</IdLocation>
<IndexLocation>^JHIPLIB.SeA85C.BaseSearchT6AD2I</IndexLocation>
<StreamLocation>^JHIPLIB.SeA85C.BaseSearchT6AD2S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
