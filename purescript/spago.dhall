{ name = "CIS194"
, dependencies = [ "arrays", "console", "effect", "maybe", "psci-support", "stringutils" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
