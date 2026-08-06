function __cb_shebang --description "Generate shebang"

    switch $argv[1]

        case fish
            echo '#!/usr/bin/env fish'

        case bash sh
            echo '#!/usr/bin/env bash'

        case python py
            echo '#!/usr/bin/env python'

        case node
            echo '#!/usr/bin/env node'

        case '*'
            return 1
    end
end