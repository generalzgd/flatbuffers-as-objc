package zgd.google.flatbuffers
{
	import flash.sensors.Accelerometer;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * 
	 * @author zhangguodong
	 * 
	 */	
	public class ByteBuffer
	{
		/**
		 * 
		 */		
		public var _buffer:ByteArray;
		
		/**
		 * 
		 */		
		private var _pos:int;
		
		/**
		 * 默认小段
		 */		
		private static var _is_little_endian:Boolean = true;
		private static var _endian_checked:Boolean = false;
		
		/**
		 * 将字节数据包装为ByteBuffer
		 * @param bytes:ByteArray
		 * @return ByteBuffer
		 */		
		public static function wrap(bytes:ByteArray):ByteBuffer
		{
			bytes.endian = Endian.LITTLE_ENDIAN;
			
			var bb:ByteBuffer = new ByteBuffer(0);
			bb._buffer = bytes;
			return bb;
		}
		
		public function ByteBuffer(size:int = 1024)
		{
			if(!_buffer)
			{
				_buffer = new ByteArray();
				_buffer.endian = Endian.LITTLE_ENDIAN;
			}
			else
				_buffer.clear();
			_buffer.length = size;
		}
		
		/**
		 * 容量
		 * @return 
		 */		
		public function capacity():int
		{
			return _buffer.length;
		}
		
		public function getPosition():int
		{
			return _pos;
		}
		
		public function setPosition(pos:int):void
		{
			_pos = pos;
		}
		
		public function reset():void
		{
			_pos = 0;
		}
		
		public function length():int
		{
			return _buffer.length;
		}
		
		/**
		 * 返回对应的数据
		 * @return 
		 */		
		public function data():ByteArray
		{
			var out:ByteArray = new ByteArray();
			out.endian = _buffer.endian;
			_buffer.readBytes(out, _pos, _buffer.length - _pos);
			return out;
		}
		
		/**
		 * 始终使用小端
		 * @return 
		 */		
		public static function isLittleEndian():Boolean
		{
			/*if(!ByteBuffer._endian_checked)
			{
				var byte:ByteArray = new ByteArray();
				byte.writeShort(0x0001);
				if(byte[1] == 1)
				{
					ByteBuffer._is_little_endian = false;
				}
				else
				{
					ByteBuffer._is_little_endian = true;
				}
				ByteBuffer._endian_checked = true;
			}*/
			return ByteBuffer._is_little_endian;
		}
		
		/**
		 * 
		 * @param offset 开始写入的位置
		 * @param data 要写入的数据
		 */		
		public function putBytes(offset:int, data:ByteArray):void
		{
			var length:int = data.length;
			assertOffsetAndLength(offset, length);
			
			_buffer.position = offset;
			_buffer.writeBytes(data, 0, length);
		}
		
		/**
		 * 
		 * @param offset 开始读取的位置
		 * @param length 要读取的长度
		 * @return 
		 */		
		public function getBytes(index:int, length:int):ByteArray
		{
			assertOffsetAndLength(index, length);
			
			var out:ByteArray = new ByteArray();
			out.endian = _buffer.endian;
			
			_buffer.position = index;
			_buffer.readBytes(out, 0, length);
			
			return out;
		}
		
		/**
		 * 
		 * @param offset
		 * @param length
		 */		
		public function assertOffsetAndLength(offset:int, length:int):void
		{
			if(offset<0 || offset>=_buffer.length || offset+length>_buffer.length)
			{
				throw new Error("offset: "+offset+", length: "+length+", buffer: " + _buffer.length);
			}
		}
		
		public function putBool(offset:int, value:Boolean):void
		{
			assertOffsetAndLength(offset, 1);
			
			_buffer[offset] = value?1:0;
		}
		
		/**
		 * -128~127
		 * @param offset
		 * @param value
		 */		
		public function putSbyte(offset:int, value:int):void
		{
			ByteBuffer.validateValue(-128, 127, value, "sbyte");
			
			assertOffsetAndLength(offset, 1);
			
			_buffer[offset] = value;
		}
		
		/**
		 * -128~127
		 * @param offset
		 * @param value
		 */		
		public function putByte(offset:int, value:int):void
		{
			ByteBuffer.validateValue(-128, 127, value, "ubyte");
			
			assertOffsetAndLength(offset, 1);
			
			_buffer[offset] = value;
		}
		
		/**
		 * 0~255
		 * @param offset
		 * @param value
		 */		
		public function putUbyte(offset:int, value:int):void
		{
			ByteBuffer.validateValue(0, 255, value, "ubyte");
			
			assertOffsetAndLength(offset, 1);
			
			_buffer[offset] = value;
		}
		
		public function put(offset:int, value:ByteArray):void
		{
			value.endian = _buffer.endian;
			var len:int = value.length;
			assertOffsetAndLength(offset, len);
			for(var i:int=0; i<len; ++i)
			{
				_buffer[offset + i] = value[i];
			}
		}
		
		public function putShort(offset:int, value:int):void
		{
			ByteBuffer.validateValue(-32768, 32767, value, "short");
			
			assertOffsetAndLength(offset, 2);
			
			_buffer.position = offset;
			_buffer.writeShort(value);
		}
		
		/**
		 * 
		 * @param offset
		 * @param value
		 */		
		public function putUshort(offset:int, value:int):void
		{
			ByteBuffer.validateValue(0, 65535, value, "short");
			
			assertOffsetAndLength(offset, 2);
			
			_buffer.position = offset;
			//_buffer.writeShort(value);
			
			var l:int = value&0xFF;
			var h:int = (value&0xFF00)>>8;
			if(_is_little_endian)
			{
				_buffer[offset] = l;
				_buffer[offset+1] = h;
			}
			else
			{
				_buffer[offset] = h;
				_buffer[offset+1] = l;
			}
		}
		
		public function putInt(offset:int, value:int):void
		{
			ByteBuffer.validateValue(-2147483648, 2147483647, value, "int");
			
			assertOffsetAndLength(offset, 4);
			
			_buffer.position = offset;
			_buffer.writeInt(value);
		}
		
		public function putUint(offset:int, value:uint):void
		{
			ByteBuffer.validateValue(0, 4294967295, value, "uint");
			
			assertOffsetAndLength(offset, 4);
			
			_buffer.position = offset;
			_buffer.writeUnsignedInt(value);
		}
		
		public function putLong(offset:int, value:Number):void
		{
			ByteBuffer.validateValue(-1<<63, 1<<63-1, value, "long");
			
			assertOffsetAndLength(offset, 8);
			
			_buffer.position = offset;
			_buffer.writeDouble(value);
		}
		
		public function putUlong(offset:int, value:Number):void
		{
			ByteBuffer.validateValue(0, 1<<64-1, value, "ulong");
			
			assertOffsetAndLength(offset, 8);
			
			_buffer.position = offset;
			_buffer.writeDouble(value);
		}
		
		public function putFloat(offset:int, value:Number):void
		{
			assertOffsetAndLength(offset, 4);
			
			_buffer.position = offset;
			_buffer.writeFloat(value);
		}
		
		public function putDouble(offset:int, value:Number):void
		{
			assertOffsetAndLength(offset, 8);
			
			_buffer.position = offset;
			_buffer.writeDouble(value);
		}
		
		/**
		 * 
		 * @param offset
		 * @param length
		 * @param value
		 * 
		 */		
		public function putString(offset:int, length:int, value:String):void
		{
			assertOffsetAndLength(offset, length);
			
			_buffer.position = offset;
			_buffer.writeMultiByte(value, "utf-8");
		}
		
		public function getUbyte(index:int):int
		{
			_buffer.position = index;
			return _buffer.readUnsignedByte();
		}
		
		public function getByte(index:int):int
		{
			_buffer.position = index;
			return _buffer.readByte();
		}
		
		public function getSbyte(index:int):int
		{
			_buffer.position = index;
			return _buffer.readByte();
		}
		
		public function getX():ByteArray
		{
			var out:ByteArray = new ByteArray();
			out.endian = _buffer.endian;
			_buffer.position = _pos;
			_buffer.readBytes(out, 0, 0);
			return out;
		}
		
		public function get(index:int):*
		{
			assertOffsetAndLength(index, 1);
			return _buffer[index];
		}
		
		public function getBool(index:int):Boolean
		{
			assertOffsetAndLength(index, 1);
			return Boolean(_buffer[index]);
		}
		
		public function getShort(index:int):int
		{
			assertOffsetAndLength(index, 2);
			_buffer.position = index;
			return _buffer.readShort();
		}
		
		public function getUshort(index:int):int
		{
			assertOffsetAndLength(index, 2);
			_buffer.position = index;
			return _buffer.readUnsignedShort();
		}
		
		public function getInt(index:int):int
		{
			assertOffsetAndLength(index, 4);
			_buffer.position = index;
			return _buffer.readInt();
		}
		
		public function getUint(index:int):uint
		{
			assertOffsetAndLength(index, 4);
			_buffer.position = index;
			return _buffer.readUnsignedInt();
		}
		
		public function getLong(index:int):Number
		{
			assertOffsetAndLength(index, 8);
			_buffer.position = index;
			return _buffer.readDouble();
		}
		
		public function getUlong(index:int):Number
		{
			assertOffsetAndLength(index, 8);
			_buffer.position = index;
			return _buffer.readDouble();
		}
		
		public function getFloat(index:int):Number
		{
			assertOffsetAndLength(index, 4);
			_buffer.position = index;
			return _buffer.readFloat();
		}
		
		public function getDouble(index:int):Number
		{
			assertOffsetAndLength(index, 8);
			_buffer.position = index;
			return _buffer.readDouble();
		}
		
		public function getString(index:int, length:int):String
		{
			assertOffsetAndLength(index, length);
			_buffer.position = index;
			return _buffer.readMultiByte(length, "utf-8");
		}
		
		private static function validateValue(min:Number, max:Number, value:Number, type:String):void
		{
			if(!(min <= value && value <= max))
			{
				throw new Error("bad number "+value+" for type "+type+".");
			}
		}
		
	}
}