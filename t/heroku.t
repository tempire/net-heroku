use Modern::Perl + 2012;
use Test::More;
use Net::Heroku;
use Devel::Dwarn;
use Data::Dumper;

my $username = 'cpantests@empireenterprises.com';
my $api_key  = 'f3d3e05d403651c24d1dc36532fe6b3884baf76a';

ok my $h = Net::Heroku->new(api_key => $api_key);

subtest apps => sub {
  plan skip_all => 'because';

  #ok my $res = $h->create(name => 'net-heroku-perl');
  #is $res->{name} => 'net-heroku-perl';

  ok my $res = Dwarn $h->create(stack => 'bamboo');
  like $res->{stack} => qr/^bamboo/;

  ok grep $_->{name} eq $res->{name} => $h->apps;
  warn Dumper $h->apps;

  ok $h->destroy(name => $res->{name});

  #
  #  ok !grep $_->{name} eq $res->{name} => $h->apps;
};

subtest config => sub {
  plan skip_all => 'because';
  ok my $res = Dwarn $h->create;
  my $buildpack_url = 'http://github.com/judofyr/perloku.git';

  $h->add_config(name => $res->{name}, BUILDPACK_URL => $buildpack_url);
  is $h->config(name => $res->{name})->{BUILDPACK_URL} => $buildpack_url;

  ok $h->destroy(name => $res->{name});
};

subtest keys => sub {
  ok my $res = Dwarn $h->create;

  $h->add_key(key => '123412341234');
  ok grep $_->{key} == '123412341234' => $h->keys;

  $h->remove_key(key => '123412341234');
  ok !grep $_->{key} == '123412341234' => $h->keys;
};

#subtests processes => sub {
#  is_deeply { $h->ps($name) } => {
#    "upid"            => "0000000",
#    "process"         => "web.1",
#    "type"            => "Dyno",
#    "command"         => "dyno",
#    "app_name"        => "example",
#    "slug"            => "0000000_0000",
#    "action"          => "down",
#    "state"           => "idle" "pretty_state" => "idle for 2h",
#    "elapsed"         => 0,
#    "rendezvous_url"  => undef,
#    "attached"        => 0,
#    "transitioned_at" => "2011/01/01 00 =>00 =>00 -0700",
#  };
#
#  is_deeply { $h->run($name => $command) } => {
#    "slug"    => "0000000_0000",
#    "command" => "ls",
#    "upid"    => "00000000",
#    "process" => "run.1",
#    "action"  => "complete",
#    "rendezvous_url" =>
#      "tcp =>//rendezvous.heroku.com =>5000/0000000000000000000",
#    "type"            => "Ps",
#    "elapsed"         => 0,
#    "attached"        => 1,
#    "transitioned_at" => "2011/01/01 00 =>00 =>00 -0700",
#    "state"           => "starting"
#  };
#
#  ok $h->restart($name);
#  ok $h->restart($name, process => $command);
#  ok $h->restart($name, type    => $command);
#
#  ok $h->stop($name);
#  ok $h->stop($name, process => $command);
#  ok $h->stop($name, type    => $command);
#
#  ok 1;
#};
#
#subtests logs => sub {
#  ok $h->logs($name);
#  ok $h->logs($name, num => 10, ps => $process, source => $source);
#};

done_testing;
