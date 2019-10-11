package test;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.zip.ZipInputStream;

import org.apache.axis.encoding.Base64;

import weaver.conn.RecordSet;
import weaver.general.BaseBean;
import weaver.general.SendMail;
import weaver.general.Util;
import weaver.system.SystemComInfo;

public class TestSendtp {
	BaseBean log = new BaseBean();
	public void sendTP() {
		log.writeLog("sendTP:");
		SystemComInfo sci = new SystemComInfo();
		String mailip = sci.getDefmailserver();//
		String mailuser = sci.getDefmailuser();
		String password = sci.getDefmailpassword();
		String needauth = sci.getDefneedauth();// 是否需要发件认证
		String mailfrom = sci.getDefmailfrom();
		ArrayList<String> filenames = new ArrayList<String>();
		ArrayList<InputStream> filecontents = new ArrayList<InputStream>();
		SendMail sm = new SendMail();
		sm.setMailServer(mailip);// 邮件服务器IP
		if (needauth.equals("1")) {
			sm.setNeedauthsend(true);
			sm.setUsername(mailuser);// 服务器的账号
			sm.setPassword(password);// 服务器密码
		} else {
			sm.setNeedauthsend(false);
		}
		String docids = "1";
		RecordSet rs = new RecordSet();
		String docsubject = "";
		String doccontent = "";
		String sql = "select docsubject,doccontent from DocDetail where id="+docids;
		rs.execute(sql);
		if(rs.next()) {
			docsubject = Util.null2String(rs.getString("docsubject"));
			doccontent = Util.null2String(rs.getString("doccontent"));
		}
		String htmlstr=changeimageString(doccontent);
		log.writeLog("htmlstr:"+htmlstr);
		boolean result = sm.sendMiltipartHtml(mailfrom, "1129520048@qq.com",
				"", "", docsubject, htmlstr, 3, filenames,
				filecontents, "3");
		log.writeLog("result:"+result);
	}
	public  String changeimageString(String htmlstr) {
		int start = htmlstr.indexOf("<img", 0);
		int end = htmlstr.indexOf("/>", start);
		if(start<0 || end<0) {
			return htmlstr;
		}
		String imgstr = htmlstr.substring(start,end+2);
		String imagefieleid = imgstr.substring(imgstr.indexOf("fileid=")+7,imgstr.indexOf("\"", imgstr.indexOf("fileid=")));
		if(!"".equals(imagefieleid)) {
			imgstr = imgstr.substring(0,imgstr.indexOf("src=\"")+5)+getTPString(imagefieleid)+imgstr.substring(imgstr.indexOf("\"", imgstr.indexOf("src=\"")+5),imgstr.length());
			log.writeLog("encode2:"+imgstr);
		}
		return htmlstr.substring(0,start)+imgstr+changeimageString(htmlstr.substring(end+2));
	}
	public String getTPString(String imagefileid) {
		RecordSet rs = new RecordSet();
		String filerealpath = "";
		String encode = "";
		String iszip = "";
		String name = "";
		String imagefiletype = "";
		String sql = " select b.filerealpath,b.iszip,b.imagefilename,b.imagefileid,b.imagefiletype from  "
				+ " imagefile b  where b.imagefileid in("+imagefileid+")";
		rs.execute(sql);
		if (rs.next()) {
			filerealpath = Util.null2String(rs.getString("filerealpath"));
			iszip = Util.null2String(rs.getString("iszip"));
			name = Util.null2String(rs.getString("imagefilename"));
			imagefiletype = Util.null2String(rs.getString("imagefiletype"));
			InputStream is = null;
			ByteArrayOutputStream baos = null;
			try {
				is = getFile(filerealpath, iszip);
				baos = new ByteArrayOutputStream(); 
				byte[] buffer = new byte[1024]; 
				int count = 0; 
				while((count = is.read(buffer)) >= 0){ 
				     baos.write(buffer, 0, count); 
			    } 
				encode=Base64.encode(baos.toByteArray());
				is.close();
				baos.close();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				try {
					is.close();
				} catch (IOException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				try {
					baos.close();
				} catch (IOException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
			}
			
		}
		if(!"".equals(encode)) {
			
			log.writeLog("encode:"+encode);
			return "data:"+imagefiletype+";base64,"+encode+"";
		}
		return "";
	}
	private InputStream getFile(String filerealpath, String iszip)
			throws Exception {
		ZipInputStream zin = null;
		InputStream imagefile = null;
		File thefile = new File(filerealpath);
		if (iszip.equals("1")) {
			zin = new ZipInputStream(new FileInputStream(thefile));
			if (zin.getNextEntry() != null)
				imagefile = new BufferedInputStream(zin);
		} else {
			imagefile = new BufferedInputStream(new FileInputStream(thefile));
		}
		return imagefile;
	}
}
