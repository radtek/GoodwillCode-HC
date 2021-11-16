Class JHIPLIB.HIPP.DB.OutInpatient.ExamineDB Extends %Persistent
{

// 日期

Property Date As %String;

Parameter XMLNAME = "CheckDB";

// 患者就诊类型        

Property EncounterType As %String;

// 检验类别        

Property ExamineType As %String;

// 检验名称        

Property ExamineName As %String;

Storage Default
{
<Data name="ExamineDBDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Date</Value>
</Value>
<Value name="3">
<Value>EncounterType</Value>
</Value>
<Value name="4">
<Value>ExamineType</Value>
</Value>
<Value name="5">
<Value>ExamineName</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.HIPP.DB37FD.ExamineDBD</DataLocation>
<DefaultData>ExamineDBDefaultData</DefaultData>
<IdLocation>^JHIPLIB.HIPP.DB37FD.ExamineDBD</IdLocation>
<IndexLocation>^JHIPLIB.HIPP.DB37FD.ExamineDBI</IndexLocation>
<StreamLocation>^JHIPLIB.HIPP.DB37FD.ExamineDBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
