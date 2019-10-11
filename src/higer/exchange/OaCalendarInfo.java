package higer.exchange;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
/**
 * oa 日程类
 *
 */
public class OaCalendarInfo {
	private String id;//唯一标示
	private String amSubject;//主题
	private String Body;//内容
	private Date amStartDate;//开始时间
	private Date amEndDate;//结束时间
	private String amLocation;//地点
	private List<String> requiredAttendees = new ArrayList<String>();//参与人员
	
	private Date createDate;
	private Date updateDate;
	private boolean allDay = false;//全天日程
	/*
	 * 附件列表 ：Ews存入oa后附件id结合逗号分隔
	 */
	private String toOaAttachments = "";
	
	/*
	 * 附件列表 ：OA存往Ews的附件
	 * 如：名称key:aname               绝对路径key:apath
	 *    "SecondAttachment.txt"(格式必须带)   "C:\\temp\\FileAttachment2.txt"
	 */
	private List<HashMap<String,String>> toEwsAttachments = new ArrayList<HashMap<String,String>>();
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getAmSubject() {
		return amSubject;
	}
	public void setAmSubject(String amSubject) {
		this.amSubject = amSubject;
	}
	public String getBody() {
		return Body;
	}
	public void setBody(String body) {
		Body = body;
	}
	public Date getAmStartDate() {
		return amStartDate;
	}
	public void setAmStartDate(Date amStartDate) {
		this.amStartDate = amStartDate;
	}
	public Date getAmEndDate() {
		return amEndDate;
	}
	public void setAmEndDate(Date amEndDate) {
		this.amEndDate = amEndDate;
	}
	public String getAmLocation() {
		return amLocation;
	}
	public void setAmLocation(String amLocation) {
		this.amLocation = amLocation;
	}
	public List<String> getRequiredAttendees() {
		return requiredAttendees;
	}
	public void setRequiredAttendees(List<String> requiredAttendees) {
		this.requiredAttendees = requiredAttendees;
	}
	
	public boolean isAllDay() {
		return allDay;
	}
	public void setAllDay(boolean allDay) {
		this.allDay = allDay;
	}
	public Date getCreateDate() {
		return createDate;
	}
	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}
	public Date getUpdateDate() {
		return updateDate;
	}
	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}
	public String getToOaAttachments() {
		return toOaAttachments;
	}
	public void setToOaAttachments(String toOaAttachments) {
		this.toOaAttachments = toOaAttachments;
	}
	public List<HashMap<String, String>> getToEwsAttachments() {
		return toEwsAttachments;
	}
	public void setToEwsAttachments(List<HashMap<String, String>> toEwsAttachments) {
		this.toEwsAttachments = toEwsAttachments;
	}
	
}
