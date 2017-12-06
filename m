Date: Thu, 7 Dec 2017 10:01:17 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171206230117.GI11835@eros>
References: <1512455204.17323.20.camel@gmail.com>
 <20171206040437.GB11835@eros>
 <1512561090.17323.32.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1512561090.17323.32.camel@gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3] scripts: leaking_addresses: add support for 32-bit
 kernel addresses
To: kaiwan.billimoria@gmail.com
Cc: Alexander Kapshuk <alexander.kapshuk@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 06, 2017 at 05:21:30PM +0530, kaiwan.billimoria@gmail.com wrote:
> On Wed, 2017-12-06 at 15:04 +1100, Tobin C. Harding wrote:
> > On Tue, Dec 05, 2017 at 11:56:44AM +0530, kaiwan.billimoria@gmail.com wrote:
> > > Currently, leaking_addresses.pl only supports scanning 64 bit
> > > architectures. This is due to how the regular expressions are formed. We
> > > can do better than this. 32 architectures can be supported if we take
> > > into consideration the kernel virtual address split (via the PAGE_OFFSET
> > > kernel configurable).
> > > 
> > > Add support for ix86 32 bit architectures.
> > >  - Add command line option for page offset.
> > >  - Add command line option for kernel configuration file.
> > >  - Parse kernel config file for page offset (CONFIG_PAGE_OFFSET).
> > >  - Use page offset when checking for kernel virtual addresses.
> > > 
> > > 
> > > Signed-off-by: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
> > > ---
> > 
> > Right, this is starting to look awesome.
> 
> Great!
> 
> > > Note- This patch represents co development by Tobin and Kaiwan (plus suggestions from 
> > > Alexander Kapshuk). Applies on Tobin's tree 'leaks' branch on top of commit 680db1ef560f
> > > (leaking_addresses: fix typo function not called).
> > > 
> > > 
> > >  scripts/leaking_addresses.pl | 169 +++++++++++++++++++++++++++++++++++++------
> > >  1 file changed, 148 insertions(+), 21 deletions(-)
> > > 
> > > diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
> > > index 2d5336b3e1ea..6b015980d117 100755
> > > --- a/scripts/leaking_addresses.pl
> > > +++ b/scripts/leaking_addresses.pl
> > > @@ -24,6 +24,7 @@ use Cwd 'abs_path';
> > >  use Term::ANSIColor qw(:constants);
> > >  use Getopt::Long qw(:config no_auto_abbrev);
> > >  use Config;
> > > +use feature 'state';
> > >  
> > >  my $P = $0;
> > >  my $V = '0.01';
> > > @@ -37,18 +38,20 @@ my $TIMEOUT = 10;
> > >  # Script can only grep for kernel addresses on the following architectures. If
> > >  # your architecture is not listed here and has a grep'able kernel address please
> > >  # consider submitting a patch.
> > > -my @SUPPORTED_ARCHITECTURES = ('x86_64', 'ppc64');
> > > +my @SUPPORTED_ARCHITECTURES = ('x86_64', 'ppc64',  'i[3456]86');
> > >  
> > >  # Command line options.
> > >  my $help = 0;
> > >  my $debug = 0;
> > > -my $raw = 0;
> > > -my $output_raw = "";	# Write raw results to file.
> > > -my $input_raw = "";	# Read raw results from file instead of scanning.
> > > +my $raw = 0;                   # Show raw output.
> > > +my $output_raw = "";           # Write raw results to file.
> > > +my $input_raw = "";            # Read raw results from file instead of scanning.
> > > +my $suppress_dmesg = 0;	       # Don't show dmesg in output.
> > > +my $squash_by_path = 0;	       # Summary report grouped by absolute path.
> > > +my $squash_by_filename = 0;    # Summary report grouped by filename.
> > >  
> > > -my $suppress_dmesg = 0;		# Don't show dmesg in output.
> > > -my $squash_by_path = 0;		# Summary report grouped by absolute path.
> > > -my $squash_by_filename = 0;	# Summary report grouped by filename.
> > > +my $page_offset_32bit = 0;     # 32-bit: value of CONFIG_PAGE_OFFSET
> > > +my $kernel_config_file = "";   # Kernel configuration file.
> > >  
> > >  # Do not parse these files (absolute path).
> > >  my @skip_parse_files_abs = ('/proc/kmsg',
> > > @@ -97,14 +100,16 @@ Version: $V
> > >  
> > >  Options:
> > >  
> > > -	-o, --output-raw=<file>  Save results for future processing.
> > > -	-i, --input-raw=<file>   Read results from file instead of scanning.
> > > -	    --raw                Show raw results (default).
> > > -	    --suppress-dmesg     Do not show dmesg results.
> > > -	    --squash-by-path     Show one result per unique path.
> > > -	    --squash-by-filename Show one result per unique filename.
> > > -	-d, --debug              Display debugging output.
> > > -	-h, --help, --version    Display this help and exit.
> > > +	-o, --output-raw=<file>         Save results for future processing.
> > > +	-i, --input-raw=<file>          Read results from file instead of scanning.
> > > +		--raw                       Show raw results (default).
> > > +		--suppress-dmesg            Do not show dmesg results.
> > > +		--squash-by-path            Show one result per unique path.
> > > +		--squash-by-filename        Show one result per unique filename.
> > > +	--page-offset-32bit=<hex>       PAGE_OFFSET value (for 32-bit kernels).
> > > +	--kernel-config-file=<file>     Kernel configuration file (e.g /boot/config)
> > > +	-d, --debug                     Display debugging output.
> > > +	-h, --help, --version           Display this help and exit.
> > >  
> > >  Examples:
> > >  
> > > @@ -117,7 +122,10 @@ Examples:
> > >  	# View summary report.
> > >  	$0 --input-raw scan.out --squash-by-filename
> > >  
> > > -Scans the running (64 bit) kernel for potential leaking addresses.
> > > +	# Scan kernel on a 32-bit system with a 2GB:2GB virtual address split.
> > > +	$0 --page-offset-32bit=0x80000000
> > > +
> > > +Scans the running kernel for potential leaking addresses.
> > >  
> > >  EOM
> > >  	exit($exitcode);
> > > @@ -133,6 +141,8 @@ GetOptions(
> > >  	'squash-by-path'        => \$squash_by_path,
> > >  	'squash-by-filename'    => \$squash_by_filename,
> > >  	'raw'                   => \$raw,
> > > +	'page-offset-32bit=o'   => \$page_offset_32bit,
> > > +	'kernel-config-file=s'  => \$kernel_config_file,
> > >  ) or help(1);
> > >  
> > >  help(0) if ($help);
> > > @@ -148,6 +158,7 @@ if (!$input_raw and ($squash_by_path or $squash_by_filename)) {
> > >  	exit(128);
> > >  }
> > >  
> > > +show_detected_architecture() if $debug;
> > >  if (!is_supported_architecture()) {
> > >  	printf "\nScript does not support your architecture, sorry.\n";
> > >  	printf "\nCurrently we support: \n\n";
> > > @@ -179,7 +190,7 @@ sub dprint
> > >  
> > >  sub is_supported_architecture
> > >  {
> > > -	return (is_x86_64() or is_ppc64());
> > > +	return (is_x86_64() or is_ppc64() or is_ix86_32());
> > >  }
> > >  
> > >  sub is_x86_64
> > > @@ -202,10 +213,40 @@ sub is_ppc64
> > >  	return 0;
> > >  }
> > >  
> > > +sub is_ix86_32
> > > +{
> > > +	my $archname = $Config{archname};
> > > +
> > > +	if ($archname =~ m/i[3456]86-linux/) {
> > > +		return 1;
> > > +	}
> > > +	return 0;
> > > +}
> > > +
> > > +sub show_detected_architecture
> > > +{
> > > +	printf "Detected architecture: ";
> > > +	if (is_ix86_32()) {
> > > +		printf "32 bit x86\n";
> > > +	} elsif (is_x86_64()) {
> > > +		printf "x86_64\n";
> > > +	} elsif (is_ppc64()) {
> > > +		printf "ppc64\n";
> > > +	} else {
> > > +		printf "failed to detect architecture\n"
> > > +	}
> > > +}
> > > +
> > >  sub is_false_positive
> > >  {
> > >  	my ($match) = @_;
> > >  
> > > +	if (is_ix86_32()) {
> > > +		return is_false_positive_ix86_32($match);
> > > +	}
> > > +
> > > +	# 64 bit architectures
> > > +
> > >  	if ($match =~ '\b(0x)?(f|F){16}\b' or
> > >  	    $match =~ '\b(0x)?0{16}\b') {
> > >  		return 1;
> > > @@ -222,6 +263,89 @@ sub is_false_positive
> > >  	return 0;
> > >  }
> > >  
> > > +sub is_false_positive_ix86_32
> > > +{
> > > +	my ($match) = @_;
> > > +	state $page_offset = get_page_offset(); # only gets called once
> > 
> > nit: new line here
> 
> Will do
> > > +	if ($match =~ '\b(0x)?(f|F){8}\b') {
> > > +		return 1;
> > > +	}
> > > +
> > > +	my $addr32 = eval hex($match);
> > > +	if ($addr32 < $page_offset) {
> > > +		return 1;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +sub get_page_offset
> > > +{
> > > +	my $page_offset;
> > > +	my $default_offset = hex("0xc0000000");
> > > +	my @config_files;
> > 
> > 	my $tmp_file = "";
> > 
> > See comments below for reasoning.
> > 
> > > +	# Allow --page-offset-32bit to override.
> > > +	if ($page_offset_32bit != 0) {
> > > +		return $page_offset_32bit;
> > > +	}
> > > +
> > > +	# Allow --kernel-config-file to override.
> > > +	if ($kernel_config_file ne "") {
> > > +		@config_files = ($kernel_config_file);
> > > +	} else {
> > > +		my $config_file = '/boot/config-' . `uname -r`;
> > > +		@config_files = ($config_file, '/boot/config');
> > > +	}
> > > +
> > > +	if (-R "/proc/config.gz") {
> > > +		my $tmp_file = "/tmp/tmpkconf";
> > 
> > 		$tmp_file = "/tmp/tmpkconf";
> > 
> > > +		if (system("gunzip < /proc/config.gz > $tmp_file")) {
> > > +			dprint " parse_kernel_config: system(gunzip...) failed\n";
> > > +		} else {
> > > +			$page_offset = parse_kernel_config_file($tmp_file);
> > > +			if ($page_offset ne "") {
> > > +				return hex($page_offset);
> > > +			}
> > > +		}
> > > +		system("rm -f $tmp_file");
> > > +	}
> > 
> > The logic is a bit broken here. sub returns without rm'ing tmp file. 
> 
> Caught! :-)  Thanks..
> 
> > I
> > believe we discussed using
> > 
> > 	@config_files = ($tmp_file);
> > 
> > Then continuing to iterate @config_files as done. 
> 
> I thought, why not just do this:
> 
> 	if (-R "/proc/config.gz") {
> 		my $tmp_file = "/tmp/tmpkconf";
> 		if (system("gunzip < /proc/config.gz > $tmp_file")) {
> 			dprint " parse_kernel_config: system(gunzip...) failed\n";
> 		} else {
> 			$page_offset = parse_kernel_config_file($tmp_file);
> 			if ($page_offset ne "") {
> 				system("rm -f $tmp_file");
> 				return hex($page_offset);
> 			}
> 			system("rm -f $tmp_file");
> 		}
> 	}
> 
> Also, this way, the '$tmp_file' var remains localized to the handling of
> the /proc/config.gz file 'if' statement scope.

Yep I like this. Perhaps you can move the 'rm' statement like this

 			$page_offset = parse_kernel_config_file($tmp_file);
     			system("rm -f $tmp_file");
 			if ($page_offset ne "") {
 				return hex($page_offset);
 			}

> > > +	foreach my $config_file (@config_files) {
> > > +		chomp $config_file;
> > > +		$page_offset = parse_kernel_config_file($config_file);
> > > +		if ($page_offset ne "") {
> > > +			return hex($page_offset);
> > > +		}
> > > +	}
> > 
> > We may need to use 'last' instead of returning so we can check for
> > 
> > 	if ($tmp_file ne "") {
> > 		system("rm -f $tmp_file");
> > 	}
> 
> Not required, if we use the manner I propose above..
> > 
> > And one final (particularly trivial) nitpick
> > 
> > Can you use the brief commit log with prefix
> > 
> > 	leaking_addresses:
> >  
> > please. That prefix is what is currently used. Using 'scripts:' makes it
> > hard to fit a descriptive message within 52 characters.
> > 
> Understood, sorry for the current patch series not using this style.
> 
> > I know we have changed it already, but perhaps it should mention x86 not
> > just 32 bit (since it is not 32 bit generic).
> > 
> > I realized while reviewing your code that there is no reason for this to
> > be x86 specific, if we can get a config file with CONFIG_PAGE_OFFSET
> > then we can scan the kernel like this irrespective of architecture. Perl
> > doesn't manage to correctly identify the RaspberryPi I tried it on as 32
> > bit so we may not be able to do it how we currently are.
> Interesting..
> > 
> > I'm mentioning this because I don't want you to go to all this work and
> > then remove a bunch of your code immediately while making it 32 bit
> > generic. If you want to work on a generic version then I'm happy to work
> > with you on it.
> Sure, lets try for a generic ver!

Cool.

> Thanks for your help on this..

No problem.

> As your experience woth the R Pi shows, we may have to just resort to building a
> generic framework of sorts, letting folks "plugin" appropriate "truth values"
> for their particular platform; this way, we support as much as we can for now
> and, going forward, it's generic.
> As of right now though, am unsure what this "generic framework" is..

ATM the best I can come up with is having two flags

--page-offset-32bit=0xc0000000 (exactly as we have now)
--32-bit

Now for the klunky bit, I can only see two options

1. Default to 64 bit, for 32 bit scan require one of the above options
to be set.

2. Parse config file for all architectures, if CONFIG_PAGE_OFFSET is set
us it.

I particularly don't like option 2. If we can find a reliable way to get
the architecture the we have a better option. At the moment the method
we use relies on the architecture of the machine that the Perl binary
was built on (AFAICT).

(/usr/bin/arch does not work on RPi either)

I'm happy with option 1 unless there is a better proposal.

> >  If you would prefer to just get this done and merged
> > then we can do that too.
> > 
> > As I've said before I'm new to the maintainer role so still learning how
> > best to approach things. Thanks for your patience.
> IMO, you're doing just great (me, am not so sure :) ).

It's a team effort!

thanks,
Tobin.
