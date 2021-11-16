/// Classname JHIPLIB.SOAP.AESCBC.DEMOBS
/// Summary   AESCBC验证接口样例
/// Version   1.0
/// Date      2019年01月11日 15:15:39
/// Author    liuwenyi
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPLIB.SOAP.AESCBC.DEMOBS Extends JHIPLIB.SOAP.AESCBC.AESCBCService
{

Parameter ADAPTER;

/// Name of the WebService
Parameter SERVICENAME = "HmacSHA256BS";

/// 返回hello，表示验证成功！
Method Test(pRequest As %String) As %String [ WebMethod ]
{
	Set result=""
	If ..Verification()=$$$OK{
		Set result="hello"
	}
	Quit result
}

/// AES CBC 解密
Method AESCBCDencrypt(content As %String, key As %String, IV As %String) As %String [ WebMethod ]
{
	Quit ##super()
}

/// AES CBC 加密.0
Method AESCBCEncrypt(content As %String, key As %String, IV As %String) As %String
{
	Quit ##super()
}

}
