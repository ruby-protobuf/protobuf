#include <google/protobuf/compiler/command_line_interface.h>
#include "RubyGenerator.h"

int main (int argc, char* argv[]) {
  google::protobuf::compiler::CommandLineInterface cli;

  // Support generation of C++ source and headers.
  google::protobuf::compiler::ruby::RubyGenerator ruby_generator;
  cli.RegisterGenerator("--ruby_out", &ruby_generator,
    "Generate Ruby-compatible protobuf message and service classes.");

  return cli.Run(argc, argv);
}
