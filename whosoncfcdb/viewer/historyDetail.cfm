<html>
	<head>
		<title>History Detail</title>
	</head>

<body>
<cfparam name="clientid" type="string" default="" />

<style>
body,td,#main{
	font-family: "Trebuchet MS", verdana, arial, sans-serif; 
	font-size: .8em; 
	color: #000000; 
}
</style>

<cfset thisClient=application.whoson.getUser(clientid=clientid) />

<div id="main" style="margin-left: 25px; margin-top: 25px;">
	
History View &raquo; <a href="/" style="color: blue;">Default Page</a> 

<cfform>
	<cfinput type="button" name="btnRefresh" value="Refresh Data" onclick="javascript:ColdFusion.navigate('historyDetail.cfm?clientid=#url.clientid#','mydiv');">
</cfform>

<p style="font-size: .9em;">
Client overview:
</p>

<cfoutput>
<table cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td width="150">Time To Live:</td>
		<td>
			<cfset InactiveTime=DateDiff("n",thisClient.LastUpdated,Now())>
			#application.whoson.getCurrentControlSet().trackTime*60 - InactiveTime# minutes
		</td>
	</tr>	
</table>
</cfoutput>

<br /><br />
<table cellspacing="0" cellpadding="2" border="0" style="width: 98%; border-left: 1px solid black;border-right: 1px solid black;border-top: 1px solid black;">
	
<cfloop list="#thisClient.ColumnList#" index="i">
	<cfoutput>
		
			<tr>
				<td style="border-right: 1px solid black; border-bottom: 1px solid black; background-color: d0cbfe; color: black;">#i#</td>
				<td style="border-bottom: 1px solid black;">
					#thisClient[i][1]#
					&nbsp;
				</td>
			</tr>
		
	</cfoutput>
</cfloop>

</table>

<cfset pageHistory=application.whoson.getHistory(clientid) />

	
	<p>
	Page history for this client:
	</p>
	
	<table cellspacing="0" cellpadding="2" border="0" style="width:98%; border-left: 1px solid black;border-right: 1px solid black;border-top: 1px solid black;">
		<tr>
			<td style="border-bottom: 1px solid black; border-right: 1px solid black; background-color: d0cbfe;">Page</td>
			<td style="border-bottom: 1px solid black; background-color: d0cbfe;">Viewed</td>
		</tr>	
		<cfloop query="pageHistory">
		<cfoutput> 
		<tr>
			<td style="border-bottom: 1px solid black; border-right: 1px solid black;">#page#</td>
			<td style="border-bottom: 1px solid black; width: 75px;">#DateFormat(LoadTime,"m/d/yy")#<br />#TimeFormat(LoadTime,"h:mm tt")#</td>
		</tr>		
		</cfoutput>
		</cfloop>
	</table>

</div>

</body>
</html>