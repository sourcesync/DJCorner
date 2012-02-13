package
{
	
	import org.aswing.*;
	import org.aswing.border.*;
	import org.aswing.geom.*;
	import org.aswing.colorchooser.*;
	import org.aswing.ext.*;
	
	/**
	 * MyPane2
	 */
	public class test extends JPanel{
		
		//members define
		private var button4:JButton;
		private var label5:JLabel;
		
		/**
		 * MyPane2 Constructor
		 */
		public function test(){
			//component creation
			setSize(new IntDimension(400, 400));
			
			button4 = new JButton();
			button4.setLocation(new IntPoint(5, 5));
			button4.setSize(new IntDimension(35, 25));
			button4.setText("label");
			
			label5 = new JLabel();
			label5.setLocation(new IntPoint(45, 8));
			label5.setSize(new IntDimension(29, 18));
			label5.setText("label");
			
			//component layoution
			append(button4);
			append(label5);
			
		}
		
		//_________getters_________
		
		public function getButton4():JButton{
			return button4;
		}
		
		
		
	}
}
