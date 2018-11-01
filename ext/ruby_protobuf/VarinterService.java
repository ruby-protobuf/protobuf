import org.jruby.Ruby;
import org.jruby.RubyModule;
import org.jruby.runtime.load.BasicLibraryService;

import java.io.IOException;

public class VarinterService implements BasicLibraryService {

    @Override
    public boolean basicLoad(final Ruby runtime) throws IOException {
        RubyModule varinter = runtime.defineModule(Varinter.class.getSimpleName());
        varinter.defineAnnotatedMethods(Varinter.class);

        return true;
    }

}
