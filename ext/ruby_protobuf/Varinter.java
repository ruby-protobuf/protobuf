import java.io.IOException;
import java.io.InputStream;
import java.io.ByteArrayOutputStream;
import java.util.concurrent.ConcurrentMap;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Function;
import org.jcodings.specific.ASCIIEncoding;
import org.jruby.Ruby;
import org.jruby.RubyBignum;
import org.jruby.RubyComplex;
import org.jruby.RubyFixnum;
import org.jruby.RubyFloat;
import org.jruby.RubyInteger;
import org.jruby.RubyNumeric;
import org.jruby.RubyString;
import org.jruby.RubyIO;
import org.jruby.ext.stringio.StringIO;
import org.jruby.util.ByteList;
import org.jruby.anno.JRubyMethod;
import org.jruby.runtime.ThreadContext;
import org.jruby.runtime.builtin.IRubyObject;

public class Varinter {
  private static byte[] internal_to_varint(long value) {
    java.io.ByteArrayOutputStream bytes = new java.io.ByteArrayOutputStream();

    while (value > 0x7f) {
      bytes.write((byte) (0x80 | (value & 0x7f)));
      value >>= 7;
    }

    bytes.write((byte) value);
    return bytes.toByteArray();
  }

  @JRubyMethod
  public static IRubyObject to_varint( ThreadContext context, IRubyObject self ) {
    if (!(self instanceof RubyFixnum)) {
      return context.nil;
    }

    long value = ((RubyFixnum) self).getLongValue();
    org.jruby.Ruby runtime = context.getRuntime();
    RubyString bit_string = runtime.newString(new ByteList(internal_to_varint(value), true));
    bit_string.force_encoding(context, runtime.getEncodingService().getEncoding(org.jcodings.specific.ASCIIEncoding.INSTANCE));
    return bit_string;
  }

  @JRubyMethod
  public static IRubyObject to_varint2( ThreadContext context, IRubyObject self ) throws IOException {
    if (!(self instanceof RubyFixnum)) {
      return context.nil;
    }

    long v = ((RubyFixnum) self).getLongValue();
    java.io.ByteArrayOutputStream bytes = new java.io.ByteArrayOutputStream();
    org.jruby.Ruby runtime = context.getRuntime();

    do {
      // Encode next 7 bits + terminator bit
      long bits = v & 0x7F;
      v >>>= 7;
      byte b = (byte) (bits | ((v != 0) ? 0x80 : 0));
      bytes.write(b);
    } while (v != 0);

    return runtime.newString(bytes.toString());
  }

  @JRubyMethod
  public static IRubyObject read_varint(ThreadContext context, IRubyObject self) throws IOException {
    long value = 0L;
    int index = 0;
    long current_byte;

    if (self instanceof StringIO) {
      StringIO current_self = ((StringIO)self);
      RubyFixnum fixnum;

      do {
        fixnum = ((RubyFixnum)(current_self.getbyte(context)));
        current_byte = fixnum.getLongValue();
        if (index == 0 && current_byte < 128) { return context.getRuntime().newFixnum(current_byte); }
        value = (value | ((current_byte & 0x7f) << (7 * index)));
        index++;
      } while ((current_byte & 0x80) != 0);

      return context.getRuntime().newFixnum(value);
    }

    if (self instanceof RubyIO) {
      RubyIO current_self = ((RubyIO)self);

      do {
        current_byte = current_self.getByte(context);
        if (index == 0 && current_byte < 128) { return context.getRuntime().newFixnum(current_byte); }
        value = (value | ((current_byte & 0x7f) << (7 * index)));
        index++;
      } while ((current_byte & 0x80) != 0);

      return context.getRuntime().newFixnum(value);
    }

    return context.nil;
  }
}
