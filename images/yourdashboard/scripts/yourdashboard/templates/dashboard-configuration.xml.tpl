<dashboard-configuration>
	<dashboard name="default">
		<row>
			<dashlet class="DashletClock" refresh="10000">
				<parameter key="location" value="Berlin, DE" />
				<parameter key="clockDiffUTC" value="+1" />
				<parameter key="clockSummertime" value="true" />
				<parameter key="displayUpdateString" value="false" />
			</dashlet>
		</row>
		<row>
			<dashlet class="DashletOpenNMSOutages" refresh="30000">
				<parameter key="title" value="Outages" />
				<parameter key="restUrl" value="{{ url }}/rest" />
				<parameter key="restUser" value="{{ user }}" />
				<parameter key="restPassword" value="{{ password }}" />
				<parameter key="linkUrlBase" value="/opennms" />
				<parameter key="maxEntries" value="10" />
				<parameter key="createAlarms" value="false" />
			</dashlet>
			<dashlet class="DashletOpenNMSAlarms" refresh="30000">
				<parameter key="title" value="Threshold Alarms" />
				<parameter key="restUrl" value="{{ url }}/rest" />
				<parameter key="restUser" value="{{ user }}" />
				<parameter key="restPassword" value="{{ password }}" />
				<parameter key="linkUrlBase" value="/opennms" />
				<parameter key="ueiFilter" value="uei.opennms.org/threshold" />
				<parameter key="maxEntries" value="10" />
				<parameter key="createAlarms" value="false" />
			</dashlet>
		</row>
	</dashboard>
	<dashboard name="about">
		<row>
			<dashlet class="DashletAbout" refresh="1000000">
				<parameter key="displayUpdateString" value="false" />
			</dashlet>
		</row>
	</dashboard>
</dashboard-configuration>
