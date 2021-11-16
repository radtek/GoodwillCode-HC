Class JHIP.Production.NEWJHIPV3 Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="JHIP.Production.JHIPV3" TestingEnabled="false" LogGeneralTraceEvents="false">
  <Description>嘉和美康HL7V3标准化</Description>
  <ActorPoolSize>20</ActorPoolSize>
  <Item Name="LIS接收测试服务BO" Category="01.就诊信息交互服务,00.患者管理服务,02.申请单信息交互服务,03.医嘱信息交互服务,04.结果、状态信息交互服务,05.预约信息交互服务,06.医疗卫生机构管理服务,,,07.医疗卫生人员管理,08.电子病历管理服务,,,09.术语管理服务," ClassName="JHIPLIB.SOAP.BO.JHIPBaseBO" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessPartner">LIS</Setting>
    <Setting Target="Host" Name="EventMethod">JH0066:Send,REQUEST;</Setting>
    <Setting Target="Adapter" Name="WebServiceClientClass">JHIP.TEST.WSC.ServiceSoap</Setting>
    <Setting Target="Adapter" Name="WebServiceURL">http://localhost:57772/soap/JHIPLIB.SOAP.BS.Service.cls?CfgItem=JH0010通用测试服务</Setting>
    <Setting Target="Host" Name="ReplyCodeActions">E=R</Setting>
    <Setting Target="Host" Name="RetryInterval">8</Setting>
    <Setting Target="Adapter" Name="ConnectTimeout">7</Setting>
    <Setting Target="Host" Name="FailureTimeout">40</Setting>
  </Item>
  <Item Name="JH0001新增患者信息服务" Category="00.患者管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="门诊挂号服务" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">00.1患者管理服务BP</Setting>
    <Setting Target="Host" Name="BusinessPartner">EMR</Setting>
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0001</Setting>
    <Setting Target="Host" Name="IsSync">0</Setting>
  </Item>
  <Item Name="JH0002患者信息更新服务" Category="00.患者管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="新建患者信息服务" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">00.1患者管理服务BP</Setting>
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0002</Setting>
  </Item>
  <Item Name="JH0003患者合并服务" Category="00.患者管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="患者信息更新" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">00.1患者管理服务BP</Setting>
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0003</Setting>
  </Item>
  <Item Name="JH0004患者基本信息查询服务" Category="00.患者管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="患者入院" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0004</Setting>
    <Setting Target="Host" Name="TargetConfigNames">00.1患者管理服务BP</Setting>
    <Setting Target="Host" Name="IsSync">1</Setting>
  </Item>
  <Item Name="HIS接收测试服务BO" Category="01.就诊信息交互服务,00.患者管理服务,02.申请单信息交互服务,03.医嘱信息交互服务,04.结果、状态信息交互服务,05.预约信息交互服务,06.医疗卫生机构管理服务,,,07.医疗卫生人员管理,08.电子病历管理服务,,,09.术语管理服务," ClassName="JHIPLIB.TCP.BO.JHIPBaseBO" PoolSize="1" Enabled="false" Foreground="false" Comment="HIS接收测试服务BO" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="Charset">@GB18030</Setting>
    <Setting Target="Adapter" Name="DiscardDataNotwithinFraming">0</Setting>
    <Setting Target="Adapter" Name="IPAddress"></Setting>
    <Setting Target="Adapter" Name="Port"></Setting>
    <Setting Target="Host" Name="EventMethod">JH0010:172.18.73.145,6003;JH0006:172.16.1.09,57775;</Setting>
    <Setting Target="Adapter" Name="RemoveFraming">1</Setting>
    <Setting Target="Adapter" Name="ReplyHasSameFraming">0</Setting>
    <Setting Target="Adapter" Name="MessageFrameEnd">28,09</Setting>
  </Item>
  <Item Name="JH0101就诊卡信息新增服务" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0101</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.1就诊卡信息服务BP</Setting>
  </Item>
  <Item Name="JH0102就诊卡信息更新服务" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0102</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.1就诊卡信息服务BP</Setting>
  </Item>
  <Item Name="JH0103就诊卡信息查询服务" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0103</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.1就诊卡信息服务BP</Setting>
  </Item>
  <Item Name="JH0104门诊挂号信息新增服务" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0104</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.3门诊挂号信息服务BP</Setting>
  </Item>
  <Item Name="JH0105门诊挂号信息更新服务" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0105</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.3门诊挂号信息服务BP</Setting>
  </Item>
  <Item Name="JH0106门诊挂号信息查询服务" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0106</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.3门诊挂号信息服务BP</Setting>
  </Item>
  <Item Name="JH0107门诊就诊查询服务" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0107</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.3门诊挂号信息服务BP</Setting>
    <Setting Target="Host" Name="IsSync">0</Setting>
  </Item>
  <Item Name="JH0108号源排班信息新增服务" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0108</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.2号源排班信息服务BP</Setting>
  </Item>
  <Item Name="JH0109号源排班信息更新服务" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0109</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.2号源排班信息服务BP</Setting>
  </Item>
  <Item Name="JH0110号源排班信息查询服务" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0110</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.2号源排班信息服务BP</Setting>
  </Item>
  <Item Name="JH0111住院就诊信息登记服务" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0111</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.4住院就诊信息服务BP</Setting>
  </Item>
  <Item Name="JH0112住院就诊信息更新服务" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0112</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.4住院就诊信息服务BP</Setting>
  </Item>
  <Item Name="JH0113住院就诊信息查询服务" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0113</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.4住院就诊信息服务BP</Setting>
  </Item>
  <Item Name="JH0114取消住院就诊信息服务" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0114</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.4住院就诊信息服务BP</Setting>
  </Item>
  <Item Name="JH0115患者入科" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0115</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.5住院转科信息服务BP</Setting>
  </Item>
  <Item Name="JH0116取消患者入科" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0116</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.5住院转科信息服务BP</Setting>
  </Item>
  <Item Name="JH0117住院转科信息新增服务" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0117</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.5住院转科信息服务BP</Setting>
  </Item>
  <Item Name="JH0118住院转科信息更新服务" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0118</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.5住院转科信息服务BP</Setting>
  </Item>
  <Item Name="JH0119住院转科信息查询服务" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0119</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.5住院转科信息服务BP</Setting>
  </Item>
  <Item Name="JH0120患者转区转床服务" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0120</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.5住院转科信息服务BP</Setting>
  </Item>
  <Item Name="JH0121出院登记信息新增服务" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0121</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.6出院登记信息服务BP</Setting>
  </Item>
  <Item Name="JH0122出院登记信息更新服务" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0122</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.6出院登记信息服务BP</Setting>
  </Item>
  <Item Name="JH0123出院信息查询服务" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0123</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.6出院登记信息服务BP</Setting>
  </Item>
  <Item Name="JH0124取消出院服务" Category="01.就诊信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0124</Setting>
    <Setting Target="Host" Name="TargetConfigNames">01.6出院登记信息服务BP</Setting>
  </Item>
  <Item Name="JH0201检查申请消息新增服务" Category="02.申请单信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0201</Setting>
    <Setting Target="Host" Name="TargetConfigNames">02.1检查申请单服务BP</Setting>
  </Item>
  <Item Name="JH0202检查申请信息更新服务" Category="02.申请单信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0202</Setting>
    <Setting Target="Host" Name="TargetConfigNames">02.1检查申请单服务BP</Setting>
  </Item>
  <Item Name="JH0203检查申请单信息查询服务" Category="02.申请单信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0203</Setting>
    <Setting Target="Host" Name="TargetConfigNames">02.1检查申请单服务BP</Setting>
  </Item>
  <Item Name="JH0204取消检查申请服务" Category="02.申请单信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0204</Setting>
    <Setting Target="Host" Name="TargetConfigNames">02.1检查申请单服务BP</Setting>
  </Item>
  <Item Name="JH0205检查退费服务" Category="02.申请单信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0205</Setting>
    <Setting Target="Host" Name="TargetConfigNames">02.1检查申请单服务BP</Setting>
  </Item>
  <Item Name="JH0206检验申请信息新增服务" Category="02.申请单信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">02.2检验申请单服务BP</Setting>
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0206</Setting>
  </Item>
  <Item Name="JH0207检验申请信息更新服务" Category="02.申请单信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0207</Setting>
    <Setting Target="Host" Name="TargetConfigNames">02.2检验申请单服务BP</Setting>
  </Item>
  <Item Name="JH0208检验申请信息查询服务" Category="02.申请单信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0208</Setting>
    <Setting Target="Host" Name="TargetConfigNames">02.2检验申请单服务BP</Setting>
  </Item>
  <Item Name="JH0209取消检验申请服务" Category="02.申请单信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0209</Setting>
    <Setting Target="Host" Name="TargetConfigNames">02.2检验申请单服务BP</Setting>
  </Item>
  <Item Name="JH0210病理申请信息新增服务" Category="02.申请单信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0210</Setting>
    <Setting Target="Host" Name="TargetConfigNames">02.3病理申请单服务BP</Setting>
  </Item>
  <Item Name="JH0211病理申请信息更新服务" Category="02.申请单信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0211</Setting>
    <Setting Target="Host" Name="TargetConfigNames">02.3病理申请单服务BP</Setting>
  </Item>
  <Item Name="JH0212病理申请信息查询服务" Category="02.申请单信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0212</Setting>
    <Setting Target="Host" Name="TargetConfigNames">02.3病理申请单服务BP</Setting>
  </Item>
  <Item Name="JH0213手术申请信息新增服务" Category="02.申请单信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0213</Setting>
    <Setting Target="Host" Name="TargetConfigNames">02.4手术申请单服务BP</Setting>
  </Item>
  <Item Name="JH0214手术申请信息更新服务" Category="02.申请单信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0214</Setting>
    <Setting Target="Host" Name="TargetConfigNames">02.4手术申请单服务BP</Setting>
  </Item>
  <Item Name="JH0215手术申请信息查询服务" Category="02.申请单信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0215</Setting>
    <Setting Target="Host" Name="TargetConfigNames">02.4手术申请单服务BP</Setting>
  </Item>
  <Item Name="JH0216取消手术申请服务" Category="02.申请单信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0216</Setting>
    <Setting Target="Host" Name="TargetConfigNames">02.4手术申请单服务BP</Setting>
  </Item>
  <Item Name="JH0217输血申请信息新增服务" Category="02.申请单信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0217</Setting>
    <Setting Target="Host" Name="TargetConfigNames">02.5输血申请单服务BP</Setting>
  </Item>
  <Item Name="JH0218输血申请信息更新服务" Category="02.申请单信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0218</Setting>
    <Setting Target="Host" Name="TargetConfigNames">02.5输血申请单服务BP</Setting>
  </Item>
  <Item Name="JH0219输血申请信息查询服务" Category="02.申请单信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0219</Setting>
    <Setting Target="Host" Name="TargetConfigNames">02.5输血申请单服务BP</Setting>
  </Item>
  <Item Name="JH0301医嘱信息新增服务" Category="03.医嘱信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0301</Setting>
    <Setting Target="Host" Name="TargetConfigNames">03.1医嘱信息服务BP</Setting>
  </Item>
  <Item Name="JH0302医嘱信息修改服务" Category="03.医嘱信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0302</Setting>
    <Setting Target="Host" Name="TargetConfigNames">03.1医嘱信息服务BP</Setting>
  </Item>
  <Item Name="JH0303医嘱信息查询服务" Category="03.医嘱信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0303</Setting>
    <Setting Target="Host" Name="TargetConfigNames">03.1医嘱信息服务BP</Setting>
  </Item>
  <Item Name="JH0304用药医嘱信息服务" Category="03.医嘱信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0304</Setting>
    <Setting Target="Host" Name="TargetConfigNames">03.1医嘱信息服务BP</Setting>
  </Item>
  <Item Name="JH0305诊疗处置服务" Category="03.医嘱信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0305</Setting>
    <Setting Target="Host" Name="TargetConfigNames">03.1医嘱信息服务BP</Setting>
  </Item>
  <Item Name="JH0306护理医嘱信息服务" Category="03.医嘱信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0306</Setting>
    <Setting Target="Host" Name="TargetConfigNames">03.1医嘱信息服务BP</Setting>
  </Item>
  <Item Name="JH0307其它医嘱信息服务" Category="03.医嘱信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0307</Setting>
    <Setting Target="Host" Name="TargetConfigNames">03.1医嘱信息服务BP</Setting>
  </Item>
  <Item Name="JH0308处方服务" Category="03.医嘱信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0308</Setting>
    <Setting Target="Host" Name="TargetConfigNames">03.2处方信息服务BP</Setting>
  </Item>
  <Item Name="JH0401医嘱执行状态信息更新服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0401</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.1医嘱执行状态服务BP</Setting>
  </Item>
  <Item Name="JH0402医嘱执行状态信息查询服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0402</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.1医嘱执行状态服务BP</Setting>
  </Item>
  <Item Name="JH0403医嘱撤销" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0403</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.1医嘱执行状态服务BP</Setting>
  </Item>
  <Item Name="JH0404停止服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0404</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.1医嘱执行状态服务BP</Setting>
  </Item>
  <Item Name="JH0405检查状态信息更新服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0405</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.2检查状态服务BP</Setting>
  </Item>
  <Item Name="JH0406检查状态信息查询服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0406</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.2检查状态服务BP</Setting>
  </Item>
  <Item Name="JH0407检查结果信息新增服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0407</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.3检查结果服务BP</Setting>
  </Item>
  <Item Name="JH0408检查结果信息更新服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0408</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.3检查结果服务BP</Setting>
  </Item>
  <Item Name="JH0409检查结果信息查询服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0409</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.3检查结果服务BP</Setting>
  </Item>
  <Item Name="JH0410检查报告回传服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0410</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.3检查结果服务BP</Setting>
  </Item>
  <Item Name="JH0411检验状态信息更新服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0411</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.4检验状态服务BP</Setting>
  </Item>
  <Item Name="JH0412检验状态信息查询服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0412</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.4检验状态服务BP</Setting>
  </Item>
  <Item Name="JH0413检体核收服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0413</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.4检验状态服务BP</Setting>
  </Item>
  <Item Name="JH0414检体拒收服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0414</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.4检验状态服务BP</Setting>
  </Item>
  <Item Name="JH0415普通检验结果信息新增服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0415</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.5普通检验结果状态服务BP</Setting>
  </Item>
  <Item Name="JH0416普通检验结果信息更新服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0416</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.5普通检验结果状态服务BP</Setting>
  </Item>
  <Item Name="JH0417普通检验结果信息查询服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0417</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.5普通检验结果状态服务BP</Setting>
  </Item>
  <Item Name="JH0418药敏检验结果信息新增服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0418</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.7药敏检验结果状态服务BP</Setting>
  </Item>
  <Item Name="JH0419药敏检验结果信息更新服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0419</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.7药敏检验结果状态服务BP</Setting>
  </Item>
  <Item Name="JH0420药敏检验结果信息查询服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0420</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.7药敏检验结果状态服务BP</Setting>
  </Item>
  <Item Name="JH0421检验报告回传服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0421</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.5普通检验结果状态服务BP</Setting>
  </Item>
  <Item Name="JH0422病理结果信息新增服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0422</Setting>
    <Setting Target="Host" Name="TargetConfigNames"></Setting>
  </Item>
  <Item Name="JH0423病理结果信息更新服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0423</Setting>
    <Setting Target="Host" Name="TargetConfigNames"></Setting>
  </Item>
  <Item Name="JH0424病理结果信息查询服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0424</Setting>
    <Setting Target="Host" Name="TargetConfigNames"></Setting>
  </Item>
  <Item Name="JH0425手术排班信息新增服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0425</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.6手术排班服务BP</Setting>
  </Item>
  <Item Name="JH0426手术排班信息更新服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0426</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.6手术排班服务BP</Setting>
  </Item>
  <Item Name="JH0427手术排班信息查询服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0427</Setting>
    <Setting Target="Host" Name="TargetConfigNames">04.6手术排班服务BP</Setting>
  </Item>
  <Item Name="JH0428手术状态信息更新服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0428</Setting>
  </Item>
  <Item Name="JH0429手术状态信息查询服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0429</Setting>
  </Item>
  <Item Name="JH0501门诊预约状态信息新增服务" Category="05.预约信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0501</Setting>
    <Setting Target="Host" Name="TargetConfigNames">05.1门诊预约状态信息服务BP</Setting>
  </Item>
  <Item Name="JH0502门诊预约状态信息更新服务" Category="05.预约信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0502</Setting>
    <Setting Target="Host" Name="TargetConfigNames">05.1门诊预约状态信息服务BP</Setting>
  </Item>
  <Item Name="JH0503门诊预约状态信息查询服务" Category="05.预约信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0503</Setting>
    <Setting Target="Host" Name="TargetConfigNames">05.1门诊预约状态信息服务BP</Setting>
  </Item>
  <Item Name="JH0504检查预约状态信息新增服务" Category="05.预约信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0504</Setting>
    <Setting Target="Host" Name="TargetConfigNames">05.2检查预约状态信息服务BP</Setting>
  </Item>
  <Item Name="JH0505检查预约状态信息更新服务" Category="05.预约信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0505</Setting>
    <Setting Target="Host" Name="TargetConfigNames">05.2检查预约状态信息服务BP</Setting>
  </Item>
  <Item Name="JH0506检查预约状态信息查询服务" Category="05.预约信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0506</Setting>
    <Setting Target="Host" Name="TargetConfigNames">05.2检查预约状态信息服务BP</Setting>
  </Item>
  <Item Name="JH0601医疗卫生机构信息注册服务" Category="06.医疗卫生机构管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0601</Setting>
    <Setting Target="Host" Name="TargetConfigNames">06.1医疗卫生机构信息服务BP</Setting>
  </Item>
  <Item Name="JH0602医疗卫生机构信息更新服务" Category="06.医疗卫生机构管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0602</Setting>
    <Setting Target="Host" Name="TargetConfigNames">06.1医疗卫生机构信息服务BP</Setting>
  </Item>
  <Item Name="JH0603医疗卫生机构信息删除服务" Category="06.医疗卫生机构管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0603</Setting>
    <Setting Target="Host" Name="TargetConfigNames">06.1医疗卫生机构信息服务BP</Setting>
  </Item>
  <Item Name="JH0604医疗卫生机构信息查询服务" Category="06.医疗卫生机构管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0604</Setting>
    <Setting Target="Host" Name="TargetConfigNames">06.1医疗卫生机构信息服务BP</Setting>
  </Item>
  <Item Name="JH0605科室订阅信息同步服务" Category="06.医疗卫生机构管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0605</Setting>
    <Setting Target="Host" Name="TargetConfigNames">06.1医疗卫生机构信息服务BP</Setting>
  </Item>
  <Item Name="JH0701医疗卫生人员信息注册服务" Category="07.医疗卫生人员管理" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0701</Setting>
    <Setting Target="Host" Name="TargetConfigNames">07.1医疗卫生人员信息服务BP</Setting>
  </Item>
  <Item Name="JH0702医疗卫生人员信息更新服务" Category="07.医疗卫生人员管理" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0702</Setting>
    <Setting Target="Host" Name="TargetConfigNames">07.1医疗卫生人员信息服务BP</Setting>
  </Item>
  <Item Name="JH0703医疗卫生人员信息删除服务" Category="07.医疗卫生人员管理" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0703</Setting>
    <Setting Target="Host" Name="TargetConfigNames">07.1医疗卫生人员信息服务BP</Setting>
  </Item>
  <Item Name="JH0704医疗卫生人员信息查询服务" Category="07.医疗卫生人员管理" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0704</Setting>
    <Setting Target="Host" Name="TargetConfigNames">07.1医疗卫生人员信息服务BP</Setting>
  </Item>
  <Item Name="JH0705人员订阅信息同步服务" Category="07.医疗卫生人员管理" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0705</Setting>
    <Setting Target="Host" Name="TargetConfigNames">07.1医疗卫生人员信息服务BP</Setting>
  </Item>
  <Item Name="JH0801电子病历文档注册服务" Category="08.电子病历管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0801</Setting>
    <Setting Target="Host" Name="TargetConfigNames">08.1电子病历文档信息服务BP</Setting>
  </Item>
  <Item Name="JH0802电子病历文档检索服务" Category="08.电子病历管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0802</Setting>
    <Setting Target="Host" Name="TargetConfigNames">08.1电子病历文档信息服务BP</Setting>
  </Item>
  <Item Name="JH0803电子病历文档调阅服务" Category="08.电子病历管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0803</Setting>
    <Setting Target="Host" Name="TargetConfigNames">08.1电子病历文档信息服务BP</Setting>
  </Item>
  
  <Item Name="00.1患者管理服务BP" Category="00.患者管理服务" ClassName="JHIP.Patient.BP.Manage" PoolSize="1" Enabled="false" Foreground="false" Comment="患者管理服务消息路由，负责分发患者管理服务消息" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="01.1就诊卡信息服务BP" Category="01.就诊信息交互服务" ClassName="JHIP.Visited.BP.VisitCard" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="01.2号源排班信息服务BP" Category="01.就诊信息交互服务" ClassName="JHIP.Visited.BP.NumSchedule" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="01.3门诊挂号信息服务BP" Category="01.就诊信息交互服务" ClassName="JHIP.Visited.BP.Outpatient" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="01.4住院就诊信息服务BP" Category="01.就诊信息交互服务" ClassName="JHIP.Visited.BP.Hospitalization" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="01.5住院转科信息服务BP" Category="01.就诊信息交互服务" ClassName="JHIP.Visited.BP.Transfer" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="01.6出院登记信息服务BP" Category="01.就诊信息交互服务" ClassName="JHIP.Visited.BP.Discharged" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="02.1检查申请单服务BP" Category="02.申请单信息交互服务" ClassName="JHIP.Application.BP.Check" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="02.2检验申请单服务BP" Category="02.申请单信息交互服务" ClassName="JHIP.Application.BP.Verify" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="02.3病理申请单服务BP" Category="02.申请单信息交互服务" ClassName="JHIP.Application.BP.Pathology" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="02.4手术申请单服务BP" Category="02.申请单信息交互服务" ClassName="JHIP.Application.BP.Operation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="02.5输血申请单服务BP" Category="02.申请单信息交互服务" ClassName="JHIP.Application.BP.Metachysis" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="03.1医嘱信息服务BP" Category="03.医嘱信息交互服务" ClassName="JHIP.Order.BP.Order" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="03.2处方信息服务BP" Category="03.医嘱信息交互服务" ClassName="JHIP.Order.BP.Prescription" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="04.1医嘱执行状态服务BP" Category="04.结果、状态信息交互服务" ClassName="JHIP.ResultStatus.BP.Order" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="04.2检查状态服务BP" Category="04.结果、状态信息交互服务" ClassName="JHIP.ResultStatus.BP.CheckStatu" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="04.3检查结果服务BP" Category="04.结果、状态信息交互服务" ClassName="JHIP.ResultStatus.BP.CheckResult" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="04.4检验状态服务BP" Category="04.结果、状态信息交互服务" ClassName="JHIP.ResultStatus.BP.VerifyStatu" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="04.5普通检验结果状态服务BP" Category="04.结果、状态信息交互服务" ClassName="JHIP.ResultStatus.BP.OrdinaryVerify" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="04.7药敏检验结果状态服务BP" Category="04.结果、状态信息交互服务" ClassName="JHIP.ResultStatus.BP.DrugSensitivity" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="04.6手术排班服务BP" Category="04.结果、状态信息交互服务" ClassName="JHIP.ResultStatus.BP.OperationScheduling" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="05.1门诊预约状态信息服务BP" Category="05.预约信息交互服务" ClassName="JHIP.Reserve.BP.Outpatient" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="05.2检查预约状态信息服务BP" Category="05.预约信息交互服务" ClassName="JHIP.Reserve.BP.Check" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="06.1医疗卫生机构信息服务BP" Category="06.医疗卫生机构管理服务" ClassName="JHIP.Department.BP.Department" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="07.1医疗卫生人员信息服务BP" Category="07.医疗卫生人员管理" ClassName="JHIP.Doctor.BP.Doctor" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="08.1电子病历文档信息服务BP" Category="08.电子病历管理服务" ClassName="JHIP.CDA.BP.CDA" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="09.1术语信息服务BP" Category="09.术语管理服务" ClassName="JHIP.Term.BP.Term" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="JH1002存储文件_存储时开启" Category="10.系统级管理服务" ClassName="JHIPLIB.Util.Save.BS.GetService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="FilePath">C:\JHV3系统管理消息模版\</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.xslt</Setting>
    <Setting Target="Adapter" Name="Charset">@UTF8</Setting>
    <Setting Target="Host" Name="MethodName">Insert</Setting>
  </Item>
  <Item Name="JHIP文件存储工具" Category="10.系统级管理服务" ClassName="JHIPLIB.Util.Save.BO.SaveOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Ens.Activity.Operation.Local" Category="10.系统级管理服务" ClassName="Ens.Activity.Operation.Local" PoolSize="1" Enabled="false" Foreground="false" Comment="活动量统计组件" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="JHIP同步合作伙伴BO" Category="10.系统级管理服务" ClassName="JHIPLIB.JHIPV5.SyncPartner.BO.SyncPartnerBO" PoolSize="1" Enabled="false" Foreground="false" Comment="同步合作伙伴BO" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="JH1001同步合作伙伴" Category="10.系统级管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigNames">10.1同步合作伙伴BP</Setting>
  </Item>
 
 
  <Item Name="JHIP生成代理类工具" Category="10.系统级管理服务" ClassName="JHIPLIB.Util.WSC.CreateAgent" PoolSize="1" Enabled="false" Foreground="false" Comment="JHIP生成代理类工具" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="Ens.Alert" Category="10.系统级管理服务" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Validation"></Setting>
    <Setting Target="Host" Name="BusinessRuleName">JHIPLIB.Util.Alert.BR.AlertBR</Setting>
    <Setting Target="Host" Name="ResponseFrom">JHIP推送告警服务BO</Setting>
  </Item>
  <Item Name="JHIP推送告警服务BO" Category="10.系统级管理服务" ClassName="JHIPLIB.Util.Alert.BO.InvokeAliServiceBO" PoolSize="1" Enabled="false" Foreground="false" Comment="推送告警信息给相应BO" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="WebServiceClientClass">JHIPLIB.Util.Alert.WSClient.MessageServiceSoap</Setting>
    <Setting Target="Adapter" Name="WebServiceURL">http://101.200.35.32/csp/healthshare/jhip/service/JHIP.Project.BS.MessageService.cls?wsdl</Setting>
    <Setting Target="Host" Name="HospitalName">嘉和美康信息医院</Setting>
    <Setting Target="Adapter" Name="Credentials">Alert</Setting>
    <Setting Target="Adapter" Name="SOAPCredentials">Alert</Setting>
  </Item>
  <Item Name="JH0001新增患者信息服务HTTP" Category="00.患者管理服务" ClassName="JHIPLIB.HTTP.BS.HTTPService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BodyType">JSON</Setting>
    <Setting Target="Host" Name="TargetConfigNames">00.1患者管理服务BP</Setting>
    <Setting Target="Host" Name="DefCharEncoding">@UTF8</Setting>
    <Setting Target="Adapter" Name="Port">9986</Setting>
  </Item>
  <Item Name="JHIPV5患者主索引BO" Category="00.患者管理服务" ClassName="JHIPLIB.SOAP.BO.JHIPBaseBO" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="WebServiceURL">http://192.168.7.114:10004/empi/services/patient?wsdl</Setting>
    <Setting Target="Host" Name="EventMethod">JH0001:PIXAdd,REQUEST;JH0002:PIXUpdate,REQUEST;JH0004:PIXQueryGroup,REQUEST;</Setting>
    <Setting Target="Adapter" Name="WebServiceClientClass">JHIP.JHIPV5.EMPI.WS.EmpiWebserviceImplPort</Setting>
    <Setting Target="Host" Name="ReplyCodeActions">E=R</Setting>
  </Item>
  <Item Name="JHIPV5主数据服务BO" Category="" ClassName="JHIPLIB.SOAP.BO.JHIPBaseBO" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="WebServiceClientClass">JHIP.JHIPV5.MDM.WS.DictDataWebserviceImplPort</Setting>
    <Setting Target="Adapter" Name="WebServiceURL">http://172.16.0.41:10007/mdm/mdmWebservice/MasterDataRetrieve</Setting>
    <Setting Target="Host" Name="EventMethod">JH0701:addDict,REQUEST;JH0702:updateDict,REQUEST;JH0703:deleteDict,REQUEST;JH0704:queryDict,REQUEST;</Setting>
  </Item>
  <Item Name="JHIPV5人员主索引BO" Category="" ClassName="JHIPLIB.SOAP.BO.JHIPBaseBO" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="EventMethod">JH1101:createPeople,REQUEST;JH1102:updatePeople,REQUEST;JH1103:deletePeople,REQUEST;JH1104:queryPeople,REQUEST;</Setting>
    <Setting Target="Adapter" Name="WebServiceClientClass">JHIP.JHIPV5.EMUI.WS.PeopleDataWebserviceImplPort</Setting>
    <Setting Target="Adapter" Name="WebServiceURL">http://172.16.0.30:10005/emui/services/userdata</Setting>
    <Setting Target="Host" Name="ReplyCodeActions">E=R</Setting>
    <Setting Target="Adapter" Name="ConnectTimeout">19</Setting>
    <Setting Target="Adapter" Name="ResponseTimeout">2</Setting>
    <Setting Target="Host" Name="FailureTimeout">40</Setting>
    <Setting Target="Host" Name="RetryInterval">8</Setting>
  </Item>
  <Item Name="JHIPV5科室主索引BO" Category="" ClassName="JHIPLIB.SOAP.BO.JHIPBaseBO" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="WebServiceClientClass">JHIP.JHIPV5.EMDI.WS.DeptMaintainWebserviceImplPort</Setting>
    <Setting Target="Adapter" Name="WebServiceURL">http://172.16.0.41:10003/emdi/services/emdiservice</Setting>
    <Setting Target="Host" Name="EventMethod">JH1201:addDept,REQUEST;JH1202:updateDept,REQUEST;JH1203:deleteDept,REQUEST;JH1204:queryDept,REQUEST;</Setting>
  </Item>
  <Item Name="JH0220会诊申请服务" Category="02.申请单信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0220</Setting>
  </Item>
  <Item Name="JH0430病理报告回传服务" Category="04.结果、状态信息交互服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  
  <Item Name="HDR数据中心EDI服务BO" Category="00.患者管理服务" ClassName="JHIPLIB.SOAP.BO.JHIPBaseBO" PoolSize="1" Enabled="false" Foreground="false" Comment="HDR数据中心EDI服务BO" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="WebServiceURL"></Setting>
  </Item>
  <Item Name="医务系统科室服务BO" Category="06.医疗卫生机构管理服务" ClassName="JHIPLIB.SOAP.BO.JHIPBaseBO" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="EventMethod">JH0601:deptSyncRegister,REQUEST;JH0602:deptSyncUpdate,REQUEST;JH0603:deptSyncDelete,REQUEST;JH0604:deptSyncQuery,REQUEST;</Setting>
    <Setting Target="Adapter" Name="WebServiceClientClass">JHIP.YW.WSC.DeptSyncServiceImplPort</Setting>
    <Setting Target="Adapter" Name="WebServiceURL">http://192.168.17.184:8000/soap/deptSync?wsdl</Setting>
  </Item>
  <Item Name="医务系统人员服务BO" Category="07.医疗卫生人员管理" ClassName="JHIPLIB.SOAP.BO.JHIPBaseBO" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="EventMethod">JH0701:employeeSyncRegister,REQUEST;JH0702:employeeSyncUpdate,REQUEST;JH0703:employeeSyncDelete,REQUEST;JH0704:employeeSyncQuery,REQUEST;</Setting>
    <Setting Target="Adapter" Name="WebServiceClientClass">JHIP.YW.WSC.EmployeeSyncServiceImplPort</Setting>
    <Setting Target="Adapter" Name="WebServiceURL">http://192.168.17.184:8000/soap/employeeSync?wsdl</Setting>
  </Item>
  
  
  
  
  <Item Name="EMR接收字典服务BO" Category="09.术语管理服务" ClassName="JHIPLIB.SOAP.BO.JHIPBaseBO" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="人事系统接收字典服务BO" Category="09.术语管理服务" ClassName="JHIPLIB.SOAP.BO.JHIPBaseBO" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="JH0901术语内容注册服务" Category="09.术语管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0901</Setting>
    <Setting Target="Host" Name="TargetConfigNames">09.1术语信息服务BP</Setting>
  </Item>
  <Item Name="JH0902术语内容更新服务" Category="09.术语管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0902</Setting>
    <Setting Target="Host" Name="TargetConfigNames">09.1术语信息服务BP</Setting>
  </Item>
  <Item Name="JH0903术语内容停用服务" Category="09.术语管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0903</Setting>
    <Setting Target="Host" Name="TargetConfigNames">09.1术语信息服务BP</Setting>
  </Item>
  <Item Name="JH0904术语内容查询服务" Category="09.术语管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0904</Setting>
    <Setting Target="Host" Name="TargetConfigNames">09.1术语信息服务BP</Setting>
  </Item>
  <Item Name="JH0905全术语内容查询服务" Category="09.术语管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0905</Setting>
    <Setting Target="Host" Name="TargetConfigNames">09.1术语信息服务BP</Setting>
  </Item>
  <Item Name="JH0906术语结构注册服务" Category="09.术语管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0906</Setting>
    <Setting Target="Host" Name="TargetConfigNames">09.1术语信息服务BP</Setting>
  </Item>
  <Item Name="JH0907术语结构更新服务" Category="09.术语管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0907</Setting>
    <Setting Target="Host" Name="TargetConfigNames">09.1术语信息服务BP</Setting>
  </Item>
  <Item Name="JH0908术语结构停用服务" Category="09.术语管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0908</Setting>
    <Setting Target="Host" Name="TargetConfigNames">09.1术语信息服务BP</Setting>
  </Item>
  <Item Name="JH0907术语结构查询服务" Category="09.术语管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0907</Setting>
    <Setting Target="Host" Name="TargetConfigNames">09.1术语信息服务BP</Setting>
  </Item>
  <Item Name="JH0910术语订阅信息同步" Category="09.术语管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0910</Setting>
    <Setting Target="Host" Name="TargetConfigNames">09.1术语信息服务BP</Setting>
  </Item>
  <Item Name="JH0911全字典发布" Category="09.术语管理服务" ClassName="JHIPLIB.SOAP.BS.HL7V3Service" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="SearchTableClass">JHIPLIB.SearchTable.HL7V3.JH0911</Setting>
    <Setting Target="Host" Name="TargetConfigNames">09.1术语信息服务BP</Setting>
  </Item>
  <Item Name="JH0901术语内容注册数据采集服务" Category="09.术语管理服务" ClassName="JHIPLIB.SQL.BS.SQLService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
    <Setting Target="Host" Name="TableName">DICT_Test</Setting>
    <Setting Target="Host" Name="TargetConfigNames">09.1术语信息服务BP</Setting>
    <Setting Target="Adapter" Name="CallInterval">180</Setting>
    <Setting Target="Adapter" Name="DSN">JDBCJH</Setting>
    <Setting Target="Adapter" Name="KeyFieldName"></Setting>
    <Setting Target="Adapter" Name="Query">select * from term_attributes</Setting>
  </Item>
  <Item Name="JH0902术语内容更新数据采集服务" Category="09.术语管理服务" ClassName="JHIPLIB.SQL.BS.SQLService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
    <Setting Target="Host" Name="TableName">DICT_Test</Setting>
    <Setting Target="Host" Name="TargetConfigNames">09.1术语信息服务BP</Setting>
    <Setting Target="Adapter" Name="CallInterval">180</Setting>
    <Setting Target="Adapter" Name="DSN">JDBCJH</Setting>
    <Setting Target="Adapter" Name="KeyFieldName"></Setting>
    <Setting Target="Adapter" Name="Query">select * from term_attributes</Setting>
  </Item>
  <Item Name="JH0903术语内容停用数据采集服务" Category="09.术语管理服务" ClassName="JHIPLIB.SQL.BS.SQLService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
    <Setting Target="Host" Name="TableName">DICT_Test</Setting>
    <Setting Target="Host" Name="TargetConfigNames">09.1术语信息服务BP</Setting>
    <Setting Target="Adapter" Name="CallInterval">180</Setting>
    <Setting Target="Adapter" Name="DSN">JDBCJH</Setting>
    <Setting Target="Adapter" Name="KeyFieldName"></Setting>
    <Setting Target="Adapter" Name="Query">select * from term_attributes</Setting>
  </Item>
  <Item Name="JH0906术语结构注册数据采集服务" Category="09.术语管理服务" ClassName="JHIPLIB.SQL.BS.SQLService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
    <Setting Target="Host" Name="TableName">DICT_Test</Setting>
    <Setting Target="Host" Name="TargetConfigNames">09.1术语信息服务BP</Setting>
    <Setting Target="Adapter" Name="CallInterval">180</Setting>
    <Setting Target="Adapter" Name="DSN">JDBCJH</Setting>
    <Setting Target="Adapter" Name="KeyFieldName"></Setting>
    <Setting Target="Adapter" Name="Query">select * from term_attributes</Setting>
  </Item>
  <Item Name="JH0907术语结构更新数据采集服务" Category="09.术语管理服务" ClassName="JHIPLIB.SQL.BS.SQLService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
    <Setting Target="Host" Name="TableName">DICT_Test</Setting>
    <Setting Target="Host" Name="TargetConfigNames">09.1术语信息服务BP</Setting>
    <Setting Target="Adapter" Name="CallInterval">180</Setting>
    <Setting Target="Adapter" Name="DSN">JDBCJH</Setting>
    <Setting Target="Adapter" Name="KeyFieldName"></Setting>
    <Setting Target="Adapter" Name="Query">select * from term_attributes</Setting>
  </Item>
  <Item Name="JH0908术语结构停用数据采集服务" Category="09.术语管理服务" ClassName="JHIPLIB.SQL.BS.SQLService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
    <Setting Target="Host" Name="TableName">DICT_Test</Setting>
    <Setting Target="Host" Name="TargetConfigNames">09.1术语信息服务BP</Setting>
    <Setting Target="Adapter" Name="CallInterval">180</Setting>
    <Setting Target="Adapter" Name="DSN">JDBCJH</Setting>
    <Setting Target="Adapter" Name="KeyFieldName"></Setting>
    <Setting Target="Adapter" Name="Query">select * from term_attributes</Setting>
  </Item>
</Production>
}

}
