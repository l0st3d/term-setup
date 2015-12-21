{:user {:pedantic? :abort
        :plugins [[cider/cider-nrepl "0.10.0" :exclusions [org.clojure/tools.nrepl]] ;; :exclusions [org.clojure/java.classpath]
                  [refactor-nrepl "2.0.0-SNAPSHOT" :exclusions [org.clojure/tools.nrepl]]]
        
        ;; :repositories [["nexus-public" "http://nexus.sbgdev.com:8081/content/groups/public"]]
        :dependencies [
                       [org.clojure/tools.nrepl "0.2.12"]
                       [org.clojure/tools.reader "1.0.0-alpha1"]
                       ;; [spyscope "0.1.5" :exclusions [clj-time]]
                       ;; [clj-time "0.11.0"]
                       ;; [eftest "0.1.0"]
                       ;; [clj-http "0.9.2"]
                       ;; [cheshire "5.5.0"]
                       ;; [org.clojure/data.json "0.2.6"]
                       ;; [org.clojure/tools.namespace "0.2.11"]
                       [leiningen "2.5.2" :exclusions [org.codehaus.plexus/plexus-utils
                                                       org.apache.maven.wagon/wagon-provider-api
                                                       commons-codec
                                                       slingshot
                                                       ;; org.apache.httpcomponents/httpclient
                                                       ]]
                       [org.apache.maven.wagon/wagon-provider-api "2.9"]
                       [alembic "0.3.2"]
                       [io.aviso/pretty "0.1.19"]
                       [im.chit/vinyasa "0.4.1"]]
        :injections
        [;; (require 'spyscope.core)
         (require 'leiningen.core.main)
         (require '[vinyasa.inject :as inject])
         (require 'io.aviso.repl)
         ;; (require 'eftest.runner)
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
          [clojure.java.shell sh])]}}







;; {:user
;;  {:plugins [...]        
;;   :dependencies [[spyscope "0.1.4"]
;;                  [org.clojure/tools.namespace "0.2.4"]
;;                  [leiningen #=(leiningen.core.main/leiningen-version)]
;;                  [io.aviso/pretty "0.1.8"]
;;                  [im.chit/vinyasa "0.3.4"]]
;;   :injections
;;   [(require 'spyscope.core)
;;    (require '[vinyasa.inject :as inject])
;;    (require 'io.aviso.repl)
;;    (inject/in ;; the default injected namespace is `.`

;;     ;; note that `:refer, :all and :exclude can be used
;;     [vinyasa.inject :refer [inject [in inject-in]]]  
;;     [vinyasa.lein :exclude [*project*]]  

;;     ;; imports all functions in vinyasa.pull
;;     [alembic.still [distill pull]]

;;     ;; inject into clojure.core
;;     clojure.core
;;     [vinyasa.reflection .> .? .* .% .%> .& .>ns .>var]

;;     ;; inject into clojure.core with prefix
;;     clojure.core >
;;     [clojure.pprint pprint]
;;     [clojure.java.shell sh])]}}

;; {:user {:plugins [[lein-cljsbuild "1.0.0"]
;;                   [lein-clojars "0.9.1"]
;;                   [lein-midje    "3.1.3"]
;;                   [lein-midje-doc "0.0.18"]
;;                   [codox "0.6.6"]]
;;         :dependencies [[spyscope "0.1.4"]
;;                        [org.clojure/tools.namespace "0.2.4"]
;;                        [io.aviso/pretty "0.1.8"]
;;                        [im.chit/vinyasa "0.1.2"]]
;;         :injections [(require 'spyscope.core)
;;                      (require 'vinyasa.inject)

;;                      (vinyasa.inject/inject 'clojure.core
;;                                             '[[vinyasa.inject [inject inject]]
;;                                               [vinyasa.pull [pull pull]]
;;                                               [vinyasa.lein [lein lein]]
;;                                               [clojure.repl apropos dir doc find-doc source 
;;                                                [root-cause cause]]
;;                                               [clojure.tools.namespace.repl [refresh refresh]]
;;                                               [clojure.pprint [pprint >pprint]]
;;                                               [io.aviso.binary [write-binary >bin]]])

;;                      (require 'io.aviso.repl 
;;                               'clojure.repl 
;;                               'clojure.main)
;;                      (alter-var-root #'clojure.main/repl-caught
;;                                      (constantly @#'io.aviso.repl/pretty-pst))
;;                      (alter-var-root #'clojure.repl/pst
;;                                      (constantly @#'io.aviso.repl/pretty-pst))]}}


;; :repl-options {:nrepl-middleware
;;                [cider.nrepl.middleware.apropos/wrap-apropos
;;                 cider.nrepl.middleware.classpath/wrap-classpath
;;                 cider.nrepl.middleware.complete/wrap-complete
;;                 cider.nrepl.middleware.debug/wrap-debug
;;                 cider.nrepl.middleware.format/wrap-format
;;                 cider.nrepl.middleware.info/wrap-info
;;                 cider.nrepl.middleware.inspect/wrap-inspect
;;                 cider.nrepl.middleware.macroexpand/wrap-macroexpand
;;                 cider.nrepl.middleware.ns/wrap-ns
;;                 cider.nrepl.middleware.pprint/wrap-pprint
;;                 cider.nrepl.middleware.refresh/wrap-refresh
;;                 cider.nrepl.middleware.resource/wrap-resource
;;                 cider.nrepl.middleware.stacktrace/wrap-stacktrace
;;                 cider.nrepl.middleware.test/wrap-test
;;                 cider.nrepl.middleware.trace/wrap-trace
;;                 ;; cider.nrepl.middleware.out/wrap-out
;;                 cider.nrepl.middleware.undef/wrap-undef]}

