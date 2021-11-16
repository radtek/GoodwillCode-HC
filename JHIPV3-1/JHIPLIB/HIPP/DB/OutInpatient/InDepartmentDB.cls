Class JHIPLIB.HIPP.DB.OutInpatient.InDepartmentDB Extends %Persistent
{

// 日期

Property Date As %String;

Parameter XMLNAME = "InDepartmentDB";

// 患者就诊类型    默认住院    

Property EncounterType As %String;

// 患者年龄        

Property Age As %String;

// 患者性别        

Property Sex As %String;

// 患者ID       

Property PatientID As %String;

// 进入的科室        

Property Department As %String;

Storage Default
{
<Data name="InDepartmentDBDefaultData">
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
<Value>Age</Value>
</Value>
<Value name="5">
<Value>Sex</Value>
</Value>
<Value name="6">
<Value>PatientID</Value>
</Value>
<Value name="7">
<Value>Department</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.HIP37FD.InDepartmentDBD</DataLocation>
<DefaultData>InDepartmentDBDefaultData</DefaultData>
<IdLocation>^JHIPLIB.HIP37FD.InDepartmentDBD</IdLocation>
<IndexLocation>^JHIPLIB.HIP37FD.InDepartmentDBI</IndexLocation>
<StreamLocation>^JHIPLIB.HIP37FD.InDepartmentDBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
