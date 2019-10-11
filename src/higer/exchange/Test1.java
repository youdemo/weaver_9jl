package higer.exchange;
import java.net.URI;
import java.net.URISyntaxException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import com.sun.star.util.DateTime;

import microsoft.exchange.webservices.data.Appointment;
import microsoft.exchange.webservices.data.AppointmentSchema;
import microsoft.exchange.webservices.data.Attendee;
import microsoft.exchange.webservices.data.BasePropertySet;
import microsoft.exchange.webservices.data.CalendarFolder;
import microsoft.exchange.webservices.data.CalendarView;
import microsoft.exchange.webservices.data.ExchangeCredentials;
import microsoft.exchange.webservices.data.ExchangeService;
import microsoft.exchange.webservices.data.ExchangeVersion;
import microsoft.exchange.webservices.data.FindItemsResults;
import microsoft.exchange.webservices.data.FolderId;
import microsoft.exchange.webservices.data.Mailbox;
import microsoft.exchange.webservices.data.PropertySet;
import microsoft.exchange.webservices.data.WebCredentials;
import microsoft.exchange.webservices.data.WellKnownFolderName;
public class Test1 {
	
	public static void main(String args[]) throws Exception {
		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");// 
		getAppointments(sf.parse("2019-08-30 00:00:00"),sf.parse("2019-08-30 23:59:59"));
	}
	
	public static void getMeetings(Date startDate, Date endDate ) throws Exception
    {
		ExchangeService service = new ExchangeService(ExchangeVersion.Exchange2007_SP1);
		ExchangeCredentials credentials = new WebCredentials("oa", "higer123");
		service.setCredentials(credentials);
		service.setUrl(new URI("https://mail.higer.com/ews/Exchange.asmx"));
		service.setCredentials(credentials);
		service.setTraceEnabled(true);
        CalendarFolder calendar = null;
        Mailbox mailbox = new Mailbox();
        mailbox.setAddress("oa@higer.com");
        if (mailbox == null)
        {
        	calendar = CalendarFolder.bind(service, WellKnownFolderName.Calendar);
        }
        else
        {
            FolderId folderid = new FolderId(WellKnownFolderName.Calendar,mailbox);
            calendar = CalendarFolder.bind(service, folderid);
        }

        // Set the start and end time and number of appointments to retrieve.
        CalendarView cView = new CalendarView(startDate, endDate);
        PropertySet ps=  new PropertySet(AppointmentSchema.Subject,
                AppointmentSchema.LastModifiedTime,
                AppointmentSchema.IsMeeting,
                AppointmentSchema.Start,
                AppointmentSchema.End);
        cView.setPropertySet(ps);
        // Limit the properties returned to the appointment's subject, start time, and end time.
     

       
			FindItemsResults<Appointment> appointments = calendar.findAppointments(cView);
			//System.out.println(appointments.getTotalCount());
        
        
    }
	
public static List<OaCalendarInfo> getAppointments(Date startDate,Date endDate){
		
        try {
        	ExchangeService service = new ExchangeService(ExchangeVersion.Exchange2007_SP1);
    		ExchangeCredentials credentials = new WebCredentials("oa", "higer123");
    		service.setCredentials(credentials);
    		service.setUrl(new URI("https://mail.higer.com/ews/Exchange.asmx"));
    		service.setCredentials(credentials);
    		service.setTraceEnabled(true);
    		EwsCalendarInfoUitl ewsUtil = new EwsCalendarInfoUitl();
			CalendarFolder calendar = CalendarFolder.bind(service, WellKnownFolderName.Calendar);
			CalendarView cView = new CalendarView(startDate, endDate);
			FindItemsResults<Appointment> appointments = calendar.findAppointments(cView);
			if(appointments.getTotalCount()==0){
				return null;
			}
			PropertySet detailedPropertySet = new PropertySet(BasePropertySet.FirstClassProperties, AppointmentSchema.Recurrence);
			service.loadPropertiesForItems(appointments , detailedPropertySet);
			System.out.println("aaa"+appointments.getItems().size());
			
			ArrayList<Appointment> items = appointments.getItems();
			for (int i = 0; i < items.size(); i++) {
				System.out.println(items.get(i).getOrganizer().getAddress());
				System.out.println(ewsUtil.utc2Local(items.get(i).getDateTimeCreated()));
				System.out.println(items.get(i).getId().toString());
				System.out.println(items.get(i).getSubject().toString());
				System.out.println(items.get(i).getBody().toString());
				System.out.println(ewsUtil.utc2Local(items.get(i).getStart()));
				System.out.println(ewsUtil.utc2Local(items.get(i).getEnd()));
				System.out.println(items.get(i).getLocation());
				Iterator<Attendee> ewsamsIterator = items.get(i).getRequiredAttendees().iterator();
				List<String> oaAddres = new ArrayList<String>();
				while(ewsamsIterator.hasNext()){
					System.out.println(ewsamsIterator.next().getAddress());
				}
				System.out.println("_____________-_________________________-分割线——————————————————————————————");
//				
//				tempOaAppointment.setAmSubject(ewsAppointments.get(i).getSubject());
//				tempOaAppointment.setBody(ewsAppointments.get(i).getBody().toString());
//				tempOaAppointment.setAmStartDate(utc2Local(ewsAppointments.get(i).getStart()));
//				tempOaAppointment.setAmEndDate(utc2Local(ewsAppointments.get(i).getEnd()));
//				tempOaAppointment.setAmLocation(ewsAppointments.get(i).getLocation());
			}
//			tempOaAppointment.setId(ewsAppointments.get(i).getId().toString());
//			tempOaAppointment.setAmSubject(ewsAppointments.get(i).getSubject());
//			tempOaAppointment.setBody(ewsAppointments.get(i).getBody().toString());
//			tempOaAppointment.setAmStartDate(utc2Local(ewsAppointments.get(i).getStart()));
//			tempOaAppointment.setAmEndDate(utc2Local(ewsAppointments.get(i).getEnd()));
//			tempOaAppointment.setAmLocation(ewsAppointments.get(i).getLocation());
			//			if(appointments.getItems().size()>0){
//				return ewsAppointments2Oa(appointments.getItems());
//			}else{
//				return null;
//			}
			return null;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	


}
