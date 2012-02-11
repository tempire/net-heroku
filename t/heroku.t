use Modern::Perl + 2012;
use Test::More;
use Net::Heroku;
use Devel::Dwarn;
use Data::Dumper;

my $username = 'cpantests@empireenterprises.com';
my $api_key = 'f3d3e05d403651c24d1dc36532fe6b3884baf76a';

ok my $h = Net::Heroku->new(api_key => $api_key);

subtest apps => sub {
  #ok my $res = $h->create(name => 'net-heroku-perl');
  #is $res->{name} => 'net-heroku-perl';

  ok my $res = $h->create;
  ok $res->{name};

  ok grep $_->{name} eq $res->{name} => $h->apps;

  ok $h->destroy(name => $res->{name});

  $h->destroy(name => $_->{name}) for $h->apps;

  #
  #  ok !grep $_->{name} eq $res->{name} => $h->apps;

  #is_deeply { $h->create($name, stack => 'cedar') } => {
  #  "id"                  => 000000,
  #  "name"                => "example",
  #  "create_status"       => "complete",
  #  "created_at"          => "2011/01/01 00:00:00 -0700",
  #  "stack"               => "cedar",
  #  "requested_stack"     => undef,
  #  "repo_migrate_status" => "complete",
  #  "slug_size"           => 1000000,
  #  "repo_size"           => 1000000,
  #  "dynos"               => 1,
  #  "workers"             => 0
  #};
  #is_deeply [$h->apps] => [
  #  { "id"                  => 000000,
  #    "name"                => "example",
  #    "create_status"       => "complete",
  #    "created_at"          => "2011/01/01 00:00:00 -0700",
  #    "stack"               => "cedar",
  #    "requested_stack"     => undef,
  #    "repo_migrate_status" => "complete",
  #    "slug_size"           => 1000000,
  #    "repo_size"           => 1000000,
  #    "dynos"               => 1,
  #    "workers"             => 0
  #  }
  #];

  #is_deeply [$h->apps($name)] => [
  #  { "id"                  => 000000,
  #    "name"                => "example",
  #    "create_status"       => "complete",
  #    "created_at"          => "2011/01/01 00:00:00 -0700",
  #    "stack"               => "cedar",
  #    "requested_stack"     => undef,
  #    "repo_migrate_status" => "complete",
  #    "slug_size"           => 1000000,
  #    "repo_size"           => 1000000,
  #    "dynos"               => 1,
  #    "workers"             => 0
  #  }
  #];

  #ok $h->rename($name => $newname);

# #New owner
  #ok $h->transfer($name => $new_owner);

  #ok $h->maintenance_mode($name => 0);
  #ok !$h->maintenance_mode($name);
  #ok $h->maintenance_mode($name => 1);
  #ok $h->maintenance_mode($name);

  #ok $h->destroy($name);
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
