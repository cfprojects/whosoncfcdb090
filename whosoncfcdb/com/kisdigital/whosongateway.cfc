<cfcomponent output="false" hint="WhosOn database gateway object">

	<cffunction name="init" returntype="whosongateway" hint="I return an instance of whosoncfcgateway">
		<cfargument name="transfer" type="any" required="true" hint="I am the transfer object" />
		<cfset var purgeQuery = "" />
		
		<cfset variables.transfer=arguments.transfer />
		
		<!--- Purge out the database --->
		
		<cfset variables.transfer.getTransfer().discardAll() />
	
		<cfreturn this />
	</cffunction>
	
	<cffunction name="addHistory" returntype="boolean" access="public" hint="I add a page to the history">
		<cfargument name="userData" type="struct" required="true" />
		
		<cfset var thisHit = "" />
		<cfset var thisUser = "" />
		<cfscript>
			
			thisUser=variables.transfer.getTransfer().get('whosoncfc.user',arguments.userData.ClientID);
			thisHit=variables.transfer.getTransfer().new('whosoncfc.pageHits');
			
			thisHit.setPage(arguments.userData.CurrentPage);
			thisHit.setLoadTime(Now());
			
			thisHit.setParentUser(thisUser);
			
			variables.transfer.getTransfer().create(thisHit);
			
			return true;
		</cfscript>
	</cffunction>
	
	<cffunction name="getPageHistory" returntype="query" access="public" hint="I return a query of page hits">
		<cfargument name="ClientID" type="string" required="true" />
		
		<cfreturn variables.transfer.getTransfer().listByProperty("whosoncfc.pageHits","ClientID",arguments.ClientID,"LoadTime") />
	</cffunction>
	
	<cffunction name="getUserByID" returntype="query" access="public" hint="I return a user with a given ClientID">
		<cfargument name="ClientID" type="string" required="true" />
		
		<cfset var transfer=variables.transfer.getTransfer() />
		<cfset var myQuery="" />
		
		<cfset myQuery=transfer.listByProperty("whosoncfc.user","ClientID",arguments.ClientID) />		
		
		<cfreturn myQuery />
	</cffunction>
	
	<cffunction name="getUsers" returntype="query" hint="I return users stored in the database">
		<cfset var transfer=variables.transfer.getTransfer() />
		
		<cfreturn transfer.list("whosoncfc.user") />
	</cffunction>
	
	<cffunction name="isTracked" returntype="boolean" access="public" hint="I check to see if we are tracking a given client">
		<cfargument name="ClientID" type="string" required="true" />
		
		<cfset var transfer=variables.transfer.getTransfer() />
		<cfset var myQuery="" />
		
		<cfset myQuery=transfer.listByProperty("whosoncfc.user","ClientID",arguments.ClientID) />
		
		<cfif myQuery.RecordCount gt 0>
			<cfreturn true />
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>
	
	<cffunction name="purgeUsers" returntype="boolean" access="public" hint="I get rid of expired data">
		<cfargument name="trackTime" type="numeric" required="true" hint="How many hours to track usrs" />
		<cfargument name="botTrackTime" type="numeric" required="true" hint="How many hours to track bots" />
		
		<cfset var transfer=variables.transfer.getTransfer() />
		<cfset var uQuery = "" />
		<cfset var user = "" />
		
		<cfset uQuery=transfer.list("whosoncfc.user") />
		
		<cfloop query="uquery">
			<cfif uQuery.HideClient is false>
				<cfif dateDiff("n",uQuery.LastUpdated,Now()) gte (60*arguments.trackTime)>
					<cfset user=transfer.get('whosoncfc.user',uQuery.ClientID) />
					<cfset transfer.cascadeDelete(user) />
				</cfif>
			<cfelse>
				<cfif dateDiff("n",uQuery.LastUpdated,Now()) gte (60*arguments.botTrackTime)>
					<cfset user=transfer.get('whosoncfc.user',uQuery.ClientID) />
					<cfset transfer.cascadeDelete(user) />
				</cfif>			
			</cfif>
		</cfloop>
		
		<cfreturn true />
	</cffunction>
	
	<cffunction name="saveUser" returntype="boolean" access="public" hint="I write hits to the user database">
		<cfargument name="userInfo" type="struct" required="true" />
	
		<cfset var transfer=variables.transfer.getTransfer() />
		<cfset var user = "" />
		<cfset var myCount=1 />
		
		<cfscript>
			user=transfer.get('whosoncfc.user',userInfo.ClientID);
			
			if(not user.getIsPersisted()){
				// New User, insert all detals into database
				user.setClientID(userInfo.ClientID);
				user.setUserID(userInfo.UserID);
				user.setRoles(userInfo.Roles);
				user.setCreated(Now());
				user.setLastUpdated(Now());
				user.setIP(userInfo.IP);
				user.setHostName(userInfo.Hostname);
				user.setCoords(userInfo.Coords);
				user.setCountry(userInfo.Country);
				user.setCity(userInfo.City);
				user.setHideClient(userInfo.HideClient);
				user.setReferer(userInfo.Referer);
				user.setEntryPage(userInfo.EntryPage);
				user.setCurrentPage(userInfo.CurrentPage);
				user.setPageHits(myCount);	
				user.setUserAgent(userInfo.UserAgent);
				user.setServerName(userInfo.ServerName);			
			} else {
				// Updating an existing client
				
				myCount=user.getPageHits();
				user.setUserID(userInfo.UserID);
				user.setRoles(userInfo.Roles);
				user.setLastUpdated(Now());
				user.setIP(userInfo.IP);
				user.setCurrentPage(userInfo.CurrentPage);
				user.setPageHits(myCount+1);
				user.setServerName(userInfo.ServerName);
			}

			transfer.save(user);
		</cfscript>		
		
		<cfreturn true />
	</cffunction>
	
</cfcomponent>
