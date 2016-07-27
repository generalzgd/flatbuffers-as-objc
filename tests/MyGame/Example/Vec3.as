/**
 * 
 * Powered by Zhangguodong 
 * 
 */

// automatically generated by the FlatBuffers compiler, do not modify

package MyGame.Example
{

	import zgd.google.flatbuffers.*;
	import flash.utils.ByteArray;


	public class Vec3 extends Struct
	{
		/**
		 * @param int i offset
		 * @param ByteBuffer bb
		 * @return Vec3
		 */
		public function init(i:int, bb:ByteBuffer):Vec3
		{
			this.bb_pos = i;
			this.bb = bb;
			return this;
		}

		/**
		 * @return Number
		 */
		public function getX():Number
		{
			return this.bb.getFloat(this.bb_pos + 0);
		}

		/**
		 * @return Number
		 */
		public function getY():Number
		{
			return this.bb.getFloat(this.bb_pos + 4);
		}

		/**
		 * @return Number
		 */
		public function getZ():Number
		{
			return this.bb.getFloat(this.bb_pos + 8);
		}

		/**
		 * @return Number
		 */
		public function getTest1():Number
		{
			return this.bb.getDouble(this.bb_pos + 16);
		}

		/**
		 * @return int
		 */
		public function getTest2():int
		{
			return this.bb.getSbyte(this.bb_pos + 24);
		}

		/**
		 * @return Test
		 */
		public function getTest3():Test
		{
			var obj:Test = new Test();
			obj.init(this.bb_pos + 26, this.bb);
			return obj;
		}


		/**
		 * @return int offset
		 */
		public static function createVec3(builder:FlatBufferBuilder, 
										x:Number, 
										y:Number, 
										z:Number, 
										test1:Number, 
										test2:int, 
										test3_a:int, 
										test3_b:int):int
		{
			builder.prep(16, 32);
			builder.pad(2);
			builder.prep(2, 4);
			builder.pad(1);
			builder.putSbyte(test3_b);
			builder.putShort(test3_a);
			builder.pad(1);
			builder.putSbyte(test2);
			builder.putDouble(test1);
			builder.pad(4);
			builder.putFloat(z);
			builder.putFloat(y);
			builder.putFloat(x);
			return builder.offset();
	}


}