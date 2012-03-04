package 
{
	
	import org.aswing.*;
	import org.aswing.border.*;
	import org.aswing.geom.*;
	import org.aswing.colorchooser.*;
	import org.aswing.ext.*;
	
	/**
	 * MyPane
	 */
	public class aswing2 extends JPanel{
		
		//members define
		private var textfield9:JTextField;
		private var label3:JLabel;
		private var panel6:JPanel;
		private var checkbox4:JCheckBox;
		
		/**
		 * MyPane Constructor
		 */
		public function aswing2(){
			//component creation
			setSize(new IntDimension(731, 505));
			var border0:LineBorder = new LineBorder();
			border0.setColor(new ASColor(0x0, 1));
			setBorder(border0);
			var layout1:BorderLayout = new BorderLayout();
			setLayout(layout1);
			
			textfield9 = new JTextField();
			textfield9.setLocation(new IntPoint(1, 483));
			textfield9.setSize(new IntDimension(729, 21));
			textfield9.setConstraints("South");
			textfield9.setText("text");
			textfield9.setHtmlText("http://www.google.com");
			textfield9.setEditable(true);
			
			label3 = new JLabel();
			label3.setLocation(new IntPoint(6, 6));
			label3.setSize(new IntDimension(308, 503));
			label3.setText("stuff");
			label3.setSelectable(true);
			label3.setHorizontalAlignment(AsWingConstants.CENTER);
			label3.setVerticalAlignment(AsWingConstants.CENTER);
			label3.setHorizontalTextPosition(AsWingConstants.CENTER);
			
			panel6 = new JPanel();
			panel6.setFont(new ASFont("Times New Roman Bold", 9, false, false, false, false));
			panel6.setForeground(new ASColor(0x3333ff, 1));
			panel6.setBackground(new ASColor(0xff00, 1));
			panel6.setLocation(new IntPoint(37, 9));
			panel6.setSize(new IntDimension(10, 10));
			
			checkbox4 = new JCheckBox();
			checkbox4.setLocation(new IntPoint(37, 6));
			checkbox4.setSize(new IntDimension(41, 17));
			checkbox4.setText("label");
			
			//component layoution
			append(textfield9);
			append(label3);
			append(panel6);
			append(checkbox4);
			
		}
		
		//_________getters_________
		
		public function getTextfield9():JTextField{
			return textfield9;
		}
		
		
		
		public function getCheckbox4():JCheckBox{
			return checkbox4;
		}
		
		
	}
}
