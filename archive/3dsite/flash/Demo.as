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

	
	// ------------------------------------------------------------------------------------------------
	// Embedded asssets
	//[Embed(source='assets/page_01a.jpg')]
	//private var page1aAsset:Class;
	// ------------------------------------------------------------------------------------------------
	// Var ini
	private var scene:Scene3D;
	private var camera:Camera3D;
	private var view:View3D;
	private var renderer:BasicRenderer;
	
	
	private var cubeArray:Array;
	private var pa:PathAnimator;
	private var paths:Array;
	private var p:Path;
	
	private var p1:Path;
	private var p2:Path;
	private var p3:Path;
	private var p4:Path;
	
	private var c1:Cube;
	private var c2:Cube;
	private var c3:Cube;
	private var c4:Cube;
	
	private var pa1:PathAnimator;
	private var pa2:PathAnimator;
	private var pa3:PathAnimator;
	private var pa4:PathAnimator;
	
	private var t1:Number = 0;
	private var t2:Number = 0;
	private var t3:Number = 0;
	private var t4:Number = 0;
	// ------------------------------------------------------------------------------------------------
	
	// ------------------------------------------------------------------------------------------------
	public function init():void
	{
		// Setup Away3D
		camera = new Camera3D();
		renderer = new BasicRenderer();
		
		scene = new Scene3D();
		view = new View3D();
		view.scene = scene;
		view.camera = camera;
		view.renderer = renderer;
		view.x = stage.stageWidth / 2;
		view.y = stage.stageHeight / 2;
		
		//var clipping:FrustumClipping = new FrustumClipping();
		//view.clipping = clipping;
		//view.renderer = Renderer.CORRECT_Z_ORDER;
		
		// Setup away3d stats (appears to slow the cpu)
		var awaystats:AwayStats = new AwayStats(view);
		away3dstatsContainer.addChild(awaystats);
		
		var tr:Trident = new Trident(500,true);
		scene.addChild(tr);
		
		// Setup camera
		camera.z = -2000;
		camera.y = 1000;
		camera.lookAt( new Vector3D(0,0,0) );
		
		// Add Away3D to its container UIComponent
		away3dContainer.addChild(view);
		
		// Resize handler
		this.addEventListener(Event.RESIZE,handleBrowserResize);
		handleBrowserResize();
		
		// Enter frame handler (make things move)
		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		
		// generate
		generateScene();
	}
	// ------------------------------------------------------------------------------------------------
	
	// ------------------------------------------------------------------------------------------------
	private function generateScene():void
	{
		//http://away3d.com/livedocs/726/away3d/animators/PathAnimator.html
		
		// Cube references holder
		cubeArray = new Array();
		
		// Floor
		var floor:Plane = new Plane();
		floor.material = new WireframeMaterial();
		floor.segmentsW = floor.segmentsH = 10;
		floor.width = 20000;
		floor.height = 20000;
		floor.y = -1900;
		scene.addChild(floor);
		
		
		// Path vectors
		var paths:Array = new Array();
		paths.push(   new Vector3D(0,0,0)  );
		paths.push(   new Vector3D(1250,250,1250)  );
		paths.push(   new Vector3D(1500,500,1500)  );
		
		paths.push(   new Vector3D(1500,500,1500)  );
		paths.push(   new Vector3D(1500,750,1500)  );
		paths.push(   new Vector3D(0,750,1500)  );
		
		paths.push(   new Vector3D(0,750,1500)  );
		paths.push(   new Vector3D(-1250,250,1750)  );
		paths.push(   new Vector3D(0,0,0)  );
		
		
		// Paths (done 4 if you wanted unique)
		p1 = new Path(paths);
		p2 = new Path(paths);
		p3 = new Path(paths);
		p4 = new Path(paths);
		
		// Init objects (needs unique 1 per pathAnimator or it bugs)
		var nFPS:Number = 15;
		var init1:Object = {	
			targetobject:null, aligntopath:true,
			targetobject:null, offset:new Vector3D(0,0,0),
			rotations:null, fps:nFPS
		};
		
		var init2:Object = {	
			targetobject:null, aligntopath:true,
			targetobject:null, offset:new Vector3D(0,0,0),
			rotations:null, fps:nFPS
		};
		
		var init3:Object = {	
			targetobject:null, aligntopath:true,
			targetobject:null, offset:new Vector3D(0,0,0),
			rotations:null, fps:nFPS
		};
		
		var init4:Object = {	
			targetobject:null, aligntopath:true,
			targetobject:null, offset:new Vector3D(0,0,0),
			rotations:null, fps:nFPS
		};
		
		// Setup 4 cubes and their path animators (for unique adjust p1 to p4 instead of p1 all the way through)
		c1 = new Cube({segmentsW:1,segmentsH:1,segmentsD:1,width:50,height:50,depth:50,material:new WireColorMaterial(),ownCanvas:true,alpha:0.5});
		scene.addChild(c1);
		pa1 = new PathAnimator(p1, c1, init1)
		
		c2 = new Cube({segmentsW:1,segmentsH:1,segmentsD:1,width:50,height:50,depth:50,material:new WireColorMaterial(),ownCanvas:true,alpha:0.5});
		scene.addChild(c2);
		pa2 = new PathAnimator(p1, c2, init2)
		
		c3 = new Cube({segmentsW:1,segmentsH:1,segmentsD:1,width:50,height:50,depth:50,material:new WireColorMaterial(),ownCanvas:true,alpha:0.5});
		scene.addChild(c3);
		pa3 = new PathAnimator(p1, c3, init3);
		
		c4 = new Cube({segmentsW:1,segmentsH:1,segmentsD:1,width:50,height:50,depth:50,material:new WireColorMaterial(),ownCanvas:true,alpha:0.5});
		scene.addChild(c4);
		pa4 = new PathAnimator(p1, c4, init4);
		
		
		// Time steppers
		var nTimeInc:Number = 0.006;
		t1 = 0.1 + (0 * nTimeInc);
		t2 = 0.1 + (1 * nTimeInc);
		t3 = 0.1 + (2 * nTimeInc);
		t4 = 0.1 + (3 * nTimeInc);
	}
	// ------------------------------------------------------------------------------------------------
	// ------------------------------------------------------------------------------------------------
	private function onEnterFrame(event:Event):void
	{
		// Time increment on each timer for each path animator
		t1 = (t1 +0.001>1)? 0 : t1+0.001;
		t2 = (t2 +0.001>1)? 0 : t2+0.001;
		t3 = (t3 +0.001>1)? 0 : t3+0.001;
		t4 = (t4 +0.001>1)? 0 : t4+0.001;
		
		pa1.update(t1);
		pa2.update(t2);
		pa3.update(t3);
		pa4.update(t4);
		
		// Ensure each cube looks at the next 1 (bar lead)
		c1.lookAt( c4.position );
		c2.lookAt( c4.position );
		c3.lookAt( c4.position );
		
		// Camera positioning
		var campos:Vector3D = c1.position;
		campos.y += 50;
		camera.position = campos;
		camera.lookAt( c4.position );
		
		// Render
		view.render();
	}
	// ------------------------------------------------------------------------------------------------
	
	
	
	
	// ------------------------------------------------------------------------------------------------
	// Browser resize handler (simply adjust view3d center x:0 y:0 at browser 1/2 width and height to keep things in the middle
	private function handleBrowserResize(e:Event=null):void
	{
		this.view.x = stage.stageWidth/2;
		this.view.y = stage.stageHeight/2;
	}
	// ------------------------------------------------------------------------------------------------
	
}