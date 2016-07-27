package zgd.google.flatbuffers
{
	import flash.utils.ByteArray;

	/**
	 * 
	 * @author zhangguodong
	 * 
	 */	
	public class Table
	{
		/**
		 * 
		 */		
		protected var bb_pos:int;
		
		/**
		 * 
		 */		
		protected var bb:ByteBuffer;
		
		
		public function Table()
		{
		}
		
		/**
		 * 获取实际的vtable offset
		 * @param vtable_offset
		 * @return 
		 */		
		protected function __offset(vtable_offset:int):int
		{
			var vtable:int = bb_pos - bb.getInt(bb_pos);
			if(vtable_offset < bb.getShort(vtable))
			{
				return bb.getShort(vtable + vtable_offset);
			}
			return 0;
		}
		
		/**
		 * 获取间接偏移地址
		 * @param offset
		 * @return 
		 */		
		protected function __indirect(offset:int):int
		{
			return offset + bb.getInt(offset);
		}
		
		/**
		 * 获取UTF8字符串
		 * @param offset
		 * @return 
		 */		
		protected function __string(offset:int):String
		{
			offset += bb.getInt(offset);
			var len:int = bb.getInt(offset);
			var startPos:int = offset + Constants.SIZEOF_INT;
			return bb.getString(startPos, len);
		}
		
		/**
		 * 获取向量长度(非字节数)
		 * @param offset
		 * @return 
		 */		
		protected function __vector_len(offset:int):int
		{
			offset += bb_pos;
			offset += bb.getInt(offset);
			return bb.getInt(offset);
		}
		
		/**
		 * 获取向量的地址位置
		 * @param offset
		 * @return 
		 */		
		protected function __vector(offset:int):int
		{
			offset += bb_pos;
			return offset + bb.getInt(offset) + Constants.SIZEOF_INT;
		}
		
		protected function __vector_as_bytes(vector_offset:int, elem_size:int=1):ByteArray
		{
			var o:int = __offset(vector_offset);
			if(o==0)
			{
				return null;
			}
			var vec_pos:int = __vector(o);
			var vec_len:int = __vector_len(o);
			
			return bb.getBytes(vec_pos, vec_len * elem_size);
		}
		
		/**
		 * 
		 * @param table
		 * @param offset
		 */		
		protected function __union(table:Table, offset:int):Table
		{
			offset += bb_pos;
			table.bb_pos = offset + bb.getInt(offset);
			table.bb = bb;
			return table;
		}
		
		protected static function __has_identifier(bb:ByteBuffer, ident:String):Boolean
		{
			if(ident.length != Constants.FILE_IDENTIFIER_LENGTH)
			{
				throw new Error("FlatBuffers: file identifier must be length " + Constants::FILE_IDENTIFIER_LENGTH);
			}
			
			for(var i:int=0; i<4; ++i)
			{
				if(ident.charCodeAt(i) != bb.get(bb.getPosition() + Constants.SIZEOF_INT + i))
				{
					return false;
				}
			}
			return true;
		}
		
		
		
		
		
	}
}