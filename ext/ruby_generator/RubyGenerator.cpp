#include "RubyGenerator.h"
#include <ctype.h>

namespace google {
namespace protobuf  {
namespace compiler {
namespace ruby {

RubyGenerator::RubyGenerator() {}  // Constructor
RubyGenerator::~RubyGenerator() {} // Destructor

// Generate one or more ruby source files for the given proto file.
bool RubyGenerator::Generate(const FileDescriptor* file,
                              const string& parameter,
                              GeneratorContext* context,
                              string* error) const {
  file_ = file;
  context_ = context;

  filename = CreateRubyFileName(file_->name());
  ns_vector.clear();
  extended_messages.clear();
  SplitStringUsing(file_->package(), ".", &ns_vector);

  // Get a ZeroCopyOutputStream object of the data.
  scoped_ptr<io::ZeroCopyOutputStream> output(context_->Open(filename));

  // Check the data against Google's proto checking algorithm.
  GOOGLE_CHECK(output.get());

  // Get a printer.
  io::Printer printer(output.get(), '$');
  printer_ = &printer;

  PrintGeneratedFileComment();
  PrintGenericRequires();
  PrintImportRequires();

  PrintEnclosingNamespaceModules();

  PrintEnumsForFileDescriptor(file_, false);
  PrintNewLine();
  PrintMessagesForFileDescriptor(file_, false);
  PrintNewLine();

  PrintMessagesForFileDescriptor(file_, true);

  PrintDanglingExtendedMessages();

  PrintServices();

  PrintEnclosingNamespaceModuleEnds();

  if (printer.failed()) {
    *error = "An unknown error occured writing file " + filename;
    return false;
  }
  else {
    return true;
  }
} // end Generate()

//
///////////////////////////////////////////////// [ namespaces ] //////////////
//

void RubyGenerator::PrintEnclosingNamespaceModules() const {
  PrintNewLine();
  vector<string>::iterator iter;
  map<string,string> data;
  for (iter = ns_vector.begin(); iter < ns_vector.end(); iter++) {
    data["ns"] = Constantize(*iter, false);

    printer_->Print(data, "module $ns$");
    PrintNewLine();
    printer_->Indent();
  }
}

void RubyGenerator::PrintEnclosingNamespaceModuleEnds() const {
  vector<string>::iterator iter;
  for (iter = ns_vector.begin(); iter < ns_vector.end(); iter++) {
    printer_->Outdent();
    printer_->Print("end");
    PrintNewLine();
  }
}


//
///////////////////////////////////////////////// [ messages ] ////////////////
//

// Print a comment and then iteratively PrintMessage for each message
// type defined by in this FileDescriptor scope.
//
void RubyGenerator::PrintMessagesForFileDescriptor(const FileDescriptor* descriptor, bool print_fields) const {
  if (descriptor->message_type_count() > 0) {
    if (print_fields) {
      PrintComment("Message Fields", true);
    }
    else {
      PrintComment("Message Classes", true);
      StoreExtensionFields(descriptor);
    }

    for (int i = 0; i < descriptor->message_type_count(); i++) {
      PrintMessage(descriptor->message_type(i), print_fields);
    }
  }
}

// Iterates the nested types of a message descriptor and calls PrintMessage for each.
//
void RubyGenerator::PrintMessagesForDescriptor(const Descriptor* descriptor, bool print_fields) const {
  for (int i = 0; i < descriptor->nested_type_count(); i++) {
    PrintMessage(descriptor->nested_type(i), print_fields);
  }
}

// Print out the given descriptor message as a Ruby class.
//
void RubyGenerator::PrintMessage(const Descriptor* descriptor, bool print_fields) const {
  map<string,string> data;
  data["class_name"] = descriptor->name();

  switch (print_fields) {
    case false:

      if (DescriptorHasNestedTypes(descriptor)) {
        printer_->Print(data, "class $class_name$ < ::Protobuf::Message");
        PrintNewLine();
        printer_->Indent();

        if (descriptor->enum_type_count() > 0) {
          PrintEnumsForDescriptor(descriptor, true);
        }

        if (descriptor->nested_type_count() > 0) {
          PrintMessagesForDescriptor(descriptor, false);
        }

        printer_->Outdent();
        printer_->Print(data, "end");
      }
      else {
        printer_->Print(data, "class $class_name$ < ::Protobuf::Message; end");
      }

      PrintNewLine();
      StoreExtensionFields(descriptor);

      break;

    case true:

      if (descriptor->field_count() > 0 || DescriptorHasExtensions(descriptor)) {
        printer_->Print(data, "class $class_name$");
        PrintNewLine();
        printer_->Indent();

        if (descriptor->nested_type_count() > 0) {
          PrintMessagesForDescriptor(descriptor, true);
        }

        // Print Fields
        if (descriptor->field_count() > 0) {
          for (int i = 0; i < descriptor->field_count(); i++) {
            PrintMessageField(descriptor->field(i));
          }
        }

        PrintExtensionRangesForDescriptor(descriptor);

        // Print Extension Fields
        if (DescriptorHasExtensions(descriptor)) {
          PrintMessageExtensionFields(descriptor->full_name());
        }

        printer_->Outdent();
        printer_->Print(data, "end");
        PrintNewLine();
        PrintNewLine();
      }
      else if (descriptor->nested_type_count() > 0) {
        printer_->Print(data, "class $class_name$");
        PrintNewLine();
        printer_->Indent();

        if (descriptor->nested_type_count() > 0) {
          PrintMessagesForDescriptor(descriptor, true);
        }

        printer_->Outdent();
        printer_->Print(data, "end");
        PrintNewLine();
        PrintNewLine();
      }

      break;
  }
}

void RubyGenerator::PrintExtensionRangesForDescriptor(const Descriptor* descriptor) const {
  if (descriptor->extension_range_count() > 0) {
    PrintNewLine();
    PrintComment("Extension Fields", false);

    for (int i = 0; i < descriptor->extension_range_count(); i++) {
      const Descriptor::ExtensionRange* range = descriptor->extension_range(i);
      map<string,string> data;
      data["message_class"] = Constantize(descriptor->full_name());
      data["start"] = SimpleItoa(range->start);
      data["end"] = SimpleItoa(range->end);
      printer_->Print(data, "extensions $start$...$end$");
      PrintNewLine();
    }
  }
}

// Print the given FieldDescriptor to the Message DSL methods.
void RubyGenerator::PrintMessageField(const FieldDescriptor* descriptor) const {
  string underscore_name = "";
  string camel_case_name = descriptor->name();

  for (string::iterator it = camel_case_name.begin(); it != camel_case_name.end(); ++it) {
    if (!islower(*it)) {
      underscore_name += '_';
      underscore_name += tolower(*it);
    }
    else {
      underscore_name += *it;
    }
  }

  map<string,string> data;
  data["field_presence"] = "";
  data["field_name"] = underscore_name;
  data["tag_number"] = SimpleItoa(descriptor->number());
  data["data_type"] = "";
  data["default_opt"] = "";
  data["packed_opt"] = "";
  data["deprecated_opt"] = "";
  data["extension_opt"] = "";

  if (descriptor->is_required()) {
    data["field_presence"] = "required";
  }
  else if (descriptor->is_optional()) {
    data["field_presence"] = "optional";
  }
  else if (descriptor->is_repeated()) {
    data["field_presence"] = "repeated";
  }

  switch (descriptor->type()) {
    // Primitives
    case FieldDescriptor::TYPE_DOUBLE:   data["data_type"] = "::Protobuf::Field::DoubleField"; break;
    case FieldDescriptor::TYPE_FLOAT:    data["data_type"] = "::Protobuf::Field::FloatField"; break;
    case FieldDescriptor::TYPE_INT64:    data["data_type"] = "::Protobuf::Field::Int64Field"; break;
    case FieldDescriptor::TYPE_UINT64:   data["data_type"] = "::Protobuf::Field::Uint64Field"; break;
    case FieldDescriptor::TYPE_INT32:    data["data_type"] = "::Protobuf::Field::Int32Field"; break;
    case FieldDescriptor::TYPE_FIXED64:  data["data_type"] = "::Protobuf::Field::Fixed64Field"; break;
    case FieldDescriptor::TYPE_FIXED32:  data["data_type"] = "::Protobuf::Field::Fixed32Field"; break;
    case FieldDescriptor::TYPE_BOOL:     data["data_type"] = "::Protobuf::Field::BoolField"; break;
    case FieldDescriptor::TYPE_STRING:   data["data_type"] = "::Protobuf::Field::StringField"; break;
    case FieldDescriptor::TYPE_BYTES:    data["data_type"] = "::Protobuf::Field::BytesField"; break;
    case FieldDescriptor::TYPE_UINT32:   data["data_type"] = "::Protobuf::Field::Uint32Field"; break;
    case FieldDescriptor::TYPE_SFIXED32: data["data_type"] = "::Protobuf::Field::Sfixed32Field"; break;
    case FieldDescriptor::TYPE_SFIXED64: data["data_type"] = "::Protobuf::Field::Sfixed64Field"; break;
    case FieldDescriptor::TYPE_SINT32:   data["data_type"] = "::Protobuf::Field::Sint32Field"; break;
    case FieldDescriptor::TYPE_SINT64:   data["data_type"] = "::Protobuf::Field::Sint64Field"; break;

    // Enums
    case FieldDescriptor::TYPE_ENUM:
      data["data_type"] = Constantize(descriptor->enum_type()->full_name());
      break;

    // Messages
    case FieldDescriptor::TYPE_GROUP:
    case FieldDescriptor::TYPE_MESSAGE:
    default:
      data["data_type"] = Constantize(descriptor->message_type()->full_name());
      break;
  }

  if (descriptor->has_default_value()) {
    string value;
    switch(descriptor->cpp_type()) {
      case FieldDescriptor::CPPTYPE_INT32:  value = SimpleItoa(descriptor->default_value_int32()); break;
      case FieldDescriptor::CPPTYPE_INT64:  value = SimpleItoa(descriptor->default_value_int64()); break;
      case FieldDescriptor::CPPTYPE_UINT32: value = SimpleItoa(descriptor->default_value_uint32()); break;
      case FieldDescriptor::CPPTYPE_UINT64: value = SimpleItoa(descriptor->default_value_uint64()); break;
      case FieldDescriptor::CPPTYPE_DOUBLE: value = SimpleDtoa(descriptor->default_value_double()); break;
      case FieldDescriptor::CPPTYPE_FLOAT:  value = SimpleFtoa(descriptor->default_value_float()); break;
      case FieldDescriptor::CPPTYPE_BOOL:   value = descriptor->default_value_bool() ? "true" : "false"; break;
      case FieldDescriptor::CPPTYPE_ENUM:   value = FullEnumNamespace(descriptor->default_value_enum()); break;
      case FieldDescriptor::CPPTYPE_STRING: value = "\"" + descriptor->default_value_string() + "\""; break;
      default: break;
    }
    data["default_opt"] = strings::Substitute(", :default => $0", value);
  }

  if (descriptor->is_packable() && descriptor->options().has_packed()) {
    string packed_bool = descriptor->options().packed() ? "true" : "false";
    data["packed_opt"] = strings::Substitute(", :packed => $0", packed_bool);
  }

  if (descriptor->options().has_deprecated()) {
    string deprecated_bool = descriptor->options().deprecated() ? "true" : "false";
    data["deprecated_opt"] = strings::Substitute(", :deprecated => $0", deprecated_bool);
  }

  if (descriptor->is_extension()) {
    data["extension_opt"] = ", :extension => true";
  }

  printer_->Print(data,
    "$field_presence$ "
    "$data_type$, "
    ":$field_name$, "
    "$tag_number$"
    "$default_opt$"
    "$packed_opt$"
    "$deprecated_opt$"
    "$extension_opt$");
  PrintNewLine();
}

// Print out each extension field previously mapped to the full name of
// the descriptor message.
//
// After printign the fields, erase the fields from the map so that we know
// which fields are dangling and to print wrapped in a re-opened class block.
//
void RubyGenerator::PrintMessageExtensionFields(const string full_name) const {
  vector<const FieldDescriptor*> message_extensions = extended_messages[full_name];
  vector<const FieldDescriptor*>::iterator it;
  for (it = message_extensions.begin(); it != message_extensions.end(); ++it) {
    PrintMessageField(*it);
  }
  extended_messages.erase(full_name);
}

//
///////////////////////////////////////////////// [ enums ] ///////////////////
//

void RubyGenerator::PrintEnumsForDescriptor(const Descriptor* descriptor, bool print_values) const {
  for (int i = 0; i < descriptor->enum_type_count(); i++) {
    PrintEnum(descriptor->enum_type(i));
  }
}

void RubyGenerator::PrintEnumsForFileDescriptor(const FileDescriptor* descriptor, bool print_values) const {
  if (descriptor->enum_type_count() > 0) {
    if (print_values) {
      PrintComment("Enum Values", true);
    }
    else {
      PrintComment("Enum Classes", true);
    }

    for (int i = 0; i < descriptor->enum_type_count(); i++) {
      PrintEnum(descriptor->enum_type(i));
    }
  }
}

// Print the given enum descriptor as a Ruby class.
void RubyGenerator::PrintEnum(const EnumDescriptor* descriptor) const {
  map<string,string> data;
  data["class_name"] = descriptor->name();

  printer_->Print(data, "class $class_name$ < ::Protobuf::Enum");
  printer_->Indent();
  PrintNewLine();

  for (int i = 0; i < descriptor->value_count(); i++) {
    PrintEnumValue(descriptor->value(i));
  }

  printer_->Outdent();
  printer_->Print(data, "end");
  PrintNewLine();

  PrintNewLine();
}

// Print the given enum value to the Enum class DSL methods.
void RubyGenerator::PrintEnumValue(const EnumValueDescriptor* descriptor) const {
  map<string,string> data;
  data["name"] = descriptor->name();
  data["number"] = ConvertIntToString(descriptor->number());
  printer_->Print(data, "define :$name$, $number$");
  PrintNewLine();
}

//
///////////////////////////////////////////////// [ services ] ////////////////
//

void RubyGenerator::PrintServices() const {
  if (file_->service_count() > 0) {
    PrintComment("Services", true);
    for (int i = 0; i < file_->service_count(); i++) {
      PrintService(file_->service(i));
    }
  }
}

// Print the given service as a Ruby class.
void RubyGenerator::PrintService(const ServiceDescriptor* descriptor) const {
  map<string,string> data;
  data["class_name"] = descriptor->name();

  printer_->Print(data, "class $class_name$ < ::Protobuf::Rpc::Service");
  PrintNewLine();
  printer_->Indent();

  for (int i = 0; i < descriptor->method_count(); i++) {
    PrintServiceMethod(descriptor->method(i));
  }

  printer_->Outdent();
  printer_->Print("end");
  PrintNewLine();
}

// Print the rpc DSL declaration to the Ruby service class.
void RubyGenerator::PrintServiceMethod(const MethodDescriptor* descriptor) const {
  map<string,string> data;
  data["name"] = Underscore(descriptor->name());
  data["request_klass"] = Constantize(descriptor->input_type()->full_name());
  data["response_klass"] = Constantize(descriptor->output_type()->full_name());
  printer_->Print(data, "rpc :$name$, $request_klass$, $response_klass$");
  PrintNewLine();
}


//
///////////////////////////////////////////////// [ general ] ////////////////
//

void RubyGenerator::PrintDanglingExtendedMessages() const {
  if (extended_messages.size() > 0) {
    PrintComment("Extended Messages", true);

    tr1::unordered_map<string, vector<const FieldDescriptor*> >::iterator it;
    for (it = extended_messages.begin(); it != extended_messages.end(); ++it ) {
      map<string,string> data;
      data["class_name"] = Constantize(it->first);

      printer_->Print(data, "class $class_name$");
      printer_->Indent();
      PrintNewLine();

      PrintMessageExtensionFields(it->first);

      printer_->Outdent();
      printer_->Print(data, "end");
      PrintNewLine();
      PrintNewLine();
    }
  }
}

// Explicitly check for the key with `count` so that we don't create
// empty vectors for classes simply using bracket access.
//
bool RubyGenerator::DescriptorHasExtensions(const Descriptor* descriptor) const {
  const string full_name = descriptor->full_name();
  if (extended_messages.count(full_name) > 0) {
    return (extended_messages[full_name].size());
  }
  else {
    return 0;
  }
}

// Print a header or one-line comment (as indicated by the as_header bool).
void RubyGenerator::PrintComment(string comment, bool as_header) const {
  char format[] = "# $comment$\n";
  char format_multi[] = "##\n# $comment$\n#\n";

  map<string,string> data;
  data["comment"] = comment;

  if (as_header) {
    printer_->Print(data, format_multi);
  }
  else {
    printer_->Print(data, format);
  }
}

// Prints a require with the given ruby library.
void RubyGenerator::PrintRequire(string lib_name) const {
  map<string,string> data;
  data["lib"] = lib_name;
  printer_->Print(data, "require '$lib$'\n");
}

// Print a comment indicating that the file was generated.
void RubyGenerator::PrintGeneratedFileComment() const {
  PrintComment("This file is auto-generated. DO NOT EDIT!", true);
}

// Print out message requires as they pertain to the ruby library.
void RubyGenerator::PrintGenericRequires() const {
  if (file_->message_type_count() > 0) {
    PrintRequire("protobuf/message");
  }
  if (file_->service_count() > 0) {
    PrintRequire("protobuf/rpc/service");
  }
}

void RubyGenerator::PrintImportRequires() const {
  if (file_->dependency_count() > 0) {
    PrintNewLine();
    PrintComment("Imports", true);
    for (int i = 0; i < file_->dependency_count(); i++) {
      PrintRequire(CreateRubyFileName(file_->dependency(i)->name(), true));
    }
  }
}

// Print a one-line comment.
void RubyGenerator::PrintComment(string comment) const {
  PrintComment(comment, false);
}

void RubyGenerator::PrintNewLine() const {
  printer_->Print("\n");
}

// We need to store any extension fields defined in the scope of this
// descriptor message by the field's containing type.
void RubyGenerator::StoreExtensionFields(const FileDescriptor* descriptor) const {
  for (int i = 0; i < descriptor->extension_count(); i++) {
    const FieldDescriptor* extension_field = descriptor->extension(i);
    const Descriptor* containing = extension_field->containing_type();
    extended_messages[containing->full_name()].push_back(extension_field);
  }
}

// Same as above, only accept the Descriptor type instead of FileDescriptor.
void RubyGenerator::StoreExtensionFields(const Descriptor* descriptor) const {
  for (int i = 0; i < descriptor->extension_count(); i++) {
    const FieldDescriptor* extension_field = descriptor->extension(i);
    const Descriptor* containing = extension_field->containing_type();
    extended_messages[containing->full_name()].push_back(extension_field);
  }
}

} // namespace ruby
} // namespace compiler
} // namespace protobuf
} // namespace google
