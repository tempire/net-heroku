package Net::Heroku;
use Mojo::Base -base;
use Net::Heroku::UserAgent;
use Mojo::JSON;
use Mojo::Util 'url_escape';

our $VERSION = 0.01;

has host => 'api.heroku.com';
has ua => sub { Net::Heroku::UserAgent->new(host => shift->host) };
has 'api_key';

sub new {
  my $self = shift->SUPER::new(@_);
  $self->ua->api_key($self->api_key);
  return $self;
}

sub apps {
  my ($self, $name) = @_;

  return @{$self->ua->get('/apps')->res->json};
}

sub app_created {
  my ($self, %params) = (shift, @_);

  return 1
    if $self->ua->put('/apps/' . $params{name} . '/status')->res->code == 201;
}

sub destroy {
  my ($self, %params) = @_;

  my $res = $self->ua->delete('/apps/' . $params{name})->res;
  return 1 if $res->{code} == 200;
}

sub create {
  my ($self, %params) = (shift, @_);

  my @ar = map +("app[$_]" => $params{$_}) => keys %params;
  %params = (
    'app[stack]' => 'cedar',
    @ar,
  );

  return %{$self->ua->post_form('/apps', {%params})->res->json};
}

sub add_config {
  my ($self, %params) = (shift, @_);

  return %{
    $self->ua->put(
          '/apps/'
        . delete($params{name})
        . '/config_vars' => Mojo::JSON->new->encode(\%params)
      )->res->json
    };
}

sub config {
  my ($self, %params) = (shift, @_);

  return %{$self->ua->get('/apps/' . $params{name} . '/config_vars')->res->json};
}

sub add_key {
  my ($self, %params) = (shift, @_);

  return 1
    if $self->ua->post('/user/keys' => $params{key})->res->{code} == 200;
}

sub keys {
  my ($self, %params) = (shift, @_);

  return @{$self->ua->get('/user/keys')->res->json};
}

sub remove_key {
  my ($self, %params) = (shift, @_);

  my $res =
    $self->ua->delete('/user/keys/' . url_escape($params{key_name}))->res;
  return 1 if $res->{code} == 200;
}

sub ps {
  my ($self, %params) = (shift, @_);

  return @{$self->ua->get('/apps/' . $params{name} . '/ps')->res->json};
}

sub run {
  my ($self, %params) = (shift, @_);

  return
    %{$self->ua->post_form('/apps/' . $params{name} . '/ps' => \%params)
      ->res->json};
}

sub restart {
  my ($self, %params) = (shift, @_);

  return 1
    if $self->ua->post_form(
    '/apps/' . $params{name} . '/ps/restart' => \%params)->res->code == 200;
}

sub stop {
  my ($self, %params) = (shift, @_);

  return 1
    if $self->ua->post_form('/apps/' . $params{name} . '/ps/stop' => \%params)
      ->res->code == 200;
}

sub releases {
  my ($self, %params) = (shift, @_);

  my $url =
      '/apps/'
    . $params{name}
    . '/releases'
    . ($params{release} ? '/' . $params{release} : '');

  my $releases = $self->ua->get($url)->res->json;

  return $params{release} ? %$releases : @$releases;
}

sub rollback {
  my ($self, %params) = (shift, @_);

  $params{rollback} = delete $params{release};

  return $params{rollback}
    if $self->ua->post_form(
    '/apps/' . $params{name} . '/releases' => \%params)->res->code == 200;
}

1;

=head1 NAME

Net::Heroku - Heroku API

=head1 DESCRIPTION

Heroku API

=head1 USAGE

    my $h = Net::Heroku->new(api_key => ...);
    my $res = $h->create;

    $h->add_config(name => $res->{name}, BUILDPACK_URL => ...);
    $h->restart(name => $res->{name});

    $h->destroy(name => $res->{name});

=head1 METHODS

=head2 new (api_key => $api_key)

Requires api key. Returns Net::Heroku object.

=head2 apps

Returns list of hash references with app information

=head2 destroy (name => $name)

Requires app name.  Destroys app.  Returns true if successful.

=head2 create

Creates a Heroku app.  Accepts optional hash list as values, returns hash list.

=head2 add_config (name => $name, %()) -> %()

Requires app name.  Adds config variables passed in hash list.  Returns hash.

=head2 config (name => $name)

Requires app name.  Returns hash reference of config variables.

=head2 add_key (key => $key)

Requires key.  Adds ssh public key.

=head2 keys

Returns list of keys.

=head2 remove_key (key_name => $key_name)

Requires name associated with key.  Removes key.

=head2 ps (name => $name)

Requires app name.  Returns list of processes.

=head2 run (name => $name, command => $command)

Requires app name and command.  Runs command once.

=head2 restart (name => $name, <ps => $ps>, <type => $type>)

Requires app name.  Restarts app.  If ps is supplied, only process is restarted.

=head2 stop (name => $name, <ps => $ps>, <type => $type>)

Requires app name.  Stop app process.

=head2 releases(name => $name, <release => $release>)

Requires app name.  Returns list of hashrefs.
If release name specified, returns hash.

=head2 rollback(name => $name, release => $release)

Rolls back to a specified releases

=head1 SEE ALSO

L<Mojo::UserAgent>, L<https://api-docs.heroku.com/>

=head1 VERSION

0.01

=head1 AUTHOR

Glen Hinkle C<tempire@cpan.org>
