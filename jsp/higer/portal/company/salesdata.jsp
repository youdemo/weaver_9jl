<%@page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="/higer/portal/company/css/init_wev8.css" type="text/css">
</head>
	<link href="./css/jquery_dialog_wev8.css" type="text/css" rel="STYLESHEET">
	<link rel="stylesheet" href="/higer/portal/company/css/base.css" type="text/css">
	<style type="text/css">
		a{
			text-decoration-line: none;
		}
	</style>
<body>

    <%
        String statistical_month = "";
        String title = "";
        String month_sale_qty = "";
        String month_sale_amt = "";
        String month_sale_qty_growth_rate = "";
        String month_sale_amt_growth_rate = "";
        String year_total_sale_qty = "";
        String year_total_sale_amt = "";
        String calc_time = "";
        RecordSetDataSource rsd = new RecordSetDataSource("CRMDB_KLPDM");
        String sql = "select statistical_month,title,month_sale_qty,month_sale_amt,month_sale_qty_growth_rate,month_sale_amt_growth_rate,year_total_sale_qty,year_total_sale_amt,calc_time from ord_klsz_month_sale_statistics_v";
        rsd.execute(sql);
        if(rsd.next()){
            statistical_month = Util.null2String(rsd.getString("statistical_month"));
            title = Util.null2String(rsd.getString("title"));
            month_sale_qty = Util.null2String(rsd.getString("month_sale_qty"));
            month_sale_amt = Util.null2String(rsd.getString("month_sale_amt"));
            month_sale_qty_growth_rate = Util.null2String(rsd.getString("month_sale_qty_growth_rate"));
            month_sale_amt_growth_rate = Util.null2String(rsd.getString("month_sale_amt_growth_rate"));
            year_total_sale_qty = Util.null2String(rsd.getString("year_total_sale_qty"));
            year_total_sale_amt = Util.null2String(rsd.getString("year_total_sale_amt"));
            calc_time = Util.null2String(rsd.getString("calc_time"));
        }
    
    
    %>
	<div class="maindiv">
		<div class="containerdiv" style="margin-top: 10px">
			<div class="theme_glt" style="font-size: 20px;text-align: center;width:100%">销售业绩通报（<%=title%>）</div>
			<div class="block-item" title="本月销售量" style="width:50.00%;cursor:pointer"> 	
				<img alt="" class="block-item-icon" src="./img/78.png"/> 	
				<div class="block-item-content"> 	
					<div class="block-item-data">
						<span><%=month_sale_qty%></span> 	
					</div> 		
					<div class="block-item-title">本月销售量（台）</div> 	
				</div> 	
				<div class="linex"></div>
				<div class="liney"></div>
			</div> 
			
			<div class="block-item" title="本月销售额（万元）" style="width:50.00%;cursor:pointer"> 	
				<img alt="" class="block-item-icon" src="./img/80.png"> 		
				<div class="block-item-content"> 	
					<div class="block-item-data">
						<span><%=month_sale_amt%></span> 	
					</div> 		
					<div class="block-item-title">本月销售额（万元）</div> 	
				</div> 	
				<div class="linex"></div>
			</div> 
            <div class="block-item" title="同比增长（销售量）" url="" style="width:50.00%;cursor:auto"> 	
				<img alt="" class="block-item-icon" src="./img/1108.png"> 	
				<div class="block-item-content"> 	
					<div class="block-item-data"> 		
						<span><%=month_sale_qty_growth_rate%></span> 	
					</div> 		
					<div class="block-item-title">同比增长（销售量）</div> 	
				</div> 	
				<div class="linex"></div>
				<div class="liney"></div>
			</div> 
		
			<div class="block-item" title="同比增长（销售额）" url="" style="width:50.00%;cursor:auto"> 	
				<img alt="" class="block-item-icon" src="./img/1109.png"> 	
				<div class="block-item-content"> 	
					<div class="block-item-data"> 		
						<span><%=month_sale_amt_growth_rate%></span> 	
					</div> 		
					<div class="block-item-title">同比增长（销售额）</div> 	
				</div> 
				<div class="linex"></div>
			</div> 
			<div class="block-item" title="累计销售量"  style="width:50.00%;cursor:pointer"> 	
				<img alt="" class="block-item-icon" src="./img/78.png"/> 	
				<div class="block-item-content"> 	
					<div class="block-item-data"> 		
						<span><%=year_total_sale_qty%></span> 	
					</div> 		
					<div class="block-item-title">年累计销售量（台）</div> 	
				</div> 	
				<div class="linex"></div>
				<div class="liney"></div>
			</div> 
		
			<div class="block-item" title="累计销售额（万元）" style="width:50.00%;cursor:pointer"> 	
				<img alt="" class="block-item-icon" src="./img/80.png"> 		
				<div class="block-item-content"> 	
					<div class="block-item-data"> 		
						<span><%=year_total_sale_amt%></span> 	
					</div> 		
					<div class="block-item-title">年累计销售额（万元）</div> 	
				</div> 	
				<div class="linex"></div>
			</div> 
		
			
		</div>
	</div>
</body>
</html>