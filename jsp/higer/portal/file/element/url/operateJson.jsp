<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="org.apache.commons.io.FileUtils"%>
<%@ page import="java.io.*"%>
<%@ page import="weaver.general.GCONST"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.file.*"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ include file="/plugin/element/util/Util.jsp"%>
<%
   out.clear();
   JSONObject json = new JSONObject();
   String operation =  Util.null2String(request.getParameter("operation"));
   String path = GCONST.getRootPath();
   if("getTableList".equals(operation)){
	   path = path +"plugin"+ File.separatorChar+"element"+ File.separatorChar+"url";
	   File file = new File(path);
	   File[] fs = file.listFiles();
	   String name = "";
	   String str ="";
	   JSONArray jsonArray = new JSONArray();
	   if(fs!=null && fs.length>0){
		   for(File fi : fs){
			   if(fi.exists()){
				   name = fi.getName();
				   if(name.endsWith(".json")){
					   str= FileUtils.readFileToString(fi, "UTF-8");
					   JSONObject jsonObject = new JSONObject(str);
					    String typeName =jsonObject.getString("name");
					    JSONArray version = getElementTag(typeName,user);
					    jsonObject.put("version", version);
					    jsonArray.put(jsonObject);
				   }
			   }
		   }
	   }
	   json.put("datas", jsonArray);
   }else if("getJsonStr".equals(operation)){
	   String key =  Util.null2String(request.getParameter("key"));
	   String folder = Util.null2String(request.getParameter("folder"));
	   JSONObject jsonconf = this.getJSONObject(folder,key);
	   json.put("datas", jsonconf);
   }else if("getSaveJsonFile".equals(operation)){
	   String key =  Util.null2String(request.getParameter("key"));
	   String folder = Util.null2String(request.getParameter("folder"));
	   String jsonStr = Util.null2String(request.getParameter("jsonStr"));
	   String jsonPath = path+"WEB-INF\\plugin\\"+folder+"\\"+key+".json";
	   createJsonFile(jsonStr,jsonPath);
   }
   json.put("status", "0");
   out.write(json.toString());
%>
<%! 
public JSONArray getElementTag(String type,User user){
	JSONArray tagArray = new JSONArray();
	try{
		String sql = "select id from uf_ystag_download where yslx=? and modedatacreater=? ";
		boolean flag = rs.executeQuery(sql,type,user.getUID());
		while(rs.next()){
			tagArray.put(Util.null2String(rs.getString("id")));
		}
	}catch (Exception e) {
        e.printStackTrace();
    }
	return tagArray;
}	

/**
 * 生成.json格式文件
 */
public  boolean createJsonFile(String jsonString, String fullPath) {
    // 标记文件生成是否成功
    boolean flag = true;
    // 生成json格式文件
    try {
        // 保证创建一个新文件
        File file = new File(fullPath);
        if (!file.getParentFile().exists()) { // 如果父目录不存在，创建父目录
            file.getParentFile().mkdirs();
        }
        if (file.exists()) { // 如果已存在,删除旧文件
            file.delete();
        }
        file.createNewFile();

        if(jsonString.indexOf("'")!=-1){  
            //将单引号转义一下，因为JSON串中的字符串类型可以单引号引起来的  
            jsonString = jsonString.replaceAll("'", "\\'");  
        }  
        if(jsonString.indexOf("\"")!=-1){  
            //将双引号转义一下，因为JSON串中的字符串类型可以单引 号引起来的  
            jsonString = jsonString.replaceAll("\"", "\\\"");  
        }  
          
        if(jsonString.indexOf("\r\n")!=-1){  
            //将回车换行转换一下，因为JSON串中字符串不能出现显式的回车换行  
            jsonString = jsonString.replaceAll("\r\n", "\\u000d\\u000a");  
        }  
        if(jsonString.indexOf("\n")!=-1){  
            //将换行转换一下，因为JSON串中字符串不能出现显式的换行  
            jsonString = jsonString.replaceAll("\n", "\\u000a");  
        }  
        // 格式化json字符串
        jsonString = formatJson(jsonString);
        // 将格式化后的字符串写入文件
        Writer write = new OutputStreamWriter(new FileOutputStream(file), "UTF-8");
        write.write(jsonString);
        write.flush();
        write.close();
    } catch (Exception e) {
        flag = false;
        e.printStackTrace();
    }
    // 返回是否成功的标记
    return flag;
}

/**
 * 返回格式化JSON字符串。
 * 
 * @param json 未格式化的JSON字符串。
 * @return 格式化的JSON字符串。
 */
public  String formatJson(String json) {
    StringBuffer result = new StringBuffer();

    int length = json.length();
    int number = 0;
    char key = 0;
    // 遍历输入字符串。
    for (int i = 0; i < length; i++) {
        // 1、获取当前字符。
        key = json.charAt(i);
        // 2、如果当前字符是前方括号、前花括号做如下处理：
        if ((key == '[') || (key == '{')) {
            // （1）如果前面还有字符，并且字符为“：”，打印：换行和缩进字符字符串。
            if ((i - 1 > 0) && (json.charAt(i - 1) == ':')) {
                result.append('\n');
                result.append(indent(number));
            }
            // （2）打印：当前字符。
            result.append(key);
            // （3）前方括号、前花括号，的后面必须换行。打印：换行。
            result.append('\n');
            // （4）每出现一次前方括号、前花括号；缩进次数增加一次。打印：新行缩进。
            number++;
            result.append(indent(number));
            // （5）进行下一次循环。
            continue;
        }
        // 3、如果当前字符是后方括号、后花括号做如下处理：
        if ((key == ']') || (key == '}')) {
            // （1）后方括号、后花括号，的前面必须换行。打印：换行。
            result.append('\n');
            // （2）每出现一次后方括号、后花括号；缩进次数减少一次。打印：缩进。
            number--;
            result.append(indent(number));
            // （3）打印：当前字符。
            result.append(key);
            // （4）如果当前字符后面还有字符，并且字符不为“，”，打印：换行。
            if (((i + 1) < length) && (json.charAt(i + 1) != ',')) {
                result.append('\n');
            }
            // （5）继续下一次循环。
            continue;
        }
        // 4、如果当前字符是逗号。逗号后面换行，并缩进，不改变缩进次数。
         if ((key == ',') && (i - 1 > 0) && (json.charAt(i - 1) == '"' || json.charAt(i - 1) == ']' || json.charAt(i - 1) == '}')) {
            result.append(key);
            result.append('\n');
            result.append(indent(number));
            continue;
        }
        // 5、打印：当前字符。
        result.append(key);
    }
    return result.toString();
}

/**
 * 返回指定次数的缩进字符串。每一次缩进三个空格，即SPACE。
 * 
 * @param number 缩进次数。
 * @return 指定缩进次数的字符串。
 */
 public  String indent(int number) {
 	String SPACE = "   ";
    StringBuffer result = new StringBuffer();
    for (int i = 0; i < number; i++) {
        result.append(SPACE);
    }
    return result.toString();
}

%>