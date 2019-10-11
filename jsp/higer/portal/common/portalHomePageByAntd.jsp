<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
String portalNo = request.getParameter("portalNo");
%>
<html>
<head>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta charset="UTF-8" />
    <title>海格门户</title>
    <link href="/higer/resource/js/framework/antd_3.20.7/antd.min.css" rel="stylesheet" type="text/css"/>
	<script src="/higer/resource/js/framework/babel-polyfill_7.2.5/polyfill.js"></script>
	<script src="/higer/resource/js/framework/babel-standalone_6.26.0/babel.js"></script>
	<script src="/higer/resource/js/framework/react_16.8.6/react.development.js"></script>
	<script src="/higer/resource/js/framework/react-dom_16.8.6/umd/react-dom.development.js"></script>
    <script src="/higer/resource/js/framework/moment_2.24.0/min/moment.min.js"></script>
    <script src="/higer/resource/js/framework/antd_3.20.7/antd.min.js"></script>
	
	
	
</head>
<body>
    <div id="higerPortalApp"></div>
	<script>
		
	</script>
    <script type="text/babel">
		

        class HigerPortal extends React.Component{
			constructor(props) {
				super(props);
				this.state = {menuInfos: portalMenuInfos,defualtPage:defualtUrl,headPicUrls:picNameArr};
			}
			componentDidMount(){
				if(this.state.defualtPage){
					document.getElementById('portalMainIframe').src = this.state.defualtPage;
				}else{
					var firstPageUrl = this.getFirstPageUrl(this.state.menuInfos);
					console.log(firstPageUrl);
					if(firstPageUrl && firstPageUrl instanceof Array){
						document.getElementById('portalMainIframe').src = firstPageUrl[0];
					}else if(firstPageUrl){
						document.getElementById('portalMainIframe').src = firstPageUrl;
					}
				}
			}
			getFirstPageUrl(menuInfos){
				return menuInfos.map((menuInfo)=>{
					if(menuInfo.menuType == "currentPage" && menuInfo.menuUrl && menuInfo.menuUrl != ""){
						return menuInfo.menuUrl;
					}else if(menuInfo.children && menuInfo.children.length > 0){
						return this.getFirstPageUrl(menuInfo.children);
					}
					return "";
				});
			}
            onClick = (e)=>{
				var pageInfo = e.key.split(",");
				if(!pageInfo || pageInfo.length < 3){
					return;
				}
				var menuType = pageInfo[1];
				var menuUrl = pageInfo[2];
				if( menuType == "newPage"){
					var windowTitle = '门户弹出窗口';
					if(pageInfo>=4){
						windowTitle = pageInfo[3];
					}
					if(!windowTitle || windowTitle == ''){
						windowTitle = '门户弹出窗口';
					}
					var fulls = "left=30px,screenX=30px,top=30px,screenY=30px,scrollbars=1";    //定义弹出窗口的参数
					if (window.screen) {
						var ah = screen.availHeight - 100;
						var aw = screen.availWidth - 100;
						fulls += ",height=" + ah;
						fulls += ",innerHeight=" + ah;
						fulls += ",width=" + aw;
						fulls += ",innerWidth=" + aw;
						fulls += ",resizable"
					} else {
						fulls += ",resizable"; // 对于不支持screen属性的浏览器，可以手工进行最大化。 manually
					}
					window.open(menuUrl,windowTitle,fulls)
				}else{
					document.getElementById('portalMainIframe').src = menuUrl;
				}
            }
			getMenuUi(menuInfos){
				return menuInfos.map((menuInfo)=>{
					if(menuInfo.children && menuInfo.children.length > 0){
						return <antd.Menu.SubMenu 
						          onTitleClick={this.onClick}
								  key={menuInfo.id+"_"+menuInfo.fatMenuId+","+menuInfo.menuType+","+menuInfo.menuUrl+","+menuInfo.menuName}
								  title={
									menuInfo.menuName
								  }
								>
								{this.getMenuUi(menuInfo.children)}
							</antd.Menu.SubMenu>
					}
					return <antd.Menu.Item key={menuInfo.id+"_"+menuInfo.fatMenuId+","+menuInfo.menuType+","+menuInfo.menuUrl+","+menuInfo.menuName}>
								{menuInfo.menuName}
						</antd.Menu.Item>;
				})
			}
			getHeadPics(){
				return this.state.headPicUrls.map((picName) => { return <img src={picName}></img>});
			}
            render = ()=>{
                return ( <div>
				<div className="hgierCarousel">
					<antd.Carousel autoplay="true" effect="fade" {...{autoplaySpeed:3000,speed:1000}}>
						{this.getHeadPics()}
					</antd.Carousel>
				</div>
				<antd.Menu mode="horizontal" className="higerPortalMenuCls" onClick={this.onClick}>{this.getMenuUi(this.state.menuInfos)}
				</antd.Menu>
				</div>)  
            }
        }
		ReactDOM.render(<HigerPortal />, document.getElementById('higerPortalApp'));
    </script>
</body>
</html>