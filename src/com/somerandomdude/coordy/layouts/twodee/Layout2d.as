﻿ /*The MIT LicenseCopyright (c) 2009 P.J. Onori (pj@somerandomdude.com)Permission is hereby granted, free of charge, to any person obtaining a copyof this software and associated documentation files (the "Software"), to dealin the Software without restriction, including without limitation the rightsto use, copy, modify, merge, publish, distribute, sublicense, and/or sellcopies of the Software, and to permit persons to whom the Software isfurnished to do so, subject to the following conditions:The above copyright notice and this permission notice shall be included inall copies or substantial portions of the Software.THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS ORIMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THEAUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHERLIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS INTHE SOFTWARE.*/  /** * * * @author      P.J. Onori * @version     0.1 * @description * @url  */package com.somerandomdude.coordy.layouts.twodee {
	import com.somerandomdude.coordy.constants.LayoutUpdateMethod;	import com.somerandomdude.coordy.layouts.Layout;	import com.somerandomdude.coordy.nodes.INode;	import com.somerandomdude.coordy.nodes.twodee.INode2d;	import com.somerandomdude.coordy.proxyupdaters.IProxyUpdater;		import flash.display.DisplayObject;	import flash.display.DisplayObjectContainer;	import flash.events.Event;	public class Layout2d extends Layout implements ILayout2d	{		protected var _x:Number;		protected var _y:Number;		protected var _width:Number;		protected var _height:Number;		protected var _rotation:Number=0;		protected var _jitterX:Number;		protected var _jitterY:Number;				protected var _updateMethod:String=LayoutUpdateMethod.UPDATE_AND_RENDER;		protected var _updateFunction:Function=updateAndRender;				protected var _proxyUpdater:IProxyUpdater;				/**		 * Sets a proxy update method for altering layouts as opposed to internal update methods		 * such as update(), render() or updateAndRender()		 * 		 * This allows more customization for the updating sequence.		 * 		 * @see com.somerandomdude.coordy.proxyupdaters.IProxyUpdater		 * @see #updateMethod		 * 		 */		public function get proxyUpdater():IProxyUpdater { return _proxyUpdater; }		public function set proxyUpdater(value:IProxyUpdater):void		{			this._updateMethod=value.name;			this._updateFunction=value.update;		}				/**		 * Specifies whether layout properties (x, y, width, height, etc.) adjust the layout 		 * automatically without calling apply() method.		 * 		 * An alternative method for updating layouts is to define a proxy updater using 		 * the proxyUpdater property 		 * 		 * @see com.somerandomdude.coordy.layouts.LayoutUpdateMethod		 * @see #proxyUpdater		 * 		 * @return  Current setting of auto-adjust (defaults to false)   		 */		public function get updateMethod():String { return this._updateMethod; }		public function set updateMethod(value:String):void 		{ 			this._updateMethod = value; 			switch(value)			{				case LayoutUpdateMethod.NONE:					this._updateFunction=function():void {};					break;				case LayoutUpdateMethod.UPDATE_ONLY:					this._updateFunction=update;					break;				default :					this._updateFunction=updateAndRender;			}		}				/**		 * Mutator/accessor for rotation property		 * 		 * @return Global rotation position of layout		 * 		 */				public function get rotation():Number { return this._rotation; }		public function set rotation(value:Number):void		{			this._rotation=value;			this._updateFunction();		}				/**		 * Mutator/accessor for layout x property		 *		 * @return	X position of layout   		 */		public function get x():Number { return this._x; }		public function set x(value:Number):void		{			this._x=value;			this._updateFunction();		}				/**		 * Mutator/accessor for layout y property		 *		 * @return	Y position of layout   		 */		public function get y():Number { return this._y; }		public function set y(value:Number):void		{			this._y=value;			this._updateFunction();		}				/**		 * Mutator/accessor for layout width property		 *		 * @return	Width of layout   		 */		public function get width():Number { return this._width; }		public function set width(value:Number):void		{			this._width=value;			this._updateFunction();		}				/**		 * Mutator/accessor for layout height property		 *		 * @return	Height position of layout   		 */		public function get height():Number { return this._height; }		public function set height(value:Number):void		{			this._height=value;			this._updateFunction();		}				/**		 * Mutator/accessor for the jitterX property. This value then mulitplied by each node's 		 * corresponding jitterX multiplier value to get its jitter offset.		 * 		 * @return Global x-axis jitter base value 		 * 		 */				public function get jitterX():Number { return this._jitterX; }		public function set jitterX(value:Number):void		{			this._jitterX=value;			this._updateFunction();		}				/**		 * Mutator/accessor for the jitterY property. This value then mulitplied by each node's 		 * corresponding jitterY multiplier value to get its jitter offset.		 *  		 * @return Global y-axis jitter base value 		 * 		 */				public function get jitterY():Number { return this._jitterY; }		public function set jitterY(value:Number):void		{			this._jitterY=value;			this._updateFunction();		}				/**		 * Core class for all 2D layouts. Cannot be instantiated as is - use child classes.		 * 		 * @param  target  The object to contain all items managed by LayoutOrganizer		 */		public function Layout2d():void		{					}			/**		 * Adds object to layout in next available position. <strong>Note</strong> - This method is to be 		 * overridden by child classes for implmentation.		 *		 * @param  object  Object to add to organizer		 * @param  moveToCoordinates  automatically move DisplayObject to corresponding cell's coordinates		 * 		 * @return newly created node object containing a link to the object		 */					override public function addToLayout(object:Object,  moveToCoordinates:Boolean=true):INode		{			throw(new Error('Method must be overriden by child class'));			return null;		}				/**		 * Removes specified cell and its link from layout organizer and adjusts layout appropriately		 *		 * @param  cell  cell object to remove		 */		override public function removeNode(node:INode):void		{			super.removeNode(node);			this._updateFunction();		}				/**		 * Performs an update on all the nodes' positions and renders each node's corresponding link		 * 		 */			public function updateAndRender():void		{			this.update();			this.render();		}				/**		 * Updates the nodes virtual coordinates. <strong>Note</strong> - this method does not update		 * the actual objects linked to the layout.		 * 		 */				public function update():void {}				/**		 * Renders all layout property values to all objects in the collection		 *		 */		public function render():void		{			var n:INode2d;			for(var i:int=0; i<_size; i++)			{				n = this._nodes[i];				if(!n.link) continue;				n.link.x=n.x, n.link.y=n.y;			}		}				/**		* Clones the current object's properties (does not include links to DisplayObjects)		* 		* @return Wave3d clone of object		*/		public function clone():ILayout2d		{			throw(new Error('Method must be overriden by child class'));			return null;		}				/**		 * Renders all layout property values of a specified node		 * @param node		 * 		 */				public function renderNode(node:INode2d):void		{			node.link.x=node.x, node.link.y=node.y;		}				/**		 * Determines if an object added to the layout contains the properties/methods 		 * required from the layout.		 *		 * @see #addToLayout()		 */		protected function validateObject(object:Object):Boolean		{			if(	object.hasOwnProperty('x')&&				object.hasOwnProperty('y')&&				object.hasOwnProperty('rotation')			) return true;						return false;		}	}}