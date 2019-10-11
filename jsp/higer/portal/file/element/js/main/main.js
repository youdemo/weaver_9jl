	//判断系统版本 弹出不同版本dialog	
	function openDialog(name,version,url,obj,width,height){
		if(version=="8"){
			e8Dialog(name,url,obj,width,height);
		}else if(version=="9"){
			e9Dialog(name,url,obj,width,height);
		}
	}
	function e8Dialog(name,url,obj,width,height){
		var w = width ? width : window.innerWidth*0.8;
		var h = height ? height : window.innerHeight*0.8;
		dialog = new Dialog();
		dialog.currentWindow = window;
		dialog.Title = name;
		dialog.Width = w;
		dialog.Height = h;
		dialog.Drag = true;
		dialog.ShowButtonRow = true;
		dialog.OKEvent = obj || OKEvent;
		dialog.closeByHand = closeDialog;
		dialog.URL = url;
		dialog.show();
		dialog.okButton.value="确定";
		dialog.cancelButton.value="关闭";
	}
	
	function e9Dialog(name,url,obj,width,height){
		var w = width ? width : window.innerWidth*0.8;
		var h = height ? height : window.innerHeight*0.8;
		var dia = top.ecCom.WeaTools.createDialog({
			title: name,
			url:url,
			icon:"icon-coms-workflow",
			iconBgcolor:"#0079DE",
			style:{width:w,height:h},
			callback:function(datas){ // 数据通信
				obj(datas);
			},
			onCancel:function(){ // 关闭通信
				dia.hide();
			}
		});
		dia.show();
	}
	function closeDialog(){
		if(dialog){
		   dialog.close();
		}
	}
	
	function OKEvent(){
		if(dialog){
			 dialog.close();
		}
	}
	
	
	if(typeof Array.prototype.map != "function") {
		  Array.prototype.map = function (fn, context) {
		    var arr = [];
		    if (typeof fn === "function") {
		      for (var k = 0, length = this.length; k < length; k++) {      
		         arr.push(fn.call(context, this[k], k, this));
		      }
		    }
		    return arr;
		  };
		}