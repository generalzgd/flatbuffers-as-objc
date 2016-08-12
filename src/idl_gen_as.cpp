/**
 * 
 * Powered by Zhangguodong 
 * 
 */

// independent from idl_parser, since this code is not needed for most clients

#include "flatbuffers/flatbuffers.h"
#include "flatbuffers/idl.h"
#include "flatbuffers/util.h"
#include "flatbuffers/code_generators.h"

#include <string>

namespace flatbuffers {

namespace as3{

	//缩进
	const std::string Indent = "	";

	class As3Generator : public BaseGenerator {
	public:
		As3Generator(const Parser &parser, const std::string &path, 
					const std::string &file_name)
			:BaseGenerator(parser, path, file_name, "", "."){
			assert(1);
		};

		bool generate(){
			if(! generateEnums() )return false;
			if(! generateStructs() )return false;
			return true;
		}

	private:
		bool generateEnums(){
			for(auto it = parser_.enums_.vec.begin();
				it != parser_.enums_.vec.end(); 
				++it){
				auto &enum_def = **it;

				std::string enumcode;
				GenEnum(enum_def, &enumcode);

				if(!SaveType(enum_def, enumcode, false))return false;
			}
			return true;
		}

		bool generateStructs(){
			for(auto it = parser_.structs_.vec.begin(); 
				it != parser_.structs_.vec.end(); ++it){
				auto &struct_def = **it;
				std::string declcode;
				GenStruct(struct_def, &declcode);
				if(!SaveType(struct_def, declcode, true))return false;
			}
			return true;
		}

		void BeginFile(const std::string name_space_name, const bool needs_imports, std::string *code_ptr){
			std::string &code = *code_ptr;
			code += "/**\n";
			code += " * \n";
			code += " * Powered by Zhangguodong \n";
			code += " * \n";
			code += " */\n\n";

			code += "// ";
			code += FlatBuffersGeneratedWarning();

			code += "package " + name_space_name + "\n{\n\n";

			if(needs_imports){
				code += Indent + "import zgd.google.flatbuffers.*;\n";
				code += Indent + "import flash.utils.ByteArray;\n";
				
				/*if(bRoot && parser_.opts.generate_reflector){
					code += Indent + "import flash.utils.Dictionary;\n";
					code += Indent + "import flash.utils.describeType;\n";
					code += Indent + "import flash.utils.getDefinitionByName;\n";
				}*/
				
				code += "\n\n";
			}
		}

		bool SaveType(const Definition &def, const std::string &classcode, bool needs_imports){
			if(!classcode.length())
				return true;

			std::string code = "";
			BeginFile(FullNamespace(".", *def.defined_namespace), needs_imports, &code);

			code += classcode;

			code += "\n\n}";//包结束括号

			std::string filename = NamespaceDir(*def.defined_namespace) + kPathSeparator + def.name + ".as";

			return SaveFile(filename.c_str(), code, false);
		}

		static void BeginClass(const StructDef &struct_def, std::string *code_ptr){
			std::string &code = *code_ptr;
			if(struct_def.fixed){
				code += Indent + "public class " + struct_def.name + " extends Struct\n";
			}else{
				code += Indent + "public class " + struct_def.name + " extends Table\n";
			}
			code += Indent + "{\n";
		}

		static void EndClass(std::string *code_ptr){
			std::string &code = *code_ptr;
			code += Indent + "}\n";
		}

		static void BeginEnum(const std::string class_name, std::string *code_ptr){
			std::string &code = *code_ptr;
			code += Indent + "public class " + class_name + "\n";
			code += Indent + "{\n";
		}

		static void EnumMember(const EnumVal ev, std::string *code_ptr){
			std::string &code = *code_ptr;
			code += Indent + Indent + "public static const " + ev.name + ":int = " + NumToString(ev.value) + ";\n";
		}

		static void EndEnum(std::string *code_ptr){
			std::string &code = *code_ptr;
			code += Indent + "}\n";
		}

		static void NewRootTypeFromBuffer(const StructDef &struct_def, std::string *code_ptr){
			std::string &code = *code_ptr;

			code += Indent + Indent + "/**\n";
			code += Indent + Indent + " * @param ByteArray inData\n";
			code += Indent + Indent + " * @return " + struct_def.name + "\n";
			code += Indent + Indent + " */\n";

			code += Indent + Indent + "public static function getRootAs" + struct_def.name + "(inData:ByteArray):"+struct_def.name+"\n";
			code += Indent + Indent + "{\n";
			code += Indent + Indent + Indent + "var bb:ByteBuffer = ByteBuffer.wrap(inData);\n";
			code += Indent + Indent + Indent + "var obj:"+struct_def.name+" = new " + struct_def.name + "();\n";
			code += Indent + Indent + Indent + "obj.init(bb.getInt(bb.getPosition()) + bb.getPosition(), bb);\n";
			code += Indent + Indent + Indent + "return obj;\n";
			code += Indent + Indent + "}\n\n";
		}

		static void InitializeExisting(const StructDef &struct_def, std::string *code_ptr){
			std::string &code = *code_ptr;

			code += Indent + Indent + "/**\n";
			code += Indent + Indent + " * @param int i offset\n";
			code += Indent + Indent + " * @param ByteBuffer bb\n";
			code += Indent + Indent + " * @return " + struct_def.name + "\n";
			code += Indent + Indent + " */\n";

			code += Indent + Indent + "public function init(i:int, bb:ByteBuffer):"+struct_def.name+"\n";
			code += Indent + Indent + "{\n";
			code += Indent + Indent + Indent + "this.bb_pos = i;\n";
			code += Indent + Indent + Indent + "this.bb = bb;\n";
			code += Indent + Indent + Indent + "return this;\n";
			code += Indent + Indent + "}\n\n";
		}

		static void GetVectorLen(const FieldDef &field, std::string *code_ptr){
			std::string &code = *code_ptr;

			code += Indent + Indent + "/**\n";
			code += Indent + Indent + " * @return int\n";
			code += Indent + Indent + " */\n";

			code += Indent + Indent + "public function get"+MakeCamel(field.name)+"Length():int\n";
			code += Indent + Indent + "{\n";
			code += Indent + Indent + Indent + "var o:int = this.__offset(" + NumToString(field.value.offset) + ");\n";
			code += Indent + Indent + Indent + "return o!=0?this.__vector_len(o):0;\n";
			code += Indent + Indent + "}\n\n";
		}

		//Get a [ubyte] vector as a byte array.
		static void GetUByte(const FieldDef &field, std::string *code_ptr){
			std::string &code = *code_ptr;

			code += Indent + Indent + "/**\n";
			code += Indent + Indent + " * @return ByteArray\n";
			code += Indent + Indent + " */\n";

			code += Indent + Indent + "public function get" + MakeCamel(field.name) + "Bytes():ByteArray\n";
			code += Indent + Indent + "{\n";
			code += Indent + Indent + Indent + "return this.__vector_as_bytes("+NumToString(field.value.offset)+");\n";
			code += Indent + Indent + "}\n\n";
		}

		static void GetScalarFieldOfStruct(const FieldDef &field, std::string *code_ptr){
			std::string &code = *code_ptr;
			std::string getter = GenGetter(field.value.type);

			code += Indent + Indent + "/**\n";
			code += Indent + Indent + " * @return " + GenTypeGet(field.value.type)+"\n";
			code += Indent + Indent + " */\n";

			code += Indent + Indent + "public function " + getter + MakeCamel(field.name) + "():"+GenTypeGet(field.value.type)+"\n";
			code += Indent + Indent + "{\n";
			code += Indent + Indent + Indent + "return this.bb.get" + MakeCamel(GenTypeGetForMethod(field.value.type)) + "(this.bb_pos + " + NumToString(field.value.offset) + ");\n";
			code += Indent + Indent + "}\n\n";
		}

		void GetScalarFieldOfTable(const FieldDef &field, std::string *code_ptr){
			std::string &code = *code_ptr;
			std::string getter = GenGetter(field.value.type);

			code += Indent + Indent + "/**\n";
			code += Indent + Indent + " * @return " + GenTypeGet(field.value.type) + "\n";
			code += Indent + Indent + " */\n";

			code += Indent + Indent + "public function get"+MakeCamel(field.name)+"():"+GenTypeGet(field.value.type)+"\n";
			code += Indent + Indent + "{\n";
			code += Indent + Indent + Indent + "var o:int = this.__offset("+NumToString(field.value.offset)+");\n";
			code += Indent + Indent + Indent + "return o!=0?this.bb.get"+MakeCamel(GenTypeGetForMethod(field.value.type))+"(o+this.bb_pos):"+GenDefaultValue(field.value)+";\n";
			code += Indent + Indent + "}\n\n";
		}

		void GetStructFieldOfStruct(const FieldDef &field, std::string *code_ptr){
			std::string &code = *code_ptr;

			code += Indent + Indent + "/**\n";
			code += Indent + Indent + " * @return " + GenTypeGet(field.value.type) + "\n";
			code += Indent + Indent + " */\n";

			code += Indent + Indent + "public function get"+MakeCamel(field.name)+"():"+GenTypeGet(field.value.type)+"\n";
			code += Indent + Indent + "{\n";
			code += Indent + Indent + Indent + "var obj:"+GenTypeGet(field.value.type)+" = new " + GenTypeGet(field.value.type) + "();\n";
			code += Indent + Indent + Indent + "obj.init(this.bb_pos + " + NumToString(field.value.offset) + ", this.bb);\n";
			code += Indent + Indent + Indent + "return obj;\n";
			code += Indent + Indent + "}\n\n";
		}

		void GetStructFieldOfTable(const FieldDef &field, std::string *code_ptr){
			std::string &code = *code_ptr;

			code += Indent + Indent + "/**\n";
			code += Indent + Indent + " * @return " + MakeCamel(GenTypeGet(field.value.type)) + "\n";
			code += Indent + Indent + " */\n";

			code += Indent + Indent + "public function get"+MakeCamel(field.name) + "():"+MakeCamel(GenTypeGet(field.value.type))+"\n";
			code += Indent + Indent + "{\n";
			code += Indent + Indent + Indent + "var obj:"+MakeCamel(GenTypeGet(field.value.type))+" = new " + MakeCamel(GenTypeGet(field.value.type)) + "();\n";
			code += Indent + Indent + Indent + "var o:int = this.__offset(" + NumToString(field.value.offset) + ");\n";
			code += Indent + Indent + Indent + "o!=0?obj.init(";
			if(field.value.type.struct_def->fixed){
				code += "o + this.bb_pos, this.bb) : ";
			}else{
				code += "this.__indirect(o + this.bb_pos), this.bb) : ";
			}
			code += GenDefaultValue(field.value) + ";\n";
			code += Indent + Indent + Indent + "return obj;\n";
			code += Indent + Indent + "}\n\n";
		}

		void GetStringField(const FieldDef &field, std::string *code_ptr){
			std::string &code = *code_ptr;

			code += Indent + Indent + "/**\n";
			code += Indent + Indent + " * @return String\n";
			code += Indent + Indent + " */\n";

			code += Indent + Indent + "public function get"+MakeCamel(field.name)+"():String\n";
			code += Indent + Indent + "{\n";
			code += Indent + Indent + Indent + "var o:int = this.__offset("+NumToString(field.value.offset)+");\n";
			code += Indent + Indent + Indent + "return o != 0?this.__string(o + this.bb_pos):"+GenDefaultValue(field.value)+";\n";
			code += Indent + Indent + "}\n\n";
		}

		void GetUnionField(const FieldDef &field, std::string *code_ptr){
			std::string &code = *code_ptr;

			code += Indent + Indent + "/**\n";
			code += Indent + Indent + " * @return " + GenTypeBasic(field.value.type) + "\n";
			code += Indent + Indent + " */\n";

			code += Indent + Indent + "public function get"+MakeCamel(field.name)+"(obj:Table):"+MakeCamel(field.name)+"\n";
			code += Indent + Indent + "{\n";
			code += Indent + Indent + Indent + "var o:int = this.__offset("+NumToString(field.value.offset)+");\n";
			code += Indent + Indent + Indent + "return o!=0?this.__union(obj, o):null;\n";
			code += Indent + Indent + "}\n\n";
		}

		void GetMemberOfVectorOfStruct(const StructDef &struct_def, const FieldDef &field, std::string *code_ptr){
			std::string &code = *code_ptr;

			auto vectortype = field.value.type.VectorType();

			code += Indent + Indent + "/**\n";
			code += Indent + Indent + " * @return " + GenTypeBasic(field.value.type) + "\n";
			code += Indent + Indent + " */\n";

			code += Indent + Indent + "public function get" + MakeCamel(field.name) + "(j:int):*\n";
			code += Indent + Indent + "{\n";
			code += Indent + Indent + Indent + "var o:int = this.__offset("+NumToString(field.value.offset)+");\n";
			code += Indent + Indent + Indent + "var obj:"+MakeCamel(GenTypeGet(field.value.type))+" = new " + MakeCamel(GenTypeGet(field.value.type)) + "();\n";

			switch(field.value.type.base_type){
			case BASE_TYPE_STRUCT:
				if(struct_def.fixed){
					code += Indent + Indent + Indent + "return o!=0?obj.init(this.bb_pos + "+NumToString(field.value.offset)+", this.bb):null;\n";
				}else{
					code += Indent + Indent + Indent + "return o!=0?obj.init(";
					code += field.value.type.struct_def->fixed?"o + this.bb_pos":"this.__indirect(o + this.bb_pos)";
					code += ", this.bb):null;\n";
				}
				break;
			case BASE_TYPE_STRING:
				code += "// base_type_string\n";
				break;
			case BASE_TYPE_VECTOR:
				if(vectortype.base_type == BASE_TYPE_STRUCT){
					code += Indent + Indent + Indent + "return o!=0?obj.init(";
					if(vectortype.struct_def->fixed){
						code += "this.__vector(o) + j * ";
						code += NumToString(InlineSize(vectortype));
					}else{
						code += "this.__indirect(this.__vector(o) + j * ";
						code += NumToString(InlineSize(vectortype)) + ")";
					}
					code += ", this.bb):null;\n";
				}
				break;
			case BASE_TYPE_UNION:
				code += Indent + Indent + Indent + "return o!=0?this."+GenGetter(field.value.type)+"(obj, o):null;\n";
				break;
			default:
				break;
			}
			code += Indent + Indent + "}\n\n";
		}

		void GetMemberOfVectorOfNonStruct(const FieldDef &field, std::string *code_ptr){
			std::string &code = *code_ptr;
			auto vectortype = field.value.type.VectorType();

			code += Indent + Indent + "/**\n";
			code += Indent + Indent + " * @param int offset\n";
			code += Indent + Indent + " * @return " + GenTypeGet(field.value.type) + "\n";
			code += Indent + Indent + " */\n";

			code += Indent + Indent + "public function get"+MakeCamel(field.name) + "(j:int):*\n";
			code += Indent + Indent + "{\n";
			code += Indent + Indent + Indent + "var o:int = this.__offset("+NumToString(field.value.offset) + ");\n";
			if(field.value.type.VectorType().base_type == BASE_TYPE_STRING){
				code += Indent + Indent + Indent + "return o!=0?this.__string(this.__vector(o) + j * "+NumToString(InlineSize(vectortype))+" ):"+GenDefaultValue(field.value)+";\n";
			}else{
				code += Indent + Indent + Indent + "return o!=0?this.bb.get"+MakeCamel(GenTypeGetForMethod(field.value.type))+"(this.__vector(o) + j * "+NumToString(InlineSize(vectortype))+"):"+GenDefaultValue(field.value)+";\n";
			}
			code += Indent + Indent + "}\n\n";
		}

		static void StructBuilderArgs(const StructDef &struct_def, const char *nameprefix, std::string *code_ptr){
			for(auto it = struct_def.fields.vec.begin();
				it != struct_def.fields.vec.end();
				++it){
				auto &field = **it;
				if(IsStruct(field.value.type)){
					StructBuilderArgs(*field.value.type.struct_def, (nameprefix + (field.name + "_")).c_str(), code_ptr);
				}else{
					std::string &code = *code_ptr;
					code += ", ";
					code += "\n" + Indent + Indent + Indent + Indent + Indent + Indent + Indent + Indent + Indent + Indent;
					code += nameprefix + MakeCamel(field.name, false) + ":" + GenTypeGet(field.value.type);
				}
			}
		}

		static void StructBuilderBody(const StructDef &struct_def, const char *nameprefix, std::string *code_ptr){
			std::string &code = *code_ptr;

			code += Indent + Indent + Indent + "builder.prep("+NumToString(struct_def.minalign)+", "+NumToString(struct_def.bytesize) + ");\n";
			for(auto it = struct_def.fields.vec.rbegin();
				it != struct_def.fields.vec.rend();
				++it){
				auto &field = **it;
				if(field.padding){
					code += Indent + Indent + Indent + "builder.pad("+NumToString(field.padding)+");\n";
				}
				if(IsStruct(field.value.type)){
					StructBuilderBody(*field.value.type.struct_def, (nameprefix + (field.name + "_")).c_str(), code_ptr);
				}else{
					code += Indent + Indent + Indent + "builder.put"+GenMethod(field)+"("+nameprefix + MakeCamel(field.name, false) + ");\n";
				}
			}
		}

		static void GetStartOfTable(const StructDef &struct_def, std::string *code_ptr){
			std::string &code = *code_ptr;

			code += Indent + Indent + "/**\n";
			code += Indent + Indent + " * @param FlatBufferBuilder builder\n";
			code += Indent + Indent + " * @return void\n";
			code += Indent + Indent + " */\n";

			code += Indent + Indent + "public static function start" + struct_def.name+"(builder:FlatBufferBuilder):void\n";
			code += Indent + Indent + "{\n";
			code += Indent + Indent + Indent + "builder.startObject(" + NumToString(struct_def.fields.vec.size()) + ");\n";
			code += Indent + Indent + "}\n\n";

			code += Indent + Indent + "/**\n";
			code += Indent + Indent + " * @param FlatBufferBuilder builder\n";
			code += Indent + Indent + " * @param (if type is * means int offset value)\n";
			code += Indent + Indent + " * @return " + struct_def.name + " offset\n";
			code += Indent + Indent + " */\n";
			code += Indent + Indent + "public static function create"+struct_def.name + "(builder:FlatBufferBuilder, ";

			for(auto it = struct_def.fields.vec.begin(); it!=struct_def.fields.vec.end(); ++it){
				auto &field = **it;

				if(field.deprecated)continue;
				//code += field.name;
				code += "\n" + Indent + Indent + Indent + Indent + Indent + Indent + Indent + Indent + Indent + Indent;
				code += MakeCamel(field.name, false) +(IsScalar(field.value.type.base_type)?"":"Offset")+ ":" + (IsScalar(field.value.type.base_type)?GenTypeGet(field.value.type):"*");
				if(!(it == (--struct_def.fields.vec.end()))){
					code += ", ";
				}
			}
			code += "):int\n";
			code += Indent + Indent + "{\n";
			code += Indent + Indent + Indent + "builder.startObject("+NumToString(struct_def.fields.vec.size())+");\n";
			for(auto it = struct_def.fields.vec.begin(); it!=struct_def.fields.vec.end(); ++it){
				auto &field = **it;
				if(field.deprecated)continue;

				code += Indent + Indent + Indent + "add"+MakeCamel(field.name)+"(builder, "+MakeCamel(field.name, false)+(IsScalar(field.value.type.base_type)?"":"Offset")+");\n";
			}

			code += Indent + Indent + Indent + "var o:int = builder.endObject();\n";

			for(auto it = struct_def.fields.vec.begin(); it != struct_def.fields.vec.end(); ++it){
				auto &field = **it;
				if(!field.deprecated && field.required){
					code += Indent + Indent + Indent + "builder.required(o, "+NumToString(field.value.offset)+");	//" + field.name + "\n";
				}
			}
			code += Indent + Indent + Indent + "return o;\n";
			code += Indent + Indent + "}\n\n";
		}

		static void BuildFieldOfTable(const FieldDef &field, const size_t offset, std::string *code_ptr){
			std::string &code = *code_ptr;

			code += Indent + Indent + "/**\n";
			code += Indent + Indent + " * @param FlatBufferBuilder builder\n";
			code += Indent + Indent + " * @param (if type is * means int offset value) " + GenTypeBasic(field.value.type) + "\n";
			code += Indent + Indent + " * @return void\n";
			code += Indent + Indent + " */\n";
			code += Indent + Indent + "public static function add"+MakeCamel(field.name)+"(builder:FlatBufferBuilder, "+MakeCamel(field.name, false)+(IsScalar(field.value.type.base_type)?"":"Offset")+":"+GenTypeBasic(field.value.type)+"):void\n";
			code += Indent + Indent + "{\n";
			code += Indent + Indent + Indent + "builder.add"+GenMethod(field)+"X("+NumToString(offset)+", "+MakeCamel(field.name, false)+(IsScalar(field.value.type.base_type)?"":"Offset")+", " + (field.value.type.base_type==BASE_TYPE_BOOL?"false":field.value.constant) + ");\n";
			code += Indent + Indent + "}\n\n";
		}

		static void BuildVectorOfTable(const FieldDef &field, std::string *code_ptr){
			std::string &code = *code_ptr;

			auto vector_type = field.value.type.VectorType();
			auto alignment = InlineAlignment(vector_type);
			auto elem_size = InlineSize(vector_type);

			code += Indent + Indent + "/**\n";
			code += Indent + Indent + " * @param FlatBufferBuilder builder\n";
			code += Indent + Indent + " * @param array ofsset array\n";
			code += Indent + Indent + " * @return int vector offset\n";
			code += Indent + Indent + " */\n";
			code += Indent + Indent + "public static function create"+MakeCamel(field.name)+"Vector(builder:FlatBufferBuilder, data:Array):int\n";
			code += Indent + Indent + "{\n";
			code += Indent + Indent + Indent + "builder.startVector("+NumToString(elem_size)+", data.length, " + NumToString(alignment) + ");\n";
			code += Indent + Indent + Indent + "for(var i:int=data.length-1; i>=0; i--){\n";
			if(IsScalar(field.value.type.VectorType().base_type)){
				code += Indent + Indent + Indent + Indent + "builder.add"+MakeCamel(GenTypeBasicForMethod(field.value.type.VectorType())) + "(data[i]);\n";
			}else{
				code += Indent + Indent + Indent + Indent + "builder.addOffset(data[i]);\n";
			}
			code += Indent + Indent + Indent + "}\n";
			code += Indent + Indent + Indent + "return builder.endVector();\n";
			code += Indent + Indent + "}\n\n";


			code += Indent + Indent + "/**\n";
			code += Indent + Indent + " * @param FlatBufferBuilder builder\n";
			code += Indent + Indent + " * @param int numElems\n";
			code += Indent + Indent + " * @return void\n";
			code += Indent + Indent + " */\n";
			code += Indent + Indent + "public static function start"+MakeCamel(field.name)+"Vector(builder:FlatBufferBuilder, numElems:int):void\n";
			code += Indent + Indent + "{\n";
			code += Indent + Indent + Indent + "builder.startVector("+NumToString(elem_size)+", numElems, "+NumToString(alignment)+");\n";
			code += Indent + Indent + "}\n\n";
		}

		void GetEndOffsetOnTable(const StructDef &struct_def, std::string *code_ptr){
			std::string &code = *code_ptr;

			code += Indent + Indent + "/**\n";
			code += Indent + Indent + " * @param FlatBufferBuilder builder\n";
			code += Indent + Indent + " * @return int table offset\n";
			code += Indent + Indent + " */\n";

			code += Indent + Indent + "public static function end"+struct_def.name+"(builder:FlatBufferBuilder):int\n";
			code += Indent + Indent + "{\n";
			code += Indent + Indent + Indent + "var o:int = builder.endObject();\n";
			for(auto it = struct_def.fields.vec.begin(); it != struct_def.fields.vec.end(); ++it){
				auto &field = **it;
				if(!field.deprecated && field.required){
					code += Indent + Indent + Indent + "builder.required(o, "+NumToString(field.value.offset)+");	//"+field.name+"\n";
				}
			}
			code += Indent + Indent + Indent + "return o;\n";
			code += Indent + Indent + "}\n\n";

			if(parser_.root_struct_def_ == &struct_def){
				code += "\n";
				code += Indent + Indent + "public static function finish" + struct_def.name+"Buffer(builder:FlatBufferBuilder, offset:int):void\n";
				code += Indent + Indent + "{\n";
				code += Indent + Indent + Indent + "builder.finish(offset"+(parser_.file_identifier_.length()?", \""+parser_.file_identifier_+"\"":"")+");\n";
				code += Indent + Indent + "}\n\n";
			}
		}

		void GenStructAccessor(const StructDef &struct_def, const FieldDef &field, std::string *code_ptr){
			GenComment(field.doc_comment, code_ptr, nullptr);

			if(IsScalar(field.value.type.base_type)){
				if(struct_def.fixed){
					GetScalarFieldOfStruct(field, code_ptr);
				}else{
					GetScalarFieldOfTable(field, code_ptr);
				}
			}else{
				switch(field.value.type.base_type){
				case BASE_TYPE_STRUCT:
					if(struct_def.fixed){
						GetStructFieldOfStruct(field, code_ptr);
					}else{
						GetStructFieldOfTable(field, code_ptr);
					}
					break;
				case BASE_TYPE_STRING:
					GetStringField(field, code_ptr);
					break;
				case BASE_TYPE_VECTOR:
					{
						auto vectortype = field.value.type.VectorType();
						if(vectortype.base_type == BASE_TYPE_STRUCT){
							GetMemberOfVectorOfStruct(struct_def, field, code_ptr);
						}else{
							GetMemberOfVectorOfNonStruct(field, code_ptr);
						}
					}
					break;
				case BASE_TYPE_UNION:
					GetUnionField(field, code_ptr);
					break;
				default:
					assert(0);
				}
			}
			if(field.value.type.base_type == BASE_TYPE_VECTOR){
				GetVectorLen(field, code_ptr);
				if(field.value.type.element == BASE_TYPE_UCHAR){
					GetUByte(field, code_ptr);
				}
			}
		}

		void GenJsonBuilder(const StructDef &struct_def, std::string *code_ptr){
			std::string &code = *code_ptr;
			code += Indent + Indent + "/**\n";
			code += Indent + Indent + " * change to json object\n";
			code += Indent + Indent + " */\n";
			code += Indent + Indent + "public function toJson():Object\n";
			code += Indent + Indent + "{\n";
			code += Indent + Indent + Indent + "var o:Object = {};\n";
			
			for(auto it = struct_def.fields.vec.begin(); it!=struct_def.fields.vec.end(); ++it){
				auto &tmpfield = **it;
				if(tmpfield.value.type.base_type == BASE_TYPE_VECTOR){
					code += Indent + Indent + Indent + "var arr:Array;\n";
					code += Indent + Indent + Indent + "var len:int;\n";
					code += Indent + Indent + Indent + "var i:int;\n";
					break;
				}
			}

			for(auto it = struct_def.fields.vec.begin(); it!=struct_def.fields.vec.end(); ++it){
				auto &field = **it;
				if(!field.deprecated){

					if(IsScalar(field.value.type.base_type)){
						code += Indent + Indent + Indent + "o." + field.name + " = get" + MakeCamel(field.name) + "();\n";
					}else if(field.value.type.base_type == BASE_TYPE_STRING){
						code += Indent + Indent + Indent + "o." + field.name + " = get" + MakeCamel(field.name) + "();\n";
					}else if(field.value.type.base_type == BASE_TYPE_VECTOR){
						GenVectorJson(struct_def, field, code_ptr);
					}else{
						code += Indent + Indent + Indent + "o." + field.name + " = get" + MakeCamel(field.name) + "().toJson();\n";
					}
				}else{
					code += Indent + Indent + Indent + "o." + field.name + " = " + (field.value.type.base_type==BASE_TYPE_BOOL?"false":field.value.constant)+";\n";
				}
			}

			code += Indent + Indent + Indent + "return o;\n";
			code += Indent + Indent + "}\n\n";

		}

		void GenVectorJson(const StructDef &struct_def, const FieldDef &field, std::string* code_ptr){
			std::string &code = *code_ptr;

			auto vector_type = field.value.type.VectorType();
			
			code += Indent + Indent + Indent + "arr = [];\n";
			code += Indent + Indent + Indent + "len = get"+MakeCamel(field.name)+"Length();\n";
			code += Indent + Indent + Indent + "for(i=0; i<len; ++i)\n";
			code += Indent + Indent + Indent + "{\n";
			code += Indent + Indent + Indent + Indent + "var e:* = get"+MakeCamel(field.name)+"(i);\n";
			if(vector_type.base_type == BASE_TYPE_STRUCT){
				code += Indent + Indent + Indent + Indent + "arr.push( e.toJson() );\n";
			}else{
				code += Indent + Indent + Indent + Indent + "arr.push( e );\n";
			}
			code += Indent + Indent + Indent + "}\n";
			
			code += Indent + Indent + Indent + "o."+field.name+" = arr;\n";
		}

		void GenTableBuilders(const StructDef &struct_def, std::string *code_ptr){
			GetStartOfTable(struct_def, code_ptr);

			for(auto it = struct_def.fields.vec.begin(); it != struct_def.fields.vec.end(); ++it){
				auto &field = **it;
				if(field.deprecated)continue;

				auto offset = it - struct_def.fields.vec.begin();
				if(field.value.type.base_type == BASE_TYPE_UNION){
					std::string &code = *code_ptr;

					code += Indent + Indent + "public static function add"+MakeCamel(field.name)+"(builder:FlatBufferBuilder, offset:int):void\n";
					code += Indent + Indent + "{\n";
					code += Indent + Indent + Indent + "builder.addOffsetX("+NumToString(offset)+", offset, 0);\n";
					code += Indent + Indent + "}\n\n";
				}else{
					BuildFieldOfTable(field, offset, code_ptr);
				}
				if(field.value.type.base_type == BASE_TYPE_VECTOR){
					BuildVectorOfTable(field, code_ptr);
				}
			}

			GetEndOffsetOnTable(struct_def, code_ptr);
		}

		void GenFactoryFun(std::string *code_ptr){
			std::string &code = *code_ptr;

			bool finded = false;
			for(auto it=parser_.enums_.vec.begin(); it!=parser_.enums_.vec.end(); it++){
				auto &enum_def = **it;
				if(enum_def.name == "ProtocolID"){
					finded = true;
					break;
				}
			}
			if(!finded)return;
			
			code += Indent + Indent + "/**\n";
			code += Indent + Indent + " * get struct class by enum protocol id\n";
			code += Indent + Indent + " */\n";
			code += Indent + Indent + "public static function getProtocol(protocolID:uint, bytes:ByteArray):*\n";
			code += Indent + Indent + "{\n";
			code += Indent + Indent + Indent + "switch(protocolID)\n";
			code += Indent + Indent + Indent + "{\n";
			for(auto it=parser_.enums_.vec.begin(); it!=parser_.enums_.vec.end(); ++it){
				auto &enum_def = **it;
				if(enum_def.name == "ProtocolID"){
					for(auto it=enum_def.vals.vec.begin(); it != enum_def.vals.vec.end(); ++it){
						auto &ev = **it;
						code += Indent + Indent + Indent + Indent + "case " + NumToString(ev.value) +":\n";
						code += Indent + Indent + Indent + Indent + Indent + "return " + FullNamespace(".", *enum_def.defined_namespace)+"."+MakeCamel(ev.name)+".getRootAs"+MakeCamel(ev.name)+"(bytes);\n";
					}
					break;
				}
			}
			code += Indent + Indent + Indent + "}\n";
			code += Indent + Indent + Indent + "return null;\n";
			code += Indent + Indent + "}\n\n";
		}

		void GenStruct(const StructDef &struct_def, std::string *code_ptr){
			if(struct_def.generated)return;

			GenComment(struct_def.doc_comment, code_ptr, nullptr);
			BeginClass(struct_def, code_ptr);

			std::string &code = *code_ptr;
			
			if(&struct_def == parser_.root_struct_def_ && parser_.opts.generate_reflector){
				GenFactoryFun(code_ptr);
				return;
			}

			if(!struct_def.fixed){
				NewRootTypeFromBuffer(struct_def, code_ptr);
			}

			
			if(!struct_def.fixed){
				if(parser_.file_identifier_.length()){
					code += Indent + Indent + "public static function " + struct_def.name + "Identifier():String\n";
					code += Indent + Indent + "{\n";
					code += Indent + Indent + Indent + "return \""+parser_.file_identifier_+"\";\n";
					code += Indent + Indent + "}\n\n";

					code += Indent + Indent + "public static function " + struct_def.name + "BufferHasIdentifier(buf:ByteBuffer):Boolean\n";
					code += Indent + Indent + "{\n";
					code += Indent + Indent + Indent + "return __has_identifier(buf, "+struct_def.name+"Identifier());\n";
					code += Indent + Indent + "}\n\n";
				}

				if(parser_.file_identifier_.length()){
					code += Indent + Indent + "public static function " + struct_def.name + "Extension():String\n";
					code += Indent + Indent + "{\n";
					code += Indent + Indent + Indent + "return \""+parser_.file_extension_+"\";\n";
					code += Indent + Indent + "}\n\n";
				}
			}

			InitializeExisting(struct_def, code_ptr);

			for(auto it = struct_def.fields.vec.begin(); it!=struct_def.fields.vec.end(); ++it){
				auto &field = **it;
				if(field.deprecated)continue;

				GenStructAccessor(struct_def, field, code_ptr);
			}

			if(parser_.opts.generate_json){
				GenJsonBuilder(struct_def, code_ptr);
			}

			if(struct_def.fixed){
				GenStructBuilder(struct_def, code_ptr);
			}else{
				GenTableBuilders(struct_def, code_ptr);
			}

			EndClass(code_ptr);
		}

		static void GenEnum(const EnumDef &enum_def, std::string *code_ptr){
			if(enum_def.generated)return;

			GenComment(enum_def.doc_comment, code_ptr, nullptr);
			BeginEnum(enum_def.name, code_ptr);
			for(auto it=enum_def.vals.vec.begin(); it != enum_def.vals.vec.end(); ++it){
				auto &ev = **it;
				GenComment(ev.doc_comment, code_ptr, nullptr);
				EnumMember(ev, code_ptr);
			}

			std::string &code = *code_ptr;
			code += "\n";
			code += Indent + Indent + "private static const names:Object = {";
			for(auto it = enum_def.vals.vec.begin(); it != enum_def.vals.vec.end(); ++it){
				auto &ev = **it;
				code += NumToString(ev.value) + ":\""+ev.name+"\"";
				if(it != --enum_def.vals.vec.end())
					code += ",";
			}
			code += "};\n\n";

			code += Indent + Indent + "public static function Name(e:int):String\n";
			code += Indent + Indent + "{\n";
			code += Indent + Indent + Indent + "if(!names.hasOwnProperty(e))\n";
			code += Indent + Indent + Indent + Indent + "throw new Error('Out of Enum Index!');\n";
			code += Indent + Indent + Indent + "return names[e];\n";
			code += Indent + Indent + "}\n";

			EndEnum(code_ptr);
		}

		static std::string GenGetter(const Type &type){
			switch(type.base_type){
			case BASE_TYPE_STRING:
				return "__string";
			case BASE_TYPE_STRUCT:
				return "__struct";
			case BASE_TYPE_UNION:
				return "__union";
			case BASE_TYPE_VECTOR:
				return GenGetter(type.VectorType());
			default:
				return "get";
			}
		}

		static std::string GenMethod(const FieldDef &field){
			return IsScalar(field.value.type.base_type)?MakeCamel(GenTypeBasicForMethod(field.value.type)):(IsStruct(field.value.type)?"Struct":"Offset");
		}

		//给参数使用
		static std::string GenTypeBasic(const Type &type){
/*			static const char * ctypename[] = {
#define FLATBUFFERS_TD(ENUM, IDLTYPE, CTYPE, JTYPE, GTYPE, NTYPE, PTYPE) \
	#NTYPE,
				FLATBUFFERS_GEN_TYPES(FLATBUFFERS_TD)
#undef FLATBUFFERS_TD
			};*/
			static const char * ctypename[] = {"int","int","Boolean","int","int","int","int","int","uint","Number","Number","Number","Number","*","*","int","int"};
			std::string typeStr = ctypename[type.base_type];
			return typeStr;
		}
		//给方法使用
		static std::string GenTypeBasicForMethod(const Type &type){
/*			static const char * ctypename[] = {
#define FLATBUFFERS_TD(ENUM, IDLTYPE, CTYPE, JTYPE, GTYPE, NTYPE, PTYPE) \
	#NTYPE,
				FLATBUFFERS_GEN_TYPES(FLATBUFFERS_TD)
#undef FLATBUFFERS_TD
			};*/
			static const char * ctypename[] = {"byte","byte","bool","byte","ubyte","short","ushort","int","uint","long","ulong","float","double","StringOffset","VectorOffset","int","int"};
			std::string typeStr = ctypename[type.base_type];
			return typeStr;
		}

		std::string GenDefaultValue(const Value &value){
			if(value.type.enum_def){
				if(auto val = value.type.enum_def->ReverseLookup(atoi(value.constant.c_str()), false)){
					return WrapInNameSpace(*value.type.enum_def) + "." + val->name;
				}
			}

			switch(value.type.base_type){
			case BASE_TYPE_BOOL:
				return value.constant == "0"?"false":"true";
			case BASE_TYPE_STRING:
				return "null";
			case BASE_TYPE_LONG:
			case BASE_TYPE_ULONG:
				if(value.constant != "0"){
					int64_t constant = StringToInt(value.constant.c_str());
					return NumToString(constant);
				}
				return "0";
			default:
				return value.constant;
			}
		}

		static std::string GenTypePointer(const Type &type){
			switch(type.base_type){
			case BASE_TYPE_STRING:
				return "string";
			case BASE_TYPE_VECTOR:
				return GenTypeGet(type.VectorType());
			case BASE_TYPE_STRUCT:
				return type.struct_def->name;
			case BASE_TYPE_UNION:
				//fall through
			default:
				return "Table";
			}
		}

		static std::string GenTypePointerForMethod(const Type &type){
			switch(type.base_type){
			case BASE_TYPE_STRING:
				return "string";
			case BASE_TYPE_VECTOR:
				return GenTypeGetForMethod(type.VectorType());
			case BASE_TYPE_STRUCT:
				return type.struct_def->name;
			case BASE_TYPE_UNION:
				//fall through
			default:
				return "Table";
			}
		}

		static std::string GenTypeGet(const Type &type){
			return IsScalar(type.base_type)?GenTypeBasic(type):GenTypePointer(type);
		}

		static std::string GenTypeGetForMethod(const Type &type){
			return IsScalar(type.base_type)?GenTypeBasicForMethod(type):GenTypePointerForMethod(type);
		}

		static void GenStructBuilder(const StructDef &struct_def, std::string *code_ptr){
			std::string &code = *code_ptr;

			code += "\n";
			code += Indent + Indent + "/**\n";
			code += Indent + Indent + " * @return int offset\n";
			code += Indent + Indent + " */\n";
			code += Indent + Indent + "public static function create" + struct_def.name + "(builder:FlatBufferBuilder";
			StructBuilderArgs(struct_def, "", code_ptr);
			code += "):int\n";
			code += Indent + Indent + "{\n";
			StructBuilderBody(struct_def, "", code_ptr);

			code += Indent + Indent + Indent + "return builder.offset();\n";
			code == Indent + Indent + "}\n";
		}

	};



}


bool GenerateAS3(const Parser &parser, const std::string &path, const std::string &file_name){
	as3::As3Generator generator(parser, path, file_name);
	return generator.generate();
}


}