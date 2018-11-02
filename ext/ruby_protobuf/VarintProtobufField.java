import java.lang.Math;
import org.jruby.Ruby;
import org.jruby.RubyBignum;
import org.jruby.RubyComplex;
import org.jruby.RubyFixnum;
import org.jruby.RubyFloat;
import org.jruby.RubyInteger;
import org.jruby.RubyNumeric;
import org.jruby.RubyString;
import org.jruby.util.TypeConverter;
import org.jruby.anno.JRubyMethod;
import org.jruby.runtime.ThreadContext;
import org.jruby.runtime.builtin.IRubyObject;

public class VarintProtobufField {
  private static final long MIN = 0L;
  private static final long MAX = ((long)java.lang.Math.pow(2, 31) - 1);
  private static String TYPE = "Varint";

  private static boolean internal_acceptable(IRubyObject self) {
    if (self instanceof RubyInteger || self instanceof RubyFixnum) {
      long value = ((RubyFixnum) self).getLongValue();
      return value >= MIN && value <= MAX;
    }

    return false;
  }

  @JRubyMethod(name = "acceptable?")
  public static IRubyObject acceptable_p( ThreadContext context, IRubyObject self ) {
    org.jruby.Ruby runtime = context.getRuntime();

    if (internal_acceptable(self)) {
      return runtime.getTrue();
    }

    return runtime.getFalse();
  }

  @JRubyMethod(name = "coerce!")
  public static IRubyObject coerce_bang( ThreadContext context, IRubyObject self ) {
    org.jruby.Ruby runtime = context.getRuntime();

    if (!internal_acceptable(self)) {
      throw runtime.newTypeError("can't convert " + self.getMetaClass() + " into " + TYPE);
    }

    if (self instanceof RubyInteger) {
      return ((RubyInteger)self).to_i();
    }

    if (self instanceof RubyFixnum) {
      return ((RubyFixnum)self).to_i();
    }

    return org.jruby.util.TypeConverter.convertToInteger(context, self, 10);
  }
}
