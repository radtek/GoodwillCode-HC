/// Classname JHIPLIB.SOAP.AESCBC.AESCBCService
/// Summary   AESCBC 加密服务
/// Version   1.0
/// Date      2019年01月11日 15:15:39
/// Author    liuwenyi
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPLIB.SOAP.AESCBC.AESCBCService Extends EnsLib.SOAP.Service
{

Parameter NAMESPACE = "http://goodwillcis.com";

Parameter SETTINGS = "Systems:Additional,TimeSpace:Additional,IsAESCBC:Basic";

Parameter USECLASSNAMESPACES = 1;

/// 允许调用接口的系统名称
Property Systems As %String;

/// 调用接口时间间隔，单位为秒
Property TimeSpace As %String;

/// 是否进行接口鉴权
Property IsAESCBC As %Boolean [ InitialExpression = 0 ];

/// AES CBC 解密
Method AESCBCDencrypt(content As %String, key As %String, IV As %String) As %String
{
	Try{
		;Set key = "0B8C4A15-E854-4284-9FB3-9C728C24C4E3"
		;Set IV="13430F5F-9BCE-4B" 
		Set text=$SYSTEM.Encryption.Base64Decode(content)
		Set text=$SYSTEM.Encryption.AESCBCDecrypt(text,key,IV)
		Set plaintext=$ZCONVERT(text,"I","UTF8")
	}catch(ex){
		$$$LOGERROR(ex.DisplayString())
	}
	Quit plaintext
}

/// AES CBC 加密.0
Method AESCBCEncrypt(content As %String, key As %String, IV As %String) As %String
{
	Try{
		;Set key = "0B8C4A15-E854-4284-9FB3-9C728C24C4E3"
		;Set IV="13430F5F-9BCE-4B"
		Set text=$ZCONVERT(content,"O","UTF8")
		Set text=$SYSTEM.Encryption.AESCBCEncrypt(text,key,IV)
		Set ciphertext=$SYSTEM.Encryption.Base64Encode(text) 
	}catch(ex){
		$$$LOGERROR(ex.DisplayString())
	}
	Quit ciphertext
}

/// 计算调用时间和当前时间相差的秒数，返回值为正整数，单位为秒
Method timeInterval(time As %String) As %String
{
	Try{
		///当前秒数
		Set now=$P($H,",",1)*86400+$P($H,",",2)
		///传入消息的秒数
		Set time=$P($ZDATETIMEH(time,5),",",1)*86400+$P($ZDATETIMEH(time,5),",",2)
		Set secondInterval = time-now
		If secondInterval<0{Set secondInterval=0-secondInterval}
	}catch(ex){
		$$$LOGERROR(ex.DisplayString())
	}
	Quit secondInterval
}

/// 验证方法
Method Verification() As %Status
{
	Set tSC=$$$NO
	Set UserName=..AESCBCDencrypt(..HeadersIn.GetAt("JiaheSecurity").UserName)
	Set Password=..AESCBCDencrypt(..HeadersIn.GetAt("JiaheSecurity").Password)
	Set Timestamp=..AESCBCDencrypt(..HeadersIn.GetAt("JiaheSecurity").Timestamp)
	Set IV=..AESCBCDencrypt(..HeadersIn.GetAt("JiaheSecurity").IV)
	Set inputs= $LISTFROMSTRING(..Systems,",")
	Set len=$LISTLENGTH(inputs)
	Set pwd=""
	Set intervalTime=..timeInterval(Timestamp)
	IF intervalTime<..TimeSpace{
		For i=1:1:len{
			Set input=$LISTGET(inputs,i)
			&sql(SELECT Password INTO :pwd From Ens_Config.Credentials WHERE Username = :System)
			if pwd = Password{
				Set tSC=$$$OK
				Quit
			}
		}
	}
	Quit tSC
}

XData AddHeader
{
<parameters xmlns="http://www.intersystems.com/configuration">
   <request>
      <header name="JiaheSecurity" class="JHIPLIB.SOAP.AESCBC.Header"/> 
   </request>
</parameters>
}

}
