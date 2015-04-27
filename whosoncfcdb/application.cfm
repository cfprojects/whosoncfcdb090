<cfapplication name="WhosOnCFCDB" clientmanagement="yes" sessionmanagement="yes" sessiontimeout="#CreateTimeSpan(0,0,30,0)#" loginstorage="session">

<cfif not structKeyExists(session,"userinfo") or structKeyExists(url,"logout")>
	<cfset session.userinfo.user="Guest" />
    <cfset session.userinfo.roles="" />
</cfif>

<cfif not isdefined("application.whosoninit") or not isdefined("application.transferFactory") or isdefined("url.reinit")> 
	<cfset session.user="Guest" />   
	
	<cfscript>
		// First create the transferFactory
		application.transferFactory = createObject('component', 'transfer.TransferFactory').init('/config/datasource.xml','/config/transfer.xml','/config/definitions');
		
		// Now create an instance of whosoncfcgateway passing it our transfer object
		application.whosongateway = createObject('component','com.kisdigital.whosongateway').init(application.transferFactory);
		
		// Configure WhosOnCFC settings
		whosonconfig=structNew();
		
		whosonconfig.trackTime=12;													// How many hours do we want WhosOnCFC to track
		whosonconfig.botTrackTime=1;												// How many hours do we want to track bots
		whosonconfig.ignoreIPs='';													// Supply a CSV list of FULL IP addresses to ignore
		
		whosonconfig.defaultTimeout=30;												// How many minutes to wait before timing out a session
		whosonconfig.botListUrl='http://whosoncfc.kisdigital.com/botlist.xml';		// URL for botlist.xml, leave blank if you do not wish to use the XML file
		whosonconfig.ipBlockListThreshhold=5;										// How many clientid's allowed from 1 IP address before it assumes its a bot
		whosonconfig.storeHistory=10;												// Minutes to retain history
		whosonconfig.botList='';													// Supply a CSV list of user-agents to ignore
		whosonconfig.ignorePages='/viewer';											// Supply a CSV list of files or directories you want ignored. Ex: '/admin/,/test/myfile.cfm'
		whosonconfig.showBots=true;													// Whether or not to keep track of bots {true/FALSE}
		whosonconfig.geoTrack=true;												    // Do we want to track geophysical location (true/FALSE)
		whosonconfig.pageHistory=true;												// Do we want to keep a history of pages the client visited? (true/FALSE)
		whosonconfig.useBlockList=false;											// Whether or not we want to use the internal block list (FALSE)
	</cfscript>

	<cfset application.whoson=createObject('component','com.kisdigital.whoson').init(args=whosonconfig,gateway=application.whosongateway) />
    
	<cfset application.lastInit=Now()>
	<cfset application.whosoninit=1>
</cfif>


<cfscript>
	thisRequest=structNew();
	thisRequest.thisClient=session.sessionid;
	thisRequest.thisUser=session.userinfo.user;
	thisRequest.Roles=session.userinfo.roles;
	thisRequest.Referer=CGI.HTTP_REFERER;
	thisRequest.IP=CGI.REMOTE_ADDR;
	if(CGI.PATH_INFO is CGI.SCRIPT_NAME){
		thisRequest.CurrentPage=CGI.SCRIPT_NAME;
	}else{
		thisRequest.CurrentPage=CGI.SCRIPT_NAME & CGI.PATH_INFO;
	}
	thisRequest.QueryString=CGI.QUERY_STRING;
	thisRequest.ServerName=CGI.SERVER_NAME;
	thisRequest.ServerPort=CGI.SERVER_PORT;
	thisRequest.Prefix="http://";
	if(CGI.HTTPS is "on") thisRequest.Prefix="https://";
	thisRequest.UserAgent=CGI.HTTP_USER_AGENT;
	thisRequest.trackedUser=application.whoson.WhosOnPageTracker(whoson=thisRequest);
	if(session.userinfo.user is not thisRequest.trackedUser){
		session.userinfo.user=thisRequest.trackedUser;
		session.userinfo.roles='';
	} 
</cfscript>



