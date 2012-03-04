package
{
	import away3d.animators.PathAnimator;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.base.Geometry;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.entities.Sprite3D;
	import away3d.extrusions.utils.Path;
	import away3d.filters.BloomFilter3D;
	import away3d.filters.BlurFilter3D;
	import away3d.filters.DepthOfFieldFilter3D;
	import away3d.lights.DirectionalLight;
	import away3d.lights.LightBase;
	import away3d.lights.PointLight;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.materials.methods.FogMethod;
	import away3d.primitives.Cube;
	import away3d.primitives.Plane;
	import away3d.primitives.Sphere;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	//import flash.geom.Vector3D;
	//import CubeJB;
	//import away3d.materials.
	
	/**
	 * Cubes Stage3D Demo by Felix Turner - www.airtight.cc
	 */
	
	[SWF( backgroundColor='0x330000', frameRate='60', width='800', height='600')]
	public class viewpathtest extends Sprite
	{
		private var MATERIAL_COUNT:int = 30;
		private var CUBE_SIZE:int = 800;
		private var CUBE_INCREMENT:int = 1 //100;
		private var SPREAD:int = 0; //1000;
		
		private var view : View3D;
		private var cubes:Array = [];
		private var materials:Array = [];
		private var cubeHolder : ObjectContainer3D;
		private var rotSpeed:Number = .3;
		private var cubeCount:int = 0;
		private var windowHalfX:int;
		private var windowHalfY:int;
		private var mX:int = 0;
		private var mY:int = 0;
		private var infoText:TextField;
		private var geometry:Geometry;
		
		//gw
		[Embed(source="/../assets/djc_alpha.png")] private var EarthImage:Class;
		private var myBitmap:Bitmap = new EarthImage();
		[Embed(source="/../assets/clubgeneric_sq128.jpg")] private var ClubImage:Class;
		private var clubBitmap:Bitmap = new ClubImage();
		private var icube:Cube;
		private var ocube:Cube;
		private var tween:Number = 0.0;
		private var viewAnim:away3d.animators.PathAnimator = null;
		private var objAnim:away3d.animators.PathAnimator = null;
		private var light:PointLight = null;
		private var light2:PointLight = null;
		//gw
		
		public function viewpathtest()
		{
			super();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//init 3D world
			view = new View3D();
			view.camera.z = -1000;
			view.backgroundColor = 0xFF0000;
			
			addChild(view);
			view.addEventListener(Event.ADDED_TO_STAGE,onViewAdded);
			
			//init object to hold cubes and rotate
			cubeHolder = new ObjectContainer3D();
			view.scene.addChild(cubeHolder);
			
			cubeHolder.x = 0;
			cubeHolder.y = 0;
			cubeHolder.z = 0;
			
			//add info text
			infoText = new TextField();			
			infoText.autoSize = TextFieldAutoSize.LEFT;
			infoText.y = 5;
			infoText.filters = [new DropShadowFilter(2.5,90,0x000000,.3,3,3,.5,1)];
			var format:TextFormat = new TextFormat();
			format.font = "Helvetica,Arial,_sans";
			format.size = 16;
			format.color = 0xFFFFFF;
			infoText.defaultTextFormat = format;			
			addChild(infoText);
			
			//add lights
			this.light = new PointLight();
			this.light.position = new Vector3D(-1000,1000,-1000);
			this.light.color = 0xffeeaa;
			view.scene.addChild(this.light);
			
			this.light2 = new PointLight();
			this.light2.position = new Vector3D(1000,1000,1000);
			this.light2.color = 0xFFFFFF;
			view.scene.addChild(this.light2);
			
			//init materials
			for (var i:int = 0 ; i < MATERIAL_COUNT; i ++ )
			{
				var material : ColorMaterial = new ColorMaterial(Math.random()*0xFFFFFF,.5);
				material.blendMode = BlendMode.ADD;
				material.lights = [light,light2];
				materials.push(material);
			}
			
			//gw
			
			//	center cube...
			var myMaterial:BitmapMaterial = new BitmapMaterial(myBitmap.bitmapData);
			//init cubes
			geometry = new Cube(myMaterial, CUBE_SIZE,CUBE_SIZE,CUBE_SIZE).geometry;
			//geometry = new Cube(materials[0], CUBE_SIZE,CUBE_SIZE,CUBE_SIZE).geometry;
			
			this.icube = addInnerCube(3.0);
			this.ocube = addOuterCube(40.0);
			
		
			var vector:Vector.<Vector3D> = new Vector.<Vector3D>();
			vector[0] = new Vector3D(0, 0, -1000);
			vector[1] = new Vector3D(0, 0, -800);
			vector[2] = new Vector3D(0, 0, -800);		
			var p:Path = new Path( vector );
			this.viewAnim = new away3d.animators.PathAnimator( p, view.camera, null, true,null, null );
			
			var vector2:Vector.<Vector3D> = new Vector.<Vector3D>();
			vector2[0] = new Vector3D(0, 0, 0);
			vector2[1] = new Vector3D(50, 80, 0 );
			vector2[2] = new Vector3D(100, 100, 0);
			
			vector2[3] = new Vector3D(100, 100, 0);
			vector2[4] = new Vector3D(150, 80, 0 );
			vector2[5] = new Vector3D(200, 0, 0);
			
			//vector2[0] = new Vector3D(0, 0, 0);
			//vector2[1] = new Vector3D(1, 0, 0 );
			//vector2[2] = new Vector3D(1, 0, 1);
			
			var p2:Path = new Path( vector2 );
			this.objAnim = new away3d.animators.PathAnimator( p2, this.icube, null, true,null, null );
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
			stage.addEventListener(Event.RESIZE, onStageResize);
			onStageResize(null);
			
		}
		
		private function addInnerCube( sc:Number ):Cube 
		{
			cubeCount += CUBE_INCREMENT;
			
			//for (var j:int = 0 ; j < CUBE_INCREMENT; j ++ ){
			
			//gw
			var cubeMaterial:BitmapMaterial = new BitmapMaterial(myBitmap.bitmapData);
			cubeMaterial.alphaBlending = false;
			cubeMaterial.alphaThreshold = 1.0;
			cubeMaterial.bothSides = true;
			//cube = new Cube({material:cubeMaterial, width:75, height:75, depth:75, tile6:false});
			//cube = new CubeJB( cubeMaterial );
			
			var material : ColorMaterial = new ColorMaterial(Math.random()*0xFFFFFF,.5);
			material.blendMode = BlendMode.ADD;
			material.lights = [ this.light,this.light2];
			
			var cube:Cube = new Cube( cubeMaterial,100,100,100,1,1,1,false);
			
			//gw
			
			
			//gw
			//randomize size
			//cube.scaleX = cube.scaleY = cube.scaleZ = Math.random() + .1;
			cube.scaleX = cube.scaleY = cube.scaleZ = sc + .1;
			//gw
			
			cubeHolder.addChild(cube);
			cubes.push(cube);
			
			cube.x = 0; //Math.random()* SPREAD - SPREAD/2;
			cube.y = 0; //Math.random()* SPREAD - SPREAD/2;
			cube.z = 0; //Math.random()* SPREAD - SPREAD/2;
			
			//cube.rotationX = Math.random()*360 - 180;
			//cube.rotationY = Math.random()*360 - 180;
			//cube.rotationZ = Math.random()*360 - 180;
			
			//}
			
			//gw
			if (false)
			{
				//make more cubes less opaque
				for(var i:int = 0; i < MATERIAL_COUNT; i++) {
					materials[i].alpha = 50 / cubeCount;
				}
			}
			
			//gw
			//set info text
			//infoText.text = "Stage3D Cubes. Rendering " + cubeCount + " cubes. Press spacebar to increase.";
			//gw
			
			return cube;
		}
		
		
		private function addOuterCube( sc:Number ):Cube 
		{
			cubeCount += CUBE_INCREMENT;
			
			//for (var j:int = 0 ; j < CUBE_INCREMENT; j ++ ){
			
			//gw
			var cubeMaterial:BitmapMaterial = new BitmapMaterial(clubBitmap.bitmapData);
			cubeMaterial.alphaBlending = true;
			cubeMaterial.alphaThreshold = 0.5;
			cubeMaterial.bothSides = true;
			//cube = new Cube({material:cubeMaterial, width:75, height:75, depth:75, tile6:false});
			//cube = new CubeJB( cubeMaterial );
			var cube:Cube = new Cube( cubeMaterial,100,100,100,1,1,1,false);
			//gw
			
			if ( false )
			{
				//gw
				var myMaterial:BitmapMaterial = new BitmapMaterial(myBitmap.bitmapData);
				//var cube:Mesh = new Mesh(materials[j % MATERIAL_COUNT], geometry);
				var cube:Mesh = new Mesh( myMaterial, geometry);
				//gw
			}
			
			//gw
			//randomize size
			//cube.scaleX = cube.scaleY = cube.scaleZ = Math.random() + .1;
			cube.scaleX = cube.scaleY = cube.scaleZ = sc + .1;
			//gw
			
			cubeHolder.addChild(cube);
			cubes.push(cube);
			
			cube.x = 0; //Math.random()* SPREAD - SPREAD/2;
			cube.y = 0; //Math.random()* SPREAD - SPREAD/2;
			cube.z = 0; //Math.random()* SPREAD - SPREAD/2;
			
			//cube.rotationX = Math.random()*360 - 180;
			//cube.rotationY = Math.random()*360 - 180;
			//cube.rotationZ = Math.random()*360 - 180;
			
			//}
			
			//gw
			if (false)
			{
				//make more cubes less opaque
				for(var i:int = 0; i < MATERIAL_COUNT; i++) {
					materials[i].alpha = 50 / cubeCount;
				}
			}
			
			//gw
			//set info text
			//infoText.text = "Stage3D Cubes. Rendering " + cubeCount + " cubes. Press spacebar to increase.";
			//gw
			
			return cube;
		}
		private function onKeyDown(event:KeyboardEvent):void {
			if(event.keyCode == 32) {
				
				tween = 0.0;
				//pathAnim.s
				//tween = tween + 0.05;
				//if (tween>1.0) tween=0.0;
				//this.objAnim.updateProgress(tween);
				
				//pathAnim.updateProgress(tween);
				
				//addCubes(3.0);
			}
		}
		
		private function onMouseMove(event:MouseEvent):void {
			mX = mouseX - windowHalfX;
			mY = mouseY - windowHalfY;
		}
		
		private function onStageResize(event : Event) : void{
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
			
			windowHalfX = stage.stageWidth/2;
			windowHalfY = stage.stageHeight/2;
			
			//center info text
			infoText.x = (stage.stageWidth - infoText.textWidth)/2
		}
		
		private function onViewAdded(event : Event) : void{
			//improve performance by disabling error checking
			view.stage3DProxy.context3D.enableErrorChecking = false
		}
		
		private function onEnterFrame(ev : Event) : void{
			
			//gw
			//view.camera.x += (mX - view.camera.position.x) * 0.1;
			//view.camera.y += (-mY - view.camera.position.y) * 0.1;
			//gw
			//always look at center
			view.camera.lookAt(cubeHolder.position);
			
			/*
			cubeHolder.rotationY += rotSpeed;
			for (var i:int = 0 ; i < cubeCount; i ++ )
			{
			cubes[i].rotationX += rotSpeed;
			}
			*/
			
			//this.icube.rotationY += rotSpeed;
			//this.icube.z += 1;
			
			//this.ocube.rotationY += rotSpeed;
			//this.icube.rotationY += rotSpeed;
			
			//this.icube.z += 1;
			
			if ( tween>=0.0 ) tween += 0.01;
			if ( tween>1.0) tween = 0.0;
			
			this.objAnim.updateProgress(tween);
			
			view.render();
			
		}
	}
}