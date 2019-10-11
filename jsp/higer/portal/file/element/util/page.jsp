<%@ include file="/plugin/element/util/Util.jsp"%>
<style>
.errormsg{text-align: center;font-style: italic;color: #f00;line-height: 30px;font-size: 14px !important;}
</style>
<%
		String key = Util.null2String(request.getParameter("key"));
		if(key.length() == 0){%>
		   <div class="errormsg">key不能为空！</div>
		   <%return;
		}
		JSONObject jsonconf = this.getJSONObject("app",key);
		String type = "1";//分页类型
		try{
			type = Util.null2s(jsonconf.getString("pagetype"),"1");
		}catch(Exception e){
			type = "1";
		}
%>
<script type="text/javascript" src="/plugin/element/js/page<%=type%>/paging.js"></script>
<link rel="stylesheet" href="/plugin/element/js/page<%=type%>/paging.css" />
<script type="text/javascript">
function pageNation(pageNumber,itotal,totalPage,type,obj){
	if(type==1){
		$("#page").paging({
			pageNo:pageNumber,
			totalPage: totalPage,
			totalSize: itotal,
			callback: function(num) {
			   obj(num);
			}
		});
	}
}
</script>