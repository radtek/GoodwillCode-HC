/// Classname:	JHIPV5.JHREG.DB.DomainDB
/// Summary:	JHIPV5.3 域管理DB;
/// TODO:		JHIPV5.3 域管理DB,维护域的相关信息;
/// Version:	1.0;
/// Date:		2021年11月29日;
/// Author:		ZFT;
/// Copyright:	北京嘉和美康信息技术有限公司;
Class JHIPV5.JHREG.DB.DomainDB Extends %Persistent
{

/// 域编号
Property DomainID As %String(MAXLEN = 256000);

/// 域名称
Property NameSpace As %String;

/// 域地址
Property IpAdderss As %String;

/// 描述
Property Description As %String;

Storage Default
{
<Data name="DomainDBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DomainID</Value>
</Value>
<Value name="3">
<Value>NameSpace</Value>
</Value>
<Value name="4">
<Value>IpAdderss</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^JHIPV5.JHREG.DB.DomainDBD</DataLocation>
<DefaultData>DomainDBDefaultData</DefaultData>
<IdLocation>^JHIPV5.JHREG.DB.DomainDBD</IdLocation>
<IndexLocation>^JHIPV5.JHREG.DB.DomainDBI</IndexLocation>
<StreamLocation>^JHIPV5.JHREG.DB.DomainDBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
