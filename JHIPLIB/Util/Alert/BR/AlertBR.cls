/// 
Class JHIPLIB.Util.Alert.BR.AlertBR Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "EnsLib.MsgRouter.RuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="EnsLib.MsgRouter.RoutingEngine" production="">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="" disabled="false">
<constraint name="msgClass" value="Ens.AlertRequest"></constraint>
<when condition="1">
<send transform="" target="JHIP推送告警服务BO"></send>
<return></return>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
