﻿/*The MIT LicenseCopyright (c) 2009 P.J. Onori (pj@somerandomdude.com)Permission is hereby granted, free of charge, to any person obtaining a copyof this software and associated documentation files (the "Software"), to dealin the Software without restriction, including without limitation the rightsto use, copy, modify, merge, publish, distribute, sublicense, and/or sellcopies of the Software, and to permit persons to whom the Software isfurnished to do so, subject to the following conditions:The above copyright notice and this permission notice shall be included inall copies or substantial portions of the Software.THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS ORIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THEAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHERLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS INTHE SOFTWARE.*/  /** * * * @author      P.J. Onori * @version     0.1 * @description * @url  */package com.somerandomdude.coordy.layouts.twodee {	import com.somerandomdude.coordy.constants.LayoutType;	import com.somerandomdude.coordy.constants.PathAlignType;	import com.somerandomdude.coordy.constants.WaveFunction;	import com.somerandomdude.coordy.nodes.INode;	import com.somerandomdude.coordy.nodes.twodee.INode2d;	import com.somerandomdude.coordy.nodes.twodee.Node2d;	import flash.display.DisplayObject;	import flash.display.DisplayObjectContainer;	public class Wave extends Layout2d implements ILayout2d	{		private static const PI:Number=Math.PI;				private var _frequency:Number;		private var _waveFunction:String;		private var _function:Function=Math.sin;		private var _heightMultiplier:Number=0;				private var _alignType:String;		private var _alignAngleOffset:Number;		/**		 * The additional angle offset of each node from it's original path-aligned angle (in degrees)		 * @return Angle in degrees		 * 		 */				public function get alignAngleOffset():Number { return this._alignAngleOffset; }		public function set alignAngleOffset(value:Number):void		{			this._alignAngleOffset=value;			this._updateFunction();		}				/**		 * The type of path alignment each node executes (parallel or perpendicular)		 * 		 * @see com.somerandomdude.coordy.layouts.PathAlignType		 * 		 * @return String value of the path alignment type		 * 		 */			public function get alignType():String { return this._alignType; }		public function set alignType(value:String):void		{			this._alignType=value;			this._updateFunction();		}		/**		 * Mutator/accessor for waveFunction property		 *		 * @return	Wave function in string form   		 */		public function get waveFunction():String { return _waveFunction; }		public function set waveFunction(value:String):void		{			switch(value)			{				case WaveFunction.SINE:					_waveFunction=value;					_function=Math.sin;					break;				case WaveFunction.COSINE:					_waveFunction=value;					_function=Math.cos;					break;				case WaveFunction.TAN:					_waveFunction=value;					_function=Math.tan;					break;				case WaveFunction.ARCSINE:					_waveFunction=value;					_function=Math.asin;					break;				case WaveFunction.ARCCOSINE:					_waveFunction=value;					_function=Math.acos;					break;				case WaveFunction.ARCTAN:					_waveFunction=value;					_function=Math.atan;					break;				default:					_waveFunction=WaveFunction.SINE;					_function=Math.sin;			}			this._updateFunction();		}		/**		 * Accessor for frequency property		 *		 * @return	Frequency of wave   		 */		public function get frequency():Number { return _frequency; }		public function set frequency(value:Number):void		{			this._frequency=value;			this._updateFunction();		}				/**		 * Accessor for heightMultiplier property		 *		 * @return	HeightMultipler of wave   		 */		public function get heightMultiplier():Number { return _heightMultiplier; }		public function set heightMultiplier(value:Number):void		{			this._heightMultiplier=value;			this._updateFunction();		}				/**		 * Distributes nodes in a wave.		 * 		 * @param width				Width (i.e. length) of the wave		 * @param height			Height of the wave		 * @param x					x position of the wave		 * @param y					y position of the wave		 * @param frequency			Frequency of the wave		 * @param waveFunction		Wave type (sin,cos,tan,etc.)		 * @param jitterX			Jitter multiplier for the layout's nodes on the x axis		 * @param jitterY			Jitter multiplier for the layout's nodes on the y axis		 * @param alignType			Method in which nodes align to the path of the wave		 * @param alignOffset		The additional offset angle of each node's path alignment		 * 		 */				public function Wave(width:Number, 							height:Number, 							x:Number=0, 							y:Number=0, 							frequency:Number=1, 							waveFunction:String=WaveFunction.SINE, 							jitterX:Number=0, 							jitterY:Number=0, 							alignType:String=PathAlignType.ALIGN_PERPENDICULAR, 							alignOffset:Number=0):void		{			this._width=width;			this._height=height;			this._x=x;			this._y=y;			this._jitterX=jitterX;			this._jitterY=jitterY;			this._frequency=frequency;			this.waveFunction=waveFunction;			this._alignType=alignType;			this._alignAngleOffset=alignOffset;		}				/**		 * Returns the type of layout in a string format		 * 		 * @see com.somerandomdude.coordy.layouts.LayoutType		 * @return Layout's type		 * 		 */		override public function toString():String { return LayoutType.WAVE; }				/**		 * Adds object to layout in next available position		 *		 * @param  object  Object to add to layout		 * @param  moveToCoordinates  automatically move DisplayObject to corresponding node's coordinates		 * 		 * @return newly created node object containing a link to the object		 */		override public function addToLayout(object:Object,  moveToCoordinates:Boolean=true):INode		{			if(!validateObject(object)) throw new Error('Object does not implement at least one of the following properties: "x", "y", "rotation"');			if(linkExists(object)) return null;			var node:Node2d = new Node2d(object,0,0,((Math.random()>.5)?-1:1)*Math.random(),((Math.random()>.5)?-1:1)*Math.random());			this.addNode(node as INode);						this.update();						if(moveToCoordinates) this.render();						return node;		}				/**		* Clones the current object's properties (does not include links to DisplayObjects)		* 		* @return Wave clone of object		*/		override public function clone():ILayout2d		{			return new Wave(_width, _height, _x, _y, _frequency, _waveFunction, _jitterX, _jitterY, _alignType, _alignAngleOffset);		}				/**		 * Applies all layout property values to all cells/display objects in the collection		 *		 */		override public function render():void		{			var c:Node2d;			for(var i:int=0; i<this._size; i++)			{				c=this._nodes[i];				c.link.x=c.x;				c.link.y=c.y;				c.link.rotation=(this._alignType==PathAlignType.NONE)?0:c.rotation;			}		}				/**		 * Updates the nodes' virtual coordinates. <strong>Note</strong> - this method does not update		 * the actual objects linked to the layout.		 * 		 */			override public function update():void		{						var len:int = this._size;			var c:Node2d;			for(var i:int=0; i<len; i++)			{				c = this._nodes[i];				c.x = (i*(this._width/len))+_x+(c.jitterX*this._jitterX);				c.y = (_function(PI*(i+1)/(len/2)*_frequency)*((this._height+(_heightMultiplier*i))/2))+_y+(c.jitterY*this._jitterY);								//in future, add option to align wave to center or top by adding height/2 to all nodes' y property								if(_function==Math.sin) c.rotation = Math.cos(PI*(i+1)/(len/2)*_frequency)*180/PI;				else if(_function==Math.cos) c.rotation = Math.sin(PI*(i+1)/(len/2)*_frequency)*180/PI;				else c.rotation = 0;												if(this._alignType==PathAlignType.ALIGN_PERPENDICULAR) c.rotation+=90; 				c.rotation+=this._alignAngleOffset;			}		}		}}