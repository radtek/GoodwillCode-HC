/// Classname JHIPV5.JHREG.DB.Theme.ThemeDB
/// Summary   主题列表 
/// Explain	  存放主题有关的数据
/// Version   1.0<br>
/// Date      2021年11月30日 
/// Author    LHX
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.DB.Theme.ThemeDB Extends %Persistent
{

/// 域ID
Property SpaceID As %String;

/// 主题编码
Property ThemeCode As %String;

/// 主题名称
Property ThemeName As %String;

/// 域名称
Property NameSpace As %String;

/// 通讯标准
Property standard As %String;

/// 通讯方式
Property IsSync As %String;

/// 启用停用按钮
Property Enabled As %Integer;

/// 业务场景
Property Category As %String;

/// 发布系统
Property BusinessPartner As %String;

/// 适配器
Property Adapter As %String;

/// 运行池大小
Property PoolSize As %String;

/// 主题注释
Property Comment As %String;

/// 主题日志
Property LogTraceEvents As %String;

/// 搜索表类
Property SearchTableClass As %String;

/// HTTP端口
Property Port As %String;

/// 字符集
Property Charset As %String;

/// 调用间隔
Property CallInterval As %String;

Storage Default
{
<Data name="ThemeDBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SpaceID</Value>
</Value>
<Value name="3">
<Value>ThemeCode</Value>
</Value>
<Value name="4">
<Value>ThemeName</Value>
</Value>
<Value name="5">
<Value>NameSpace</Value>
</Value>
<Value name="6">
<Value>standard</Value>
</Value>
<Value name="7">
<Value>IsSync</Value>
</Value>
<Value name="8">
<Value>Enabled</Value>
</Value>
<Value name="9">
<Value>Category</Value>
</Value>
<Value name="10">
<Value>BusinessPartner</Value>
</Value>
<Value name="11">
<Value>Adapter</Value>
</Value>
<Value name="12">
<Value>PoolSize</Value>
</Value>
<Value name="13">
<Value>Comment</Value>
</Value>
<Value name="14">
<Value>LogTraceEvents</Value>
</Value>
<Value name="15">
<Value>SearchTableClass</Value>
</Value>
<Value name="16">
<Value>Port</Value>
</Value>
<Value name="17">
<Value>Charset</Value>
</Value>
<Value name="18">
<Value>CallInterval</Value>
</Value>
</Data>
<DataLocation>^JHIPV5.JHREG.DB.Theme.ThemeDBD</DataLocation>
<DefaultData>ThemeDBDefaultData</DefaultData>
<IdLocation>^JHIPV5.JHREG.DB.Theme.ThemeDBD</IdLocation>
<IndexLocation>^JHIPV5.JHREG.DB.Theme.ThemeDBI</IndexLocation>
<StreamLocation>^JHIPV5.JHREG.DB.Theme.ThemeDBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
