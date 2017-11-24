Date: Fri, 24 Nov 2017 16:56:10 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171124055610.GA17858@eros>
References: <1511414040.12425.11.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1511414040.12425.11.camel@gmail.com>
Subject: [kernel-hardening] Re: [PATCH 1/2] scripts: leaking_addresses: add support for 32-bit
 kernel addresses
To: kaiwan.billimoria@gmail.com
Cc: linux-kernel@vger.kernel.org, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kaiwan,

thanks for the patches!

On Thu, Nov 23, 2017 at 10:44:00AM +0530, kaiwan.billimoria@gmail.com wrote:
> The current leaking_addresses.pl script only supports showing "leaked"
> 64-bit kernel virtual addresses. This patch adds support for showing
> "leaked" 32-bit kernel virtual addresses. It also takes into account Tobin's
> feedback on the previous iteration. (Note: this patch is meant to apply on
> the 'leaks' branch of Tobin's tree).

Please don't mention me in the commit log. Usually this sort of comment
would go below the ----- so it doesn't get into the kernel tree.

Perhaps

Currently leaking_addresses.pl only supports scanning 64 bit kernels. We
can scan 32 bit kernels also by ... (describe PAGE_OFFSET stuff)

> Briefly, the way it works- once it detects we're running on an i'x'86 platform,
> (where x=3|4|5|6), it takes this arch into account for checking. The essential rationale:
>  if virt-addr >= PAGE_OFFSET => it's a kernel virtual address.
> 
> This version programatically queries and sets PAGE_OFFSET based on the
> /boot/config-$(uname -r) content. If, for any reason, this file cannot be
> used, we fallback to requesting the user to pass PAGE_OFFSET as a parameter.

This is a good start. What if we were to check a few places in order?

	/boot/config
	/boot/config-$(uname -r)
	/proc/config.gz 

And fall back to 0xc0000000 with a warning printed to stderr if we can't
find it?

I'd suggest creating a sub routine get_page_offset() that returns
it. You could cache the result locally in the subroutine to make it
faster, here is a stack overflow post on how to do that

	https://stackoverflow.com/questions/10841076/static-local-variables-in-perl

Or you could save it to a global and check this each time the you enter
the subroutine, which ever you fancy.

> Pending/TODO:
> - support for ARM-32

We don't need this in the git log either :)

> Feedback welcome..

Or this. Once it is in the tree no feed back will be possible.

> Signed-off-by: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
> ---
> diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
> index 865c07649dff..0566f8055ec5 100755
> --- a/scripts/leaking_addresses.pl
> +++ b/scripts/leaking_addresses.pl
> @@ -2,10 +2,10 @@
>  #
>  # (c) 2017 Tobin C. Harding <me@tobin.cc>
>  # (c) 2017 Kaiwan N Billimoria <kaiwan.billimoria@gmail.com> (ix86 support)
> - 
> +
>  # Licensed under the terms of the GNU GPL License version 2
>  #
> -# leaking_addresses.pl: Scan 64 bit kernel for potential leaking addresses.
> +# leaking_addresses.pl: Scan 32/64 bit kernel for potential leaking addresses.
>  #  - Scans dmesg output.
>  #  - Walks directory tree and parses each file (for each directory in @DIRS).
>  #
> @@ -14,7 +14,7 @@
>  #
>  # You may like to set kptr_restrict=2 before running script
>  # (see Documentation/sysctl/kernel.txt).
> -
> +#
>  use warnings;
>  use strict;
>  use POSIX;
> @@ -37,7 +37,7 @@ my $TIMEOUT = 10;
>  # Script can only grep for kernel addresses on the following architectures. If
>  # your architecture is not listed here and has a grep'able kernel address please
>  # consider submitting a patch.
> -my @SUPPORTED_ARCHITECTURES = ('x86_64', 'ppc64');
> +my @SUPPORTED_ARCHITECTURES = ('x86_64', 'ppc64', 'i[3456]86');
>  
>  # Command line options.
>  my $help = 0;
> @@ -49,6 +49,12 @@ my $input_raw = "";	# Read raw results from file instead of scanning.
>  my $suppress_dmesg = 0;		# Don't show dmesg in output.
>  my $squash_by_path = 0;		# Summary report grouped by absolute path.
>  my $squash_by_filename = 0;	# Summary report grouped by filename.
> +my $page_offset_param = 0;      # 32-bit: overrides value of PAGE_OFFSET_32BIT

I don't like the _param here, it's not in style with the rest of the
code. I do like the global name $PAGE_OFFSET_32BIT though. You don't
_really_ need both since the command line option _is_ a global. I also
struggled with the Perl variable nomenclature between capitals for
globals but not for command line options. (For the record I attempted to
imitate checkpatch.pl.)

 +my $page_offset = 0;     # ...

> +
> +my $bit_size = 64;      # Check 64-bit kernel addresses by default

I thought we said we didn't need this?

> +my $kconfig_file = '/boot/config-'.`uname -r`;
> +$kconfig_file =~ s/\R*//g;
> +my $PAGE_OFFSET_32BIT = 0xc0000000;

So, the page_offset stuff still needs a bit of work. We want it as
simple as possible and also we don't want the 32 bit stuff cluttering up
the 64 bit stuff (i.e with lots of globals). For this reason I think it
would be nice to confine all this to a subroutine then we can do

    if (is_ix86_32()) {
    	$page_offset = get_page_offset();
    	...
	if ($addr < $page_offset)
	...
    }
    
>  # Do not parse these files (absolute path).
>  my @skip_parse_files_abs = ('/proc/kmsg',
> @@ -99,10 +105,11 @@ Options:
>  
>  	-o, --output-raw=<file>  Save results for future processing.
>  	-i, --input-raw=<file>   Read results from file instead of scanning.
> -	    --raw                Show raw results (default).
> -	    --suppress-dmesg     Do not show dmesg results.
> -	    --squash-by-path     Show one result per unique path.
> -	    --squash-by-filename Show one result per unique filename.
> +	--raw                    Show raw results (default).
> +	--suppress-dmesg         Do not show dmesg results.
> +	--squash-by-path         Show one result per unique path.
> +	--squash-by-filename     Show one result per unique filename.
> +	--page-offset=<hex>      PAGE_OFFSET value (for 32-bit kernels).
>  	-d, --debug              Display debugging output.
>  	-h, --help, --version    Display this help and exit.

This shouldn't be in this patch.

> @@ -117,7 +124,7 @@ Examples:
>  	# View summary report.
>  	$0 --input-raw scan.out --squash-by-filename
>  
> -Scans the running (64 bit) kernel for potential leaking addresses.
> +Scans the running (32 or 64 bit) kernel for potential leaking addresses.

Perhaps just:

 +Scans the running kernel for potential leaking addresses.

>  EOM
>  	exit($exitcode);
> @@ -133,10 +140,16 @@ GetOptions(
>  	'squash-by-path'        => \$squash_by_path,
>  	'squash-by-filename'    => \$squash_by_filename,
>  	'raw'                   => \$raw,
> +	'page-offset=o'         => \$page_offset_param,
>  ) or help(1);
>  
>  help(0) if ($help);
>  
> +sub dprint
> +{
> +	printf(STDERR @_) if $debug;
> +}
> +
>  if ($input_raw) {
>  	format_output($input_raw);
>  	exit(0);
> @@ -162,6 +175,24 @@ if (!is_supported_architecture()) {
>  	exit(129);
>  }
>  
> +dprint "Detected arch : $bit_size bits\n";
> +
> +if ($bit_size == 32) {
> +	# Parameter --page-offset passed? if Y, override with it
> +	if ($page_offset_param != 0) {
> +		$PAGE_OFFSET_32BIT = $page_offset_param;
> +	} else {
> +		$PAGE_OFFSET_32BIT = eval parse_kconfig($kconfig_file, "CONFIG_PAGE_OFFSET");
> +		if ($PAGE_OFFSET_32BIT == 0) {
> +			printf "$P: Fatal Error :: couldn't parse CONFIG_PAGE_OFFSET, aborting...\n";
> +			printf " [Detail :: arch=32-bit, kconfig file=$kconfig_file]\n\n";
> +			printf "You can pass it as a parameter via the --page-offset= option switch.\n";

nit: a command line option is not a parameter.

> +			exit(1);
> +		}
> +	}
> +	dprint "PAGE_OFFSET = 0x%X\n", $PAGE_OFFSET_32BIT;
> +}
> +

All this could be in the sub get_page_offset() right? (You probably want
to print all errors to stderr.)

>  if ($output_raw) {
>  	open my $fh, '>', $output_raw or die "$0: $output_raw: $!\n";
>  	select $fh;
> @@ -172,14 +203,9 @@ walk(@DIRS);
>  
>  exit 0;
>  
> -sub dprint
> -{
> -	printf(STDERR @_) if $debug;
> -}
> -
>  sub is_supported_architecture
>  {
> -	return (is_x86_64() or is_ppc64());
> +	return (is_x86_64() or is_ppc64() or is_ix86_32());
>  }
>  
>  sub is_x86_64
> @@ -187,6 +213,7 @@ sub is_x86_64
>  	my $archname = $Config{archname};
>  
>  	if ($archname =~ m/x86_64/) {
> +		$bit_size = 64;
	:(
>  		return 1;
>  	}
>  	return 0;
> @@ -197,6 +224,19 @@ sub is_ppc64
>  	my $archname = $Config{archname};
>  
>  	if ($archname =~ m/powerpc/ and $archname =~ m/64/) {
> +		$bit_size = 64;
	:(
> +		return 1;
> +	}
> +	return 0;
> +}
> +
> +# 32-bit x86: is_i'x'86_32() ; where is [3 or 4 or 5 or 6]
> +sub is_ix86_32
> +{
> +	my $archname = $Config{archname};
> +
> +	if ($archname =~ m/i[3456]86-linux/) {
> +		$bit_size = 32;
	:(
>  		return 1;
>  	}
>  	return 0;
> @@ -217,6 +257,14 @@ sub is_false_positive
>  		    $match =~ '\bf{10}601000\b') {
>  			return 1;
>  		}
> +	} elsif ($bit_size == 32) {

 is_ix86_32()

> +		my $addr32 = eval hex($match);
> +		if ($addr32 < $PAGE_OFFSET_32BIT ) {
> +			return 1;
> +		}
> +		if ($match =~ '\b(0x)?(f|F){8}\b') {
> +			return 1;
> +		}

Awesome, apologies for the brain dead comment last time about all zero
mask.

>  	}
>  
>  	return 0;
> @@ -245,6 +293,8 @@ sub may_leak_address
>  		$address_re = '\b(0x)?ffff[[:xdigit:]]{12}\b';
>  	} elsif (is_ppc64()) {
>  		$address_re = '\b(0x)?[89abcdef]00[[:xdigit:]]{13}\b';
> +	} elsif (is_ix86_32()) {
> +		$address_re = '\b(0x)?[[:xdigit:]]{8}\b';
>  	}
>  
>  	while (/($address_re)/g) {
> @@ -501,3 +551,28 @@ sub add_to_cache
>  	}
>  	push @{$cache->{$key}}, $value;
>  }
> +
> +sub parse_kconfig

This overloads the term kconfig and is a bit confusing. I can't come up
with anything great but perhaps parse_kernel_config() would be clearer.

> +{
> +	my ($file,$config) = @_;

Why not just have CONFIG_PAGE_OFFSET here as a constant?

> +	my $str;
> +	my $val=NULL;
> +
> +	if (! -R $file) {
> +               return NULL;
> +	}
> +
> +	open my $fh, "<", $file or return;
> +	while (my $line = <$fh> ) {
> +		if ($line =~ /^$config/) {
> +			($str,$val) = split /=/, $line;
> +		}
> +	}
> +	close $fh;
> +
> +	if ($val eq NULL) {
> +		return NULL;
> +	}
> +	$val =~ s/\R*//g;
> +	return $val;
> +}

Please use kernel coding style (spaces around '=', and after ','). The
basic idea here is sound, I'd like to see this incorporated into, or
called from get_page_offset().

Let me know if you disagree, I'm open to discussion. It's hard to write
clean Perl so extra discipline is needed.

Thanks again for your efforts, I look forward to v2.

Tobin.
