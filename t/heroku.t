use strict;
use warnings;
use Test::More;
use Net::Heroku;

use constant TEST => $ENV{TEST_ONLINE};

my $username = 'cpantests@empireenterprises.com';
my $api_key  = 'f3d3e05d403651c24d1dc36532fe6b3884baf76a';

ok my $h = Net::Heroku->new(api_key => $api_key);

subtest apps => sub {
  #plan skip_all => 'because' unless TEST;

  ok my %res = $h->create(stack => 'bamboo');
  like $res{stack} => qr/^bamboo/;

  ok grep $_->{name} eq $res{name} => $h->apps;

  ok $h->destroy(name => $res{name});
  ok !grep $_->{name} eq $res{name} => $h->apps;
};

subtest config => sub {
  plan skip_all => 'because' unless TEST;

  ok my $res = $h->create;

  $h->add_config(name => $res->{name}, TEST_CONFIG => 'Net-Heroku');
  is $h->config(name => $res->{name})->{TEST_CONFIG} => 'Net-Heroku';

  ok $h->destroy(name => $res->{name});
};

subtest keys => sub {
  plan skip_all => 'because' unless TEST;

  my $key = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQCwiIC7DZYfPbSn/O82ei262gnExmsvx27nkmNgl5scyYhJjwMkZrl66zofAkwsydxl+7fNfKio+FsdutNva4yVruk011fzKU+Nsa5jEe0MF/x0e6QwBLtq9QthWomgvoNccV9g3TkkjykCFQQ7aLId1Wur0B+MzwCIVZ5Cm/+K2w== cpantests-net-heroku';

  ok $h->add_key(key => $key);
  ok grep $_->{contents} eq $key => $h->keys;

  $h->remove_key(key_name => 'cpantests-net-heroku');
  ok !grep $_->{contents} eq $key => $h->keys;
};

subtest processes => sub {
  plan skip_all => 'because' unless TEST;

  ok my $res = $h->create;
  ok grep defined $_->{pretty_state} => $h->ps(name => $res->{name});

  ok my $ps = $h->run(name => $res->{name}, command => 'ls');
  is $ps->{action} => 'complete';

  ok $h->restart(name => $res->{name}), 'restart app';
  ok $h->restart(name => $res->{name}, ps => 'ls'), 'restart app process';

  ok $h->stop(name => $res->{name}, ps => 'ls'), 'stop app process';
};

done_testing;
