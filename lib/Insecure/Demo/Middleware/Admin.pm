package Insecure::Demo::Middleware::Admin;

use parent 'Plack::Middleware';
use strict;
use warnings;

use Insecure::Demo::Container 'service';
use Plack::Request;
use Plack::Util;
use URI::Escape 'uri_escape';

sub call {
    my ( $self, $env ) = @_;

    my $req = Plack::Request->new($env);
    my $srv = service 'Users';

    my $user_id;
    my $token = $req->cookies->{user};
    $user_id = $srv->get_user_id($token) if $token;

    return _redirect( '/admin/login/?return=' . uri_escape $env->{REQUEST_URI} )
      unless $user_id;

    my $user_info = service('Users')->user_details($user_id);

    return _redirect( '/admin/login/?return=' . uri_escape $env->{REQUEST_URI} )
      unless $user_info;

    $env->{$_} = $user_info->{$_} for keys %$user_info;
    # FIXME: lets push out a username to the nginx log

    return $self->app->($env);
}

sub _redirect { [ 302, [ Location => $_[0] ], [] ] }

1;
