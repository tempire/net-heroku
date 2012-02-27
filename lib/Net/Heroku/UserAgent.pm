package Net::Heroku::UserAgent;
use Mojo::Base 'Mojo::UserAgent';

has 'host';
has 'tx';
has 'api_key';

sub format_host {
  my $self = shift;
  my $path = pop;

  return
      'https://:'
    . $self->api_key . '@'
    . $self->host
    . (substr($path, 0, 1) eq '/' ? '' : '/')    # optional slash
    . $path;
}


sub build_form_tx {
  my $self   = shift;
  my @params = @_;

  # Pre-assigned host
  $params[0] = $self->format_host($params[0]) if @params;

  # Headers
  push @params => {Accept => 'application/json'};

  $self->tx($self->SUPER::build_form_tx(@params));

  return $self->tx;
}

sub build_tx {
  my $self   = shift;
  my @params = @_;

  # $params[0] is http method)

  # Host
  $params[1] = $self->format_host($params[1]);

  # Insert headers before form
  push @params => {Accept => 'application/json'} if @_ == 2;
  splice @params, -2, -1, $params[-2], {Accept => 'application/json'}
    if @_ > 2;

  $self->tx($self->SUPER::build_tx(@params));

  return $self->tx;
}

1;

=head1 NAME

Net::Heroku::UserAgent

=head1 DESCRIPTION

Subclass of Mojo::UserAgent, making the host persistent

=head1 METHODS

Net::Heroku::UserAgent inherits all methods from Mojo::UserAgent and implements the following new ones.

=head2 build_tx

Builds a transaction using a persistently stored host

=head2 build_form_tx

Builds a form transaction using a persistently stored host

=cut
