package higer.exchange;
import java.net.URI;
import java.net.URISyntaxException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import microsoft.exchange.webservices.data.AffectedTaskOccurrence;
import microsoft.exchange.webservices.data.Appointment;
import microsoft.exchange.webservices.data.AppointmentSchema;
import microsoft.exchange.webservices.data.Attendee;
import microsoft.exchange.webservices.data.BasePropertySet;
import microsoft.exchange.webservices.data.BodyType;
import microsoft.exchange.webservices.data.CalendarFolder;
import microsoft.exchange.webservices.data.CalendarView;
import microsoft.exchange.webservices.data.ConflictResolutionMode;
import microsoft.exchange.webservices.data.ConnectingIdType;
import microsoft.exchange.webservices.data.DeleteMode;
import microsoft.exchange.webservices.data.EmailMessage;
import microsoft.exchange.webservices.data.ExchangeService;
import microsoft.exchange.webservices.data.ExchangeVersion;
import microsoft.exchange.webservices.data.FindItemsResults;
import microsoft.exchange.webservices.data.GetItemResponse;
import microsoft.exchange.webservices.data.ImpersonatedUserId;
import microsoft.exchange.webservices.data.Item;
import microsoft.exchange.webservices.data.ItemId;
import microsoft.exchange.webservices.data.MessageBody;
import microsoft.exchange.webservices.data.MessageDisposition;
import microsoft.exchange.webservices.data.PropertySet;
import microsoft.exchange.webservices.data.SendCancellationsMode;
import microsoft.exchange.webservices.data.SendInvitationsMode;
import microsoft.exchange.webservices.data.SendInvitationsOrCancellationsMode;
import microsoft.exchange.webservices.data.ServiceLocalException;
import microsoft.exchange.webservices.data.ServiceResponse;
import microsoft.exchange.webservices.data.ServiceResponseCollection;
import microsoft.exchange.webservices.data.ServiceResult;
import microsoft.exchange.webservices.data.WebCredentials;
import microsoft.exchange.webservices.data.WellKnownFolderName;
import weaver.file.Prop;
import weaver.general.BaseBean;
import weaver.general.Util;
/**
 * 日程EWS 中间件
 *
 */
public class EwsCalendarInfoUitl {
	private ExchangeService service = new ExchangeService(ExchangeVersion.Exchange2007_SP1);
	//private String attachmentTempPath = "";
	//private int userid=0;
//	public EwsCalendarInfoUitl(String mailStr/*,String mailPwd,int currentUserid*/) {
//		try {
//			//service.setCredentials(new WebCredentials("mailtest@saisc.com", "Password01"));
//			String demand = Prop.getPropValue("exchange", "exchangeServer");
//			String domain = Prop.getPropValue("exchange", "domain");
//			
//			//--qc:278966 采用管理员模拟邮箱操作 --start
//			String adminname= Prop.getPropValue("exchange", "username");
//			String adminpwd= Prop.getPropValue("exchange", "password");
//			//参数是用户名,密码,域  
//			service.setCredentials(new WebCredentials(adminname, adminpwd,domain));
//			//指定获取邮箱账户
//			service.setImpersonatedUserId(new ImpersonatedUserId(ConnectingIdType.SmtpAddress, mailStr));
//			//service.setCredentials(new WebCredentials(mailStr, mailPwd , domain));//废弃老方法
//			//--qc:278966 采用管理员模拟邮箱操作 --end
//			
//			//给出Exchange Server的URL http://xxxxxxx  
//			service.setUrl(new URI("https://"+demand+"/ews/exchange.asmx"));
//			//service.setUrl(new URI("https://outlook.office365.com/ews/exchange.asmx"));
//			//attachmentTempPath  = Util.null2String(Prop.getPropValue("exchange", "attachmentTempPath"));
//			//userid = currentUserid;
//		} catch (URISyntaxException e) {
//			e.printStackTrace();
//		}  
//	} 
//	
	
	
	public EwsCalendarInfoUitl(String mailStr,String mailPwd,String url) {
	
			try {
				//service.setCredentials(new WebCredentials("mailtest@saisc.com", "Password01"));
				service.setCredentials(new WebCredentials(mailStr, mailPwd));
				//service.setUrl(new URI(Prop.getPropValue("exchange", "exchangeServer")+"/ews/exchange.asmx"));
				service.setUrl(new URI(url));
			} catch (URISyntaxException e) {
				e.printStackTrace();
			}  
		} 
	public EwsCalendarInfoUitl() {
		try {
			service.setCredentials(new WebCredentials(Prop.getPropValue("exchange", "username"), Prop.getPropValue("exchange", "password")));	
			service.setUrl(new URI(Prop.getPropValue("exchange", "exchangeServer")+"/ews/exchange.asmx"));
			
		} catch (URISyntaxException e) {
			e.printStackTrace();
		} 
	}
	/**
	 * 获取日程列表
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public List<OaCalendarInfo> getAppointments(Date startDate,Date endDate){
		
        try {
			CalendarFolder calendar = CalendarFolder.bind(service, WellKnownFolderName.Calendar);
			CalendarView cView = new CalendarView(startDate, endDate);
			FindItemsResults<Appointment> appointments = calendar.findAppointments(cView);
			if(appointments.getTotalCount()==0){
				return null;
			}
			PropertySet detailedPropertySet = new PropertySet(BasePropertySet.FirstClassProperties, AppointmentSchema.Recurrence);
			service.loadPropertiesForItems(appointments , detailedPropertySet);
			if(appointments.getItems().size()>0){
				return ewsAppointments2Oa(appointments.getItems());
			}else{
				return null;
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	public String sendMail(OaCalendarInfo oaam,  List<String> reserver){
		try{
			//创建邮件
			EmailMessage msg = new EmailMessage(service);
			// 设置主题
			msg.setSubject(oaam.getAmSubject());
			// 邮件内容
			MessageBody body = MessageBody.getMessageBodyFromText(oaam.getBody());
			body.setBodyType(BodyType.HTML);
			msg.setBody(body);
			// to 收件人
			for (String s : reserver) {
				msg.getToRecipients().add(s);
			}
			// cc //抄送
//			if (cc != null) {
//				for (String s : cc) {
//					msg.getCcRecipients().add(s);
//				}
//			}
			
			// 附件
//			if(realPath!=null&&!"".equals(realPath)){
//				msg.getAttachments().addFileAttachment(realPath);
//			}
			msg.send();
		}catch(Exception e){
			
		}
		
		return null;
	}
	/**
	 * 添加日程
	 * @param amSubject 日程主题
	 * @param Body 日程内容
	 * @param amStartDate 日程开始时间
	 * @param amEndDate 日程结束时间
	 * @param amLocation 地点
	 * @param requiredAttendees 添加参与者
	 * @return 日程id
	 */
	public String addAppointment(OaCalendarInfo oaam){
		String amid="";
		//实例化一个Appointment
		Appointment appointment;
		try {
			appointment = new Appointment(service);
			//日程主题
			appointment.setSubject(oaam.getAmSubject());
			//日程内容
			appointment.setBody(new MessageBody(oaam.getBody()));
			//日程开始时间
			appointment.setStart(oaam.getAmStartDate());
			//日程结束时间
			appointment.setEnd(oaam.getAmEndDate());
			//添加参与者
			for (int i = 0; null != oaam.getRequiredAttendees() && i < oaam.getRequiredAttendees().size(); i++) {
				appointment.getRequiredAttendees().add(oaam.getRequiredAttendees().get(i));
			}
			//地点
			appointment.setLocation(oaam.getAmLocation());
			//全天日程
			appointment.setIsAllDayEvent(oaam.isAllDay());
			
			//附件
			/*for (int i = 0; i < oaam.getToEwsAttachments().size(); i++) {
				System.out.println(">>"+oaam.getToEwsAttachments().get(i).get("aname")+"\n"+ oaam.getToEwsAttachments().get(i).get("apath"));
				appointment.getAttachments().addFileAttachment(oaam.getToEwsAttachments().get(i).get("aname"), oaam.getToEwsAttachments().get(i).get("apath"));
			}*/
			
			appointment.save();
			amid = appointment.getId().toString();
		} catch (Exception e) {
			BaseBean log = new BaseBean();
			log.writeLog(e);
			log.writeLog("Url:"+service.getUrl()+" username:"+Prop.getPropValue("exchange", "username")+" password:"+Prop.getPropValue("exchange", "password"));
			e.printStackTrace();
		}
		return amid;
		
	} 
	
	public boolean isExistItem(String id){
		try {
			Item item = Item.bind(service, new ItemId(id));
			//System.out.println(null ==item);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		return true;
	}
	/**
	 * 批量添加日程
	 * @param appointments
	 * @return 返回日程id 集合
	 */
	public List<String> addAppointments(ArrayList<OaCalendarInfo> oaAppointments){
		ArrayList<Appointment> appointments = oaAppointments2Ews(oaAppointments);
		List<String> itemIds = new ArrayList<String>();
		
	    try {
			Collection<Item> calendarItems = new ArrayList<Item>();
			for (int i = 0; i < appointments.size(); i++) {
				calendarItems.add(appointments.get(i));
			}
			//System.out.println("calendarItems size:"+calendarItems.size());
			//FolderId folderid = FolderId.getFolderIdFromString("Calendar");
			ServiceResponseCollection<ServiceResponse> response = service.createItems(calendarItems,
																					null ,
			                                                                          MessageDisposition.SendAndSaveCopy,
			                                                                          SendInvitationsMode.SendToAllAndSaveCopy);
			if (response.getOverallResult() == ServiceResult.Success)
			{
				for (Item appt:calendarItems)
				{
					itemIds.add(((Appointment)appt).getId().toString());
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	
		return itemIds;
	}
	/**
	 * 更新日程
	 * @param appointmentId
	 * @param amSubject
	 * @param Body
	 * @param amStartDate
	 * @param amEndDate
	 * @param amLocation
	 * @param requiredAttendees
	 * @return
	 */
	public boolean updateAppointment(OaCalendarInfo oaam){
		try {
			ItemId amId = new ItemId(oaam.getId());
			Appointment appointment = Appointment.bind(service, amId , new PropertySet(BasePropertySet.FirstClassProperties, AppointmentSchema.Recurrence));
			
			//日程主题
			appointment.setSubject(oaam.getAmSubject());
			//日程内容
			if(""!=Util.null2String(oaam.getBody()))
			appointment.setBody(new MessageBody(oaam.getBody()));
			//日程开始时间
			if(null != oaam.getAmStartDate())
			appointment.setStart(oaam.getAmStartDate());
			//日程结束时间
			if(null != oaam.getAmEndDate())
			appointment.setEnd(oaam.getAmEndDate());
			//地点
			if(""!=Util.null2String(oaam.getAmLocation()))
			appointment.setLocation(oaam.getAmLocation());
			//添加参与者
			for (int i = 0; null != oaam.getRequiredAttendees() && i < oaam.getRequiredAttendees().size(); i++) {
				appointment.getRequiredAttendees().add(oaam.getRequiredAttendees().get(i));
			}
			//全天日程
			appointment.setIsAllDayEvent(oaam.isAllDay());
			//附件重写
			/*if(oaam.getToEwsAttachments().size()>0){
				appointment.getAttachments().clear();
				for (int i = 0; i < oaam.getToEwsAttachments().size(); i++) {
					System.out.println(">>"+oaam.getToEwsAttachments().get(i).get("aname")+"\n"+ oaam.getToEwsAttachments().get(i).get("apath"));
					appointment.getAttachments().addFileAttachment(oaam.getToEwsAttachments().get(i).get("aname"), oaam.getToEwsAttachments().get(i).get("apath"));
				}
			}*/
			appointment.update(ConflictResolutionMode.AlwaysOverwrite, SendInvitationsOrCancellationsMode.SendToNone);
			return true;
		} catch (Exception e) {
			BaseBean log = new BaseBean();
			log.writeLog(e);
			log.writeLog("Url:"+service.getUrl()+" username:"+Prop.getPropValue("exchange", "username")+" password:"+Prop.getPropValue("exchange", "password"));
			e.printStackTrace();
			return false;
		}
	}
	/**
	 * 删除日程
	 * @param appointmentId
	 * @param deleteMode
	 * @return
	 */
	public boolean delAppointment(String appointmentId){
		try {
			ItemId amId = new ItemId(appointmentId);
			Appointment appointment = Appointment.bind(service, amId, new PropertySet());
	
			appointment.delete(DeleteMode.MoveToDeletedItems);
			return true;
		} catch (Exception e) {
			BaseBean log = new BaseBean();
			log.writeLog(e);
			log.writeLog("Url:"+service.getUrl()+" username:"+Prop.getPropValue("exchange", "username")+" password:"+Prop.getPropValue("exchange", "password"));
			e.printStackTrace();
			return false;
		}
	}
	/**
	 * 批量删除日程
	 * @param appointmentId
	 * @param deleteMode
	 * @return
	 */
	public boolean delAppointments(List<String> appointmentIds){
		try {
			
			Collection<ItemId> itemIds = new ArrayList<ItemId>();
			for (int i = 0; i < appointmentIds.size(); i++) {
				itemIds.add(new ItemId(appointmentIds.get(i)));
			}
		    ServiceResponseCollection<ServiceResponse> response = service.deleteItems(itemIds, 
		                                                                                DeleteMode.MoveToDeletedItems, 
		                                                                                SendCancellationsMode.SendToAllAndSaveCopy, 
		                                                                                AffectedTaskOccurrence.AllOccurrences);
		    int counter = 1;
		    for(ServiceResponse resp : response)
		    {
		        System.out.println("Result index("+counter+"):"+ resp.getResult());
		        System.out.println("Error Code : "+resp.getErrorCode());
		        System.out.println("ErrorMessage : "+resp.getErrorMessage());
		        counter++;
		    }
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	/**
	 * 通过itemids 获取一组日程
	 * @param itemIds
	 * @return
	 */
	public Collection<Appointment> batchGetCalendarItems(Collection<ItemId> itemIds)
	{
		Collection<Appointment> calendarItems = new ArrayList<Appointment>();
		
	    try {
			PropertySet appointmentProps = new PropertySet(BasePropertySet.FirstClassProperties, AppointmentSchema.Recurrence);
			ServiceResponseCollection<GetItemResponse> response = service.bindToItems(itemIds , appointmentProps);
			for (GetItemResponse items:response)
			{
			    Item item = items.getItem();
			    Appointment appointmentItem = (Appointment)item;
			    calendarItems.add(appointmentItem);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	    return calendarItems;
	}
	/**
	 * 通过itemids 获取一组日程
	 * @param itemIds
	 * @return
	 */
	public OaCalendarInfo getOaCalendarInfo(String itemId)
	{
		OaCalendarInfo calendarItems = null;
		
	    try {
	    	ItemId amId = new ItemId(itemId);
	    	Appointment appointment = Appointment.bind(service, amId , new PropertySet(BasePropertySet.FirstClassProperties, AppointmentSchema.Recurrence));
	    	calendarItems = ewsAppointment2Oa(appointment);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return calendarItems;
	}
	/**
	 * oa日程类转ews类
	 * @param oaam
	 * @return
	 */
	public Appointment  oaAppointment2Ews(OaCalendarInfo oaam){
		Appointment am = null;
		
		try {
			ItemId amId = new ItemId(oaam.getId());
			am = Appointment.bind(service, amId , new PropertySet(BasePropertySet.FirstClassProperties, AppointmentSchema.Recurrence));
			
			//日程主题
			am.setSubject(oaam.getAmSubject());
			//日程内容
			am.setBody(new MessageBody(oaam.getBody()));
			//日程开始时间
			am.setStart(oaam.getAmStartDate());
			//日程结束时间
			am.setEnd(oaam.getAmEndDate());
			//地点
			am.setLocation(oaam.getAmLocation());
			//添加参与者
			for (int j = 0; null != oaam.getRequiredAttendees() && j < oaam.getRequiredAttendees().size(); j++) {
				am.getRequiredAttendees().add(oaam.getRequiredAttendees().get(j));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return am;
	}
	/**
	 * ews 日程类转oa类
	 * @param ewsam
	 * @return
	 */
	public OaCalendarInfo  ewsAppointment2Oa(Appointment ewsam){
		OaCalendarInfo am = null;
		try {
			am = new OaCalendarInfo();
			am.setId(ewsam.getId().toString());
			am.setAmSubject(ewsam.getSubject());
			am.setBody(ewsam.getBody().toString());
			am.setAmStartDate(utc2Local(ewsam.getStart()));
			am.setAmEndDate(utc2Local(ewsam.getEnd()));
			am.setAmLocation(ewsam.getLocation());
			am.setAllDay(ewsam.getIsAllDayEvent());
			am.setUpdateDate(utc2Local(ewsam.getLastModifiedTime()));
			Iterator<Attendee> ewsamsIterator = ewsam.getResources().iterator();
			List<String> oaAddres = new ArrayList<String>();
			while(ewsamsIterator.hasNext()){
				oaAddres.add(ewsamsIterator.next().getAddress());
			}
			am.setRequiredAttendees(oaAddres);
		} catch (ServiceLocalException e) {
			e.printStackTrace();
		}
		return am;
	}
	/**
	 * oa日程集合转ews集合
	 * @param oaAppointments
	 * @return
	 */
	public ArrayList<Appointment>  oaAppointments2Ews(ArrayList<OaCalendarInfo> oaAppointments){
		ArrayList<Appointment> ams = new ArrayList<Appointment>();
		
		try {
			Appointment temAm = null;
			for (int i = 0; i < oaAppointments.size(); i++) {
				if("".equals(Util.null2String(oaAppointments.get(i).getId()))){
					temAm = new Appointment(service); 
				}else{
					ItemId amId = new ItemId(oaAppointments.get(i).getId());
					temAm = Appointment.bind(service, amId , new PropertySet(BasePropertySet.FirstClassProperties, AppointmentSchema.Recurrence));
				}
				//日程主题
				temAm.setSubject(oaAppointments.get(i).getAmSubject());
				//日程内容
				temAm.setBody(new MessageBody(oaAppointments.get(i).getBody()));
				//日程开始时间
				temAm.setStart(oaAppointments.get(i).getAmStartDate());
				//日程结束时间
				temAm.setEnd(oaAppointments.get(i).getAmEndDate());
				//地点
				temAm.setLocation(oaAppointments.get(i).getAmLocation());
				//添加参与者
				for (int j = 0; null != oaAppointments.get(i).getRequiredAttendees() && j < oaAppointments.get(i).getRequiredAttendees().size(); j++) {
					temAm.getRequiredAttendees().add(oaAppointments.get(i).getRequiredAttendees().get(j));
				}
				//全天日程
				temAm.setIsAllDayEvent(oaAppointments.get(i).isAllDay());
				
				/*if(oaAppointments.get(i).getToEwsAttachments().size()>0){
					//批量更新附件清理
					if(!"".equals(Util.null2String(oaAppointments.get(i).getId()))){
						temAm.getAttachments().clear();
					}
					//附件写入
					for (int j = 0; j < oaAppointments.get(i).getToEwsAttachments().size(); j++) {
						temAm.getAttachments().addFileAttachment(oaAppointments.get(i).getToEwsAttachments().get(j).get("aname"), 
																oaAppointments.get(i).getToEwsAttachments().get(j).get("apath"));
					}
				}*/
				
				ams.add(temAm);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ams;
	}
	/**
	 * ews 日程集合转 oa 集合
	 * @param ewsAppointments
	 * @return
	 * @throws ServiceLocalException
	 */
	public List<OaCalendarInfo>  ewsAppointments2Oa(ArrayList<Appointment> ewsAppointments) throws ServiceLocalException{
		List<OaCalendarInfo> ams = null;
		if(ewsAppointments.size()>0){
			ams = new ArrayList<OaCalendarInfo>();
			OaCalendarInfo tempOaAppointment = null;
			for (int i = 0; i < ewsAppointments.size(); i++) {
				tempOaAppointment = new OaCalendarInfo();
				tempOaAppointment.setId(ewsAppointments.get(i).getId().toString());
				tempOaAppointment.setAmSubject(ewsAppointments.get(i).getSubject());
				tempOaAppointment.setBody(ewsAppointments.get(i).getBody().toString());
				tempOaAppointment.setAmStartDate(utc2Local(ewsAppointments.get(i).getStart()));
				tempOaAppointment.setAmEndDate(utc2Local(ewsAppointments.get(i).getEnd()));
				tempOaAppointment.setAmLocation(ewsAppointments.get(i).getLocation());
				
				//附件下载
				/*Iterator<Attachment> ass = ewsAppointments.get(i).getAttachments().iterator();
				int index = 1;
				while(ass.hasNext()){
					FileAttachment tempa = (FileAttachment)ass.next();
					try {
							System.out.println(":"+tempa.getId());
							User user = new User(userid);
						    String doccategory = getDoccategory();
						    //ews 附件存储到oa
						    tempa.load(attachmentTempPath+tempa.getName());
						    int docid = Process( attachmentTempPath+tempa.getName(), doccategory, user, tempa.getName());
						    System.out.println("ews 附件:"+tempa.getName()+"存储到oa,docid="+docid);
						    tempOaAppointment.setToOaAttachments(tempOaAppointment.getToOaAttachments()+docid+",");
					} catch (Exception e) {
						e.printStackTrace();
					}
					index++;
				}*/
				
				tempOaAppointment.setAllDay(ewsAppointments.get(i).getIsAllDayEvent());
				tempOaAppointment.setUpdateDate(utc2Local(ewsAppointments.get(i).getLastModifiedTime()));
				
				Iterator<Attendee> ewsamsIterator = ewsAppointments.get(i).getRequiredAttendees().iterator();
				List<String> oaAddres = new ArrayList<String>();
				while(ewsamsIterator.hasNext()){
					oaAddres.add(ewsamsIterator.next().getAddress());
				}
				tempOaAppointment.setRequiredAttendees(oaAddres);
				ams.add(tempOaAppointment);
			}
		}
		return ams;
	}
	
	
	public static void main(String[] args) {
		try {
			System.out.println(">>");
			SimpleDateFormat  aa = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			EwsCalendarInfoUitl ewsUtil = new EwsCalendarInfoUitl("chengz","cgz1212","https://mail.higer.com/ews/Exchange.asmx");
//			//新增
//			OaCalendarInfo oaam = new OaCalendarInfo();
//			oaam.setAmSubject("test333");
//			oaam.setBody("222233");
//			//oaam.setAmStartDate(ewsUtil.getSpecifiedDayBefore(1));
//			//oaam.setAmEndDate(ewsUtil.getSpecifiedDayBefore(1));
//			oaam.setAmStartDate(ewsUtil.local2Utc(aa.parse("2019-06-05 12:00:00")));
//			oaam.setAmEndDate(ewsUtil.local2Utc(aa.parse("2019-06-05 13:00:00")));
//			oaam.setAmLocation("地点");
//			oaam.setAllDay(false);
//			
//			List<String> rmailsplus = new ArrayList<String>();
//			rmailsplus.add("chengz@higer.com");
//			oaam.setRequiredAttendees(rmailsplus);
//			String amid=ewsUtil.addAppointment(oaam);
//			System.out.println(amid);
			//
//			SimpleDateFormat  aa = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//			OaCalendarInfo oaam = new OaCalendarInfo();
//			oaam.setId("AAMkADViMGRlZjdhLTc0YTYtNDI5Ni05MTJiLWY5ZDUyYWJiOGNiYQBGAAAAAACkxgnBcAP/TYj7vDbF6wlxBwCWCGW+NmY5SbktqZPv6U/qAAAAL/F9AACWCGW+NmY5SbktqZPv6U/qAABNQVDBAAA=");
//			oaam.setAmSubject("测试日历");
//			oaam.setAmStartDate(ewsUtil.local2Utc(aa.parse("2019-06-05 17:20:12")));
//			oaam.setAmEndDate(ewsUtil.local2Utc(aa.parse("2019-06-06 17:40:12")));
//			oaam.setAllDay(false);
//			boolean result = ewsUtil.updateAppointment(oaam);
//			System.out.println(result);
			
			boolean result = ewsUtil.delAppointment("AAMkADViMGRlZjdhLTc0YTYtNDI5Ni05MTJiLWY5ZDUyYWJiOGNiYQBGAAAAAACkxgnBcAP/TYj7vDbF6wlxBwCWCGW+NmY5SbktqZPv6U/qAAAAL/F9AACWCGW+NmY5SbktqZPv6U/qAABNQVDBAAA=");
			System.out.println(result);
			
//			List<String> appointmentIds = new ArrayList<String>();
//			appointmentIds.add("AAMkADgzNmEyYmQ5LWY2OGQtNDQzOS1iNGQzLTJmZmMyMTI5MTY1MABGAAAAAAAZZLubW2T7RbSVGV/XDR2EBwAyTYc7caxJRKAbQv/LiI4IAAAAAAENAAAyTYc7caxJRKAbQv/LiI4IAAADo89cAAA=");
//			appointmentIds.add("AAMkADgzNmEyYmQ5LWY2OGQtNDQzOS1iNGQzLTJmZmMyMTI5MTY1MABGAAAAAAAZZLubW2T7RbSVGV/XDR2EBwAyTYc7caxJRKAbQv/LiI4IAAAAAAENAAAyTYc7caxJRKAbQv/LiI4IAAADo89dAAA=");
//			appointmentIds.add("AAMkADgzNmEyYmQ5LWY2OGQtNDQzOS1iNGQzLTJmZmMyMTI5MTY1MABGAAAAAAAZZLubW2T7RbSVGV/XDR2EBwAyTYc7caxJRKAbQv/LiI4IAAAAAAENAAAyTYc7caxJRKAbQv/LiI4IAAADo89bAAA=");
//			appointmentIds.add("AAMkADgzNmEyYmQ5LWY2OGQtNDQzOS1iNGQzLTJmZmMyMTI5MTY1MABGAAAAAAAZZLubW2T7RbSVGV/XDR2EBwAyTYc7caxJRKAbQv/LiI4IAAAAAAENAAAyTYc7caxJRKAbQv/LiI4IAAADo89gAAA=");
//			appointmentIds.add("AAMkADgzNmEyYmQ5LWY2OGQtNDQzOS1iNGQzLTJmZmMyMTI5MTY1MABGAAAAAAAZZLubW2T7RbSVGV/XDR2EBwAyTYc7caxJRKAbQv/LiI4IAAAAAAENAAAyTYc7caxJRKAbQv/LiI4IAAADo89hAAA=");
//			ewsUtil.delAppointments(appointmentIds );
//			EwsCalendarInfoUitl ewsUtil = new EwsCalendarInfoUitl("office365testing12@yipschemical.com");
			
			//新增：
			/*OaCalendarInfo oaam = new OaCalendarInfo();
			oaam.setAmSubject("参与者+");
			oaam.setBody("2222");
			oaam.setAmStartDate(ewsUtil.getSpecifiedDayBefore(1));
			oaam.setAmEndDate(ewsUtil.getSpecifiedDayBefore(1));
			oaam.setAmLocation("地点");
			oaam.setAllDay(true);
			
			List<String> rmailsplus = new ArrayList<String>();
			rmailsplus.add("435232572@qq.com");
			oaam.setRequiredAttendees(rmailsplus);
			ewsUtil.addAppointment(oaam);*/
			
			
			//批量新增：
			/*OaCalendarInfo oaam = new OaCalendarInfo();
			oaam.setAmSubject("主题new");
			oaam.setBody("内容new");
			oaam.setAmStartDate(ewsUtil.getSpecifiedDayAfter(3));
			oaam.setAmEndDate(ewsUtil.getSpecifiedDayAfter(4));
			oaam.setAmLocation("地点new");
			List<String> rmails = new ArrayList<String>();
			rmails.add("435232572@qq.com");
			oaam.setRequiredAttendees(rmails);
			
			OaCalendarInfo oaamplus = new OaCalendarInfo();
			oaamplus.setAmSubject("主题 newplus");
			oaamplus.setBody("内容 newplus");
			oaamplus.setAmStartDate(ewsUtil.getSpecifiedDayAfter(5));
			oaamplus.setAmEndDate(ewsUtil.getSpecifiedDayAfter(6));
			oaamplus.setAmLocation("地点 newplus");
			List<String> rmailsplus = new ArrayList<String>();
			rmailsplus.add("435232572@qq.com");
			oaamplus.setRequiredAttendees(rmailsplus);
			
			ArrayList<OaCalendarInfo> oaams = new ArrayList<OaCalendarInfo>();
			oaams.add(oaam);
			oaams.add(oaamplus);
			List<String> itemIds = ewsUtil.addAppointments(oaams);*/
			
			//获取日程by id
//			String itemid = "AAMkADgzNmEyYmQ5LWY2OGQtNDQzOS1iNGQzLTJmZmMyMTI5MTY1MABGAAAAAAAZZLubW2T7RbSVGV/XDR2EBwAyTYc7caxJRKAbQv/LiI4IAAAAAAENAAAyTYc7caxJRKAbQv/LiI4IAAAHcCHDAAA=";
//			OaCalendarInfo oac = ewsUtil.getOaCalendarInfo(itemid);
//			System.out.println(oac.getAmSubject());
//			System.out.println(oac.getUpdateDate());
			
			//列表：
			/*List<OaCalendarInfo> ams = ewsUtil.getAppointments(
					ewsUtil.getSpecifiedDayBefore(1), ewsUtil.getSpecifiedDayAfter(7)
					);
			for (int i = 0; i < ams.size(); i++) {
				System.out.println(ams.get(i).getId());
				System.out.println(ams.get(i).getAmSubject());
				System.out.println(ams.get(i).getUpdateDate());
			}*/
			
			
			//修改：
			/*OaCalendarInfo oaam = new OaCalendarInfo();
			oaam.setId("AAMkADgzNmEyYmQ5LWY2OGQtNDQzOS1iNGQzLTJmZmMyMTI5MTY1MABGAAAAAAAZZLubW2T7RbSVGV/XDR2EBwAyTYc7caxJRKAbQv/LiI4IAAAAAAENAAAyTYc7caxJRKAbQv/LiI4IAAAHcCHCAAA=");
			oaam.setAmSubject("参与者+++");
			ewsUtil.updateAppointment(oaam);*/
			
			//删除：
			/*AAMkADgzNmEyYmQ5LWY2OGQtNDQzOS1iNGQzLTJmZmMyMTI5MTY1MABGAAAAAAAZZLubW2T7RbSVGV/XDR2EBwAyTYc7caxJRKAbQv/LiI4IAAAAAAENAAAyTYc7caxJRKAbQv/LiI4IAAADo89fAAA=*/
			//ewsUtil.delAppointment("AAMkADgzNmEyYmQ5LWY2OGQtNDQzOS1iNGQzLTJmZmMyMTI5MTY1MABGAAAAAAAZZLubW2T7RbSVGV/XDR2EBwAyTYc7caxJRKAbQv/LiI4IAAAAAAENAAAyTYc7caxJRKAbQv/LiI4IAAADo89fAAA=");
			
			//批量删除
			/*List<String> appointmentIds = new ArrayList<String>();
			appointmentIds.add("AAMkADgzNmEyYmQ5LWY2OGQtNDQzOS1iNGQzLTJmZmMyMTI5MTY1MABGAAAAAAAZZLubW2T7RbSVGV/XDR2EBwAyTYc7caxJRKAbQv/LiI4IAAAAAAENAAAyTYc7caxJRKAbQv/LiI4IAAADo89cAAA=");
			appointmentIds.add("AAMkADgzNmEyYmQ5LWY2OGQtNDQzOS1iNGQzLTJmZmMyMTI5MTY1MABGAAAAAAAZZLubW2T7RbSVGV/XDR2EBwAyTYc7caxJRKAbQv/LiI4IAAAAAAENAAAyTYc7caxJRKAbQv/LiI4IAAADo89dAAA=");
			appointmentIds.add("AAMkADgzNmEyYmQ5LWY2OGQtNDQzOS1iNGQzLTJmZmMyMTI5MTY1MABGAAAAAAAZZLubW2T7RbSVGV/XDR2EBwAyTYc7caxJRKAbQv/LiI4IAAAAAAENAAAyTYc7caxJRKAbQv/LiI4IAAADo89bAAA=");
			appointmentIds.add("AAMkADgzNmEyYmQ5LWY2OGQtNDQzOS1iNGQzLTJmZmMyMTI5MTY1MABGAAAAAAAZZLubW2T7RbSVGV/XDR2EBwAyTYc7caxJRKAbQv/LiI4IAAAAAAENAAAyTYc7caxJRKAbQv/LiI4IAAADo89gAAA=");
			appointmentIds.add("AAMkADgzNmEyYmQ5LWY2OGQtNDQzOS1iNGQzLTJmZmMyMTI5MTY1MABGAAAAAAAZZLubW2T7RbSVGV/XDR2EBwAyTYc7caxJRKAbQv/LiI4IAAAAAAENAAAyTYc7caxJRKAbQv/LiI4IAAADo89hAAA=");
			ewsUtil.delAppointments(appointmentIds );*/
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	/**
	 * utc 2 local time
	 * @param gpsUTCDate
	 * @return
	 */
	public Date utc2Local(Date gpsUTCDate) {
				//SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd"); 
			Calendar c = Calendar.getInstance(); 
			c.setTime(gpsUTCDate); 
			int hour=c.get(Calendar.HOUR); 
			c.set(Calendar.HOUR,hour+8);
			return c.getTime();
	}
	
	public Date local2Utc(Date date) {
		//SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd"); 
	Calendar c = Calendar.getInstance(); 
	c.setTime(date); 
	int hour=c.get(Calendar.HOUR); 
	c.set(Calendar.HOUR,hour-8);
	return c.getTime();
}
	
	
	
	
	/** 
	* 获得指定日期的前一天 
	* @param specifiedDay 
	* @return 
	* @throws Exception 
	*/ 
	public  Date getSpecifiedDayBefore(int num){ 
		//SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd"); 
		Calendar c = Calendar.getInstance(); 
		Date date= new Date(); 
		c.setTime(date); 
		int day=c.get(Calendar.DATE); 
		c.set(Calendar.DATE,day-num); 
		
		return c.getTime(); 
	} 
	/** 
	* 获得指定日期的后一天 
	* @param specifiedDay 
	* @return 
	*/ 
	public  Date getSpecifiedDayAfter(int addCount){ 
		Calendar c = Calendar.getInstance(); 
		Date date=new Date();
		c.setTime(date); 
		int day=c.get(Calendar.DATE); 
		c.set(Calendar.DATE,day+addCount); 
		
		return c.getTime(); 
	} 
}
