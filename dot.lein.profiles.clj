{:user {:pedantic? :abort
        :aws {:access-key #=(eval (System/getenv "AWS_ACCESS_KEY_ID"))
              :secret-key #=(eval (System/getenv "AWS_SECRET_ACCESS_KEY")) :endpoint "eu-west-1"}}
 :repl {:plugins [[cider/cider-nrepl "0.10.0" :exclusions [org.clojure/tools.nrepl]]
                  [refactor-nrepl "2.0.0-SNAPSHOT" :exclusions [org.clojure/tools.nrepl]]]
        :dependencies [[org.clojure/tools.nrepl "0.2.12"]
                       [org.clojure/tools.reader "1.0.0-alpha1"]
                       [org.clojure/tools.cli "0.3.1"] ; marginalia clashing with leiningen below
                       [leiningen "2.5.2" :exclusions [org.codehaus.plexus/plexus-utils org.apache.maven.wagon/wagon-provider-api commons-codec slingshot]]
                       [org.apache.maven.wagon/wagon-provider-api "2.9"]
                       [alembic "0.3.2"]
                       [io.aviso/pretty "0.1.19"]
                       [im.chit/vinyasa "0.4.1"]]
        :injections
        [(require 'leiningen.core.main)
         (require '[vinyasa.inject :as inject])
         (require 'io.aviso.repl)
         (require '[clojure.test :refer :all])
         (require '[clojure.repl :refer :all])
         (require 'leiningen.core.main)
         (require 'alembic.still)
         
         (defn rt []
           (run-tests 'integration-testing.core-test))

         (defn reload-project []
           (alembic.still/load-project))
         
         (inject/in ;; the default injected namespace is `.`
          ;; note that `:refer, :all and :exclude can be used
          [vinyasa.inject :refer [inject [in inject-in]]]  
          [vinyasa.lein :exclude [*project*]]  
          ;; imports all functions in vinyasa.pull
          [alembic.still [distill pull]]
          ;; inject into clojure.core
          clojure.repl
          [vinyasa.reflection .> .? .* .% .%> .& .>ns .>var]
          ;; inject into clojure.core with prefix
          clojure.repl >
          [clojure.pprint pprint]
          [clojure.java.shell sh])]
        :repl-options {:init (set! *print-length* 15)}}} 
