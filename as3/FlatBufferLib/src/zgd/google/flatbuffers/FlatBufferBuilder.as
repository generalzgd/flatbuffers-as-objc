package zgd.google.flatbuffers
{
	import flash.utils.ByteArray;

	/**
	 * 
	 * @author zhangguodong
	 * 
	 */	
	public class FlatBufferBuilder
	{
		/**
		 * 内部数据
		 */		
		public var bb:ByteBuffer;
		
		/**
		 * 空间大小
		 */		
		protected var space:int;
		
		/**
		 * 最小对齐字节数
		 */		
		protected var minalign:int = 1;
		
		/**
		 * 虚拟表
		 */		
		protected var vtable:Array;
		
		/**
		 * 实际使用虚拟表
		 */		
		protected var vtable_in_use:int = 0;
		
		/**
		 * 
		 */		
		protected var _nested:Boolean = false;
		
		/**
		 * 
		 */		
		protected var object_start:int;
		
		/**
		 * 
		 */		
		protected var vtables:Array = [];
		
		/**
		 * 
		 */		
		protected var num_vtables:int = 0;
		
		/**
		 * 
		 */		
		protected var vector_num_elems:int = 0;
		
		/**
		 * 强制写入默认值
		 */		
		protected var force_defaults:Boolean = false;
		
		
		public function FlatBufferBuilder(initial_size:int = 1024)
		{
			if(initial_size <= 0)
				initial_size = 1;
			
			space = initial_size;
			bb = new ByteBuffer(initial_size);
		}
		
		private function newByteBuffer(size:int):ByteBuffer
		{
			return new ByteBuffer(size);
		}
		
		/**
		 * 当前的偏移位置
		 * @return 
		 */		
		public function offset():int
		{
			return bb.capacity() - space;
		}
		
		/**
		 * 填充数据
		 * @param byteSize：要填充个数
		 * @return 
		 */		
		public function pad(byteSize:int):void
		{
			for(var i:int=0; i<byteSize; ++i)
			{
				bb.putByte(--space, 0);
			}
		}
		
		/**
		 * 准备
		 * @param size
		 * @param additional_bytes
		 */		
		public function prep(size:int, additional_bytes:int):void
		{
			if(size > this.minalign)
				this.minalign = size;
			
			var align_size:int = ((~(this.bb.capacity() - this.space + additional_bytes)) + 1) & (size - 1);
			
			while(this.space < align_size + size + additional_bytes)
			{
				var old_buf_size:int = this.bb.capacity();
				this.bb = growByteBuffer(this.bb);
				this.space += this.bb.capacity() - old_buf_size;
			}
			
			this.pad(align_size);
		}
		
		private static function growByteBuffer(bb:ByteBuffer):ByteBuffer
		{
			var old_buf_size:int = bb.capacity();
			if((old_buf_size & 0xC0000000) != 0)
			{
				throw new Error("FlatBuffers: cannot grow buffer beyond 2 gigabytes");
			}
			
			var new_buf_size:int = old_buf_size << 1;
			
			bb.setPosition(0);
			
			var nbb:ByteBuffer = new ByteBuffer(new_buf_size);
			nbb.setPosition(new_buf_size - old_buf_size);
			
			for(var i:int = new_buf_size-old_buf_size, j:int=0; j<bb._buffer.length; ++i, ++j)
			{
				nbb._buffer[i] = bb._buffer[j];
			}
			return nbb;
		}
		
		public function putBool(x:Boolean):void
		{
			bb.putBool(space -= Constants.SIZEOF_BYTE, x);
		}
		
		public function putSbyte(x:int):void
		{
			bb.putSbyte(space-=Constants.SIZEOF_BYTE, x);
		}
		
		public function putByte(x:int):void
		{
			bb.putByte(space-=Constants.SIZEOF_BYTE, x);
		}
		
		public function putUbyte(x:int):void
		{
			bb.putUbyte(space-=Constants.SIZEOF_BYTE, x);
		}
		
		public function putShort(x:int):void
		{
			bb.putShort(space-=Constants.SIZEOF_SHORT, x);
		}
		
		public function putUshort(x:int):void
		{
			bb.putUshort(space-=Constants.SIZEOF_SHORT, x);
		}
		
		public function putInt(x:int):void
		{
			bb.putInt(space-=Constants.SIZEOF_INT, x);
		}
		
		public function putUint(x:uint):void
		{
			bb.putUint(space-=Constants.SIZEOF_INT, x);
		}
		
		public function putLong(x:Number):void
		{
			bb.putLong(space-=Constants.SIZEOF_LONG, x);
		}
		
		public function putUlong(x:Number):void
		{
			bb.putUlong(space-=Constants.SIZEOF_LONG, x);
		}
		
		public function putFloat(x:Number):void
		{
			bb.putFloat(space-=Constants.SIZEOF_FLOAT, x);
		}
		
		public function putDouble(x:Number):void
		{
			bb.putDouble(space-=Constants.SIZEOF_DOUBLE, x);
		}
		
		public function addBool(x:Boolean):void
		{
			prep(Constants.SIZEOF_BYTE, 0);
			putBool(x);
		}
		
		public function addByte(x:int):void
		{
			prep(Constants.SIZEOF_BYTE, 0);
			putByte(x);
		}
		
		public function addSbyte(x:int):void
		{
			prep(Constants.SIZEOF_BYTE, 0);
			putSbyte(x);
		}
		
		public function addUbyte(x:int):void
		{
			prep(Constants.SIZEOF_BYTE, 0);
			putUbyte(x);
		}
		
		public function addShort(x:int):void
		{
			prep(Constants.SIZEOF_SHORT, 0);
			putShort(x);
		}
		
		public function addUshort(x:int):void
		{
			prep(Constants.SIZEOF_SHORT, 0);
			putUshort(x);
		}
		
		public function addInt(x:int):void
		{
			prep(Constants.SIZEOF_INT, 0);
			putInt(x);
		}
		
		public function addUint(x:uint):void
		{
			prep(Constants.SIZEOF_INT, 0);
			putUint(x);
		}
		
		public function addLong(x:Number):void
		{
			prep(Constants.SIZEOF_LONG, 0);
			putLong(x);
		}
		
		public function addUlong(x:Number):void
		{
			prep(Constants.SIZEOF_LONG, 0);
			putUlong(x);
		}
		
		public function addFloat(x:Number):void
		{
			prep(Constants.SIZEOF_FLOAT, 0);
			putFloat(x);
		}
		
		public function addDouble(x:Number):void
		{
			prep(Constants.SIZEOF_DOUBLE, 0);
			putDouble(x);
		}
		
		/**
		 * Add a `boolean` to a table at `o` into its vtable, with value `x` and default `d`.
	     * @param o The index into the vtable.
	     * @param x A `boolean` to put into the buffer, depending on how defaults are handled. If
	     * `force_defaults` is `false`, compare `x` against the default value `d`. If `x` contains the
	     * default value, it can be skipped.
	     * @param d A `boolean` default value to compare against when `force_defaults` is `false`.		 */		
		public function addBoolX(o:int, x:Boolean, d:Boolean):void
		{
			if(force_defaults || x != d)
			{
				addBool(x);
				slot(o);
			}
		}
		
		/**
		 * Add a `byte` to a table at `o` into its vtable, with value `x` and default `d`.
	     * @param o The index into the vtable.
	     * @param x A `byte` to put into the buffer, depending on how defaults are handled. If
	     * `force_defaults` is `false`, compare `x` against the default value `d`. If `x` contains the
	     * default value, it can be skipped.
	     * @param d A `byte` default value to compare against when `force_defaults` is `false`.
		 */		
		public function addByteX(o:int, x:int, d:int):void
		{
			if(force_defaults || x != d)
			{
				addByte(x);
				slot(o);
			}
		}
		
		public function addSbyteX(o:int, x:int, d:int):void
		{
			if(force_defaults || x != d)
			{
				addSbyte(x);
				slot(o);
			}
		}
		
		public function addUbyteX(o:int, x:int, d:int):void
		{
			if(force_defaults || x != d)
			{
				addUbyte(x);
				slot(o);
			}
		}
		
		/**
		 * Add a `short` to a table at `o` into its vtable, with value `x` and default `d`.
	     * @param o The index into the vtable.
	     * @param x A `short` to put into the buffer, depending on how defaults are handled. If
	     * `force_defaults` is `false`, compare `x` against the default value `d`. If `x` contains the
	     * default value, it can be skipped.
	     * @param d A `short` default value to compare against when `force_defaults` is `false`.
		 */		
		public function addShortX(o:int, x:int, d:int):void
		{
			if(force_defaults || x != d)
			{
				addShort(x);
				slot(o);
			}
		}
		
		public function addUshortX(o:int, x:int, d:int):void
		{
			if(force_defaults || x != d)
			{
				addUshort(x);
				slot(o);
			}
		}
		
		/**
		 * Add an `int` to a table at `o` into its vtable, with value `x` and default `d`.
	     * @param o The index into the vtable.
	     * @param x An `int` to put into the buffer, depending on how defaults are handled. If
	     * `force_defaults` is `false`, compare `x` against the default value `d`. If `x` contains the
	     * default value, it can be skipped.
	     * @param d An `int` default value to compare against when `force_defaults` is `false`.
		 */		
		public function addIntX(o:int, x:int, d:int):void
		{
			if(force_defaults || x != d)
			{
				addInt(x);
				slot(o);
			}
		}
		
		public function addUintX(o:int, x:int, d:int):void
		{
			if(force_defaults || x != d)
			{
				addUint(x);
				slot(o);
			}
		}
		
		/**
		 * Add a `long` to a table at `o` into its vtable, with value `x` and default `d`.
	     * @param o The index into the vtable.
	     * @param x A `long` to put into the buffer, depending on how defaults are handled. If
	     * `force_defaults` is `false`, compare `x` against the default value `d`. If `x` contains the
	     * default value, it can be skipped.
	     * @param d A `long` default value to compare against when `force_defaults` is `false`.
		 */		
		public function addLongX(o:int, x:Number, d:Number):void
		{
			if(force_defaults || x != d)
			{
				addLong(x);
				slot(o);
			}
		}
		
		public function addUlongX(o:int, x:Number, d:Number):void
		{
			if(force_defaults || x != d)
			{
				addUlong(x);
				slot(o);
			}
		}
		
		/**
		 * Add a `float` to a table at `o` into its vtable, with value `x` and default `d`.
		 * @param o The index into the vtable.
		 * @param x A `float` to put into the buffer, depending on how defaults are handled. If
		 * `force_defaults` is `false`, compare `x` against the default value `d`. If `x` contains the
		 * default value, it can be skipped.
		 * @param d A `float` default value to compare against when `force_defaults` is `false`.
		 */
		public function addFloatX(o:int, x:Number, d:Number):void
		{
			if(force_defaults || x != d)
			{
				addFloat(x);
				slot(o);
			}
		}
		
		/**
		 * Add a `double` to a table at `o` into its vtable, with value `x` and default `d`.
		 *
		 * @param o The index into the vtable.
		 * @param x A `double` to put into the buffer, depending on how defaults are handled. If
		 * `force_defaults` is `false`, compare `x` against the default value `d`. If `x` contains the
		 * default value, it can be skipped.
		 * @param d A `double` default value to compare against when `force_defaults` is `false`.
		 */
		public function addDoubleX(o:int, x:Number, d:Number):void
		{
			if(force_defaults || x != d)
			{
				addDouble(x);
				slot(o);
			}
		}
		
		/**
		 * Add an `offset` to a table at `o` into its vtable, with value `x` and default `d`.
		 *
		 * @param o The index into the vtable.
		 * @param x An `offset` to put into the buffer, depending on how defaults are handled. If
		 * `force_defaults` is `false`, compare `x` against the default value `d`. If `x` contains the
		 * default value, it can be skipped.
		 * @param d An `offset` default value to compare against when `force_defaults` is `false`.
		 */
		public function addOffsetX(o:int, x:int, d:int):void
		{
			if(force_defaults || x != d)
			{
				addOffset(x);
				slot(o);
			}
		}
		
		/**
		 * Adds on offset, relative to where it will be written.
		 * @param off The offset to add to the buffer.
		 * Throws an exception if `$off` is greater than the underlying ByteBuffer's offest.
		 */		
		public function addOffset(off:int):void
		{
			//确保已经对齐
			prep(Constants.SIZEOF_INT, 0);
			
			if(off > this.offset())
			{
				throw new Error();	
			}
			off = offset() - off + Constants.SIZEOF_INT;
			putInt(off);
		}
		
		public function startVector(elem_size:int, num_elems:int, alignment:int):void
		{
			notNested();
			vector_num_elems = num_elems;
			prep(Constants.SIZEOF_INT, elem_size * num_elems);
			prep(alignment, elem_size * num_elems);
			_nested = true;
		}
		
		/**
		 * Finish off the creation of an array and all its elements.  The array
    	 * must be created with {@link #startVector(int, int, int)}.
		 * @return The Vector position 
		 */		
		public function endVector():int
		{
			_nested = false;
			putUint(vector_num_elems);
			return offset();
		}
		
		protected function is_utf8(bytes:ByteArray):Boolean
		{
			var len:int = bytes.length;
			if(len<1)
				return true;
			
			for(var j:int=0, i:int=0; i<len; ++i)
			{
				// check ACII
				if(bytes[j] == 0x09 || bytes[j] == 0x0A || bytes[j] == 0x0D || (bytes[j] >= 0x20 && bytes[j] <= 0x7E))
				{
					j++;
					continue;
				}
				/* non-overlong 2-byte */
				if(((i+1) <= len) && (bytes[j] >= 0xC2 && bytes[j] <= 0xDF && (bytes[j+1] >= 0x80 && bytes[j+1] <= 0xBF)))
				{
					j += 2;
					i++;
					continue;
				}
				/* excluding overlongs */
				if(((i + 2) <= len) && bytes[j] == 0xE0 && (bytes[j+1]>=0xA0 && bytes[j+1]<=0xBF && (bytes[j+2]>=0x80 && bytes[j+2] <= 0xBF)))
				{
					j += 3;
//					bytes += 3;//?????????????????????
					i += 2;
					continue;
				}
				/* straight 3-byte */
				if(((i+2)<=len) && ((bytes[j]>=0xE1 && bytes[j]<=0xEC) || bytes[j]==0xEE || bytes[j]==0xEF) && (bytes[j+1]>=0x80 && bytes[j+1]<=0xBF) && (bytes[j+2]>=0x80 && bytes[j+2]<=0xBF))
				{
					j += 3;
					i += 2;
					continue;
				}
				/* excluding surrogates */
				if(((i+2)<=len) && bytes[j]==0xED && (bytes[j+1]>=0x80 && bytes[j+1]<=0x9F && (bytes[j+2]>=0x80 && bytes[j+2]<=0xBF)))
				{
					j += 3;
					i += 2;
					continue;
				}
				/* planes 1-3 */
				if(((i+3)<=len) && bytes[j]==0xF0 && (bytes[j+1]>=0x90 && bytes[j+1]<=0xBF) && (bytes[j+2]>=0x80 && bytes[j+2]<=0xBF) && (bytes[j+3]>=0x80 && bytes[j+3]<=0xBF))
				{
					j += 4;
					i += 3;
					continue;
				}
				/* planes 4-15 */
				if(((i+3)<=len) && bytes[j]>=0xF1 && bytes[j]<=0xF3 && bytes[j+1]>=0x80 && bytes[j+1]<=0xBF && bytes[j+2]>=0x80 && bytes[j+2]<=0xBF && bytes[j+3]>=0x80 && bytes[j+3]<=0xBF)
				{
					j += 4;
					i += 3;
					continue;
				}
				/* plane 16 */
				if(((i+3)<=len) && bytes[j]==0xF4 && (bytes[j+1]>=0x80 && bytes[j+1]<=0xBF) && (bytes[j+2]>=0x80 && bytes[j+2]<=0xBF) && (bytes[j+3]>=0x80 && bytes[j+3]<=0xBF))
				{
					j += 4;
//					bytes += 4;//??????????????????????????
					i += 3;
					continue;
				}
				return false;
			}
			return true;
		}
		
		/**
		 * 
		 * @param s
		 * @return offset
		 */		
		public function createString(s:String):int
		{
			//if(!s)return 0;
			notNested();
			
			//need to check utf8 string???  Flash's String is already utf8 code
			var sb:ByteArray = new ByteArray();
			sb.writeMultiByte(s, "utf-8");
//			if(!is_utf8(sb))
//				throw new Error("string must be utf-8 encoded value.");
			
			addByte(0);
			startVector(1, sb.length, 1);
			space -= sb.length;
			for(var i:int=space, j:int=0; j<sb.length; ++i, ++j)
			{
				bb._buffer[i] = sb[j];
			}
			return endVector();
		}
		
		public function createByteVector(byte:ByteArray):int
		{
			if(!byte)return 0;
			notNested()
			
			var len:uint = byte.length;
			startVector(1, length, 1);
			space -= len;
			bb.putBytes(space, byte);
			return endVector();
		}
		
		/*public function createVector(elem_size:int, data:Array):int
		{
			startVector(elem_size, data.length, minalign);
			for(var i:int=0; i<data.length;++i)
			{
				
			}
		}*/
		
		public function notNested():void
		{
			if(_nested)
			{
				throw new Error("FlatBuffers; object serialization must not be nested");
			}
		}
			
		public function nestedObj(obj:int):void
		{
			if(obj != offset())
			{
				throw new Error("FlatBuffers: struct must be serialized inline");
			}
		}
		
		/**
		 * Start encoding a new object in the buffer.  Users will not usually need to
	    * call this directly. The `FlatBuffers` compiler will generate helper methods
	    * that call this method internally.
	    * <p>
	    * For example, using the "Monster" code found on the "landing page". An
	    * object of type `Monster` can be created using the following code:
	    *
	    * <pre>{@code
	    * int testArrayOfString = Monster.createTestarrayofstringVector(fbb, new int[] {
	    *   fbb.createString("test1"),
	    *   fbb.createString("test2")
	    * });
	    *
	    * Monster.startMonster(fbb);
	    * Monster.addPos(fbb, Vec3.createVec3(fbb, 1.0f, 2.0f, 3.0f, 3.0,
	    *   Color.Green, (short)5, (byte)6));
	    * Monster.addHp(fbb, (short)80);
	    * Monster.addName(fbb, str);
	    * Monster.addInventory(fbb, inv);
	    * Monster.addTestType(fbb, (byte)Any.Monster);
	    * Monster.addTest(fbb, mon2);
	    * Monster.addTest4(fbb, test4);
	    * Monster.addTestarrayofstring(fbb, testArrayOfString);
	    * int mon = Monster.endMonster(fbb);
	    * }</pre>
	    * <p>
	    * Here:
	    * <ul>
	    * <li>The call to `Monster#startMonster(FlatBufferBuilder)` will call this
	    * method with the right number of fields set.</li>
	    * <li>`Monster#endMonster(FlatBufferBuilder)` will ensure {@link #endObject()} is called.</li>
	    * </ul>
	    * <p>
	    * It's not recommended to call this method directly.  If it's called manually, you must ensure
	    * to audit all calls to it whenever fields are added or removed from your schema.  This is
	    * automatically done by the code generated by the `FlatBuffers` compiler.
	    *
	    * @param numfields The number of fields found in this object.
		 */		
		public function startObject(numfields:int):void
		{
			notNested();
			if(vtable == null || vtable.length < numfields)
			{
				vtable = [];
			}
			
			vtable_in_use = numfields;
			for(var i:int=0; i<numfields; ++i)
			{
				vtable[i] = 0;
			}
			
			_nested = true;
			object_start = offset();
		}
		
		/**
		 * Add a struct to the table. Structs are stored inline, so nothing additional is being added.
		 * @param voffset The index into the vtable.
		 * @param x The offset of the created struct.
		 * @param d The default value is always `0`.
		 */
		public function addStructX(voffset:int, x:*, d:*):void
		{
			if(x != d)
			{
				nestedObj(voffset);
				slot(voffset);
			}
		}
		
		public function addStruct(voffset:int, x:*, d:*):void
		{
			if(x != d)
			{
				nestedObj(x);
				slot(voffset);
			}
		}
		
		/**
		 * Set the current vtable at `voffset` to the current location in the buffer.
		 * @param voffset The index into the vtable to store the offset relative to the end of the
		 * buffer.
		 */	
		public function slot(voffset:int):void
		{
			vtable[voffset] = this.offset();
		}
		
		/**
		 * Finish off writing the object that is under construction.
		 * @return The offset to the object inside {@link #dataBuffer()}.
		 * @see #startObject(int)
		 */
		public function endObject():int
		{
			if(vtable == null || !_nested)
			{
				throw new Error("FlatBuffers: endObject called without startObject");
			}
			
			addInt(0);
			var vtableloc:int = offset();
			// Write out the current vtable.
			for(var i:int=vtable_in_use - 1; i>=0; i--)
			{
				var off:int = vtable[i] != 0? vtableloc - vtable[i] : 0;
				addShort(off);
			}
			
			var standard_fields:int = 2;
			addShort(vtableloc - object_start);
			addShort((vtable_in_use+standard_fields)*Constants.SIZEOF_SHORT);
			
			var existing_vtable:int = 0;
			outer_loop:
			for(i=0; i<num_vtables; ++i)
			{
				var vt1:int = bb.capacity() - vtables[i];
				var vt2:int = space;
				
				var len:int = bb.getShort(vt1);
				
				if(len == bb.getShort(vt2))
				{
					for(var j:int=Constants.SIZEOF_SHORT; j<len; j+=Constants.SIZEOF_SHORT)
					{
						if(bb.getShort(vt1 + j) != bb.getShort(vt2+j))
						{
							continue outer_loop;
						}
					}
					existing_vtable = vtables[i];
					break;
				}
			}
			
			if(existing_vtable != 0)
			{
				//Found a match
				//Remove the current vtable
				space = bb.capacity() - vtableloc;
				// Point table to existing vtable.
				bb.putInt(space, existing_vtable - vtableloc);
			}
			else
			{
				//No match
				//add the location of the current vtable to the list of vtables
				if(num_vtables == vtables.length)
				{
					var tmpVtables:Array = vtables;
					vtables = [];
					
					for(i=0; i<tmpVtables.length*2; ++i)
					{
						vtables[i] = (i<tmpVtables.length)?tmpVtables[i]:0;
					}
				}
				vtables[num_vtables++] = offset();
				// Point table to current vtable.
				bb.putInt(bb.capacity() - vtableloc, offset() - vtableloc);
			}
			
			_nested = false;
			return vtableloc;
		}
		
		/**
		 * Checks that a required field has been set in a given table that has
		 * just been constructed.
		 *
		 * @param table The offset to the start of the table from the `ByteBuffer` capacity.
		 * @param field The offset to the field in the vtable.
		 */
		public function required(table:int, field:int):void
		{
			var table_start:int = bb.capacity() - table;
			var vtable_start:int = table_start - bb.getInt(table_start);
			var ok:Boolean = bb.getShort(vtable_start + field) != 0;
			
			if(!ok)
			{
				throw new Error("FlatBuffers: field " + field + " must be set");
			}
		}
		
		/**
		 * Finalize a buffer, pointing to the given `root_table`.
		 * @param root_table An offset to be added to the buffer.
		 * @param file_identifier A FlatBuffer file identifier to be added to the buffer before
		 * `root_table`.
		 */	
		public function finish(root_table:int, identifier:String = null):void
		{
			if(identifier == null)
			{
				prep(minalign, Constants.SIZEOF_INT);
				addOffset(root_table);
				bb.setPosition(space);
			}
			else
			{
				prep(minalign, Constants.SIZEOF_INT + Constants.FILE_IDENTIFIER_LENGTH);
				
				if(identifier.length != Constants.FILE_IDENTIFIER_LENGTH)
				{
					throw new Error("FlatBuffers: file identifier must be length " + Constants.FILE_IDENTIFIER_LENGTH);
				}
				
				for(var i:int = Constants.FILE_IDENTIFIER_LENGTH-1; i>=0; --i)
				{
					addByte(identifier.charCodeAt(i));
				}
				finish(root_table);
			}
		}
		
		/**
		 * In order to save space, fields that are set to their default value
		 * don't get serialized into the buffer. Forcing defaults provides a
		 * way to manually disable this optimization.
		 *
		 * @param forceDefaults When set to `true`, always serializes default values.
		 * @return Returns `this`.
		 */	
		public function forceDefaults(forceDefaults:Boolean):void
		{
			this.force_defaults = forceDefaults;
		}
		
		/**
		 * Get the ByteBuffer representing the FlatBuffer. Only call this after you've
		 * called `finish()`. The actual data starts at the ByteBuffer's current position,
		 * not necessarily at `0`.
		 * @return The {@link ByteBuffer} representing the FlatBuffer
		 */	
		public function dataBuffer():ByteBuffer
		{
			return bb;
		}
		
		/**
		 * The FlatBuffer data doesn't start at offset 0 in the {@link ByteBuffer}, but
		 * now the {@code ByteBuffer}'s position is set to that location upon {@link #finish(int)}.
		 *
		 * @return The {@link ByteBuffer#position() position} the data starts in {@link #dataBuffer()}
		 * @deprecated This method should not be needed anymore, but is left
		 * here for the moment to document this API change. It will be removed in the future.
		 */
		public function dataStart():int
		{
			return space;
		}
		
		/**
		 * A utility function to copy and return the ByteBuffer data from `start` to
		 * `start` + `length` as a `byte[]`.
		 *
		 * @param start Start copying at this offset.
		 * @param length How many bytes to copy.
		 * @return A range copy of the {@link #dataBuffer() data buffer}.
		 * @throws IndexOutOfBoundsException If the range of bytes is ouf of bound.
		 */
		public function sizedByteArray():ByteArray
		{
			var start:int = space;
			var len:int = bb.capacity() - space;
			
			bb.setPosition(start);
			var res:ByteArray = bb.getX();
			return res;
		}
		
		
		
		
		
		
		
	}
}