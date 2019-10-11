<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="com.higer.oa.service.portal.ProductPortalService"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
ProductPortalService service = new ProductPortalService();
String otherProductInfosStr = service.getOtherProductInfos("");
%>
<html>
<head>
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta charset="UTF-8" />
    <title>竞品信息</title>
    <link href="/higer/resource/js/framework/antd_3.20.7/antd.min.css" rel="stylesheet" type="text/css"/>
	<script src="/higer/resource/js/framework/babel-polyfill_7.2.5/polyfill.js"></script>
	<script src="/higer/resource/js/framework/babel-standalone_6.26.0/babel.js"></script>
	<script src="/higer/resource/js/framework/react_16.8.6/react.development.js"></script>
	<script src="/higer/resource/js/framework/react-dom_16.8.6/umd/react-dom.development.js"></script>
    <script src="/higer/resource/js/framework/moment_2.24.0/min/moment.min.js"></script>
    <script src="/higer/resource/js/framework/antd_3.20.7/antd.min.js"></script>
	<style type="text/css">
		.otherProductInfoCls{
			width:100%;
			height:168px;
			box-shadow: #ccc 0px 0px 5px;
			border-radius: 5px;
		}
		.otherProductInfoCls .productInfoPic{
			width:200px;
			height:168px;
			float:left;
			position: relative;
		}
		.otherProductInfoCls img{
			width:200px;
			height:auto;
			max-height:168px;
			position: absolute;
			top: 50%;
			left: 50%;
			transform: translate(-50%,-50%);
		}
		.otherProductInfoCls .productInfoContent{
			float:right;
			width: calc(100% - 200px);
			height:168px;
			overflow:hidden;
			padding-top:3px;
			padding-right:3px;
		}
		.otherProductInfoCls .ant-descriptions-bordered .ant-descriptions-item-content{
			display: -webkit-box;
			-webkit-box-orient: vertical;
			-webkit-line-clamp: 1;
			overflow: hidden;
			white-space: nowrap;
			text-overflow: ellipsis;
			word-break: normal;
		}
		.otherProductInfoCls .ant-descriptions-bordered .ant-descriptions-item-label{
			width:55px
		}
		.otherProductInfoCls .ant-descriptions-bordered .ant-descriptions-item-content, 
		.otherProductInfoCls .ant-descriptions-bordered .ant-descriptions-item-label{
			padding:5px 5px
		}
		.otherProductInfoCls .ant-list-grid .ant-list-item{
			margin-bottom：10px
		}
		#otherProjectListApp .ant-list-pagination {
			margin-top：5px
		}
		#otherProjectListApp .ant-list-pagination .ant-pagination-item-link i{
			padding-top:10px;
		}
	</style>
</head>
<body>
    <div id="otherProjectListApp"></div>
	<script>
	</script>
    <script type="text/babel">
		var otherProductInfosStr = <%=otherProductInfosStr%>;
		class HigerOtherProductInfoList extends React.Component {
			componentDidMount () {
				
			}
			render () {
				return (
					<antd.List
					grid={{gutter: 16,xs: 1,sm: 1,md: 1,lg: 1,xl: 2,xxl:3,}}
					itemLayout="horizontal"
					size="large"
					pagination={{
					  onChange: page => {},
					  pageSize: 6,
					}}
					dataSource={otherProductInfosStr}
					renderItem={item => (
					  <antd.List.Item
						key={item.id}
					  >
						<div className="otherProductInfoCls">
							<div className="productInfoPic"><a href={item.vehicleModelUrl} target="_blank"><img src={item.vehiclePic}/></a></div>
							<div className="productInfoContent">
								<antd.Descriptions layout="horizontal" column={{ xs: 1, sm: 1, md: 1}} bordered>
									<antd.Descriptions.Item label="车型">
										<antd.Tooltip placement="topLeft" title={item.vehicleModel}>
											<a href={item.vehicleModelUrl} target="_blank">{item.vehicleModel}</a>
										</antd.Tooltip>
									</antd.Descriptions.Item>
									<antd.Descriptions.Item label="车型名称">
										<antd.Tooltip placement="topLeft" title={item.vehicleModelName}>
											<a href={item.vehicleModelUrl} target="_blank">{item.vehicleModelName}</a>
										</antd.Tooltip>
									</antd.Descriptions.Item>
									<antd.Descriptions.Item label="企业">
										<antd.Tooltip placement="topLeft" title={item.manufacturer}>
											{item.manufacturer}
										</antd.Tooltip>
									</antd.Descriptions.Item>
									<antd.Descriptions.Item label="用途">
										<antd.Tooltip placement="topLeft" title={item.useDesc}>
											{item.useDesc}
										</antd.Tooltip>
									</antd.Descriptions.Item>
									<antd.Descriptions.Item label="车型说明">
										<antd.Tooltip placement="topLeft" title={item.vehicleModelDesc}>
											{item.vehicleModelDesc}
										</antd.Tooltip>
									</antd.Descriptions.Item>
								  </antd.Descriptions>
							  </div>
						  </div>
					  </antd.List.Item>
					)}
				  />
				);
			}
		}
		ReactDOM.render(
		  <HigerOtherProductInfoList />,
		  document.getElementById('otherProjectListApp'),
		);
    </script>
</body>
</html>