package {
	import away3d.arcane;
	import away3d.cameras.Camera3D;
	import away3d.cameras.HoverCamera3D;
	import away3d.cameras.lenses.*;
	import away3d.containers.*;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.base.*;
	import away3d.core.base.Object3D;
	import away3d.core.clip.*;
	import away3d.core.draw.*;
	import away3d.core.render.Renderer;
	import away3d.core.utils.*;
	import away3d.events.*;
	import away3d.events.MouseEvent3D;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.MovieMaterial;
	import away3d.materials.VideoMaterial;
	import away3d.materials.WireColorMaterial;
	import away3d.materials.WireframeMaterial;
	import away3d.primitives.LineSegment;
	import away3d.primitives.Plane;
	import away3d.primitives.Sphere;
	
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.geom.*;
	import flash.utils.*;
	
	[SWF(backgroundColor="#FF0000")]
	
	public class mixed extends Sprite {
		
		private var videoURL:String = "http://www.tartiflop.com/away3d/FirstSteps/AmIWrong.flv";
		
		//[Embed(source="/../assets/DrawTool.swf")]
		[Embed(source="/../assets/aswingtest.swf")]
		private var DrawToolEmbedded:Class;
		
		private var scene:Scene3D;
		//private var camera:HoverCamera3D;
		private var camera:Camera3D;
		private var view:View3D;
		
		private var planeGroup:ObjectContainer3D;
		
		private var doRotation:Boolean = true;
		
		private var b:Bitmap = null; //new Bitmap( bd );
		private var t:aswing2 = null;
		
		[Embed(source="/../assets/djc_alpha.png")] private var EarthImage:Class;
		private var myBitmap:Bitmap = new EarthImage();
		private var cubeMaterial:BitmapMaterial = null;
		
		private var group:ObjectContainer3D;
		private var sphere:Sphere;
		
		public function mixed() {
			
			//var t:test = new test();
			//t.bringToTop();
			//addChild(t);
			
			t = new aswing2();
			//t.bringToTop();
			addChild(t);		
			//t.setLocationXY( 50,50 );
			//var w:int = t.getWidth();
			//var h:int = t.getHeight();
			
			var bd:BitmapData = new BitmapData(100,100, false, 0x0000FF);
			b = new Bitmap( bd );
			//b.x = 498;
			//b.y = 269;
			//addChild(b);
			
			//gw
			cubeMaterial = new BitmapMaterial( myBitmap.bitmapData);
			
			//cubeMaterial.alpha = 0.5;
			//cubeMaterial.alphaBlending = true;
			//cubeMaterial.alphaThreshold = 0.5;
			//cubeMaterial.bothSides = true;
			
			// set up the stage
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// Add resize event listener
			stage.addEventListener(Event.RESIZE, onResize);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			
			// Initialise Away3D
			init3D();
			
			// Create the 3D objects
			createScene();
			
			// Initialise frame-enter loop
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		/**
		 * Initialise all 3D components.
		 */
		private function init3D():void {
			
			// Create a new scene where all the 3D object will be rendered
			scene = new Scene3D();
			
			// Create a new camera, passing some initialisation parameters
			//camera = new HoverCamera3D({zoom:25, focus:30, distance:200});
			//camera.yfactor = 1;
			
			
			//camera = new Camera3D({zoom:15, focus:30, x:100, y:300, z:-200});
			//camera.lookAt( new Vector3D(0, 0, 0), null); //   new Number3D(0, 0, 0));
			
			camera = new Camera3D({zoom:15, focus:30, x:0, y:0, z:-200}); //z:-200});
			
			// Create a new view that encapsulates the scene and the camera
			view = new View3D({scene:scene, camera:camera});
			
			// center the view to the middle of the stage
			var w:int = stage.stageWidth;
			var h:int = stage.stageHeight;
			
			view.x = stage.stageWidth / 2;
			view.y = stage.stageHeight / 2;
			
			// ensure that the z-order is calculated correctly
			//view.renderer = Renderer.CORRECT_Z_ORDER;
			
			addChild(view);
		}
		
		/**
		 * Create the objects of the scene
		 */
		private function createScene():void {
			
			// Video material using a flash streaming video URL
			var frontMaterial:VideoMaterial = new VideoMaterial({file:videoURL});
			
			// Movie material from an embedded flash animation
			var topMaterial:MovieMaterial = new MovieMaterial(new DrawToolEmbedded(), {lockW:731, lockH:505, interactive:true, smooth:false, precision:5});
			
			// Movie material from another class
			//var leftMaterial:MovieMaterial = new MovieMaterial(new Pong(), {smooth:true, precision:5});
			
			// Create three planes with different material, blurred by default
			// and position them them to create tree sides of a cube
			var frontPlane:Plane = new Plane( {material:cubeMaterial, width:100, height:100, segmentsW:2, segmentsH:2, ownCanvas:true});
			frontPlane.yUp = false;
			frontPlane.z = -50;
			var frontPlaneB:Plane = new Plane( {material:frontPlane.material, width:100, height:100, segmentsW:2, segmentsH:2, ownCanvas:true});
			frontPlaneB.yUp = false;
			frontPlaneB.z = -49;
			frontPlaneB.invertFaces();
	
			var rightPlane:Plane = new Plane({material:cubeMaterial, width:100, height:100, segmentsW:2, segmentsH:2, ownCanvas:true});
			rightPlane.yUp = false;
			rightPlane.x = 50;
			rightPlane.rotationY = -90.0;
			var rightPlaneB:Plane = new Plane({material:rightPlane.material, width:100, height:100, segmentsW:2, segmentsH:2, ownCanvas:true});
			rightPlaneB.yUp = false;
			rightPlaneB.x = 50;
			rightPlaneB.rotationY = -90.0;
			rightPlaneB.invertFaces();
			
			var leftPlane:Plane = new Plane({material:cubeMaterial, width:100, height:100, segmentsW:2, segmentsH:2, ownCanvas:true});
			leftPlane.yUp = false;
			leftPlane.rotationY = 90;
			leftPlane.x = -50;
			var leftPlaneB:Plane = new Plane({material:leftPlane.material, width:100, height:100, segmentsW:2, segmentsH:2, ownCanvas:true});
			leftPlaneB.yUp = false;
			leftPlaneB.rotationY = 90;
			leftPlaneB.x = -50;
			leftPlaneB.invertFaces();
			
			// Create three planes with different material, blurred by default
			// and position them them to create tree sides of a cube
			var backPlane:Plane = new Plane( {material:topMaterial, width:100, height:100, segmentsW:2, segmentsH:2, ownCanvas:true});
			backPlane.yUp = false;
			backPlane.z = 50;
			backPlane.rotationY = 180;
			var backPlaneB:Plane = new Plane( {material:backPlane.material, width:100, height:100, segmentsW:2, segmentsH:2, ownCanvas:true});
			backPlaneB.yUp = false;
			backPlaneB.z = 50;
			backPlaneB.rotationY = 180;
			backPlaneB.invertFaces();
			
			// Create an object container to group the sides of the cube
			planeGroup = new ObjectContainer3D();
			scene.addChild(planeGroup);
			
			planeGroup.addChild(rightPlane);
			planeGroup.addChild(rightPlaneB);
			
			planeGroup.addChild(leftPlane);
			planeGroup.addChild(leftPlaneB);
			
			planeGroup.addChild(frontPlane);
			planeGroup.addChild(frontPlaneB);
			
			planeGroup.addChild(backPlane);
			planeGroup.addChild(backPlaneB);
			
			// Add mouse listeners to each plane for mouse down, over and out events
			//topPlane.addOnMouseDown(onMouseClickOnObject);
			//leftPlane.addOnMouseDown(onMouseClickOnObject);
			//frontPlane.addOnMouseDown(onMouseClickOnObject);
			//topPlane.addOnMouseOver(onMouseOverObject);
			//leftPlane.addOnMouseOver(onMouseOverObject);
			//frontPlane.addOnMouseOver(onMouseOverObject);
			//topPlane.addOnMouseOut(onMouseLeavesObject);
			//leftPlane.addOnMouseOut(onMouseLeavesObject);
			//frontPlane.addOnMouseOut(onMouseLeavesObject);
			
			group = new ObjectContainer3D();
			scene.addChild(group);
			
			// Create a new sphere object using a wirecolor material
			var sphereMaterial:WireColorMaterial = new WireColorMaterial(0x5500FF, {wirecolor:0xFF9900});
			sphere = new Sphere({material:sphereMaterial, radius:50, segmentsW:10, segmentsH:10});
			
			// Position the sphere and add it to the group
			sphere.x = 0;
			//group.addChild(sphere);
		}
		
		
		
		/**
		 * Frame-enter event handler
		 */
		private function loop(event:Event):void {
			
			// update camera position
			updateCamera();
			//camera.hover();
			
			//planeGroup. -= 0.5;
			
			// Render the 3D scene
			view.render();
			
			
		}
		
		/**
		 * Update the camera position from mouse positions
		 */
		private function updateCamera():void {
			
			
			// center the view to the middle of the stage
			var w:int = stage.stageWidth;
			var h:int = stage.stageHeight;
			
			if (doRotation) {
				//camera.targetpanangle =  (stage.stageWidth - stage.mouseX) / stage.stageWidth * 90;
				//camera.targettiltangle = (stage.stageHeight - stage.mouseY) / stage.stageHeight * 70
			}
		}
		
		private function runOnce(event:TimerEvent):void 
		{
			//trace("runOnce() called @ " + getTimer() + " ms");
			trace("yo!");
			
			planeGroup.visible = false;
			b.visible = true;
			t.visible = true;
		}
		
		private function onKeyDown(event:KeyboardEvent):void 
		{
			var myTimer:Timer = new Timer(2000,1); // 2 second
			myTimer.addEventListener( TimerEvent.TIMER_COMPLETE, runOnce );
			myTimer.start();
			b.visible = false;
			t.visible = false;
			planeGroup.visible = true;
			
			Tweener.addTween( camera, {z:-170, time:1, transition:"linear"});
			Tweener.addTween( camera, {z:-110, time:1, delay:1, transition:"linear"});
			
			var k:uint = event.keyCode;
			if(event.keyCode == 48) 
			{
				Tweener.addTween( planeGroup, {rotationY:90, time:2, transition:"linear"});
			}
			else if(event.keyCode == 49) 
			{
				Tweener.addTween( planeGroup, {rotationY:180, time:2, transition:"linear"});
			}
			else if(event.keyCode == 50) 
			{
				Tweener.addTween( planeGroup, {rotationY:-90, time:2, transition:"linear"});
			}
			else if(event.keyCode == 51) 
			{
				Tweener.addTween( planeGroup, {rotationY:180, time:2, transition:"linear"});
			}
			
			else if(event.keyCode == 32) 
			{
				Tweener.addTween( planeGroup, {rotationY:90, time:1, transition:"linear"});
				/*
				var myTimer:Timer = new Timer(2000, 1); // 1 second
				myTimer.addEventListener( TimerEvent.TIMER_COMPLETE, runOnce );
				myTimer.start();
				b.visible = true;
				t.visible = true;
				planeGroup.visible = false;
				*/
			}
		}
		
		/**
		 * Event listener for mouse click on plane. Makes the camera look
		 * directly at the plane and move closer to it.
		 */
		private function onMouseClickOnObject(event:MouseEvent3D):void {
			var object:Object3D = event.object;
			
			var myTimer:Timer = new Timer(2000, 1); // 1 second
			myTimer.addEventListener( TimerEvent.TIMER_COMPLETE, runOnce );
			myTimer.start();
			b.visible = true;
			t.visible = true;
			planeGroup.visible = false;
			
			doRotation = false;
			
			// Calculate angles necessary for camera     
			var theta:Number = Math.atan2(object.x, object.z);
			var len:Number = Math.sqrt(object.x*object.x + object.z*object.z);
			var phi:Number = Math.atan2(object.y, len);
			
			// rotate camera position
			//camera.targetpanangle = theta * 180 / Math.PI;
			//camera.targettiltangle = phi * 180 / Math.PI;
			
			// move camera towards plane
			//Tweener.addTween(camera, {distance:150, time:0.5, transition:"easeOutSine"});
		}    
		
		/**
		 * Event listener for mouse over plane. Removes the blur filter.
		 */   
		private function onMouseOverObject(event:MouseEvent3D):void {
			//var object:Object3D = event.object;
			
			//object.filters = new Array();
		}   
		
		/**
		 * Event listener for mouse out of plane. Adds blur filter and moves
		 * camera away from plane if it isn't already.
		 */
		private function onMouseLeavesObject(event:MouseEvent3D):void {
			var object:Object3D = event.object;
			
			//object.filters.push(new BlurFilter(8, 8));
			//Tweener.addTween(camera, {distance:200, time:0.5, transition:"easeOutSine"});
			//doRotation = true;
		}
		
		/**
		 * Resize the scene when the stage resizes
		 */ 
		private function onResize(event:Event):void {
			
			
			// center the view to the middle of the stage
			var w:int = stage.stageWidth;
			var h:int = stage.stageHeight;
			
			// relocate the 2d page
			var x:int = w/2 - b.width/2;
			var y:int = h/2 - b.height/2;
			b.x = x;
			b.y = y;
			
			x = w/2 - t.width/2;
			y = h/2 - t.height/2;
			t.x = x;
			t.y = y;
			
			//b.z = 300;
			
			
			view.x = stage.stageWidth / 2;
			view.y = stage.stageHeight / 2;
		}
		
	}
	
}