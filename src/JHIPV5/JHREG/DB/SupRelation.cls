Class JHIPV5.JHREG.DB.SupRelation Extends %Persistent
{

Property Name As %String;

// bp组件名

Property className As %String;

// bp class名

Property bsId As %String(MAXLEN = "");

// 主题id

Property ifInitialization As %String;

// 是否为初始化数据

Property boName As %String(MAXLEN = "");

// 订户名 

Property pubSystem As %String;

// 发布系统 

Property subSystem As %String;

// 订阅系统

Property nameSpaceId As %String;

// 域id  

Property nameSpace As %String;

// 域名称

Property openStatus As %Numeric;

// 启用停用状态  

Property Category As %String;

// 分类

Storage Default
{
<Data name="SupRelationDefaultData">
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
<Value>bsName</Value>
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
<Value>ThemeId</Value>
</Value>
<Value name="13">
<Value>ThemeName</Value>
</Value>
<Value name="14">
<Value>Category</Value>
</Value>
<Value name="15">
<Value>boIdJSON</Value>
</Value>
<Value name="16">
<Value>boId</Value>
</Value>
<Value name="17">
<Value>ifInitialization</Value>
</Value>
</Data>
<DataLocation>^JHIPV5.JHREG.DB.SupRelationD</DataLocation>
<DefaultData>SupRelationDefaultData</DefaultData>
<IdLocation>^JHIPV5.JHREG.DB.SupRelationD</IdLocation>
<IndexLocation>^JHIPV5.JHREG.DB.SupRelationI</IndexLocation>
<StreamLocation>^JHIPV5.JHREG.DB.SupRelationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
