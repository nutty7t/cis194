{ name = "CIS194"
, dependencies = [ "arrays", "console", "effect", "generics-rep", "maybe", "node-fs", "node-path", "psci-support", "spec", "stringutils", "transformers", "tuples" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
