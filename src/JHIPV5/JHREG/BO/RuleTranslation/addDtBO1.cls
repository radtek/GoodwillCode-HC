/// Classname 
/// Summary   
/// Version   1.0
/// Date      2021年11月16日
/// Author    喻珊珊
/// Copyright 北京嘉和美康信息技术有限公司
Class JHIPV5.JHREG.BO.RuleTranslation.addDtBO1 Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method bpSelect(pRequest As JHIPLIB.Util.MSG.JHRequestMsg, Output pResponse As Ens.StringResponse) As %Status
{
	
	 
	  set request=##class(%DynamicObject).%New()
	  set request.Timestamp="2021-12-14 17:49:55.259521"  //当前时间
      set request.ReadOnly= 0
       set request.Parent= ""
       set request.Annotation= "患者信息更新DT"
       set request.Disabled=0
      set request.Expanded= 1
     set request.Language= "objectscript"
     set request.SourceClass= "EnsLib.EDI.XML.Document"
     set request.TargetClass= "JHIPLIB.Util.MSG.PatientInfoMSG"
     set request.Create= "new"
    set request.SourceDocType= ""
    set request.TargetDocType= ""
    set request.ReportErrors= 1
    set request.IgnoreMissingSource= 1
    set request.TreatEmptyAsNull= 0
    set request.Actions=##class(%DynamicArray).%New()
	
	 
	  set requestAction1=##class(%DynamicObject).%New()
	  set requestAction1.type="Assign"
	  SET requestAction1.Annotation=""
      SET requestAction1.Disabled= 0
      SET requestAction1.Expanded= 1
      SET requestAction1.Property= "target.PATIENTID"
      SET requestAction1.Value= "source.GetValueAt(""/PRPA_IN201314UV02/controlActProcess/subject/registrationRequest/subject1/patient/id/item/@extension"")"
      SET requestAction1.Action= "set"
      SET requestAction1.Key= """"""
      Do request.Actions.%Push(requestAction1)
      
      
       set requestAction1=##class(%DynamicObject).%New()
	  set requestAction1.type="If"
	 SET requestAction1.Annotation=""
      SET requestAction1.Disabled= 0
      SET requestAction1.Expanded= 1
      
      SET requestAction1.Condition= "source.GetValueAt(""/PRPA_IN201314UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/administrativeGenderCode/displayName/@value"")=""女性"""
 
 
      set requestAction1.True=##class(%DynamicArray).%New()
      set true1=##class(%DynamicObject).%New()
      SET true1.type="Assign"
      SET true1.Annotation=""
      SET true1.Disabled= 0
      SET true1.Expanded= 1
      SET true1.Property= "target.SEX"
      SET true1.Value= "M"
      SET true1.Action= "set"
      SET true1.Key= """"""
      Do requestAction1.True.%Push(true1)
      set requestAction1.False=##class(%DynamicArray).%New()

      Do request.Actions.%Push(requestAction1)
      

      Set tProxy = ##class(Ens.DTL.Transform).%New()
      set tProxy.Timestamp=request.Timestamp  //当前时间
      set tProxy.ReadOnly= request.ReadOnly
       set tProxy.Parent= request.Parent
       set tProxy.Annotation= request.Annotation
       set tProxy.Disabled=request.Disabled
      set tProxy.Expanded=request.Expanded
     set tProxy.Language=request.Language
     set tProxy.SourceClass= request.SourceClass
     set tProxy.TargetClass= request.TargetClass
     set tProxy.Create= request.Create
    set tProxy.SourceDocType= request.SourceDocType
    set tProxy.TargetDocType= request.TargetDocType
    set tProxy.ReportErrors=request.ReportErrors
    set tProxy.IgnoreMissingSource= request.IgnoreMissingSource
    set tProxy.TreatEmptyAsNull= request.TreatEmptyAsNull
    set tProxy.Actions=##class(Ens.DTL.ActionList).%New()
    set iteR=request.Actions.%GetIterator()
    while iteR.%GetNext(.key, .value) { 
     if (value.type="Assign"){
	     SET ASS=##class(Ens.DTL.Assign).%New()
	     set tsc=..createAssign(value,.ASS)
	     Do tProxy.Actions.Insert(ASS)
	   }
	  elseif (value.type="If"){
		 SET ASS=##class(Ens.DTL.If).%New()
	     set tsc=..createIF(value,.ASS)
	     Do tProxy.Actions.Insert(ASS)
     }
     
    }
    

    set tsc=##class(EnsPortal.DTLEditor).SaveDTLToClass("JHIPW.TEST.DT.CS1",tProxy)
  
    Do $System.OBJ.Compile("JHIPV5-3.TEST.DT.CS1")
	  Quit $$$OK
	  Set pResponse=##class(Ens.StringResponse).%New()
	  Set pResponse.StringValue=Result.TResult("123")
	  Quit $$$OK
}

ClassMethod createAssign(pInput As %DynamicObject, ByRef actions As Ens.DTL.Assign)
{
	
	
    SET actions=##class(Ens.DTL.Assign).%New()
    set actions.Parent=##class(Ens.DTL.Node).%New()
     //set ASS.Parent.
     
      
      SET actions.Annotation=pInput.Annotation
      SET actions.Disabled=pInput.Disabled
      SET actions.Expanded= pInput.Expanded
      SET actions.Property=pInput.Property
      SET actions.Value= pInput.Value
      SET actions.Action=pInput.Action
      SET actions.Key=pInput.Key
      Quit $$$OK
}

ClassMethod createIF(pInput As %DynamicObject, ByRef actionif As Ens.DTL.If)
{
	  SET actionif=##class(Ens.DTL.If).%New()
      set actionif.Parent= ##class(Ens.DTL.Node).%New()
     //set ASS.Parent.
      SET actionif.Annotation=pInput.Annotation
      SET actionif.Disabled= pInput.Disabled
      SET actionif.Expanded= pInput.Expanded
      SET actionif.Condition=pInput.Condition
      set actionif.True=##class(Ens.DTL.ActionList).%New()	
      set iter1=pInput.True.%GetIterator()
        while iter1.%GetNext(.key, .value) { 
          if (value.type="Assign"){
	     SET ASS=##class(Ens.DTL.Assign).%New()
	     set tsc=..createAssign(value,.ASS)
	     Do actionif.True.Insert(ASS)
	   }
	  elseif (value.type="If"){
		 SET ASS=##class(Ens.DTL.If).%New()
	     set tsc=..createIF(value,.ASS)
	     Do tactionif.True.Insert(ASS)
     }
        
        }
      //如果存在 调用ceateAssign
      set actionif.False=##class(Ens.DTL.ActionList).%New()
      
      Quit $$$OK
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="JHIPLIB.Util.MSG.JHRequestMsg"> 
		<Method>bpSelect</Method>
	</MapItem>
</MapItems>
}

}
