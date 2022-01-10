/// Classname:	JHIPV5.JHREG.DB.RuleTranslationDB
/// Summary:	规则转换总表
/// TODO:		规则转换总表
/// Version:	1.0;
/// Date:		
/// Author:		
/// Copyright:	北京嘉和美康信息技术有限公司;
Class JHIPV5.JHREG.DB.RuleTranslationDB Extends %Persistent
{

/// 规则名称
Property RuleName As %String;

/// 规则类型
Property RuleType As %String;

/// 源标准
Property SourceStandard As %String(MAXLEN = "");

/// 目标标准
Property TargetStandard As %String(MAXLEN = "");

/// 源标准消息类型
Property SourceStandardMessage As %String(MAXLEN = "");

/// 目标标准消息类型
Property TargetStandardMessage As %String(MAXLEN = "");

/// 所属域
Property nameSpaceId As %String;

/// 类名
Property FilesName As %String;

/// 操作时间
Property OperaTime As %String;

Storage Default
{
<Data name="RuleTranslationDBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RuleName</Value>
</Value>
<Value name="3">
<Value>RuleType</Value>
</Value>
<Value name="4">
<Value>SourceStandard</Value>
</Value>
<Value name="5">
<Value>TargetStandard</Value>
</Value>
<Value name="6">
<Value>NameSpaceId</Value>
</Value>
<Value name="7">
<Value>nameSpaceId</Value>
</Value>
<Value name="8">
<Value>FilesName</Value>
</Value>
<Value name="9">
<Value>SourceStandardMessage</Value>
</Value>
<Value name="10">
<Value>TargetStandardMessage</Value>
</Value>
<Value name="11">
<Value>OperaTime</Value>
</Value>
</Data>
<DataLocation>^JHIPV5.JHRCB30.RuleTransla9802D</DataLocation>
<DefaultData>RuleTranslationDBDefaultData</DefaultData>
<IdLocation>^JHIPV5.JHRCB30.RuleTransla9802D</IdLocation>
<IndexLocation>^JHIPV5.JHRCB30.RuleTransla9802I</IndexLocation>
<StreamLocation>^JHIPV5.JHRCB30.RuleTransla9802S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
