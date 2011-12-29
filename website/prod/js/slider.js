$(function() {
	
	var totalPanels			= $(".scrollContainer").children().size();
		
	var regWidth			= $(".panel").css("width");
	var regImgWidth			= $(".panel img").css("width");
	var regImgHeight		= $(".panel img").css("height");
	var regTitleSize		= $(".panel h2").css("font-size");
	var regParSize			= $(".panel p").css("font-size");
	
	var movingDistance	    = 200;
	
	var curWidth			= 300;
	var curImgWidth			= 295;
	var curImgHeight		= 350;
	var curTitleSize		= "20px";
	var curParSize			= "15px";
	var display1				= "hidden";

	var $panels				= $('#slider .scrollContainer > div');
	var $container			= $('#slider .scrollContainer');

	$panels.css({'float' : 'left','position' : 'relative'});
    
	$("#slider").data("currentlyMoving", false);

	$container
		.css('width', ($panels[0].offsetWidth * $panels.length) + 100 )
		.css('left', "-100px");

	var scroll = $('#slider .scroll').css('overflow', 'hidden');

	function returnToNormal(element) {
		$(element)
			.animate({ width: regWidth })
			.find("img")
			//.animate({ width: regImgWidth })
			//.animate({ height: regImgHeight })
			.css({'width' : regImgWidth})
			.css({'height' : regImgHeight})
		    .end()
			.find("h2")
			.animate({ fontSize: regTitleSize })
			.end()
			.find("p")
			.animate({  fontSize: curParSize })
			.end()
			.find("h2")
			.css({'display' : 'none'})
			.end()
			.find("span")
			.css({'display' : 'none'})
			.end()
			.find("p")
			.css({'display' : 'none'})
			.end()
			.css({'top' : '50'});
	};
	
	function growBigger(element) {
		
		$(element)
			.animate({ width: curWidth })
			.find("img")
			//.animate({ width: curImgWidth })
			.css({'width' : '295'})
			.css({'height' : '350'})
		    .end()
			.find("h2")
			.animate({ fontSize: regTitleSize  })
			.end()
			.find("h2")
			.css({'display' : 'block'})
			.end()
			.find("span")
			.css({'display' : 'block'})
			.end()
			.find("p")
			.css({'display' : 'block'})
			.end()
			.find("div")
			.css({'display' : 'block'})
			.end()
			.css({'top' : '0'});
			//.animate({ visibility: display1 });
	}
	
	//direction true = right, false = left
	function change(direction) {
	   
	    //if not at the first or last panel
		if((direction && !(curPanel < totalPanels)) || (!direction && (curPanel <= 1))) { return false; }	
        
        //if not currently moving
        if (($("#slider").data("currentlyMoving") == false)) {
            
			$("#slider").data("currentlyMoving", true);
			
			var next         = direction ? curPanel + 1 : curPanel - 1;
			var leftValue    = $(".scrollContainer").css("left");
			var movement	 = direction ? parseFloat(leftValue, 10) - movingDistance : parseFloat(leftValue, 10) + movingDistance;
		
			$(".scrollContainer")
				.stop()
				.animate({
					"left": movement
				}, function() {
					$("#slider").data("currentlyMoving", false);
				});
			
			returnToNormal("#panel_"+curPanel);
			growBigger("#panel_"+next);
			
			curPanel = next;
			
			//remove all previous bound functions
			$("#panel_"+(curPanel+1)).unbind();	
			
			//go forward
			$("#panel_"+(curPanel+1)).click(function(){ change(true); });
			
            //remove all previous bound functions															
			$("#panel_"+(curPanel-1)).unbind();
			
			//go back
			$("#panel_"+(curPanel-1)).click(function(){ change(false); }); 
			
			//remove all previous bound functions
			$("#panel_"+curPanel).unbind();
		}
	}
	
	// Set up "Current" panel and next and prev
	growBigger("#panel_3");	
	var curPanel = 3;
	
	$("#panel_"+(curPanel+1)).click(function(){ change(true); });
	$("#panel_"+(curPanel-1)).click(function(){ change(false); });
	
	//when the left/right arrows are clicked
	$(".right").click(function(){ change(true); });	
	$(".left").click(function(){ change(false); });
	
	$(window).keydown(function(event){
	  switch (event.keyCode) {
			case 13: //enter
				$(".right").click();
				break;
			case 32: //space
				$(".right").click();
				break;
	    case 37: //left arrow
				$(".left").click();
				break;
			case 39: //right arrow
				$(".right").click();
				break;
	  }
	});
	
});