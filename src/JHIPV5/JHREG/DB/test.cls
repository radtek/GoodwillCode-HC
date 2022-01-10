Class JHIPV5.JHREG.DB.test Extends %Persistent
{

Property Name As %String;

// bp组件名

Storage Default
{
<Data name="testDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>className</Value>
</Value>
<Value name="4">
<Value>bsId</Value>
</Value>
<Value name="5">
<Value>boId</Value>
</Value>
<Value name="6">
<Value>boName</Value>
</Value>
<Value name="7">
<Value>pubSystem</Value>
</Value>
<Value name="8">
<Value>subSystem</Value>
</Value>
<Value name="9">
<Value>nameSpaceId</Value>
</Value>
<Value name="10">
<Value>nameSpace</Value>
</Value>
<Value name="11">
<Value>openStatus</Value>
</Value>
<Value name="12">
<Value>Category</Value>
</Value>
</Data>
<DataLocation>^JHIPV5.JHREG.DB.testD</DataLocation>
<DefaultData>testDefaultData</DefaultData>
<IdLocation>^JHIPV5.JHREG.DB.testD</IdLocation>
<IndexLocation>^JHIPV5.JHREG.DB.testI</IndexLocation>
<StreamLocation>^JHIPV5.JHREG.DB.testS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
