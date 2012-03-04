package
{
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.display.Shape;
	
	public class widget extends Sprite
	{
		public function widget()
		{
			// creating a new shape instance
			var circle:Shape = new Shape( ); 
			// starting color filling
			circle.graphics.beginFill( 0xff9933 , 1 );
			// drawing circle 
			circle.graphics.drawCircle( 0 , 0 , 40 );
			// repositioning shape
			circle.x = 40;                                 
			circle.y = 40;
			
			// adding displayobject to the display list
			addChild( circle ); 
		}
	}
}