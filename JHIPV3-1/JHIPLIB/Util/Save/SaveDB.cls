/// 
Class JHIPLIB.Util.Save.SaveDB Extends %Persistent [ ClassType = persistent, DdlAllowed, Final, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SaveDB ]
{

Property ID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 2 ];

Property FileBody As %Library.String(MAXLEN = 1000) [ SqlColumnNumber = 3 ];

Property FileName As %Library.String(MAXLEN = 250) [ SqlColumnNumber = 4 ];

Property FileType As %Library.String(MAXLEN = 250) [ SqlColumnNumber = 5 ];

Property OperationFileTIME As %Library.String(MAXLEN = 250) [ SqlColumnNumber = 6 ];

/// Bitmap Extent Index auto-generated by DDL CREATE TABLE statement.  Do not edit the SqlName of this index.
Index DDLBEIndex [ Extent, SqlName = "%%DDLBEIndex", Type = bitmap ];

Storage Default
{
<Data name="SaveDBDefaultData">
<Value name="1">
<Value>ID</Value>
</Value>
<Value name="2">
<Value>FileBody</Value>
</Value>
<Value name="3">
<Value>FileName</Value>
</Value>
<Value name="4">
<Value>FileType</Value>
</Value>
<Value name="5">
<Value>OperationFileTIME</Value>
</Value>
</Data>
<DataLocation>^JHIPLIB.Util.Save.SaveDBD</DataLocation>
<DefaultData>SaveDBDefaultData</DefaultData>
<IdFunction>sequence</IdFunction>
<IdLocation>^JHIPLIB.Util.Save.SaveDBD</IdLocation>
<IndexLocation>^JHIPLIB.Util.Save.SaveDBI</IndexLocation>
<StreamLocation>^JHIPLIB.Util.Save.SaveDBS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
