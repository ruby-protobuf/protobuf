#ifndef GOOGLE_PROTOBUF_COMPILER_RUBY_GENERATOR_H
#define GOOGLE_PROTOBUF_COMPILER_RUBY_GENERATOR_H

#include <string>
#include <iostream>
#include <sstream>
#include <vector>

#include <google/protobuf/compiler/command_line_interface.h>
#include <google/protobuf/compiler/code_generator.h>
#include <google/protobuf/descriptor.h>
#include <google/protobuf/descriptor.pb.h>
#include <google/protobuf/io/zero_copy_stream.h>
#include <google/protobuf/io/printer.h>
#include <google/protobuf/stubs/substitute.h>
#include <google/protobuf/stubs/strutil.h>

namespace google {
namespace protobuf {
namespace compiler {
namespace ruby {

class LIBPROTOC_EXPORT RubyGenerator : public CodeGenerator {
	public:
		RubyGenerator();
		~RubyGenerator();

		// implemented Generate method from parent
		bool Generate(const FileDescriptor* file,
			const string& parameter,
			GeneratorContext* context,
			string* error) const;


	private:
		mutable GeneratorContext* context_;
		mutable io::Printer* printer_;
		mutable const FileDescriptor* file_;
		mutable string filename;
		mutable vector<string> ns_vector;

		GOOGLE_DISALLOW_EVIL_CONSTRUCTORS(RubyGenerator);

		void PrintEnclosingNamespaceModules() const;
		void PrintEnclosingNamespaceModuleEnds() const;

		void PrintMessagesForDescriptor(const Descriptor* descriptor, bool print_fields) const;
		void PrintMessagesForFileDescriptor(const FileDescriptor* descriptor, bool print_fields) const;
		void PrintMessage(const Descriptor* descriptor, bool print_fields) const;
		void PrintExtensionRangesForDescriptor(const Descriptor* descriptor) const;
		void PrintMessageField(const FieldDescriptor* descriptor) const;

		void PrintEnumsForDescriptor(const Descriptor* descriptor, bool print_values) const;
		void PrintEnumsForFileDescriptor(const FileDescriptor* descriptor, bool print_values) const;
		void PrintEnum(const EnumDescriptor* descriptor, bool print_values) const;
		void PrintEnumValue(const EnumValueDescriptor* descriptor) const;

		void PrintServices() const;
		void PrintService(const ServiceDescriptor* descriptor) const;
		void PrintServiceMethod(const MethodDescriptor* descriptor) const;

		void PrintGeneratedFileComment() const;
		void PrintGenericRequires() const;
		void PrintImportRequires() const;
		void PrintComment(string comment) const;
		void PrintComment(string comment, bool as_header) const;
		void PrintRequire(string lib_name) const;
		void PrintNewLine() const;

		// Take the proto file name, strip ".proto"
		// from the end and add ".pb.rb"
		static string CreateRubyFileName(const string proto_filename) {
			return CreateRubyFileName(proto_filename, false);
		}

		static string CreateRubyFileName(const string proto_filename, bool for_require) {
			string replacement = for_require ? ".pb" : ".pb.rb";
			return StringReplace(proto_filename, ".proto", replacement, false);
		}

		static string ConvertIntToString(int number) {
			stringstream stream;
			stream << number;
			return stream.str();
		}

		static string ConvertDoubleToString(double number) {
			stringstream stream;
			stream << number;
			return stream.str();
		}

		static string ConvertFloatToString(float number) {
			stringstream stream;
			stream << number;
			return stream.str();
		}

		static string Constantize(string full_path) {
			return Constantize(full_path, true);
		}

		static string Constantize(string full_path, bool is_top_level) {
			stringstream constantized;

			if (is_top_level) {
				constantized << "::";
			}

			string::iterator i;
			bool segment_end = true;
			for (i = full_path.begin(); i < full_path.end(); i++) {
				char c = *i;
				if (c == 46) { // period char
					constantized << ':' << ':';
					segment_end = true;
					continue;
				}
				else if (c == 95) { // underscore char
					segment_end = true;
				}
				else if (segment_end) {
					if (c >= 97 && c <= 122) { // a-z chars
						c -= 32;
					}
					segment_end = false;
				}
				constantized << c;
			}

			return constantized.str();
		}

		static string Underscore(string name) {
			stringstream underscored;

			string::iterator i;
			for (i = name.begin(); i < name.end(); i++) {
				char c = *i;
				if (c >= 65 && c <= 90) { // a-z chars
					if (i != name.begin()) {
						underscored << '_';
					}
					c += 32;
				}
				underscored << c;
			}

			return underscored.str();
		}

    static string FullEnumNamespace(const EnumValueDescriptor* descriptor) {
      string parent_enum_type = Constantize(descriptor->type()->full_name());
      string enum_name = descriptor->name();

      return strings::Substitute("$0::$1", parent_enum_type, enum_name);
    }

    static bool DescriptorHasNestedTypes(const Descriptor* descriptor) {
      return (descriptor->enum_type_count() > 0 || descriptor->nested_type_count() > 0);
    }

}; // class RubyGenerator

} // namespace ruby
} // namespace compiler
} // namespace protobuf
} // namespace google

#ifdef __cplusplus
extern "C" {
#endif

int _rprotoc_extern(int argc, char* argv[]) {
  google::protobuf::compiler::CommandLineInterface cli;

  google::protobuf::compiler::ruby::RubyGenerator ruby_generator;
  cli.RegisterGenerator("--ruby_out", &ruby_generator,
    "Generate Ruby-compatible protobuf message and service classes.");

  return cli.Run(argc, argv);
}

/*

Use for testing:

int main(int argc, char* argv[]) {
  return _rprotoc_extern(argc, argv);
}

*/

#ifdef __cplusplus
}
#endif

#endif // GOOGLE_PROTOBUF_COMPILER_RUBY_GENERATOR_H
