#!/usr/bin/env perl

$quoted = qr{
    " (?<content> (?: [^"\\] | \\. )* ) "
  | ' (?<content> (?: [^'\\] | \\. )* ) '
  | (?<content> [\w\-.]+ )
  }x;

$exclude = qr{^(http|\#|mailto:)};

$field = qr{
    (?: src | href | url | srcset | data-src | data-srcset | poster )
}x;

$\ = "\n";
while (<>) {
    if (/^(.*)<!--/) {
        while ($1 =~ m/$field=$quoted/g) {
            push @deps, $+{content} unless $+{content} =~ /$exclude/;
        }
        unless (m/-->/) {
            while (<>) {
                last if /-->/;
            }
        }
        s/.*-->//;
    }
    while (m/$field=$quoted/g) {
        push @deps, $+{content} unless $+{content} =~ /$exclude/;
    }
}

print for grep { !$_{$_}++ } @deps;
