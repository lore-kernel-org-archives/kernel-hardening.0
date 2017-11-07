References: <1510050731-32446-1-git-send-email-me@tobin.cc>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <ec5a3690-a8c2-0329-66c0-ed7dda5db958@redhat.com>
Date: Tue, 7 Nov 2017 15:36:06 -0800
MIME-Version: 1.0
In-Reply-To: <1510050731-32446-1-git-send-email-me@tobin.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH v4] scripts: add leaking_addresses.pl
To: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On 11/07/2017 02:32 AM, Tobin C. Harding wrote:
> Currently we are leaking addresses from the kernel to user space. This
> script is an attempt to find some of those leakages. Script parses
> `dmesg` output and /proc and /sys files for hex strings that look like
> kernel addresses.
> 
> Only works for 64 bit kernels, the reason being that kernel addresses
> on 64 bit kernels have 'ffff' as the leading bit pattern making greping
> possible. On 32 kernels we don't have this luxury.
> 
> Scripts is _slightly_ smarter than a straight grep, we check for false
> positives (all 0's or all 1's, and vsyscall start/finish addresses).
> 
> Output is saved to file to expedite repeated formatting/viewing of
> output.
> 
> Signed-off-by: Tobin C. Harding <me@tobin.cc>
> ---
> 
> This version outputs a report instead of the raw results by default. Designing
> this proved to be non-trivial, the reason being that it is not immediately clear
> what constitutes a duplicate entry (similar message, address range, same
> file?). Also, the aim of the report is to assist users _not_ missing correct
> results; limiting the output is inherently a trade off between noise and
> correct, clear results.
> 
> Without testing on various real kernels its not clear that this reporting is any
> good, my test cases were a bit contrived. Your usage may vary.
> 
> It would be super helpful to get some comments from people running this with
> different set ups.
> 

Running on a stock Fedora kernel with gnome generates a 139M file.
I'll admit that Fedora is pretty generous in what it enables.
Trimmed down to omit some redundancies in various processes
by only printing off of the last file in the path

/proc/kallsyms
/proc/modules
/proc/timer_list
/proc/1244/stack
/proc/4041/status
/proc/bus/input/devices <--- Probably a false positive
/proc/1/net/hci
/proc/1/net/tcp
/proc/1/net/udp
/proc/1/net/bnep
/proc/1/net/raw6
/proc/1/net/tcp6
/proc/1/net/udp6
/proc/1/net/unix
/proc/1/net/l2cap
/proc/1/net/packet
/proc/1/net/rfcomm
/proc/1/net/netlink
/sys/module/snd_compress/sections/.note.gnu.build-id
/sys/module/snd_compress/sections/.exit.text
/sys/module/snd_compress/sections/__mcount_loc
/sys/module/snd_compress/sections/__ksymtab_strings
/sys/module/snd_compress/sections/__ksymtab_gpl
/sys/module/snd_compress/sections/.init.text
/sys/module/snd_compress/sections/.gnu.linkonce.this_module
/sys/module/snd_compress/sections/__jump_table
/sys/module/snd_compress/sections/.strtab
/sys/module/snd_compress/sections/.bss
/sys/module/snd_compress/sections/.rodata.str1.1
/sys/module/snd_compress/sections/__bug_table
/sys/module/snd_compress/sections/__verbose
/sys/module/snd_compress/sections/.rodata.str1.8
/sys/module/snd_compress/sections/.text
/sys/module/snd_compress/sections/.data
/sys/module/snd_compress/sections/.symtab
/sys/module/snd_compress/sections/.rodata
/sys/module/iwlmvm/sections/.altinstr_replacement
/sys/module/iwlmvm/sections/.altinstructions
/sys/module/iwlmvm/sections/.data.unlikely
/sys/module/iwlmvm/sections/__param
/sys/module/iwlmvm/sections/.smp_locks
/sys/module/snd_hda_intel/sections/__tracepoints_ptrs
/sys/module/snd_hda_intel/sections/__tracepoints
/sys/module/snd_hda_intel/sections/__tracepoints_strings
/sys/module/snd_hda_intel/sections/_ftrace_events
/sys/module/snd_hda_intel/sections/.ref.data
/sys/module/iwlwifi/sections/.parainstructions
/sys/module/iwlwifi/sections/__ksymtab
/sys/module/uvcvideo/sections/.fixup
/sys/module/uvcvideo/sections/.text.unlikely
/sys/module/uvcvideo/sections/__ex_table
/sys/module/intel_powerclamp/sections/.init.rodata
/sys/module/mac80211/sections/.data..read_mostly
/sys/module/nfnetlink/sections/.init.data
/sys/module/ghash_clmulni_intel/sections/.rodata.cst16.bswap_mask
/sys/module/videodev/sections/_ftrace_eval_map
/sys/module/kvm_intel/sections/.data..ro_after_init
/sys/module/kvm_intel/sections/.altinstr_aux
/sys/module/crct10dif_pclmul/sections/.rodata.cst16.SHUF_MASK
/sys/module/crct10dif_pclmul/sections/.rodata.cst16.mask1
/sys/module/crct10dif_pclmul/sections/.rodata.cst32.pshufb_shf_table
/sys/module/crct10dif_pclmul/sections/.rodata.cst16.mask2
/sys/module/nf_conntrack/sections/.data..cacheline_aligned
/sys/firmware/efi/runtime-map/5/virt_addr
/sys/devices/platform/i8042/serio0/input/input3/uevent
/sys/devices/platform/i8042/serio0/input/input3/capabilities/key

I'd probably put /proc/kallsyms and /proc/modules on the omit list
since those are designed to leak addresses to userspace. The
modules in sysfs might be harder to lockdown.

Thanks,
Laura

> Please feel free to say 'try harder Tobin, this reporting is shit'.
> 
> Thanks, appreciate your time,
> Tobin.
> 
> v4:
>   - Add `scan` and `format` sub-commands.
>   - Output report by default.
>   - Add command line option to send scan results (to me).
> 
> v3:
>   - Iterate matches to check for results instead of matching input line against
>     false positives i.e catch lines that contain results as well as false
>     positives.
> 
> v2:
>   - Add regex's to prevent false positives.
>   - Clean up white space.
> 
>   MAINTAINERS                  |   5 +
>   scripts/leaking_addresses.pl | 437 +++++++++++++++++++++++++++++++++++++++++++
>   2 files changed, 442 insertions(+)
>   create mode 100755 scripts/leaking_addresses.pl
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2f4e462aa4a2..a7995c737728 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7745,6 +7745,11 @@ S:	Maintained
>   F:	Documentation/scsi/53c700.txt
>   F:	drivers/scsi/53c700*
>   
> +LEAKING_ADDRESSES
> +M:	Tobin C. Harding <me@tobin.cc>
> +S:	Maintained
> +F:	scripts/leaking_addresses.pl
> +
>   LED SUBSYSTEM
>   M:	Richard Purdie <rpurdie@rpsys.net>
>   M:	Jacek Anaszewski <jacek.anaszewski@gmail.com>
> diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
> new file mode 100755
> index 000000000000..282c0cc2bdea
> --- /dev/null
> +++ b/scripts/leaking_addresses.pl
> @@ -0,0 +1,437 @@
> +#!/usr/bin/env perl
> +#
> +# (c) 2017 Tobin C. Harding <me@tobin.cc>
> +# Licensed under the terms of the GNU GPL License version 2
> +#
> +# leaking_addresses.pl: Scan 64 bit kernel for potential leaking addresses.
> +#  - Scans dmesg output.
> +#  - Walks directory tree and parses each file (for each directory in @DIRS).
> +#
> +# Use --debug to output path before parsing, this is useful to find files that
> +# cause the script to choke.
> +#
> +# You may like to set kptr_restrict=2 before running script
> +# (see Documentation/sysctl/kernel.txt).
> +
> +use warnings;
> +use strict;
> +use POSIX;
> +use File::Basename;
> +use File::Spec;
> +use Cwd 'abs_path';
> +use Term::ANSIColor qw(:constants);
> +use Getopt::Long qw(:config no_auto_abbrev);
> +use File::Spec::Functions 'catfile';
> +
> +my $P = $0;
> +my $V = '0.01';
> +
> +# Directories to scan (we scan `dmesg` also).
> +my @DIRS = ('/proc', '/sys');
> +
> +# Output path for raw scan data, set by set_ouput_path().
> +my $OUTPUT = "";
> +
> +# Command line options.
> +my $output = "";
> +my $suppress_dmesg = 0;
> +my $squash_by_path = 0;
> +my $raw = 0;
> +my $send_report = 0;
> +my $help = 0;
> +my $debug = 0;
> +
> +# Do not parse these files (absolute path).
> +my @skip_parse_files_abs = ('/proc/kmsg',
> +			    '/proc/kcore',
> +			    '/proc/fs/ext4/sdb1/mb_groups',
> +			    '/proc/1/fd/3',
> +			    '/sys/kernel/debug/tracing/trace_pipe',
> +			    '/sys/kernel/security/apparmor/revision')> +
> +# Do not parse thes files under any subdirectory.
> +my @skip_parse_files_any = ('0',
> +			    '1',
> +			    '2',
> +			    'pagemap',
> +			    'events',
> +			    'access',
> +			    'registers',
> +			    'snapshot_raw',
> +			    'trace_pipe_raw',
> +			    'ptmx',
> +			    'trace_pipe');
> +
> +# Do not walk these directories (absolute path).
> +my @skip_walk_dirs_abs = ();
> +
> +# Do not walk these directories under any subdirectory.
> +my @skip_walk_dirs_any = ('self',
> +			  'thread-self',
> +			  'cwd',
> +			  'fd',
> +			  'stderr',
> +			  'stdin',
> +			  'stdout');
> +
> +sub help
> +{
> +	my ($exitcode) = @_;
> +
> +	print << "EOM";
> +Usage: $P COMMAND [OPTIONS]
> +Version: $V
> +
> +Commands:
> +
> +	scan	Scan the kernel (savesg raw results to file and runs `format`).
> +	format	Parse results file and format output.
> +
> +Options:
> +	-o, --output=<path>	 Accepts absolute or relative filename or directory name.
> +	    --suppress-dmesg	 Don't show dmesg results.
> +	    --squash-by-path	 Show one result per unique path.
> +	    --raw	 	 Show raw results.
> +	    --send-report	 Submit raw results for someone else to worry about.
> +	-d, --debug              Display debugging output.
> +	-h, --help, --version    Display this help and exit.
> +
> +Scans the running (64 bit) kernel for potential leaking addresses.
> +}
> +
> +EOM
> +	exit($exitcode);
> +}
> +
> +GetOptions(
> +        'o|output=s'		=> \$output,
> +        'suppress-dmesg'	=> \$suppress_dmesg,
> +        'squash-by-path'	=> \$squash_by_path,
> +        'raw'			=> \$raw,
> +        'send-report'		=> \$send_report,
> +        'd|debug'		=> \$debug,
> +        'h|help'		=> \$help,
> +        'version'		=> \$help
> +) or help(1);
> +
> +help(0) if ($help);
> +
> +my ($command) = @ARGV;
> +if (not defined $command) {
> +        help(128);
> +}
> +
> +set_output_path($output);
> +
> +if ($command ne 'scan' and $command ne 'format') {
> +        printf "\nUnknown command: %s\n\n", $command;
> +        help(128);
> +}
> +
> +if ($command eq 'scan') {
> +        scan();
> +}
> +
> +if ($send_report) {
> +        send_report();
> +        print "Raw scan results sent, thank you.\n";
> +        exit(0);
> +}
> +
> +format_output();
> +
> +exit 0;
> +
> +sub dprint
> +{
> +	printf(STDERR @_) if $debug;
> +}
> +
> +# Sets global $OUTPUT, defaults to "./scan.out"
> +# Accepts relative or absolute path (directory name or filename).
> +sub set_output_path
> +{
> +        my ($path) = @_;
> +        my $def_filename = "scan.out";
> +        my $def_dirname = getcwd();
> +
> +        if ($path eq "") {
> +                $OUTPUT = catfile($def_dirname, $def_filename);
> +                return;
> +        }
> +
> +        my($filename, $dirs, $suffix) = fileparse($path);
> +
> +        if ($filename eq "") {
> +                $OUTPUT = catfile($dirs, $def_filename);
> +        } elsif ($filename) {
> +                $OUTPUT = catfile($dirs, $filename);
> +        }
> +}
> +
> +sub scan
> +{
> +        open (my $fh, '>', "$OUTPUT") or die "Cannot open $OUTPUT\n";
> +        select $fh;
> +
> +        parse_dmesg();
> +        walk(@DIRS);
> +
> +        select STDOUT;
> +}
> +
> +sub send_report
> +{
> +        system("mail -s 'LEAK REPORT' leaks\@tobin.cc < $OUTPUT");
> +}
> +
> +sub parse_dmesg
> +{
> +	open my $cmd, '-|', 'dmesg';
> +	while (<$cmd>) {
> +		if (may_leak_address($_)) {
> +			print 'dmesg: ' . $_;
> +		}
> +	}
> +	close $cmd;
> +}
> +
> +# Recursively walk directory tree.
> +sub walk
> +{
> +	my @dirs = @_;
> +	my %seen;
> +
> +	while (my $pwd = shift @dirs) {
> +		next if (skip_walk($pwd));
> +		next if (!opendir(DIR, $pwd));
> +		my @files = readdir(DIR);
> +		closedir(DIR);
> +
> +		foreach my $file (@files) {
> +			next if ($file eq '.' or $file eq '..');
> +
> +			my $path = "$pwd/$file";
> +			next if (-l $path);
> +
> +			if (-d $path) {
> +				push @dirs, $path;
> +			} else {
> +				parse_file($path);
> +			}
> +		}
> +	}
> +}
> +
> +# True if argument potentially contains a kernel address.
> +sub may_leak_address
> +{
> +        my ($line) = @_;
> +
> +        my @addresses = extract_addresses($line);
> +        return @addresses > 0;
> +}
> +
> +# Return _all_ non false positive addresses from $line.
> +sub extract_addresses
> +{
> +        my ($line) = @_;
> +        my $address = '\b(0x)?ffff[[:xdigit:]]{12}\b';
> +        my (@addresses, @empty);
> +
> +        # Signal masks.
> +        if ($line =~ '^SigBlk:' or
> +            $line =~ '^SigCgt:') {
> +                return @empty;
> +        }
> +
> +        if ($line =~ '\bKEY=[[:xdigit:]]{14} [[:xdigit:]]{16} [[:xdigit:]]{16}\b' or
> +            $line =~ '\b[[:xdigit:]]{14} [[:xdigit:]]{16} [[:xdigit:]]{16}\b') {
> +                return @empty;
> +        }
> +
> +        while ($line =~ /($address)/g) {
> +                if (!is_false_positive($1)) {
> +                        push @addresses, $1;
> +                }
> +        }
> +
> +        return @addresses;
> +}
> +
> +# True if we should skip walking this directory.
> +sub skip_walk
> +{
> +	my ($path) = @_;
> +	return skip($path, \@skip_walk_dirs_abs, \@skip_walk_dirs_any)
> +}
> +
> +sub parse_file
> +{
> +	my ($file) = @_;
> +
> +	if (! -R $file) {
> +		return;
> +	}
> +
> +	if (skip_parse($file)) {
> +		dprint "skipping file: $file\n";
> +		return;
> +	}
> +	dprint "parsing: $file\n";
> +
> +	open my $fh, "<", $file or return;
> +	while ( <$fh> ) {
> +		if (may_leak_address($_)) {
> +			print $file . ': ' . $_;
> +		}
> +	}
> +	close $fh;
> +}
> +
> +sub is_false_positive
> +{
> +        my ($match) = @_;
> +
> +        if ($match =~ '\b(0x)?(f|F){16}\b' or
> +            $match =~ '\b(0x)?0{16}\b') {
> +                return 1;
> +        }
> +
> +        # vsyscall memory region, we should probably check against a range here.
> +        if ($match =~ '\bf{10}600000\b' or
> +            $match =~ '\bf{10}601000\b') {
> +                return 1;
> +        }
> +
> +        return 0;
> +}
> +
> +# True if we should skip this path.
> +sub skip
> +{
> +	my ($path, $paths_abs, $paths_any) = @_;
> +
> +	foreach (@$paths_abs) {
> +		return 1 if (/^$path$/);
> +	}
> +
> +	my($filename, $dirs, $suffix) = fileparse($path);
> +	foreach (@$paths_any) {
> +		return 1 if (/^$filename$/);
> +	}
> +
> +	return 0;
> +}
> +
> +sub skip_parse
> +{
> +	my ($path) = @_;
> +	return skip($path, \@skip_parse_files_abs, \@skip_parse_files_any);
> +}
> +
> +sub format_output
> +{
> +        if ($raw) {
> +                dump_raw_output();
> +                return;
> +        }
> +
> +        my ($total, $dmesg, $paths, $files) = parse_raw_file();
> +
> +        printf "\nTotal number of results from scan (incl dmesg): %d\n", $total;
> +
> +        if (!$suppress_dmesg) {
> +                print_dmesg($dmesg);
> +        }
> +        squash_by($files, 'filename');
> +
> +        if ($squash_by_path) {
> +                squash_by($paths, 'path');
> +        }
> +}
> +
> +sub dump_raw_output
> +{
> +        open (my $fh, '<', $OUTPUT) or die "Cannot open $OUTPUT\n";
> +        while (<$fh>) {
> +                print $_;
> +        }
> +        close $fh;
> +}
> +
> +sub print_dmesg
> +{
> +        my ($dmesg) = @_;
> +
> +        print "\ndmesg output:\n";
> +        foreach(@$dmesg) {
> +                my $index = index($_, ':');
> +                $index += 2;    # skid ': '
> +                print substr($_, $index);
> +        }
> +}
> +
> +sub squash_by
> +{
> +        my ($ref, $desc) = @_;
> +
> +        print "\nResults squashed by $desc (excl dmesg). ";
> +        print "Displaying <number of results>, <$desc>, <example result>\n";
> +        foreach(keys %$ref) {
> +                my $lines = $ref->{$_};
> +                my $length = @$lines;
> +                printf "[%d %s] %s", $length, $_, @$lines[0];
> +        }
> +}
> +
> +sub parse_raw_file
> +{
> +        my $total = 0;          # Total number of lines parsed.
> +        my @dmesg;              # dmesg output.
> +        my %files;              # Unique filenames containing leaks.
> +        my %paths;              # Unique paths containing leaks.
> +
> +        open (my $fh, '<', $OUTPUT) or die "Cannot open $OUTPUT\n";
> +
> +        while (my $line = <$fh>) {
> +                $total++;
> +
> +                if ("dmesg:" eq substr($line, 0, 6)) {
> +                        push @dmesg, $line;
> +                        next;
> +                }
> +
> +                cache_path(\%paths, $line);
> +                cache_filename(\%files, $line);
> +        }
> +
> +        return $total, \@dmesg, \%paths, \%files;
> +}
> +
> +sub cache_path
> +{
> +        my ($paths, $line) = @_;
> +
> +        my $index = index($line, ':');
> +        my $path = substr($line, 0, $index);
> +
> +        if (!$paths->{$path}) {
> +                $paths->{$path} = ();
> +        }
> +        push @{$paths->{$path}}, $line;
> +}
> +
> +sub cache_filename
> +{
> +        my ($files, $line) = @_;
> +
> +        my $index = index($line, ':');
> +        my $path = substr($line, 0, $index);
> +        my $filename = basename($path);
> +        if (!$files->{$filename}) {
> +                $files->{$filename} = ();
> +        }
> +        $index += 2;            # skip ': '
> +        push @{$files->{$filename}}, substr($line, $index);
> +}
> 
