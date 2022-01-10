Class JHIPV5.JHREG.BS.SubPubBS Extends Ens.BusinessService
{

Method SubscriptioPublication(URL As %String, pInput As JHIPLIB.Util.MSG.JHRequestMsg, Output pOutput As Ens.StringResponse) As %Status
{
  
	$$$TRACE(URL)
	set Tsc=..SendRequestSync(URL,pInput,.Output)
	set pOutput=##class(Ens.StringResponse).%New()
	set pOutput=Output
	Quit $$$OK
}

Method SubscriptioPublicationFile(URL As %String, pInput As %CSP.BinaryStream, Output pOutput As Ens.StringResponse) As %Status
{
     $$$TRACE(URL)

	 //$$$TRACE(pInput)
	 //set t1=##class(%CSP.BinaryStream).%New()
	 
	//set t1=pInput

	set Tsc=..SendRequestSync(URL,pInput,.Output)
	$$$TRACE(Tsc)
    set pOutput=##class(Ens.StringResponse).%New()
	set pOutput=Output
	Quit $$$OK
}

}
