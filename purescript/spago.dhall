{ name = "CIS194"
, dependencies = [ "arrays", "console", "effect", "maybe", "psci-support", "spec", "stringutils" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
