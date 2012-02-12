package Net::Heroku;
use Modern::Perl + 2012;
use Mojo::Base -base;
use Net::Heroku::UserAgent;
use Data::Dumper;
use Mojo::JSON;

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
    'app[collaborators]' => 'cpantests@empireenterprises.com',
    @ar,
  );

  return $self->ua->post_form('/apps', {%params})->res->json;
}

sub add_config {
  my ($self, %params) = (shift, @_);

  return $self->ua->put('/apps/'
      . delete($params{name})
      . '/config_vars' => Mojo::JSON->new->encode(\%params))->res->json;
}

sub config {
  my ($self, %params) = (shift, @_);

  return $self->ua->get('/apps/' . $params{name} . '/config_vars')->res->json;
}

sub add_key {
  my ($self, %params) = (shift, @_);

  return $self->ua->put('/user/keys' => $params{key});

1;

=head1 NAME

Net::Heroku - Heroku API

=head1 DESCRIPTION

Heroku API

=head1 USAGE

=head1 METHODS

=head1 VERSION

0.01

=head AUTHOR

Glen Hinkle C<tempire@cpan.org>
