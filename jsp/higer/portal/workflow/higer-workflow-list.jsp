<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*,weaver.hrm.appdetach.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<html class=" ">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="initial-scale=1,maximum-scale=2">
<link rel="stylesheet" href="/higer/portal/workflow/css/index.min.css">
<link rel="stylesheet" href="/higer/portal/workflow/css/ecCom.min.css">
<link href="/higer/portal/workflow/css/index(2).css" rel="stylesheet">
<link rel="stylesheet"
	href="/higer/portal/workflow/css/devModuleStyle.css">
<style>
#container, body, html {
	height: 100%;
	overflow: auto;
}
</style>
<style type="text/css">
.amap_markers_pop_window {
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 8px;
	background: #fff;
	position: relative;
	display: flex;
	flex-wrap: wrap;
	justify-content: flex-start;
}

.amap_markers_pop_window::before {
	content: ' ';
	display: block;
	position: absolute;
	bottom: -12px;
	left: 50%;
	margin-left: -7px;
	width: 0;
	height: 0;
	border-top: 12px solid #ddd;
	border-left: 7px solid transparent;
	border-right: 7px solid transparent;
}

.amap_markers_pop_window::after {
	content: ' ';
	display: block;
	position: absolute;
	bottom: -11px;
	left: 50%;
	margin-left: -6px;
	width: 0;
	height: 0;
	border-top: 11px solid #fff;
	border-left: 6px solid transparent;
	border-right: 6px solid transparent;
}

.amap_markers_pop_window_item {
	cursor: pointer;
	width: 40px;
	height: 50px;
	display: flex;
	align-items: flex-end;
	justify-content: center;
}

.amap_markers_pop_window_item span {
	pointer-events: none;
}

.amap_markers_window_overflow_warning {
	text-align: center;
	width: 100%;
	margin: 5px 0;
	color: #666;
}
</style>
<style id="ace_editor.css">
.ace_editor {
	position: relative;
	overflow: hidden;
	font: 12px/normal 'Monaco', 'Menlo', 'Ubuntu Mono', 'Consolas',
		'source-code-pro', monospace;
	direction: ltr;
	text-align: left;
	-webkit-tap-highlight-color: rgba(0, 0, 0, 0);
}

.ace_scroller {
	position: absolute;
	overflow: hidden;
	top: 0;
	bottom: 0;
	background-color: inherit;
	-ms-user-select: none;
	-moz-user-select: none;
	-webkit-user-select: none;
	user-select: none;
	cursor: text;
}

.ace_content {
	position: absolute;
	-moz-box-sizing: border-box;
	-webkit-box-sizing: border-box;
	box-sizing: border-box;
	min-width: 100%;
}

.ace_dragging .ace_scroller:before {
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	content: '';
	background: rgba(250, 250, 250, 0.01);
	z-index: 1000;
}

.ace_dragging.ace_dark .ace_scroller:before {
	background: rgba(0, 0, 0, 0.01);
}

.ace_selecting, .ace_selecting * {
	cursor: text !important;
}

.ace_gutter {
	position: absolute;
	overflow: hidden;
	width: auto;
	top: 0;
	bottom: 0;
	left: 0;
	cursor: default;
	z-index: 4;
	-ms-user-select: none;
	-moz-user-select: none;
	-webkit-user-select: none;
	user-select: none;
}

.ace_gutter-active-line {
	position: absolute;
	left: 0;
	right: 0;
}

.ace_scroller.ace_scroll-left {
	box-shadow: 17px 0 16px -16px rgba(0, 0, 0, 0.4) inset;
}

.ace_gutter-cell {
	padding-left: 19px;
	padding-right: 6px;
	background-repeat: no-repeat;
}

.ace_scrollbar {
	position: absolute;
	right: 0;
	bottom: 0;
	z-index: 6;
}

.ace_scrollbar-inner {
	position: absolute;
	cursor: text;
	left: 0;
	top: 0;
}

.ace_scrollbar-v {
	overflow-x: hidden;
	overflow-y: scroll;
	top: 0;
}

.ace_scrollbar-h {
	overflow-x: scroll;
	overflow-y: hidden;
	left: 0;
}

.ace_print-margin {
	position: absolute;
	height: 100%;
}

.ace_text-input {
	position: absolute;
	z-index: 0;
	width: 0.5em;
	height: 1em;
	opacity: 0;
	background: transparent;
	-moz-appearance: none;
	appearance: none;
	border: none;
	resize: none;
	outline: none;
	overflow: hidden;
	font: inherit;
	padding: 0 1px;
	margin: 0 -1px;
	text-indent: -1em;
	-ms-user-select: text;
	-moz-user-select: text;
	-webkit-user-select: text;
	user-select: text;
	white-space: pre !important;
}

.ace_text-input.ace_composition {
	background: inherit;
	color: inherit;
	z-index: 1000;
	opacity: 1;
	text-indent: 0;
}

.ace_layer {
	z-index: 1;
	position: absolute;
	overflow: hidden;
	word-wrap: normal;
	white-space: pre;
	height: 100%;
	width: 100%;
	-moz-box-sizing: border-box;
	-webkit-box-sizing: border-box;
	box-sizing: border-box;
	pointer-events: none;
}

.ace_gutter-layer {
	position: relative;
	width: auto;
	text-align: right;
	pointer-events: auto;
}

.ace_text-layer {
	font: inherit !important;
}

.ace_cjk {
	display: inline-block;
	text-align: center;
}

.ace_cursor-layer {
	z-index: 4;
}

.ace_cursor {
	z-index: 4;
	position: absolute;
	-moz-box-sizing: border-box;
	-webkit-box-sizing: border-box;
	box-sizing: border-box;
	border-left: 2px solid;
	transform: translatez(0);
}

.ace_multiselect .ace_cursor {
	border-left-width: 1px;
}

.ace_slim-cursors .ace_cursor {
	border-left-width: 1px;
}

.ace_overwrite-cursors .ace_cursor {
	border-left-width: 0;
	border-bottom: 1px solid;
}

.ace_hidden-cursors .ace_cursor {
	opacity: 0.2;
}

.ace_smooth-blinking .ace_cursor {
	-webkit-transition: opacity 0.18s;
	transition: opacity 0.18s;
}

.ace_marker-layer .ace_step, .ace_marker-layer .ace_stack {
	position: absolute;
	z-index: 3;
}

.ace_marker-layer .ace_selection {
	position: absolute;
	z-index: 5;
}

.ace_marker-layer .ace_bracket {
	position: absolute;
	z-index: 6;
}

.ace_marker-layer .ace_active-line {
	position: absolute;
	z-index: 2;
}

.ace_marker-layer .ace_selected-word {
	position: absolute;
	z-index: 4;
	-moz-box-sizing: border-box;
	-webkit-box-sizing: border-box;
	box-sizing: border-box;
}

.ace_line .ace_fold {
	-moz-box-sizing: border-box;
	-webkit-box-sizing: border-box;
	box-sizing: border-box;
	display: inline-block;
	height: 11px;
	margin-top: -2px;
	vertical-align: middle;
	background-repeat: no-repeat, repeat-x;
	background-position: center center, top left;
	color: transparent;
	border: 1px solid black;
	border-radius: 2px;
	cursor: pointer;
	pointer-events: auto;
}

.ace_dark .ace_fold {
	
}

.ace_tooltip {
	background-color: #FFF;
	background-image: -webkit-linear-gradient(top, transparent, rgba(0, 0, 0, 0.1));
	background-image: linear-gradient(to bottom, transparent, rgba(0, 0, 0, 0.1));
	border: 1px solid gray;
	border-radius: 1px;
	box-shadow: 0 1px 2px rgba(0, 0, 0, 0.3);
	color: black;
	max-width: 100%;
	padding: 3px 4px;
	position: fixed;
	z-index: 999999;
	-moz-box-sizing: border-box;
	-webkit-box-sizing: border-box;
	box-sizing: border-box;
	cursor: default;
	white-space: pre;
	word-wrap: break-word;
	line-height: normal;
	font-style: normal;
	font-weight: normal;
	letter-spacing: normal;
	pointer-events: none;
}

.ace_folding-enabled>.ace_gutter-cell {
	padding-right: 13px;
}

.ace_fold-widget:hover {
	border: 1px solid rgba(0, 0, 0, 0.3);
	background-color: rgba(255, 255, 255, 0.2);
	box-shadow: 0 1px 1px rgba(255, 255, 255, 0.7);
}

.ace_fold-widget:active {
	border: 1px solid rgba(0, 0, 0, 0.4);
	background-color: rgba(0, 0, 0, 0.05);
	box-shadow: 0 1px 1px rgba(255, 255, 255, 0.8);
}

.ace_dark .ace_fold-widget:hover {
	box-shadow: 0 1px 1px rgba(255, 255, 255, 0.2);
	background-color: rgba(255, 255, 255, 0.1);
}

.ace_dark .ace_fold-widget:active {
	box-shadow: 0 1px 1px rgba(255, 255, 255, 0.2);
}

.ace_fold-widget.ace_invalid {
	background-color: #FFB4B4;
	border-color: #DE5555;
}

.ace_fade-fold-widgets .ace_fold-widget {
	-webkit-transition: opacity 0.4s ease 0.05s;
	transition: opacity 0.4s ease 0.05s;
	opacity: 0;
}

.ace_fade-fold-widgets:hover .ace_fold-widget {
	-webkit-transition: opacity 0.05s ease 0.05s;
	transition: opacity 0.05s ease 0.05s;
	opacity: 1;
}

.ace_underline {
	text-decoration: underline;
}

.ace_bold {
	font-weight: bold;
}

.ace_nobold .ace_bold {
	font-weight: normal;
}

.ace_italic {
	font-style: italic;
}

.ace_error-marker {
	background-color: rgba(255, 0, 0, 0.2);
	position: absolute;
	z-index: 9;
}

.ace_highlight-marker {
	background-color: rgba(255, 255, 0, 0.2);
	position: absolute;
	z-index: 8;
}

.ace_br1 {
	border-top-left-radius: 3px;
}

.ace_br2 {
	border-top-right-radius: 3px;
}

.ace_br3 {
	border-top-left-radius: 3px;
	border-top-right-radius: 3px;
}

.ace_br4 {
	border-bottom-right-radius: 3px;
}

.ace_br5 {
	border-top-left-radius: 3px;
	border-bottom-right-radius: 3px;
}

.ace_br6 {
	border-top-right-radius: 3px;
	border-bottom-right-radius: 3px;
}

.ace_br7 {
	border-top-left-radius: 3px;
	border-top-right-radius: 3px;
	border-bottom-right-radius: 3px;
}

.ace_br8 {
	border-bottom-left-radius: 3px;
}

.ace_br9 {
	border-top-left-radius: 3px;
	border-bottom-left-radius: 3px;
}

.ace_br10 {
	border-top-right-radius: 3px;
	border-bottom-left-radius: 3px;
}

.ace_br11 {
	border-top-left-radius: 3px;
	border-top-right-radius: 3px;
	border-bottom-left-radius: 3px;
}

.ace_br12 {
	border-bottom-right-radius: 3px;
	border-bottom-left-radius: 3px;
}

.ace_br13 {
	border-top-left-radius: 3px;
	border-bottom-right-radius: 3px;
	border-bottom-left-radius: 3px;
}

.ace_br14 {
	border-top-right-radius: 3px;
	border-bottom-right-radius: 3px;
	border-bottom-left-radius: 3px;
}

.ace_br15 {
	border-top-left-radius: 3px;
	border-top-right-radius: 3px;
	border-bottom-right-radius: 3px;
	border-bottom-left-radius: 3px;
}

.ace_text-input-ios {
	position: absolute !important;
	top: -100000px !important;
	left: -100000px !important;
}
/*# sourceURL=ace/css/ace_editor.css */
</style>
<style id="ace-tm">
.ace-tm .ace_gutter {
	background: #f0f0f0;
	color: #333;
}

.ace-tm .ace_print-margin {
	width: 1px;
	background: #e8e8e8;
}

.ace-tm .ace_fold {
	background-color: #6B72E6;
}

.ace-tm {
	background-color: #FFFFFF;
	color: black;
}

.ace-tm .ace_cursor {
	color: black;
}

.ace-tm .ace_invisible {
	color: rgb(191, 191, 191);
}

.ace-tm .ace_storage, .ace-tm .ace_keyword {
	color: blue;
}

.ace-tm .ace_constant {
	color: rgb(197, 6, 11);
}

.ace-tm .ace_constant.ace_buildin {
	color: rgb(88, 72, 246);
}

.ace-tm .ace_constant.ace_language {
	color: rgb(88, 92, 246);
}

.ace-tm .ace_constant.ace_library {
	color: rgb(6, 150, 14);
}

.ace-tm .ace_invalid {
	background-color: rgba(255, 0, 0, 0.1);
	color: red;
}

.ace-tm .ace_support.ace_function {
	color: rgb(60, 76, 114);
}

.ace-tm .ace_support.ace_constant {
	color: rgb(6, 150, 14);
}

.ace-tm .ace_support.ace_type, .ace-tm .ace_support.ace_class {
	color: rgb(109, 121, 222);
}

.ace-tm .ace_keyword.ace_operator {
	color: rgb(104, 118, 135);
}

.ace-tm .ace_string {
	color: rgb(3, 106, 7);
}

.ace-tm .ace_comment {
	color: rgb(76, 136, 107);
}

.ace-tm .ace_comment.ace_doc {
	color: rgb(0, 102, 255);
}

.ace-tm .ace_comment.ace_doc.ace_tag {
	color: rgb(128, 159, 191);
}

.ace-tm .ace_constant.ace_numeric {
	color: rgb(0, 0, 205);
}

.ace-tm .ace_variable {
	color: rgb(49, 132, 149);
}

.ace-tm .ace_xml-pe {
	color: rgb(104, 104, 91);
}

.ace-tm .ace_entity.ace_name.ace_function {
	color: #0000A2;
}

.ace-tm .ace_heading {
	color: rgb(12, 7, 255);
}

.ace-tm .ace_list {
	color: rgb(185, 6, 144);
}

.ace-tm .ace_meta.ace_tag {
	color: rgb(0, 22, 142);
}

.ace-tm .ace_string.ace_regex {
	color: rgb(255, 0, 0)
}

.ace-tm .ace_marker-layer .ace_selection {
	background: rgb(181, 213, 255);
}

.ace-tm.ace_multiselect .ace_selection.ace_start {
	box-shadow: 0 0 3px 0px white;
}

.ace-tm .ace_marker-layer .ace_step {
	background: rgb(252, 255, 0);
}

.ace-tm .ace_marker-layer .ace_stack {
	background: rgb(164, 229, 101);
}

.ace-tm .ace_marker-layer .ace_bracket {
	margin: -1px 0 0 -1px;
	border: 1px solid rgb(192, 192, 192);
}

.ace-tm .ace_marker-layer .ace_active-line {
	background: rgba(0, 0, 0, 0.07);
}

.ace-tm .ace_gutter-active-line {
	background-color: #dcdcdc;
}

.ace-tm .ace_marker-layer .ace_selected-word {
	background: rgb(250, 250, 255);
	border: 1px solid rgb(200, 200, 250);
}
</style>
<style>
.error_widget_wrapper {
	background: inherit;
	color: inherit;
	border: none
}

.error_widget {
	border-top: solid 2px;
	border-bottom: solid 2px;
	margin: 5px 0;
	padding: 10px 40px;
	white-space: pre-wrap;
}

.error_widget.ace_error, .error_widget_arrow.ace_error {
	border-color: #ff5a5a
}

.error_widget.ace_warning, .error_widget_arrow.ace_warning {
	border-color: #F1D817
}

.error_widget.ace_info, .error_widget_arrow.ace_info {
	border-color: #5a5a5a
}

.error_widget.ace_ok, .error_widget_arrow.ace_ok {
	border-color: #5aaa5a
}

.error_widget_arrow {
	position: absolute;
	border: solid 5px;
	border-top-color: transparent !important;
	border-right-color: transparent !important;
	border-left-color: transparent !important;
	top: -5px;
}
</style>
<style type="text/css">
.fancybox-margin {
	margin-right: 0px;
}
</style>
<style id="tsbrowser_video_independent_player_style" type="text/css">
[tsbrowser_force_max_size] {
	width: 100% !important;
	height: 100% !important;
	left: 0px !important;
	top: 0px !important;
	margin: 0px !important;
	padding: 0px !important;
}

[tsbrowser_force_fixed] {
	position: fixed !important;
	z-index: 9999 !important;
	background: black !important;
}

[tsbrowser_force_hidden] {
	opacity: 0 !important;
	z-index: 0 !important;
}

[tsbrowser_hide_scrollbar] {
	overflow: hidden !important;
}
</style>
<style type="text/css">
.wf-card-type-name span img {
	width: 100%;
	height: 100%;
}

.wea-wf-add-content {
	min-width: 1300px;
}
</style>
</head>
<%
	String[] color = { "rgb(85, 210, 212)", "rgb(179, 123, 250)", "rgb(255, 198, 46)", "rgb(141, 206, 54)", "rgb(255, 94, 86)", "rgb(55, 178, 255)" };
	String[] imgsrc = { "work.png", "qd.png", "rs.png", "xs.png", "xz.png", "zc.png" };
%>

<body cz-shortcut-listen="true">
	<div id="container">
		<div style="height: 100%;">
			<div class="wf-create-main">
				<div class="wea-new-top-wapper" id="weatop_h9ozis_1560916566759">
					<div class="ant-row wea-new-top"></div>
				</div>
				<div class="wea-wf-add-content" style="height: 100%;">
					<div class="ant-row">
						<%!public String getMinlength(int length1, int length2, int length3, int length4) {
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
						
							}%>
						<%
							int userid = user.getUID();
							String tmp_jobtitle = "";
							String tmp_seclevel = "";
							String tmp_departmentid = "";
							String tmp_subcompanyid1 = "";
							String sql = "select * from hrmresource where id = " + userid;
							rs.execute(sql);
							if (rs.next()) {
								tmp_jobtitle = Util.null2String(rs.getString("jobtitle"));
								tmp_seclevel = Util.null2String(rs.getString("seclevel"));
								tmp_departmentid = Util.null2String(rs.getString("departmentid"));
								tmp_subcompanyid1 = Util.null2String(rs.getString("subcompanyid1"));
							}
							sql = "select resourceid,roleid from hrmrolemembers where resourceid = " + userid;
							rs.execute(sql);
							String tmp_roles = "0";
							while (rs.next()) {
								String tmp_xx = Util.null2String(rs.getString("roleid"));
								tmp_roles = tmp_roles + "," + tmp_xx;
							}
							Map<String, List<Map>> typeflowMap = new HashMap<String, List<Map>>();
							Map<String, String> typemap = new HashMap<String, String>();
							sql = "select id,workflowname,workflowtype,(select typename from workflow_type where id=t.workflowtype) as typename,'0' as systype from workflow_base t where id in("
									+ " select workflowid from shareinnerwfcreate where workflowid  in(select id from workflow_base where isvalid = 1) and ( "
									+ " (type = 4 and min_seclevel <= " + tmp_seclevel + " and max_seclevel >= " + tmp_seclevel + " ) "
									+ " or (type = 3 and content = " + userid + ") " + " or (type = 1 and isbelong = 1 and content in("
									+ tmp_departmentid + ") and bhxj in(1)) or (type = 1 and isbelong = 2 and content not in("
									+ tmp_departmentid + ") and bhxj in(1)) " + " or (type = 1 and isbelong = 1 and content = "
									+ tmp_departmentid + " and bhxj in(0)) or (type = 1 and isbelong = 2 and content != "
									+ tmp_departmentid + " and bhxj in(0))   " + " or (type = 30 and isbelong = 1 and content in("
									+ tmp_subcompanyid1 + ") and bhxj in(1)) or (type = 30 and isbelong = 2 and content not in("
									+ tmp_subcompanyid1 + ") and bhxj in(1)) " + " or (type = 30 and isbelong = 1 and content = "
									+ tmp_subcompanyid1 + " and bhxj in(1)) or (type = 30 and isbelong = 2 and content != "
									+ tmp_subcompanyid1 + " and bhxj in(1)) "
									+ " or (type = 58 and min_seclevel = 2 and isbelong = 1 and content = " + tmp_jobtitle
									+ ") or (type = 58 and min_seclevel = 2 and isbelong = 2 and content != " + tmp_jobtitle + " ) "
									+ " or (type = 58 and min_seclevel = 0 and isbelong = 1 and content = " + tmp_jobtitle
									+ " and max_seclevel = " + tmp_departmentid
									+ ") or (type = 58 and min_seclevel = 0 and isbelong = 2 and content != " + tmp_jobtitle
									+ " and max_seclevel != " + tmp_departmentid + ") "
									+ " or (type = 58 and min_seclevel = 1 and isbelong = 1 and content = " + tmp_jobtitle
									+ " and max_seclevel = " + tmp_subcompanyid1
									+ ") or (type = 58 and min_seclevel = 1 and isbelong = 2 and content != " + tmp_jobtitle
									+ " and max_seclevel != " + tmp_subcompanyid1 + ") "
									+ " or (type = 2 and isbelong = 1 and trunc(content/10) in(" + tmp_roles
									+ ") ) or (type = 2 and isbelong = 2 and trunc(content/10) not in(" + tmp_roles
									+ ") ) ) ) and id in (select lcmc from  uf_create_oalist ) order by dsporder asc";
							rs.execute(sql);

							while (rs.next()) {
								String workflowid = Util.null2String((rs.getString("id")));
								String workflowname = Util.null2String(rs.getString("workflowname"));
								String workflowtype = Util.null2String(rs.getString("workflowtype"));
								String typename = Util.null2String(rs.getString("typename"));
								String systype = Util.null2String(rs.getString("systype"));
								typemap.put(typename, workflowtype);
								Map<String, String> flowmap = new HashMap<String, String>();
								//flowmap.put("workflowid", workflowid);
								flowmap.put("workflowname", workflowname);
								flowmap.put("url", "/spa/workflow/index_form.jsp#/main/workflow/req?iscreate=1&workflowid=" + workflowid
										+ "&isagent=0&beagenter=0&f_weaver_belongto_userid=&f_weaver_belongto_usertype=0");
								if (typeflowMap.get(typename) == null) {
									typeflowMap.put(typename, new ArrayList<Map>());
								}
								typeflowMap.get(typename).add(flowmap);

							}
							sql = "select wfname,wfurl,wftype,(select typename from workflow_type where id=a.wftype) as typename,'1' as systype from uf_other_WF_START a where is_active = 0 and (ftype = 0 or (ftype = 1 and  FUN_INSTR_CONTAINS(roles,'"
									+ tmp_roles + ",')>0 ) ) order by seqno asc";
							rs.execute(sql);
							while (rs.next()) {
								String workflowname = Util.null2String(rs.getString("wfname"));
								String workflowtype = Util.null2String(rs.getString("wftype"));
								String typename = Util.null2String(rs.getString("typename"));
								String systype = Util.null2String(rs.getString("systype"));
								String wfurl = Util.null2String(rs.getString("wfurl"));
								typemap.put(typename, workflowtype);
								Map<String, String> flowmap = new HashMap<String, String>();
								//flowmap.put("workflowid", "0");
								flowmap.put("workflowname", workflowname);
								flowmap.put("url", wfurl);
								if (typeflowMap.get(typename) == null) {
									typeflowMap.put(typename, new ArrayList<Map>());
								}
								typeflowMap.get(typename).add(flowmap);

							}
							String workflowtypes = "-1";
							Iterator typei = typemap.keySet().iterator();
							while (typei.hasNext()) {
								String key = (String) typei.next();
								String value = typemap.get(key);
								workflowtypes = workflowtypes + "," + value;
							}
							int count = 0;
							int length1 = 0;
							int length2 = 0;
							int length3 = 0;
							int length4 = 0;
							String divhtml1 = "";
							String divhtml2 = "";
							String divhtml3 = "";
							String divhtml4 = "";
							sql = "select id,typename from workflow_type where id in(" + workflowtypes + ") order by dsporder asc";
							rs.execute(sql);
							while (rs.next()) {
								String typename = Util.null2String(rs.getString("typename"));
								List<Map> flowlist = typeflowMap.get(typename);
								int choosetype = count % 6;
								int listsize = flowlist.size()+3;
								String minlength = getMinlength(length1, length2, length3, length4);
								String htmltype = "<div>" + "<div class=\"ant-card ant-card-bordered\" style=\"border-top-color: "
										+ color[choosetype] + ";\">" + "<div class=\"ant-card-body\">"
										+ "<div style=\"padding: 5px 0px 25px; text-align: center;\">"
										+ " <div class=\"wf-card-type-name\">" + "  <span style = \"width: 40px;height:40px;\">"
										+ "    <img src = \"/higer/portal/workflow/img/" + imgsrc[choosetype] + "\"/>" + " </span>"
										+ " <span style=\"height: 36px; line-height: 36px;\">" + typename + "("+flowlist.size()+")</span>" + "</div>"
										+ "</div>";
								for (Map<String, String> mapflow : flowlist) {

									htmltype = htmltype + "<div class=\"centerItem\">"
											+ "<div class=\"fontItem\" style=\"width: 100%;\">" + "<a  href='" + mapflow.get("url")
											+ "'target=\"_blank\" >" + mapflow.get("workflowname") + "</a>" + "</div>" + "</div>";
								}
								htmltype = htmltype + "</div></div></div>";
								if ("1".equals(minlength)) {
									divhtml1 = divhtml1 + htmltype;
									length1 = length1 + listsize;
								} else if ("2".equals(minlength)) {
									divhtml2 = divhtml2 + htmltype;
									length2 = length2 + listsize;
								} else if ("3".equals(minlength)) {
									divhtml3 = divhtml3 + htmltype;
									length3 = length3 + listsize;
								} else if ("4".equals(minlength)) {
									divhtml4 = divhtml4 + htmltype;
									length4 = length4 + listsize;
								}
								count++;
							}
						%>
						<div class="ant-col-6" style="padding: 0px 10px;">
							<%=divhtml1%>
						</div>
						<div class="ant-col-6" style="padding: 0px 10px;">
							<%=divhtml2%>
						</div>
						<div class="ant-col-6" style="padding: 0px 10px;">
							<%=divhtml3%>
						</div>
						<div class="ant-col-6" style="padding: 0px 10px;">
							<%=divhtml4%>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
