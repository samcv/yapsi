use v6;

use Test;
plan *;

use Yapsi;

my $out;
sub clear-out() { $out = '' }
my $io-collector = class { method say($i) {$out ~= $i ~ "\n"} };

my Yapsi::Compiler $compiler .= new;
my Yapsi::Runtime $runtime .= new( :io($io-collector) );

my @tests =
    'say 42',                          "42\n",      'printing',
    'my $a = 42; say $a',              "42\n",      'variables',
    'my $a = 5; my $b = $a; say $b',   "5\n",       'assignment',
    'my $b := my $a; $a = 7; say $b',  "7\n",       'binding',
    'say my $a',                       "Any()\n",   'uninitialized',
    'say say 42',                      "42\n1\n",   'return value of say',
    'my $a = 42; my $a; say $a',       "42\n",      'same scope, same var',
;

for @tests -> $program, $expected, $message {
    clear-out;
    $runtime.run( $compiler.compile($program) );

    is $out, $expected, $message;
}

done_testing;