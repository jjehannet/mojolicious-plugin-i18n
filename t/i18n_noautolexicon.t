#!/usr/bin/env perl
use lib qw(lib ../lib ../mojo/lib ../../mojo/lib);
use utf8;

use Mojo::Base -strict;

# Disable Bonjour, IPv6 and libev
BEGIN {
  $ENV{MOJO_NO_BONJOUR} = $ENV{MOJO_NO_IPV6} = 1;
  $ENV{MOJO_IOWATCHER} = 'Mojo::IOWatcher';
}

use Test::More;

package App::I18N;
use base 'Locale::Maketext';

package App::I18N::en;
use Mojo::Base 'App::I18N';

our %Lexicon = (_AUTO => 0);

package main;

use Test::Mojo;

use Mojolicious::Lite;

# I18N plugin
plugin 'I18N' => { namespace => 'App::I18N', default => 'en', support_url_langs => [qw(en)] };

my $t = Test::Mojo->new;

my $controller = $t->app->build_controller;
$controller->languages(['en']);

eval { is $controller->l("hello"), "hello"; };
like $@, qr/maketext doesn\'t know how to say:\nhello.*/;

done_testing;
