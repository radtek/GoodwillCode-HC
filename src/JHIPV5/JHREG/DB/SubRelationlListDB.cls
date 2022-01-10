Class JHIPV5.JHREG.DB.SubRelationlListDB Extends %Persistent
{

Property SubId As %String;

// 订阅关系id

Property boId As %String;

// 订户表中的id

Property ifAsyn As %String;

// 是否异步 1是 0否

Property RulesTransId As %String;

// 转换规则id

Storage Default
{
<Data name="SubRelationlListDBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SubId</Value>
</Value>
<Value name="3">
<Value>bsId</Value>
</Value>
<Value name="4">
<Value>ifAsyn</Value>
</Value>
<Value name="5">
<Value>boId</Value>
</Value>
<Value name="6">
<Value>RulesTransId</Value>
</Value>
</Data>
<DataLocation>^JHIPV5.JHRCB30.SubRelation7B31D</DataLocation>
<DefaultData>SubRelationlListDBDefaultData</DefaultData>
<IdLocation>^JHIPV5.JHRCB30.SubRelation7B31D</IdLocation>
<IndexLocation>^JHIPV5.JHRCB30.SubRelation7B31I</IndexLocation>
<StreamLocation>^JHIPV5.JHRCB30.SubRelation7B31S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
