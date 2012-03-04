// usingas/includes/IncludedFile.as
import flash.display.Stage;

public function computeSum(a:Number, b:Number):Number {
	return a + b;
}

public function init():void {
	
	trace('yo');

	//var c:classtest = new classtest();
	var a:away36 = new away36();
	//ui::
	//ui::__stage.addChild( a );
}


import mx.core.UIComponent; 
private var bgColor:uint = 0xFFCC00; 
import flash.display.Sprite;

public function drawStuff() : void 
{ 
	var ref : UIComponent = new UIComponent(); // creating a UI compoent Object 
	var circle1 : Sprite = new Sprite(); 
	circle1.graphics.beginFill(bgColor); 
	
	circle1.graphics.drawCircle( 40, 40, 40 ); 
	circle1.buttonMode = true; 
	addChild( ref ); // add UI component to mxml base container 
	ref.addChild( circle1 );// adding sprite to UIcompoent 
} 