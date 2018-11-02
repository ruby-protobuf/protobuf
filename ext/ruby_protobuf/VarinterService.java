import org.jruby.Ruby;
import org.jruby.RubyModule;
import org.jruby.runtime.load.BasicLibraryService;

import java.io.IOException;

public class VarinterService implements BasicLibraryService {

    @Override
    public boolean basicLoad(final Ruby runtime) throws IOException {
        RubyModule varinter = runtime.defineModule(Varinter.class.getSimpleName());
        varinter.defineAnnotatedMethods(Varinter.class);

        RubyModule uint64_protobuf = runtime.defineModule(Uint64ProtobufField.class.getSimpleName());
        uint64_protobuf.defineAnnotatedMethods(Uint64ProtobufField.class);

        RubyModule uint32_protobuf = runtime.defineModule(Uint32ProtobufField.class.getSimpleName());
        uint32_protobuf.defineAnnotatedMethods(Uint32ProtobufField.class);

        RubyModule sint64_protobuf = runtime.defineModule(Sint64ProtobufField.class.getSimpleName());
        sint64_protobuf.defineAnnotatedMethods(Sint64ProtobufField.class);

        RubyModule sint32_protobuf = runtime.defineModule(Sint32ProtobufField.class.getSimpleName());
        sint32_protobuf.defineAnnotatedMethods(Sint32ProtobufField.class);

        RubyModule int64_protobuf = runtime.defineModule(Int64ProtobufField.class.getSimpleName());
        int64_protobuf.defineAnnotatedMethods(Int64ProtobufField.class);

        RubyModule int32_protobuf = runtime.defineModule(Int32ProtobufField.class.getSimpleName());
        int32_protobuf.defineAnnotatedMethods(Int32ProtobufField.class);

        RubyModule varint_protobuf_field = runtime.defineModule(VarintProtobufField.class.getSimpleName());
        varint_protobuf_field.defineAnnotatedMethods(VarintProtobufField.class);

        return true;
    }

}
