Class JHIPLIB.HIPP.SaveBase
{

/// MethodName：OutInpatient<br>
/// Summary:    门诊住院大屏存储<br>
/// Parameter：	入参为EnsLib.EDI.XML.Document
/// Return：    <br>
/// Date：      2019年12月5日 13:00 <br>
/// Author：    ZBT<br>
ClassMethod OutInpatient(pInput As EnsLib.EDI.XML.Document) As %Status
{
	Set date=$TRanslate($ZDate($H,3),"-"),Type=pInput.OriginalDocId
	//患者注册  统计信息有：年龄、性别、patientid、就诊类型默认门诊（在入科时进行修改）
	IF Type="JH0001"{
	     Set birthTime=pInput.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/birthTime/@value")
	     Set Age=($e(date,1,4)-$e(birthTime,1,4))+1
	     Set PatientID=pInput.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/id/item/@extension")
	     Set Sex=pInput.GetValueAt("/PRPA_IN201311UV02/controlActProcess/subject/registrationRequest/subject1/patient/patientPerson/administrativeGenderCode/displayName/@value")
		 &Sql(INSERT INTO JHIPLIB_HIPP_DB_OutInpatient.PatientDB (Age, "Date", PatientID, PatientType, Sex) VALUES (:Age,:date,:PatientID,'其他',:Sex))
	//患者合并数据   统计信息有：患者名字（会在建档统计中使用）
	}ElseIF Type="JH0003"{
		Set PatientName=pInput.GetValueAt("/PRPA_IN201304UV02/controlActProcess/subject/registrationEvent/subject1/patient/patientPerson/name")
	    &Sql(INSERT INTO JHIPLIB_HIPP_DB_OutInpatient.CombinePatientDB ( "Date", PatientName) VALUES (:date,:PatientName))
	//门诊登记   统计信息：患者ID ,患者入院途径
	}ElseIF Type="JH0104"{
		Set PatientID=pInput.GetValueAt("/PRPA_IN400001UV/controlActProcess/subject/encounterEvent/code/displayName/@value")
	    Set EncounterType=pInput.GetValueAt("/PRPA_IN400001UV/controlActProcess/subject/encounterEvent/code/displayName/@value")
	    &Sql(SELECT count(1) INTO :count FROM JHIPLIB_HIPP_DB_OutInpatient.PatientDB WHERE  PatientID=:PatientID)
		&Sql(INSERT INTO JHIPLIB_HIPP_DB_OutInpatient.OutPatientDB ( "Date", EncounterType,PatientID) VALUES (:date,:EncounterType,:PatientID))
	    IF count>0 {&Sql(UPDATE  JHIPLIB_HIPP_DB_OutInpatient.PatientDB SET PatientType=:EncounterType WHERE  PatientID=:PatientID)}
	//患者入科   统计的信息：住院年龄   入科科室  就诊类型默认住院  患者ID  性别
	}ElseIF Type="JH0115"{
		Set Age=pInput.GetValueAt("/PRPA_IN400001UV/controlActProcess/subject/encounterEvent/subject/patient/patientPerson/birthTime/originalText/@value")
	    Set Department=pInput.GetValueAt("/PRPA_IN400001UV/controlActProcess/subject/encounterEvent/location/serviceDeliveryLocation/name")
	    Set PatientID=pInput.GetValueAt("/PRPA_IN400001UV/controlActProcess/subject/encounterEvent/subject/patient/id/item[2]/@extension")
	    Set Sex=pInput.GetValueAt("/PRPA_IN400001UV/controlActProcess/subject/encounterEvent/subject/patient/patientPerson/administrativeGenderCode/@code")
	    Set EncounterType=pInput.GetValueAt("/PRPA_IN400001UV/controlActProcess/subject/encounterEvent/code/displayName/@value")
	    
	    &Sql(SELECT count(1) INTO :count FROM JHIPLIB_HIPP_DB_OutInpatient.PatientDB WHERE  PatientID=:PatientID)
		&Sql(INSERT INTO JHIPLIB_HIPP_DB_OutInpatient.InDepartmentDB ( Age, "Date", Department, EncounterType, PatientID, Sex) VALUES (:Age,:date,:Department,:EncounterType,:PatientID,:Sex))
		IF count>0 {&Sql(UPDATE  JHIPLIB_HIPP_DB_OutInpatient.PatientDB SET PatientType=:EncounterType WHERE  PatientID=:PatientID)}
	//检查申请单  统计信息：检查名称、检查类别、就诊类型
	}ElseIF Type="JH0201"{
		Set i=1,EncounterType=pInput.GetValueAt("/POOR_IN200901UV/controlActProcess/subject/observationRequest/componentOf1/encounter/code/displayName/@value")
	    while i=1{
		    Set CheckName=pInput.GetValueAt("/POOR_IN200901UV/controlActProcess/subject/observationRequest/component2["_i_"]/observationRequest/code/displayName/@value")
		    Set CheckType=pInput.GetValueAt("/POOR_IN200901UV/controlActProcess/subject/observationRequest/component2["_i_"]/observationRequest/methodCode/item[2]/displayName/@value")
		    &Sql(INSERT INTO JHIPLIB_HIPP_DB_OutInpatient.CheckDB ( CheckName, CheckType, "Date", EncounterType) VALUES (:CheckName,:CheckType,:date,:EncounterType))
			Set:$L(pInput.GetValueAt("/POOR_IN200901UV/controlActProcess/subject/observationRequest/component2["_i+1_"]/observationRequest/code/displayName/@value"))=0 i=0
		}
	//检验申请单  统计信息：检验名称、检验类别、就诊类型
	}ElseIF Type="JH0206"{
		Set i=1,j=1,EncounterType=pInput.GetValueAt("/POOR_IN200901UV/controlActProcess/subject/observationRequest/componentOf1/encounter/code/displayName/@value")
	    while i=1{
		    Set ExamineName=pInput.GetValueAt("/POOR_IN200901UV/controlActProcess/subject/observationRequest/component2["_j_"]/observationRequest/code/displayName/@value")
		    Set ExamineType="",j=j+1
		    &Sql(INSERT INTO JHIPLIB_HIPP_DB_OutInpatient.ExamineDB ( ExamineName,ExamineType, "Date", EncounterType) VALUES (:ExamineName,:ExamineType,:date,:EncounterType))
			Set:$L(pInput.GetValueAt("/POOR_IN200901UV/controlActProcess/subject/observationRequest/component2["_j+1_"]/observationRequest/code/displayName/@value"))=0 i=0
		}
	//住院医嘱 统计的信息：住院医嘱数量JH0301/JH0304(取药人数)/JH0305/JH0306/JH0307    处方数量JH0308     手术数量JH0425
	}ElseIF Type="JH0301"||Type="JH0306"||Type="JH0307"||Type="JH0305"||Type="JH0304"||Type="JH0308"||Type="JH0425"{
		&Sql(INSERT INTO JHIPLIB_HIPP_DB_OutInpatient.OrderDB ( "Date", OrderType) VALUES (:date,:Type))
	//手术状态统计  统计的信息：手术状态
	}ElseIF Type="JH0428"{
		Set a=1,b=1
		while a=1{
			Set Status=pInput.GetValueAt("/POOR_IN200902UV/controlActProcess/subject/placerGroup/component2["_b_"]/procedureRequest/component1/processStep/code/displayName/@value")
		    Set b=b+1
		    &Sql(INSERT INTO JHIPLIB_HIPP_DB_OutInpatient.OperationDB ( "Date", Status) VALUES (:date,:Status))
			Set:$L(pInput.GetValueAt("/POOR_IN200902UV/controlActProcess/subject/placerGroup/component2["_b_"]/procedureRequest/component1/processStep/code/displayName/@value"))=0 a=0
		    
		}
	}
	Quit $$$OK
}

/// MethodName：Activity<br>
/// Summary:    大屏活动量存储<br>
/// Parameter：	入参为
/// Return：    <br>
/// Date：      2019年10月15日 16:00 <br>
/// Author：    ZBT<br>
ClassMethod Activity(BusinessPartner As %String, EventType As %String, ConfigName As %String, Type As %String) As %Status
{
	Set date=$TRanslate($ZDate($H,3),"-"),Number=""
	
	&Sql(SELECT Number INTO :Number FROM JHIPLIB_HIPP_DB.ActivityDB WHERE EventType=:EventType AND "Date"=:date AND Type=:Type)
		If Number=""{
			Set Number=1
			IF Type="O"{
				&Sql(SELECT ConfigName INTO :NConfigName FROM JHIPLIB_HIPP_DB.ActivityDB WHERE Type='I' AND "Date"=:date AND EventType=:EventType)
				&Sql(INSERT INTO JHIPLIB_HIPP_DB.ActivityDB ("Date",BusinessPartner,Number,EventType,ConfigName,Type) VALUES (:date,:BusinessPartner,:Number,:EventType,:NConfigName,:Type))
			
			}ELSE{
			&Sql(INSERT INTO JHIPLIB_HIPP_DB.ActivityDB ("Date",BusinessPartner,Number,EventType,ConfigName,Type) VALUES (:date,:BusinessPartner,:Number,:EventType,:ConfigName,:Type))
				
				}
		}else{
			Set Number=Number+1
			&Sql(UPDATE  JHIPLIB_HIPP_DB.ActivityDB SET Number=:Number WHERE ConfigName=:ConfigName AND "Date"=:date)
			
			}
	Quit $$$OK
}

}
