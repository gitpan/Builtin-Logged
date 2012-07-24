
use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
  "build_requires" => {
    "File::Slurp" => 0,
    "File::Which" => 0,
    "File::chdir" => 0,
    "Module::Build" => "0.3601",
    "Test::More" => "0.96",
    "UUID::Random" => 0
  },
  "configure_requires" => {
    "Module::Build" => "0.3601"
  },
  "dist_abstract" => "Alias for Log::Any::For::Builtins",
  "dist_author" => [
    "Steven Haryanto <stevenharyanto\@gmail.com>"
  ],
  "dist_name" => "Builtin-Logged",
  "dist_version" => "0.05",
  "license" => "perl",
  "module_name" => "Builtin::Logged",
  "recommends" => {},
  "recursive_test_files" => 1,
  "requires" => {
    "Exporter::Lite" => 0,
    "SHARYANTO::Proc::ChildError" => 0,
    "SHARYANTO::String::Util" => "0.19",
    "parent" => 0,
    "perl" => "5.010000"
  },
  "script_files" => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;
