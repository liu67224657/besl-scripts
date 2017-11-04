#!/usr/bin/perl
 
#
# Seek out and start every installed server on a box.
# USAGE: startservall
#
BEGIN { push @INC, '/opt/ops/bin' }
use Runtime;
use IniFiles;

#check the args
#######################
if (scalar(@ARGV) != 2)
{
        usage();
}

my $patchnum = $ARGV[0];
my $patchops = $ARGV[1];
#######################

my $hostname = `hostname`;

my $hostcfg = new Config::IniFiles( -file => "/opt/ops/bin/cfg.$hostname" );
my $patchcfg = new Config::IniFiles( -file => "/opt/package/patch/$patchnum/conf/patch.cfg" );
 
my @deployitems = split(" ", $hostcfg->val('hostconfig', 'host.deploy.webapps.name'));


my @servicesArray = installedServices();

#push webapps to sevices
#foreach $item (@deployitems) {
    #if ( $item =~ /^webapps./ ) {
    #push (@servicesArray, "webapps.$item");
    #}
#}

my @webappsItem = split(" ", $hostcfg->val('hostconfig', 'host.deploy.webapps.names'));
foreach $webappInfo (@webappsItem) {
   @webappArray = split(":", $webappInfo);
   $length=@webappArray;

   if($length==3){
     push (@servicesArray, "webapps.$webappArray[1]");
   }else{
     print("ERROR: webapp config error.array:@webappArray \n");
   }
}

#grep items
my %count;
@services = grep { ++$count{ $_ } < 2; } @servicesArray;

my @patchwebapps = split(" ", $patchcfg->val('patchconfig', 'webapps.list'));
my @patchservices = split(" ", $patchcfg->val('patchconfig', 'besl.list'));
my $opertype = $patchcfg->val('patchconfig', 'oper.type');

#####################################
if ( $patchops =~ /^deploy/ ) {
    deploy();
} else {
    check();
}

sub check()
{
    my $needpatch = 0;
    foreach $service (@services) {
        foreach $webapp (@patchwebapps) {
            if ( $service =~ /^$webapp/ ) {
		        print("The webapp $service needs the patch.\n");
                $needpatch = $needpatch + 1;
            }
        }

        foreach $pservice (@patchservices) {
            if ( $service =~ /^$pservice/ ) {
		        print("The service $service needs the patch.\n");
                $needpatch = $needpatch + 1;
            }
        }
    }

    if ($needpatch > 0){
	    print("The machine needs the patch.\n");
        exit 0;
    }else{
	    print("The machine doesn't needs the patch.\n");
        exit 2;
    }
}

sub deploy()
{
    my $needpatch = 0;

    foreach $service (@services) {
        foreach $webapp (@patchwebapps) {
            if ( $service =~ /^$webapp/ ) {
		        print("The webapp $service needs the patch.\n");
                $needpatch = $needpatch + 1;
            }
        }

        foreach $pservice (@patchservices) {
            if ( $service =~ /^$pservice/ ) {
		        print("The service $service needs the patch.\n");
                $needpatch = $needpatch + 1;
            }
        }
    }

    if ($needpatch > 0){
	    print("The machine needs the patch.\n");

        #deploy the patch content.
        system("/opt/ops/bin/patchdeploy.sh -Dpatch=$patchnum deploy");
         
        #restart the needed services and webapps
	    restart();

        #return
        exit 0;
    }else{
	    print("The machine doesn't needs the patch.\n");
        exit 2;
    }
}


sub restart()
{
    if ( $opertype =~ /^none/ ){
        print("The patch don't need restarting.\n");
        exit 0;
    }

    print("Start to restart all the needed services and web server.\n");

    print("====service====@services \n");
    foreach $service (@services) {
        foreach $webapp (@patchwebapps) {
            if ( $service =~ /^$webapp/ ) {
		        print("The webapp $service needs the patch.\n");

               # `/opt/ops/bin/release restartdynamicweb`;

                   foreach $webappDeployInfo (@webappsItem) {
                      @webappDeployItem = split(":", $webappDeployInfo);
                      $length=@webappDeployItem;
                      if($length==3){
                          if ( $service =~ /^webapps\.$webappDeployItem[1]/ ) {
                             print("patch restart tomcat tcnum:@webappDeployItem[0] webapp:@webappDeployItem[1]\n");
                            `/opt/ops/bin/release restartdynamicwebbytcnum @webappDeployItem[0]`;
                          }
                      }
                   }
            }
        }

        foreach $pservice (@patchservices) {
            if ( $service =~ /^$pservice/ ) {
		        print("The service $service needs the patch.\n");

                `/opt/ops/bin/restartserv $service`;

                sleep 5;
            }
        }
    }
    
    exit 0;
}

##########
# usage: #
##########
sub usage()
{
        print "\nUSAGE: patch.sh patchnumber check|deploy\n";
        exit 1;
}

