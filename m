MIME-Version: 1.0
References: <1515068485.3034.5.camel@gmail.com> <20180105221228.GB5445@eros>
In-Reply-To: <20180105221228.GB5445@eros>
From: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
Date: Sat, 13 Jan 2018 10:55:26 +0000
Message-ID: <CAPDLWs_T4aC2jWgLA6yEsQ-6e2J4rH3CniX8Dt0=-WBRK00gGg@mail.gmail.com>
Content-Type: multipart/alternative; boundary="001a113de47e92119a0562a6388c"
Subject: [kernel-hardening] Re: [PATCH v5] leaking_addresses: add generic 32-bit support
To: "Tobin C. Harding" <me@tobin.cc>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--001a113de47e92119a0562a6388c
Content-Type: text/plain; charset="UTF-8"

Hi Tobin,

Thanks very much for your detailed review.
Just wanted to say that am up to my neck in work (an exceptionally busy
time), hence will take a while to work on this - around another 3 weeks
perhaps.
I'd like to continue, but if you feel it's too long please move ahead.

On Sat, 6 Jan 2018, 3:42 am Tobin C. Harding, <me@tobin.cc> wrote:

> Hi Kaiwan,
>
> Thanks for the patch
>
> On Thu, Jan 04, 2018 at 05:51:25PM +0530, kaiwan.billimoria@gmail.com
> wrote:
> > The script now attempts to detect the architecture it's running upon; as
> of now,
> > we explicitly support x86_64, PPC64, ARM64, MIPS64 and x86_32.
>
> This is incorrect. We do not currently support ARM64, MIPS64 and x86_32.
>
> > If it's one of them, we proceed "normally". If we fail to detect the
> arch,
> > we fallback to 64-bit scanning, _unless_ the user has passed either of
> these
> > option switches: "--opt-32bit" and/or "--page-offset-32bit=<val>".
> >
> > If so, we switch to scanning for leaked addresses based on the value of
> > PAGE_OFFSET (via an auto-detected or fallback mechanism).
> >
> > Currently, code (or "rules") to detect special cases for x86_64, PPC64
> and Aarch64
> > (in the get_address_re sub) is present. Also, we now have also builtin
> "stubs",
> > for lack of a better term, where additional rules for other 64-bit
> arch's can be
> > plugged into the code, in future, as applicable.
> >
> > This patch adds support for ix86 and generic 32 bit architectures.
> >  - Add command line option for generic 32-bit checking.
> >  - Add command line option for page offset.
> >  - Add command line option for kernel configuration file.
> >  - Parse kernel config file for page offset (CONFIG_PAGE_OFFSET).
> >  - Use page offset when checking for kernel virtual addresses.
>
> This is all pretty confusing. It is hard to discern what is the
> description of the problem being fixed and what is the description of
> the new behaviour implemented by the patch. Also this patch does not add
> kernel configuration file option.
>
> > The script has been lightly tested on the following systems:
> >  x86_64
> >  x86_32 (on a i686 running Debian 7 to be precise)
> >  ARM32  (on a Yocto-based qemuarm32 ARM Versatile platform (ARM926EJ-S
> cpu))
> >
> > In the first two cases, one just has to run the script - no parameters
> required.
> > In the ARM-32 case, it will, by design, fail to detect the architecture;
> > (re)running it with the '--32-bit' and/or the
> '--page-offset-32bit=<hexval>'
>
> This does not match the code. In the code you have defined the option as
> '--opt-32bit'? '--32-bit' is better ;)
>
> > option switch(es) has the desired effect: it now detects 32-bit leaking
> kernel
> > addresses, if any.
> >
> > Request more testing on the above and other platforms.
> >
> >
> > Signed-off-by: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
> >
> > ---
> >  scripts/leaking_addresses.pl | 190
> +++++++++++++++++++++++++++++++++++--------
> >  1 file changed, 156 insertions(+), 34 deletions(-)
> >
> > diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
> > index a29e13e577a7..b0807b3a3c7c 100755
> > --- a/scripts/leaking_addresses.pl
> > +++ b/scripts/leaking_addresses.pl
> > @@ -1,10 +1,10 @@
> >  #!/usr/bin/env perl
> >  #
> >  # (c) 2017 Tobin C. Harding <me@tobin.cc>
> > -
>
> Please make only the minimum number of changes required.
>
> > +# (c) 2017 Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
> >  # Licensed under the terms of the GNU GPL License version 2
> >  #
> > -# leaking_addresses.pl: Scan 64 bit kernel for potential leaking
> addresses.
> > +# leaking_addresses.pl: Scan kernel for potential leaking addresses.
> >  #  - Scans dmesg output.
> >  #  - Walks directory tree and parses each file (for each directory in
> @DIRS).
> >  #
> > @@ -32,11 +32,6 @@ my @DIRS = ('/proc', '/sys');
> >  # Timer for parsing each file, in seconds.
> >  my $TIMEOUT = 10;
> >
> > -# Script can only grep for kernel addresses on the following
> architectures. If
> > -# your architecture is not listed here and has a grep'able kernel
> address please
> > -# consider submitting a patch.
> > -my @SUPPORTED_ARCHITECTURES = ('x86_64', 'ppc64');
> > -
> >  # Command line options.
> >  my $help = 0;
> >  my $debug = 0;
> > @@ -48,7 +43,9 @@ my $suppress_dmesg = 0;             # Don't show dmesg
> in output.
> >  my $squash_by_path = 0;              # Summary report grouped by
> absolute path.
> >  my $squash_by_filename = 0;  # Summary report grouped by filename.
> >
> > -my $kernel_config_file = ""; # Kernel configuration file.
>
> No need for this to be removed and re-added (if you line up the comments).
>
> > +my $opt_32_bit = 0;            # Detect (only) 32-bit kernel leaking
> addresses.
>
> As previously discussed, please be consistent in naming: $opt_32bit
>
> > +my $page_offset_32bit = 0;     # 32-bit: value of CONFIG_PAGE_OFFSET.
> > +my $kernel_config_file = "";   # Kernel configuration file.
> >
> >  # Do not parse these files (absolute path).
> >  my @skip_parse_files_abs = ('/proc/kmsg',
> > @@ -104,10 +101,12 @@ Options:
> >             --squash-by-path          Show one result per unique path.
> >             --squash-by-filename      Show one result per unique
> filename.
> >       --kernel-config-file=<file>     Kernel configuration file (e.g
> /boot/config)
> > +     --opt-32bit                     Detect (only) 32-bit kernel
> leaking addresses.
>
>         --32-bit                        Scan 32-bit kernel.
>
> > +     --page-offset-32bit=<hex>       PAGE_OFFSET value (for 32-bit
> kernels).
> >       -d, --debug                     Display debugging output.
> > -     -h, --help, --versionq          Display this help and exit.
> > +     -h, --help, --version           Display this help and exit.
> >
> > -Scans the running (64 bit) kernel for potential leaking addresses.
> > +Scans the running kernel for potential leaking addresses.
> >
> >  EOM
> >       exit($exitcode);
> > @@ -123,7 +122,9 @@ GetOptions(
> >       'squash-by-path'        => \$squash_by_path,
> >       'squash-by-filename'    => \$squash_by_filename,
> >       'raw'                   => \$raw,
> > -     'kernel-config-file=s'  => \$kernel_config_file,
> > +     'opt-32bit'             => \$opt_32_bit,
> > +     'page-offset-32bit=o'   => \$page_offset_32bit,
> > +     'kernel-config-file=s'  => \$kernel_config_file,
> >  ) or help(1);
> >
> >  help(0) if ($help);
> > @@ -139,16 +140,15 @@ if (!$input_raw and ($squash_by_path or
> $squash_by_filename)) {
> >       exit(128);
> >  }
> >
> > -if (!is_supported_architecture()) {
> > -     printf "\nScript does not support your architecture, sorry.\n";
> > -     printf "\nCurrently we support: \n\n";
> > -     foreach(@SUPPORTED_ARCHITECTURES) {
> > -             printf "\t%s\n", $_;
> > -     }
> > +show_detected_architecture() if $debug;
> >
> > -     my $archname = $Config{archname};
> > -     printf "\n\$ perl -MConfig -e \'print
> \"\$Config{archname}\\n\"\'\n";
> > -     printf "%s\n", $archname;
> > +if (!is_known_architecture()) {
> > +     printf STDERR "\nFATAL: Script does not recognize your
> architecture\n";
> > +
> > +     my $arch = `uname -m`;
> > +     chomp $arch;
> > +     printf "\n\$ uname -m\n";
> > +     printf "%s\n", $arch;
> >
> >       exit(129);
> >  }
>
> I am going to add a patch to use `uname -m` instead of `perl -MConfig
> ...` on powerpc. Please rebase your next version.
>
> > @@ -168,21 +168,45 @@ sub dprint
> >       printf(STDERR @_) if $debug;
> >  }
> >
> > -sub is_supported_architecture
> > +sub is_known_architecture
>
> Please don't change this.
>
> >  {
> > -     return (is_x86_64() or is_ppc64());
> > +     return (is_64bit() or is_32bit());
> >  }
> >
> > -sub is_x86_64
> > +sub is_32bit
> >  {
> > -     my $archname = $Config{archname};
> > +     # 32-bit actual case
> > +     if (is_ix86_32()) {
> > +             return 1;
> > +     }
> >
> > -     if ($archname =~ m/x86_64/) {
> > +     # 32-bit "forced" case (for any arch other than IA-32)
> > +     if ($opt_32_bit or $page_offset_32bit) {
> >               return 1;
> >       }
> >       return 0;
> >  }
>
> Perhaps
>
>
> sub is_32bit
> {
>         # Allow --32-bit and/or --page-offset-32bit to override.
>         if ($opt_32_bit or $page_offset_32bit) {
>                 return 1;
>         }
>
>         if (is_ix86_32()) {
>                 return 1;
>         }
>
>         return 0;
> }
>
>
> > +sub is_64bit
> > +{
> > +     return (is_x86_64() or is_ppc64() or is_arm64() or is_mips64());
> > +}
> > +
> > +sub is_x86_64
> > +{
> > +     is_arch("x86_64");
> > +}
> > +
> > +sub is_arm64
> > +{
> > +     is_arch("aarch64");
> > +}
> > +
> > +sub is_mips64
> > +{
> > +     is_arch("mips64");
> > +}
> > +
>
> We cannot add these last two. There has been no talk (to my knowledge) of
> the
> address format for mips64 or aarch64. If you have tested for these please
> add as a separate patch.
>
> >  sub is_ppc64
> >  {
> >       my $archname = $Config{archname};
> > @@ -193,6 +217,47 @@ sub is_ppc64
> >       return 0;
> >  }
> >
> > +sub is_ix86_32
> > +{
> > +     my $arch = `uname -m`;
> > +
> > +     chomp $arch;
> > +     if ($arch =~ m/i[3456]86/) {
> > +             return 1;
> > +     }
> > +     return 0;
> > +}
> > +
> > +sub is_arch
> > +{
> > +     my ($desc) = @_;
> > +     my $arch = `uname -m`;
> > +
> > +     chomp $arch;
> > +     if ($arch eq $desc) {
> > +             return 1;
> > +     }
> > +     return 0;
> > +}
> > +
> > +sub show_detected_architecture
> > +{
> > +     printf "Detected architecture: ";
> > +     if (is_32bit()) {
> > +             printf "32 bit\n";
>
> is_32bit includes the command line options so this is not _totally_
> correct. Prefer
>
>          if (is_x64_32()) {
>                 ...
>
> > +     } elsif (is_x86_64()) {
> > +             printf "x86_64\n";
> > +     } elsif (is_ppc64()) {
> > +             printf "PPC64\n";
> > +     } elsif (is_arm64()) {
> > +             printf "ARM64\n";
> > +     } elsif (is_mips64()) {
> > +             printf "MIPS64\n";
> > +     } else {
> > +             printf "failed to detect architecture\n"
> > +     }
> > +}
> > +
> >  # gets config option value from kernel config file
> >  sub get_kernel_config_option
> >  {
> > @@ -212,7 +277,6 @@ sub get_kernel_config_option
> >               } else {
> >                       @config_files = ($tmp_file);
> >               }
> > -
>
> Please don't do white space changes in the middle or another patch.
>
> >       } else {
> >               my $file = '/boot/config-' . `uname -r`;
> >               chomp $file;
> > @@ -220,7 +284,6 @@ sub get_kernel_config_option
> >       }
> >
> >       foreach my $file (@config_files) {
> > -             dprint("parsing config file: %s\n", $file);
>
> This should be a separate patch. 'One thing per patch' is the kernel mantra
>
> >               $value = option_from_file($option, $file);
> >               if ($value ne "") {
> >                       last;
> > @@ -258,6 +321,14 @@ sub is_false_positive
> >  {
> >       my ($match) = @_;
> >
> > +     # 32 bit architectures, actual or forced
> > +
>
> No need for this comment.
>
> > +     if (is_32bit()) {
> > +             return is_false_positive_32bit($match);
> > +     }
> > +
> > +     # 64 bit architectures
> > +
>
> Or this one.
>
> >       if ($match =~ '\b(0x)?(f|F){16}\b' or
> >           $match =~ '\b(0x)?0{16}\b') {
> >               return 1;
> > @@ -281,6 +352,58 @@ sub is_in_vsyscall_memory_region
> >       return ($hex >= $region_min and $hex <= $region_max);
> >  }
> >
> > +sub is_false_positive_32bit
> > +{
> > +     my ($match) = @_;
> > +     state $page_offset = get_page_offset(); # only gets called once
> > +
> > +     if ($match =~ '\b(0x)?(f|F){8}\b') {
> > +             return 1;
> > +     }
> > +
> > +     my $addr32 = hex($match);
> > +     if ($addr32 < $page_offset) {
> > +             return 1;
> > +     }
> > +
> > +     return 0;
> > +}
>
> The return value of this sub routine is confusing. Either it should be
> commented as returning a hex value or it should return a string. I
> prefer a string since the rest of the subs in the file return strings,
> less cognitive load to keep everything the same. Unless there is some
> clear advantage to returning a hex value (which I cannot see).
>
> > +sub get_page_offset
> > +{
> > +     my $page_offset;
> > +     my $default_offset = hex("0xc0000000");
> > +     my @config_files;
> > +
> > +     # Allow --page-offset-32bit to override.
> > +     if ($page_offset_32bit != 0) {
> > +             return $page_offset_32bit;
> > +     }
> > +
> > +     $page_offset = get_kernel_config_option('CONFIG_PAGE_OFFSET');
> > +     return $default_offset;
> > +}
>
> This is wrong.
>
> > +
> > +sub parse_kernel_config_file
> > +{
> > +     my ($file) = @_;
> > +     my $config = 'CONFIG_PAGE_OFFSET';
> > +     my $str = "";
> > +     my $val = "";
> > +
> > +     open(my $fh, "<", $file) or return "";
> > +     while (my $line = <$fh> ) {
> > +             if ($line =~ /^$config/) {
> > +                     ($str, $val) = split /=/, $line;
> > +                     chomp($val);
> > +                     last;
> > +             }
> > +     }
> > +
> > +     close $fh;
> > +     return $val;
> > +}
> > +
>
> When do you call this subroutine?
>
> >  # True if argument potentially contains a kernel address.
> >  sub may_leak_address
> >  {
> > @@ -300,8 +423,6 @@ sub may_leak_address
> >       }
> >
> >       $address_re = get_address_re();
> > -     dprint("Kernel address regular expression: %s\n", $address_re);
> > -
>
> Please see comments above on 'one thing per patch'.
>
> >       while (/($address_re)/g) {
> >               if (!is_false_positive($1)) {
> >                       return 1;
> > @@ -313,16 +434,17 @@ sub may_leak_address
> >
> >  sub get_address_re
> >  {
> > -     my $re;
> > +     my $re = "";
> >
> >       if (is_x86_64()) {
> >               $re = get_x86_64_re();
> >       } elsif (is_ppc64()) {
> >               $re = '\b(0x)?[89abcdef]00[[:xdigit:]]{13}\b';
> > -     }
> > -
> > -     if ($re eq "") {
> > -             print STDERR "$0: failed to build kernel address regular
> expression\n";
> > +     ###
> > +     # Any special cases for other arch's go below this line
> > +     ###
> > +     } else {  # nothing? then we assume it's a generic 32-bit
> > +             $re = '\b(0x)?[[:xdigit:]]{8}\b';
> >       }
> >
> >       return $re;
>
> This is messy. We definitely want to warn if we cannot fully determine
> the correct regex to use. Also, if you would like to default to 32-bit
> you will need to back it up with some reasoning. Currently there is no
> default if the correct regex cannot be ascertained. At this stage I feel
> this is the correct behaviour, I'm open to discussion though.
>
> > --
> > 2.14.3
>
>
> thanks,
> Tobin.
>

--001a113de47e92119a0562a6388c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr">Hi Tobin,</p>
<p dir=3D"ltr">Thanks very much for your detailed review.<br>
Just wanted to say that am up to my neck in work (an exceptionally busy tim=
e), hence will take a while to work on this - around another 3 weeks perhap=
s. <br>
I&#39;d like to continue, but if you feel it&#39;s too long please move ahe=
ad. </p>
<br><div class=3D"gmail_quote"><div dir=3D"ltr">On Sat, 6 Jan 2018, 3:42 am=
 Tobin C. Harding, &lt;me@tobin.cc&gt; wrote:<br></div><blockquote class=3D=
"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding=
-left:1ex">Hi Kaiwan,<br>
<br>
Thanks for the patch<br>
<br>
On Thu, Jan 04, 2018 at 05:51:25PM +0530, <a href=3D"mailto:kaiwan.billimor=
ia@gmail.com" target=3D"_blank">kaiwan.billimoria@gmail.com</a> wrote:<br>
&gt; The script now attempts to detect the architecture it&#39;s running up=
on; as of now,<br>
&gt; we explicitly support x86_64, PPC64, ARM64, MIPS64 and x86_32.<br>
<br>
This is incorrect. We do not currently support ARM64, MIPS64 and x86_32.<br=
>
<br>
&gt; If it&#39;s one of them, we proceed &quot;normally&quot;. If we fail t=
o detect the arch,<br>
&gt; we fallback to 64-bit scanning, _unless_ the user has passed either of=
 these<br>
&gt; option switches: &quot;--opt-32bit&quot; and/or &quot;--page-offset-32=
bit=3D&lt;val&gt;&quot;.<br>
&gt;<br>
&gt; If so, we switch to scanning for leaked addresses based on the value o=
f<br>
&gt; PAGE_OFFSET (via an auto-detected or fallback mechanism).<br>
&gt;<br>
&gt; Currently, code (or &quot;rules&quot;) to detect special cases for x86=
_64, PPC64 and Aarch64<br>
&gt; (in the get_address_re sub) is present. Also, we now have also builtin=
 &quot;stubs&quot;,<br>
&gt; for lack of a better term, where additional rules for other 64-bit arc=
h&#39;s can be<br>
&gt; plugged into the code, in future, as applicable.<br>
&gt;<br>
&gt; This patch adds support for ix86 and generic 32 bit architectures.<br>
&gt;=C2=A0 - Add command line option for generic 32-bit checking.<br>
&gt;=C2=A0 - Add command line option for page offset.<br>
&gt;=C2=A0 - Add command line option for kernel configuration file.<br>
&gt;=C2=A0 - Parse kernel config file for page offset (CONFIG_PAGE_OFFSET).=
<br>
&gt;=C2=A0 - Use page offset when checking for kernel virtual addresses.<br=
>
<br>
This is all pretty confusing. It is hard to discern what is the<br>
description of the problem being fixed and what is the description of<br>
the new behaviour implemented by the patch. Also this patch does not add<br=
>
kernel configuration file option.<br>
<br>
&gt; The script has been lightly tested on the following systems:<br>
&gt;=C2=A0 x86_64<br>
&gt;=C2=A0 x86_32 (on a i686 running Debian 7 to be precise)<br>
&gt;=C2=A0 ARM32=C2=A0 (on a Yocto-based qemuarm32 ARM Versatile platform (=
ARM926EJ-S cpu))<br>
&gt;<br>
&gt; In the first two cases, one just has to run the script - no parameters=
 required.<br>
&gt; In the ARM-32 case, it will, by design, fail to detect the architectur=
e;<br>
&gt; (re)running it with the &#39;--32-bit&#39; and/or the &#39;--page-offs=
et-32bit=3D&lt;hexval&gt;&#39;<br>
<br>
This does not match the code. In the code you have defined the option as<br=
>
&#39;--opt-32bit&#39;? &#39;--32-bit&#39; is better ;)<br>
<br>
&gt; option switch(es) has the desired effect: it now detects 32-bit leakin=
g kernel<br>
&gt; addresses, if any.<br>
&gt;<br>
&gt; Request more testing on the above and other platforms.<br>
&gt;<br>
&gt;<br>
&gt; Signed-off-by: Kaiwan N Billimoria &lt;<a href=3D"mailto:kaiwan.billim=
oria@gmail.com" target=3D"_blank">kaiwan.billimoria@gmail.com</a>&gt;<br>
&gt;<br>
&gt; ---<br>
&gt;=C2=A0 scripts/<a href=3D"http://leaking_addresses.pl" rel=3D"noreferre=
r" target=3D"_blank">leaking_addresses.pl</a> | 190 +++++++++++++++++++++++=
++++++++++++--------<br>
&gt;=C2=A0 1 file changed, 156 insertions(+), 34 deletions(-)<br>
&gt;<br>
&gt; diff --git a/scripts/<a href=3D"http://leaking_addresses.pl" rel=3D"no=
referrer" target=3D"_blank">leaking_addresses.pl</a> b/scripts/<a href=3D"h=
ttp://leaking_addresses.pl" rel=3D"noreferrer" target=3D"_blank">leaking_ad=
dresses.pl</a><br>
&gt; index a29e13e577a7..b0807b3a3c7c 100755<br>
&gt; --- a/scripts/<a href=3D"http://leaking_addresses.pl" rel=3D"noreferre=
r" target=3D"_blank">leaking_addresses.pl</a><br>
&gt; +++ b/scripts/<a href=3D"http://leaking_addresses.pl" rel=3D"noreferre=
r" target=3D"_blank">leaking_addresses.pl</a><br>
&gt; @@ -1,10 +1,10 @@<br>
&gt;=C2=A0 #!/usr/bin/env perl<br>
&gt;=C2=A0 #<br>
&gt;=C2=A0 # (c) 2017 Tobin C. Harding &lt;me@tobin.cc&gt;<br>
&gt; -<br>
<br>
Please make only the minimum number of changes required.<br>
<br>
&gt; +# (c) 2017 Kaiwan N Billimoria &lt;<a href=3D"mailto:kaiwan.billimori=
a@gmail.com" target=3D"_blank">kaiwan.billimoria@gmail.com</a>&gt;<br>
&gt;=C2=A0 # Licensed under the terms of the GNU GPL License version 2<br>
&gt;=C2=A0 #<br>
&gt; -# <a href=3D"http://leaking_addresses.pl" rel=3D"noreferrer" target=
=3D"_blank">leaking_addresses.pl</a>: Scan 64 bit kernel for potential leak=
ing addresses.<br>
&gt; +# <a href=3D"http://leaking_addresses.pl" rel=3D"noreferrer" target=
=3D"_blank">leaking_addresses.pl</a>: Scan kernel for potential leaking add=
resses.<br>
&gt;=C2=A0 #=C2=A0 - Scans dmesg output.<br>
&gt;=C2=A0 #=C2=A0 - Walks directory tree and parses each file (for each di=
rectory in @DIRS).<br>
&gt;=C2=A0 #<br>
&gt; @@ -32,11 +32,6 @@ my @DIRS =3D (&#39;/proc&#39;, &#39;/sys&#39;);<br>
&gt;=C2=A0 # Timer for parsing each file, in seconds.<br>
&gt;=C2=A0 my $TIMEOUT =3D 10;<br>
&gt;<br>
&gt; -# Script can only grep for kernel addresses on the following architec=
tures. If<br>
&gt; -# your architecture is not listed here and has a grep&#39;able kernel=
 address please<br>
&gt; -# consider submitting a patch.<br>
&gt; -my @SUPPORTED_ARCHITECTURES =3D (&#39;x86_64&#39;, &#39;ppc64&#39;);<=
br>
&gt; -<br>
&gt;=C2=A0 # Command line options.<br>
&gt;=C2=A0 my $help =3D 0;<br>
&gt;=C2=A0 my $debug =3D 0;<br>
&gt; @@ -48,7 +43,9 @@ my $suppress_dmesg =3D 0;=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0# Don&#39;t show dmesg in output.<br>
&gt;=C2=A0 my $squash_by_path =3D 0;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 # Summary report grouped by absolute path.<br>
&gt;=C2=A0 my $squash_by_filename =3D 0;=C2=A0 # Summary report grouped by =
filename.<br>
&gt;<br>
&gt; -my $kernel_config_file =3D &quot;&quot;; # Kernel configuration file.=
<br>
<br>
No need for this to be removed and re-added (if you line up the comments).<=
br>
<br>
&gt; +my $opt_32_bit =3D 0;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 # Dete=
ct (only) 32-bit kernel leaking addresses.<br>
<br>
As previously discussed, please be consistent in naming: $opt_32bit<br>
<br>
&gt; +my $page_offset_32bit =3D 0;=C2=A0 =C2=A0 =C2=A0# 32-bit: value of CO=
NFIG_PAGE_OFFSET.<br>
&gt; +my $kernel_config_file =3D &quot;&quot;;=C2=A0 =C2=A0# Kernel configu=
ration file.<br>
&gt;<br>
&gt;=C2=A0 # Do not parse these files (absolute path).<br>
&gt;=C2=A0 my @skip_parse_files_abs =3D (&#39;/proc/kmsg&#39;,<br>
&gt; @@ -104,10 +101,12 @@ Options:<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0--squash-by-path=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 Show one result per unique path.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0--squash-by-filename=C2=
=A0 =C2=A0 =C2=A0 Show one result per unique filename.<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0--kernel-config-file=3D&lt;file&gt;=C2=A0 =
=C2=A0 =C2=A0Kernel configuration file (e.g /boot/config)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0--opt-32bit=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Detect (only) 32-bit kernel leaking a=
ddresses.<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 --32-bit=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 Scan 32-bit kernel.<br>
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0--page-offset-32bit=3D&lt;hex&gt;=C2=A0 =C2=A0 =
=C2=A0 =C2=A0PAGE_OFFSET value (for 32-bit kernels).<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0-d, --debug=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Display debugging output.<br>
&gt; -=C2=A0 =C2=A0 =C2=A0-h, --help, --versionq=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 Display this help and exit.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0-h, --help, --version=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0Display this help and exit.<br>
&gt;<br>
&gt; -Scans the running (64 bit) kernel for potential leaking addresses.<br=
>
&gt; +Scans the running kernel for potential leaking addresses.<br>
&gt;<br>
&gt;=C2=A0 EOM<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0exit($exitcode);<br>
&gt; @@ -123,7 +122,9 @@ GetOptions(<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0&#39;squash-by-path&#39;=C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =3D&gt; \$squash_by_path,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0&#39;squash-by-filename&#39;=C2=A0 =C2=A0 =
=3D&gt; \$squash_by_filename,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0&#39;raw&#39;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D&gt; \$raw,<br>
&gt; -=C2=A0 =C2=A0 =C2=A0&#39;kernel-config-file=3Ds&#39;=C2=A0 =3D&gt; \$=
kernel_config_file,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0&#39;opt-32bit&#39;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0=3D&gt; \$opt_32_bit,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0&#39;page-offset-32bit=3Do&#39;=C2=A0 =C2=A0=3D&g=
t; \$page_offset_32bit,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0&#39;kernel-config-file=3Ds&#39;=C2=A0 =3D&gt; \$=
kernel_config_file,<br>
&gt;=C2=A0 ) or help(1);<br>
&gt;<br>
&gt;=C2=A0 help(0) if ($help);<br>
&gt; @@ -139,16 +140,15 @@ if (!$input_raw and ($squash_by_path or $squash_=
by_filename)) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0exit(128);<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; -if (!is_supported_architecture()) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0printf &quot;\nScript does not support your archi=
tecture, sorry.\n&quot;;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0printf &quot;\nCurrently we support: \n\n&quot;;<=
br>
&gt; -=C2=A0 =C2=A0 =C2=A0foreach(@SUPPORTED_ARCHITECTURES) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printf &quot;\t%s\n&q=
uot;, $_;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +show_detected_architecture() if $debug;<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0my $archname =3D $Config{archname};<br>
&gt; -=C2=A0 =C2=A0 =C2=A0printf &quot;\n\$ perl -MConfig -e \&#39;print \&=
quot;\$Config{archname}\\n\&quot;\&#39;\n&quot;;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0printf &quot;%s\n&quot;, $archname;<br>
&gt; +if (!is_known_architecture()) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0printf STDERR &quot;\nFATAL: Script does not reco=
gnize your architecture\n&quot;;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0my $arch =3D `uname -m`;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0chomp $arch;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0printf &quot;\n\$ uname -m\n&quot;;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0printf &quot;%s\n&quot;, $arch;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0exit(129);<br>
&gt;=C2=A0 }<br>
<br>
I am going to add a patch to use `uname -m` instead of `perl -MConfig<br>
...` on powerpc. Please rebase your next version.<br>
<br>
&gt; @@ -168,21 +168,45 @@ sub dprint<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0printf(STDERR @_) if $debug;<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; -sub is_supported_architecture<br>
&gt; +sub is_known_architecture<br>
<br>
Please don&#39;t change this.<br>
<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0return (is_x86_64() or is_ppc64());<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return (is_64bit() or is_32bit());<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; -sub is_x86_64<br>
&gt; +sub is_32bit<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0my $archname =3D $Config{archname};<br>
&gt; +=C2=A0 =C2=A0 =C2=A0# 32-bit actual case<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (is_ix86_32()) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if ($archname =3D~ m/x86_64/) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0# 32-bit &quot;forced&quot; case (for any arch ot=
her than IA-32)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if ($opt_32_bit or $page_offset_32bit) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt;=C2=A0 }<br>
<br>
Perhaps<br>
<br>
<br>
sub is_32bit<br>
{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 # Allow --32-bit and/or --page-offset-32bit to =
override.<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if ($opt_32_bit or $page_offset_32bit) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (is_ix86_32()) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;<br>
}<br>
<br>
<br>
&gt; +sub is_64bit<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return (is_x86_64() or is_ppc64() or is_arm64() o=
r is_mips64());<br>
&gt; +}<br>
&gt; +<br>
&gt; +sub is_x86_64<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0is_arch(&quot;x86_64&quot;);<br>
&gt; +}<br>
&gt; +<br>
&gt; +sub is_arm64<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0is_arch(&quot;aarch64&quot;);<br>
&gt; +}<br>
&gt; +<br>
&gt; +sub is_mips64<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0is_arch(&quot;mips64&quot;);<br>
&gt; +}<br>
&gt; +<br>
<br>
We cannot add these last two. There has been no talk (to my knowledge) of t=
he<br>
address format for mips64 or aarch64. If you have tested for these please<b=
r>
add as a separate patch.<br>
<br>
&gt;=C2=A0 sub is_ppc64<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0my $archname =3D $Config{archname};<br>
&gt; @@ -193,6 +217,47 @@ sub is_ppc64<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; +sub is_ix86_32<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0my $arch =3D `uname -m`;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0chomp $arch;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if ($arch =3D~ m/i[3456]86/) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; +}<br>
&gt; +<br>
&gt; +sub is_arch<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0my ($desc) =3D @_;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0my $arch =3D `uname -m`;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0chomp $arch;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if ($arch eq $desc) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; +}<br>
&gt; +<br>
&gt; +sub show_detected_architecture<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0printf &quot;Detected architecture: &quot;;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (is_32bit()) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printf &quot;32 bit\n=
&quot;;<br>
<br>
is_32bit includes the command line options so this is not _totally_<br>
correct. Prefer<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (is_x64_32()) {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ...<br>
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0} elsif (is_x86_64()) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printf &quot;x86_64\n=
&quot;;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0} elsif (is_ppc64()) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printf &quot;PPC64\n&=
quot;;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0} elsif (is_arm64()) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printf &quot;ARM64\n&=
quot;;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0} elsif (is_mips64()) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printf &quot;MIPS64\n=
&quot;;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0} else {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printf &quot;failed t=
o detect architecture\n&quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +}<br>
&gt; +<br>
&gt;=C2=A0 # gets config option value from kernel config file<br>
&gt;=C2=A0 sub get_kernel_config_option<br>
&gt;=C2=A0 {<br>
&gt; @@ -212,7 +277,6 @@ sub get_kernel_config_option<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0@config_files =3D ($tmp_file);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; -<br>
<br>
Please don&#39;t do white space changes in the middle or another patch.<br>
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0my $file =3D &#3=
9;/boot/config-&#39; . `uname -r`;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0chomp $file;<br>
&gt; @@ -220,7 +284,6 @@ sub get_kernel_config_option<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0foreach my $file (@config_files) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dprint(&quot;parsing =
config file: %s\n&quot;, $file);<br>
<br>
This should be a separate patch. &#39;One thing per patch&#39; is the kerne=
l mantra<br>
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$value =3D optio=
n_from_file($option, $file);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ($value ne &q=
uot;&quot;) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0last;<br>
&gt; @@ -258,6 +321,14 @@ sub is_false_positive<br>
&gt;=C2=A0 {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0my ($match) =3D @_;<br>
&gt;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0# 32 bit architectures, actual or forced<br>
&gt; +<br>
<br>
No need for this comment.<br>
<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (is_32bit()) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return is_false_posit=
ive_32bit($match);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0# 64 bit architectures<br>
&gt; +<br>
<br>
Or this one.<br>
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if ($match =3D~ &#39;\b(0x)?(f|F){16}\b&#39;=
 or<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$match =3D~ &#39;\b(0x)?0{16}\=
b&#39;) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
&gt; @@ -281,6 +352,58 @@ sub is_in_vsyscall_memory_region<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return ($hex &gt;=3D $region_min and $hex &l=
t;=3D $region_max);<br>
&gt;=C2=A0 }<br>
&gt;<br>
&gt; +sub is_false_positive_32bit<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0my ($match) =3D @_;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0state $page_offset =3D get_page_offset(); # only =
gets called once<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if ($match =3D~ &#39;\b(0x)?(f|F){8}\b&#39;) {<br=
>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0my $addr32 =3D hex($match);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if ($addr32 &lt; $page_offset) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; +}<br>
<br>
The return value of this sub routine is confusing. Either it should be<br>
commented as returning a hex value or it should return a string. I<br>
prefer a string since the rest of the subs in the file return strings,<br>
less cognitive load to keep everything the same. Unless there is some<br>
clear advantage to returning a hex value (which I cannot see).<br>
<br>
&gt; +sub get_page_offset<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0my $page_offset;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0my $default_offset =3D hex(&quot;0xc0000000&quot;=
);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0my @config_files;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0# Allow --page-offset-32bit to override.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if ($page_offset_32bit !=3D 0) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return $page_offset_3=
2bit;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0$page_offset =3D get_kernel_config_option(&#39;CO=
NFIG_PAGE_OFFSET&#39;);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return $default_offset;<br>
&gt; +}<br>
<br>
This is wrong.<br>
<br>
&gt; +<br>
&gt; +sub parse_kernel_config_file<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 =C2=A0my ($file) =3D @_;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0my $config =3D &#39;CONFIG_PAGE_OFFSET&#39;;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0my $str =3D &quot;&quot;;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0my $val =3D &quot;&quot;;<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0open(my $fh, &quot;&lt;&quot;, $file) or return &=
quot;&quot;;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0while (my $line =3D &lt;$fh&gt; ) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if ($line =3D~ /^$con=
fig/) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0($str, $val) =3D split /=3D/, $line;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0chomp($val);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0last;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; +<br>
&gt; +=C2=A0 =C2=A0 =C2=A0close $fh;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return $val;<br>
&gt; +}<br>
&gt; +<br>
<br>
When do you call this subroutine?<br>
<br>
&gt;=C2=A0 # True if argument potentially contains a kernel address.<br>
&gt;=C2=A0 sub may_leak_address<br>
&gt;=C2=A0 {<br>
&gt; @@ -300,8 +423,6 @@ sub may_leak_address<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0$address_re =3D get_address_re();<br>
&gt; -=C2=A0 =C2=A0 =C2=A0dprint(&quot;Kernel address regular expression: %=
s\n&quot;, $address_re);<br>
&gt; -<br>
<br>
Please see comments above on &#39;one thing per patch&#39;.<br>
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0while (/($address_re)/g) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (!is_false_po=
sitive($1)) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return 1;<br>
&gt; @@ -313,16 +434,17 @@ sub may_leak_address<br>
&gt;<br>
&gt;=C2=A0 sub get_address_re<br>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0my $re;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0my $re =3D &quot;&quot;;<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (is_x86_64()) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$re =3D get_x86_=
64_re();<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0} elsif (is_ppc64()) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$re =3D &#39;\b(=
0x)?[89abcdef]00[[:xdigit:]]{13}\b&#39;;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0}<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if ($re eq &quot;&quot;) {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0print STDERR &quot;$0=
: failed to build kernel address regular expression\n&quot;;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0###<br>
&gt; +=C2=A0 =C2=A0 =C2=A0# Any special cases for other arch&#39;s go below=
 this line<br>
&gt; +=C2=A0 =C2=A0 =C2=A0###<br>
&gt; +=C2=A0 =C2=A0 =C2=A0} else {=C2=A0 # nothing? then we assume it&#39;s=
 a generic 32-bit<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0$re =3D &#39;\b(0x)?[=
[:xdigit:]]{8}\b&#39;;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0return $re;<br>
<br>
This is messy. We definitely want to warn if we cannot fully determine<br>
the correct regex to use. Also, if you would like to default to 32-bit<br>
you will need to back it up with some reasoning. Currently there is no<br>
default if the correct regex cannot be ascertained. At this stage I feel<br=
>
this is the correct behaviour, I&#39;m open to discussion though.<br>
<br>
&gt; --<br>
&gt; 2.14.3<br>
<br>
<br>
thanks,<br>
Tobin.<br>
</blockquote></div>

--001a113de47e92119a0562a6388c--
