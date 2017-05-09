package
{
	import Jason.Flat.Test.TestAppend;
	import Jason.Flat.Test.Texture;
	import Jason.Flat.Test.TextureData;
	
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	import zgd.google.flatbuffers.FlatBufferBuilder;
	import zgd.hurlant.util.Base64;
	
	
	public class FlatBuffersTest extends Sprite
	{
		public function FlatBuffersTest()
		{
			//writeTest();
			
			//readTest();
			
			testObjCContent();
		}
		
		private function testObjCContent():void
		{
			var base64:String = "EgAAAAAADAASAAQACAAMABAADAAAAB4AAAAKAAAAWAAAAFoAAgAAAIMM";
			var bytes:ByteArray = Base64.decodeToByteArray(base64);
			
			//var inst:TestAppend = TestAppend.getRootAsTestAppend(bytes);
			//var inst:Texture = Texture.getRootAsTexture(bytes);
			var inst:TextureData = TextureData.getRootAsTextureData(bytes);
			trace(JSON.stringify(inst.toJson()));
			
		}		
		
		private function writeTest():void
		{
			var builder:FlatBufferBuilder = new FlatBufferBuilder();
			
			var test_append:int = 300;
			var name_test:* = builder.createString("TestAppend");
			var testApp:* = TestAppend.createTestAppend(builder, test_append, test_append);
			
			var image_size:int = 12;
			var elem_size:int = 1;
			var inv_data:Array = [11,2,4,2,10,3,5,7,10,39,45,23];
			var name:* = builder.createString("TextureData");
			var image_data:* = TextureData.createImageDataVector(builder, inv_data);
			var image_test:int = 900;
			var texture_data:* = TextureData.createTextureData(builder, image_size, image_data, image_test, image_test);
			
			var texture_num:int = 1;
			var name_tex:* = builder.createString("Texture");
			
			var tex_vec:Array = [];
			tex_vec.push(texture_data);
			
			var tex_data:* = Texture.createTexturesVector(builder, tex_vec);
			var num_text:int = 100;
			var num_text2:int = 200;
			var texture:* = Texture.createTexture(builder,name_tex, texture_num, tex_data, num_text, num_text2, testApp);
			
			Texture.finishTextureBuffer(builder, texture);
			
			saveFile( builder.sizedByteArray(), "texture2.bin" );
		}
		
		private function readTest():void
		{
			var fileData:ByteArray = new ByteArray();
			readFile(fileData, "texture2.bin");
			
			var builder:FlatBufferBuilder = new FlatBufferBuilder();
			
			var texture:Texture = Texture.getRootAsTexture(fileData);
			
			var name:String = texture.getTextureName();
			
			var num_textures:* = texture.getNumTextures();
			
			var texture_data:TextureData = texture.getTextures(0) as TextureData;
			
			var image_len:* = texture_data.getImageDataLength();
			
			var image_data_5:* = texture_data.getImageData(5);
		}
		
		private function saveFile(data:ByteArray, fileName:String):void
		{
			var file:File = File.desktopDirectory.resolvePath(fileName);
			
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(data, 0, data.bytesAvailable);
			stream.close();
		}
		
		private function readFile(data:ByteArray, fileName:String):void
		{
			var file:File = File.desktopDirectory.resolvePath(fileName);
			
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			stream.readBytes(data);
			stream.close();
		}
		
	}
	
	
	
}