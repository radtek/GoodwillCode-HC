/// Classname JHIPV5.JHREG.Common.NameSpace
/// Summary   依据域ID返回DSN
/// Explain	  设置DSN
/// Version   1.0<br>
/// Date      2021年12月7日
/// Author    ZFT
/// Copyright 北京嘉和美康信息技术有限公司<br>
Class JHIPV5.JHREG.Common.NameSpace
{

/// 配置命名空间DSN
ClassMethod ConfigDSN(DomainID As %String) As %String
{
	Set tStatment = ##class(%SQL.Statement).%New()
	Set DSN="JHIP"
	Set Sql="SELECT NameSpace FROM JHIPV5_JHREG_DB.DomainDB Where DomainID ='"_DomainID_"' "
	Set tSC = tStatment.%Prepare(Sql)
	Set tResult = tStatment.%Execute()
	IF tResult.%Next(){
		Set NameSpace=tResult.%Get("NameSpace")
		/** 通过获取数据查找表来设置DSN **/
		Set DSN= ^Ens.LookupTable("DSNTABLE",NameSpace)
	}
	Quit DSN
}

/// 根据 域ID获取命名空间名称 
ClassMethod GetNameSpace(DomainID As %String) As %String
{
	Set tStatment = ##class(%SQL.Statement).%New()
	Set NameSpace="JHIP"
	Set Sql="SELECT NameSpace FROM JHIPV5_JHREG_DB.DomainDB Where DomainID ='"_DomainID_"' "
	Set tSC = tStatment.%Prepare(Sql)
	Set tResult = tStatment.%Execute()
	IF tResult.%Next(){
		Set NameSpace=tResult.%Get("NameSpace")
	}
	Quit NameSpace
}

/// 统一配置 JHIP 命名空间 DSN （固定方法）
ClassMethod JHIPConfig() As %String
{
	Set DSN= ^Ens.LookupTable("DSNTABLE","JHIP")
	Quit DSN
}

/// 统一配置 HII 命名空间 DSN （固定方法）
ClassMethod HIIConfig() As %String
{
	Set DSN= ^Ens.LookupTable("DSNTABLE","HII")
	Quit DSN
}

/// 统一配置 HIPP 命名空间 DSN （固定方法）
ClassMethod HIPPConfig() As %String
{
	Set DSN= ^Ens.LookupTable("DSNTABLE","HIPP")
	Quit DSN
}

/// 统一配置 JHIPV5 MYSql数据库 （固定方法）
ClassMethod JHIPV5Config() As %String
{
	Set DSN= ^Ens.LookupTable("DSNTABLE","JHIPV5")
	Quit DSN
}

}
