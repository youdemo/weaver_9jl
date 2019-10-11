package test;

public class Test {

	public static void main(String[] args) {
		String test = "<html> <head>  <title></title>   </head> <body> <p style=\"text-align:center\"><img alt=\"\" height=\"391\" src=\"/weaver/weaver.file.FileDownload?fileid=1435\" width=\"400\" /></p>  <p style=\"text-align: center;\">123123213122</p> <img alt=\"\" height=\"391\" src=\"/weaver/weaver.file.FileDownload?fileid=1435\" width=\"400\" /></body> </html> ";
		int startindex = 0;
		int endindex = 0;
		int start = test.indexOf("<img", startindex);
		System.out.println(start);
		int end = test.indexOf("/>", start);
		System.out.println(end);
		System.out.println(test.substring(start,end+2));
		String imgstr = test.substring(start,end+2);
		System.out.println(imgstr.substring(0,imgstr.indexOf("src=\"")+5));
		System.out.println(imgstr.substring(imgstr.indexOf("\"", imgstr.indexOf("src=\"")+5),imgstr.length()));
		System.out.println(imgstr.substring(0,imgstr.indexOf("src=\"")+5)+"aaa"+imgstr.substring(imgstr.indexOf("\"", imgstr.indexOf("src=\"")+5),imgstr.length()));
		System.out.println(imgstr.indexOf("fileid="));
		System.out.println(imgstr.indexOf("\"", imgstr.indexOf("fileid=")));
		String imagefieleid = imgstr.substring(imgstr.indexOf("fileid=")+7,imgstr.indexOf("\"", imgstr.indexOf("fileid=")));
		System.out.println(imagefieleid);
	}
	
	public static String changeimageString(String htmlstr) {
		int start = htmlstr.indexOf("<img", 0);
		int end = htmlstr.indexOf("/>", start);
		if(start<0 || end<0) {
			return htmlstr;
		}
		String imgstr = htmlstr.substring(start,end+2);
		String imagefieleid = imgstr.substring(imgstr.indexOf("fileid=")+7,imgstr.indexOf("\"", imgstr.indexOf("fileid=")));
		
		return htmlstr.substring(0,start)+"aaaa"+changeimageString(htmlstr.substring(end+2));
	}
}
