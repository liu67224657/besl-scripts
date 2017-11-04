package Runtime;
require Exporter;


our @ISA = qw(Exporter);

# Symbols to be exported by default
our @EXPORT = qw(installedServices $SERVICE_RUN_ROOT getPid matchingProcs sleepMillis procsToPids);


$SERVICE_RUN_ROOT=$ENV{'SERVICE_RUN_ROOT'} || "/opt/ops/services";

# Function installedServers
# returns a list of servers that are configured on this machine
sub installedServices{
	my @services;

	while (glob "$SERVICE_RUN_ROOT/*")
	{
		next unless -d $_;					# must be a dir
		next unless -e "$_/alias";		# can't use startserv otherwise

		s/.*\/(\S+)$/$1/;					# leave only dir name

		if ($_ eq "ini")
		{
			next;							# not a server
		}

		push (@services, $_);
	}

	return @services;
}

# Function matchingProcs
# returns a list of processes in "ps -ef" form that
# match the given java server name
sub matchingProcs
{
	my ($serviceName) = @_;

	@procs = `ps -ef`;
	@taggedProcs = grep / -Dea.proc=$serviceName /, @procs;
	if (scalar(@taggedProcs))
	{
		return @taggedProcs;		# this is the preferred way to match
	}

	# Otherwise, the command line may be truncated.  Look for
	# the serverName in the command path.  This is more fragile
	# because it assumes details about how java appears in the
	# process table.

	@procs = grep /$SERVICE_RUN_ROOT\/$serviceName\//, @procs;
	@procs = grep /\/jdk\//, @procs;
	return @procs;
}

# Function matchingProcs
# returns a list of processes in "ps -ef" form that
# match the given java server name
sub freeMatchingProcs
{
	my ($serviceName) = @_;

	@procs = `ps -ef`;
	@taggedProcs = grep / $serviceName /, @procs;
	if (scalar(@taggedProcs))
	{
		return @taggedProcs;		# this is the preferred way to match
	}

	return @procs;
}

# Function procsToPids
# Given an array of processes in the form returned by matchingProcs,
# return an array of corresponding pids.
sub procsToPids
{
	my @procs = @_;

	@pids = ();
	while (defined($_ = shift(@procs)))
	{
		($pid) = m/^\s*\S+\s+(\S+)\s/;
		push @pids, $pid;
	}
	return @pids;
}


# Function sleepMillis
# sleeps the integer number of milliseconds
sub sleepMillis
{
	my ($millis) = @_;

	$secs = $millis / 1000.0;
	select undef, undef, undef, $secs;
}

sub getPid{
	my $id;
	$id = "1234567890";
	return $id;
}