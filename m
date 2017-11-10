Message-ID: <1510322194.19812.3.camel@gmail.com>
From: kaiwan.billimoria@gmail.com
Date: Fri, 10 Nov 2017 19:26:34 +0530
In-Reply-To: <1510050731-32446-1-git-send-email-me@tobin.cc>
References: <1510050731-32446-1-git-send-email-me@tobin.cc>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCH v4] scripts: add leaking_addresses.pl
To: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2017-11-07 at 21:32 +1100, Tobin C. Harding wrote:
> Currently we are leaking addresses from the kernel to user space.
> This
> script is an attempt to find some of those leakages. Script parses
> `dmesg` output and /proc and /sys files for hex strings that look
> like
> kernel addresses.
> 
> Only works for 64 bit kernels, the reason being that kernel addresses
> on 64 bit kernels have 'ffff' as the leading bit pattern making
> greping
> possible. On 32 kernels we don't have this luxury.

Tobin C. Harding <me@tobin.cc> wrote:
>Only works for 64 bit kernels, the reason being that kernel addresses
>on 64 bit kernels have 'ffff' as the leading bit pattern making greping
>possible. On 32 kernels we don't have this luxury.

[RFC] leaking_addresses.pl - enhance it to work for 32-bit kernels as well

(Firstly, apologies if I've got the protocol horribly wrong- should this
be a new thread altogether?)

Ok so, I was interested in figuring - why not have this useful script work
for 32-bit kernel virtual addresses as well (and those systems by
extension).

The approach am considering, pl correct me if I'm way off:
on 32-bit, the kernel macro PAGE_OFFSET will give us the user-kernel split;
(alternatively, could also script up CONFIG_VMSPLIT_[n]G and figure the
split from there.)

For the time being, lets say we go with the "use PAGE_OFFSET" approach and
PAGE_OFFSET = 0xc0000000 , whch implies we have a 3:1 GB user:kernel split.
So any virtual addresses >= PAGE_OFFSET are kernel virtual addresses (i
know, untrue on some ARM-32 systems!).

As a very early and *far-from-perfect* start, I've enhanced Tobin's Perl
script to take into account 32-bit address space by passing the
parameter '--bit-size='.

The patch below does Not take into account (yet) stuff like:
 - exactly which files & dirs should be skipped on 32-bit (will it be
identical to 64-bit?; unsure..)
 - it currently hard-codes a global 'PAGE_OFFSET_32BIT=0xc0000000' , just
 so I can test quickly; must figure whether to query it or pass it;
 Suggestions?
 - the 'false positives'; again, what differs for 32-bit?
   (BTW, shouldn't the dmesg 'root=UUID=<...>' line be a false positive
    & skipped?).

Also, I must point out that I'm a complete newbie to Perl :-) so, pl excuse
my highly inadequate perl-foo; I rely on you perl gurus out there to fix
and optimize :)

Yes, I've **Very Minimally** tested the patch in it's current form on:
a) a regular (Fedora 26) x86_64 desktop,
b) a (Debian 7) 32-bit kernel (VM) with PAGE_OFFSET=3 Gb
and it seems all right, considering...

Some sample output from test (b), if interested:
=====
dmesg: [    0.000000] found SMP MP-table at [c00f1280] f1280
dmesg: [    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
dmesg: [    0.000000] ACPI: Local APIC address 0xfee00000
dmesg: [    0.000000] free_area_init_node: node 0, pgdat c1418bc0, node_mem_map dfbfa200
dmesg: [    0.000000] ACPI: Local APIC address 0xfee00000
dmesg: [    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
dmesg: [    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
dmesg: [    0.000000] PERCPU: Embedded 14 pages/cpu @dfbe8000 s33344 r0 d24000 u57344
dmesg: [    0.000000]     fixmap  : 0xffd36000 - 0xfffff000   (2852 kB)
dmesg: [    0.000000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
dmesg: [    0.000000]     vmalloc : 0xe07fb000 - 0xff9fe000   ( 498 MB)
dmesg: [    0.000000]     lowmem  : 0xc0000000 - 0xdfffb000   ( 511 MB)
dmesg: [    0.000000]       .init : 0xc1421000 - 0xc148c000   ( 428 kB)

[...]

/proc/kallsyms: c10010e8 T _stext
/proc/kallsyms: c1002000 T hypercall_page
/proc/kallsyms: c1003000 t arch_local_save_flags
/proc/kallsyms: c1003007 t arch_local_irq_enable
/proc/kallsyms: c100300e T do_one_initcall

<< ... plenty more kallsyms of course (92.5% of the output to be precise!) ... >>

/proc/modules: loop 17803 0 - Live 0xe097c000
/proc/modules: crc32c_intel 12659 0 - Live 0xe096e000
/proc/modules: snd_pcm 53461 0 - Live 0xe09f5000
/proc/modules: snd_page_alloc 12867 1 snd_pcm, Live 0xe0957000
/proc/modules: snd_timer 22401 1 snd_pcm, Live 0xe093c000

[...]

/proc/modules: usb_common 12338 1 usbcore, Live 0xe0860000
/proc/timer_list:   .base:       dfbeb8b0
/proc/timer_list:  #0: <dfbeb954>, tick_sched_timer, S:01, hrtimer_start_range_ns, swapper/0/0

[...]

/proc/iomem:   f8000000-fbffffff : 0000:00:02.0
/proc/iomem:   fc000000-fcffffff : 0000:00:02.0
/proc/iomem:   fd000000-fd03ffff : 0000:00:03.0

[...]

/proc/11422/syscall: 7 0xffffffff 0xbf814618 0xa 0xa 0x0 0x1 0xbf8145b8 0xb7780428
/proc/11422/stack: [<c102953f>] kmap_atomic_prot+0x2f/0xe0
/proc/11422/stack: [<c1125213>] security_task_wait+0xc/0xd

[...]

/proc/bus/input/devices: B: KEY=4 2000000 3803078 f800d001 feffffdf ffefffff ffffffff fffffffe
/proc/1/net/ipv6_route: 00000000000000000000000000000000 00 00000000000000000000000000000000 00 00000000000000000000000000000000 ffffffff 00000001 0000000f 00200200       lo

[...]

/proc/2/net/unix: dce872c0: 00000005 00000000 00000000 0002 01  4978 /dev/log
/proc/2/net/unix: dce87a40: 00000002 00000000 00010000 0001 01  5006 /var/run/acpid.socket
/proc/2/net/unix: dce87540: 00000002 00000000 00010000 0005 01  3246 /run/udev/control

[...]
=====
etc etc.


Finally, unsure if am working against the latest ver of your script Tobin, apologies if not.

Signed-off-by: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
---

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 2977371b2956..b6280dca8c46 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -45,6 +45,7 @@ my $P = $0;
 my $V = '0.01';

 # Directories to scan.
+#my @DIRS = ('/home/kai/0tmp/addr32_pl');
 my @DIRS = ('/proc', '/sys');

 # Command line options.
@@ -52,6 +53,7 @@ my $help = 0;
 my $debug = 0;
 my @dont_walk = ();
 my @dont_parse = ();
+my $bit_size = 64;

 # Do not parse these files (absolute path).
 my @skip_parse_files_abs = ('/proc/kmsg',
@@ -86,6 +88,8 @@ my @skip_walk_dirs_any = ('self',
			  'stdin',
			  'stdout');

+my $PAGE_OFFSET_32BIT = 0xc0000000;
+
 sub help
 {
	my ($exitcode) = @_;
@@ -96,10 +100,12 @@ Version: $V

 Options:

+	--bit-size= 32|[64]    Checks for 64-bit kernel addresses by default;
+                                change to check for 32-bit kernel addresses by passing 32 here
	--dont-walk=<dir>      Don't walk tree starting at <dir>.
	--dont-parse=<file>    Don't parse <file>.
-	-d, --debug                Display debugging output.
-	-h, --help, --version      Display this help and exit.
+	-d, --debug            Display debugging output.
+	-h, --help, --version  Display this help and exit.

 If an absolute path is passed to --dont_XXX then this path is skipped. If a
 single filename is passed then this file/directory will be skipped when
@@ -117,8 +123,9 @@ EOM
 }

 GetOptions(
-	'dont-walk=s'		=> \@dont_walk,
-	'dont-parse=s'		=> \@dont_parse,
+	'dont-walk=s'	=> \@dont_walk,
+	'dont-parse=s'	=> \@dont_parse,
+	'bit-size=i'	=> \$bit_size,
	'd|debug'		=> \$debug,
	'h|help'		=> \$help,
	'version'		=> \$help
@@ -126,6 +133,10 @@ GetOptions(

 help(0) if ($help);

+if ($bit_size != 64 && $bit_size != 32) {
+    help(1);
+}
+
 push_to_global();

 parse_dmesg();
@@ -168,6 +179,7 @@ sub push_to_global
	push_in_abs_any(\@dont_parse, \@skip_parse_files_abs, \@skip_parse_files_any);
 }

+# NOT updated for 32-bit kernel addresses yet
 sub is_false_positive
 {
         my ($match) = @_;
@@ -183,6 +195,7 @@ sub is_false_positive
                 return 1;
         }

+# TODO - skip the 'root=UUID=<...>' line as well
         return 0;
 }

@@ -190,7 +203,8 @@ sub is_false_positive
 sub may_leak_address
 {
         my ($line) = @_;
-        my $address = '\b(0x)?ffff[[:xdigit:]]{12}\b';
+        my $address64 = '\b(0x)?ffff[[:xdigit:]]{12}\b';
+        my $address32 = '\b(0x)?[[:xdigit:]]{8}\b';

         # Signal masks.
         if ($line =~ '^SigBlk:' or
@@ -202,11 +216,23 @@ sub may_leak_address
             $line =~ '\b[[:xdigit:]]{14} [[:xdigit:]]{16} [[:xdigit:]]{16}\b') {
		return 0;
         }
-
-        while (/($address)/g) {
+
+        if ($bit_size == 64) {
+            while (/($address64)/g) {
                 if (!is_false_positive($1)) {
                         return 1;
                 }
+            }
+        } elsif ($bit_size == 32) {
+            while (/($address32)/g) {
+		        my $addr32 = eval hex($1);
+		        if ($addr32 < $PAGE_OFFSET_32BIT) {
+                        return 0;
+                }
+                if (!is_false_positive($addr32)) {
+                        return 1;
+                }
+            }
         }

         return 0;

 scripts/leaking_addresses.pl | 40 +++++++++++++++++++++++++++++++++-------
