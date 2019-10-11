package higer.exchange;

import java.net.URI;
import java.text.SimpleDateFormat;
import java.util.Collection;

import org.json.JSONArray;
import org.json.JSONObject;

import microsoft.exchange.webservices.data.Appointment;
import microsoft.exchange.webservices.data.ConflictResolutionMode;
import microsoft.exchange.webservices.data.ExchangeCredentials;
import microsoft.exchange.webservices.data.ExchangeService;
import microsoft.exchange.webservices.data.ExchangeVersion;
import microsoft.exchange.webservices.data.MessageBody;
import microsoft.exchange.webservices.data.TimeZoneDefinition;
import microsoft.exchange.webservices.data.WebCredentials;

public class Test {

	public static void main(String[] args) throws Exception {
		System.out.println(getMinlength(2, 0, 0, 0));
	}

	public static String getMinlength(int length1, int length2, int length3, int length4) {
		String result = "";
		int length = length1;
		result = "1";
		if (length > length2) {
			result = "2";
			length = length2;
		}
		if (length > length3) {
			result = "3";
			length = length3;
		}
		if (length > length4) {
			result = "4";
			length = length4;
		}

		return result;

	}

	public static void sendRc() throws Exception {
		SimpleDateFormat aa = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		ExchangeService service = new ExchangeService(ExchangeVersion.Exchange2007_SP1);
		ExchangeCredentials credentials = new WebCredentials("chengz", "cgz1212");
		service.setCredentials(credentials);
		service.setUrl(new URI("https://mail.higer.com/ews/Exchange.asmx"));
		service.setCredentials(credentials);
		service.setTraceEnabled(true);
		Appointment appointment = new Appointment(service);
		// Set the properties on the appointment object to create the appointment.
		appointment.setSubject("test123");
		appointment.setBody(MessageBody.getMessageBodyFromText("test"));
		appointment.setStart(aa.parse("2019-06-03 15:20:12"));
		appointment.setEnd(aa.parse("2019-06-03 17:20:12"));
		appointment.setLocation("123");
		appointment.setLocation("会议位置");
		Collection<TimeZoneDefinition> t = service.getServerTimeZones();
		TimeZoneDefinition tf = null;
		for (TimeZoneDefinition timeZoneDefinition : t) {
			tf = timeZoneDefinition;
		}
		appointment.setStartTimeZone(tf);
		// appointment.getResources().add("会议资源账号，如：meetingroom@company.com");

		appointment.getRequiredAttendees().add("chengz@higer.com");
		// appointment.getOptionalAttendees().add("可选参加的员工的账号");
		appointment.save();
		appointment.update(ConflictResolutionMode.AutoResolve);

	}

}
