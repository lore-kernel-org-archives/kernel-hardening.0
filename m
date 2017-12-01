Message-ID: <1512133747.17323.3.camel@gmail.com>
From: kaiwan.billimoria@gmail.com
Date: Fri, 01 Dec 2017 18:39:07 +0530
In-Reply-To: <20171129204812.GE6217@eros>
References: <1511850724-2381-1-git-send-email-me@tobin.cc>
	 <CAJ1xhMXjSTV92DxRz269sB=fZLEXJimr7_8PX8viamm02+xN1w@mail.gmail.com>
	 <20171128211003.GY17858@eros>
	 <CAJ1xhMUV8G+-e8fO2MGEWvQGpLVBsETWTpyMZ5wb9evoszZEJg@mail.gmail.com>
	 <20171129101640.GC6217@eros>
	 <CAPDLWs8ooetPXhuHXyCLZ2LnPRKBf0CSMoESbXMD4sGnLLNFuA@mail.gmail.com>
	 <20171129204812.GE6217@eros>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] leaking_addresses: add support for 32-bit kernel
 addresses
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Alexander Kapshuk <alexander.kapshuk@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

Applies upon the previous one in this thread.
Found and fixed some minor issues with light testing on a 32-bit x86.
(I realize this isn't an ideal description, forgive me!).

Have also emitted a 'noisy' warning on PAGE_OFFSET fallback to 0xc00000000.

Signed-off-by: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
---
 scripts/leaking_addresses.pl | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index fcf1ebe0f043..3a8691a642c8 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -160,7 +160,6 @@ if (!$input_raw and ($squash_by_path or $squash_by_filename)) {
 
 if (!is_supported_architecture()) {
 	show_detected_architecture() if $debug;
-} else {
 	printf "\nScript does not support your architecture, sorry.\n";
 	printf "\nCurrently we support: \n\n";
 	foreach(@SUPPORTED_ARCHITECTURES) {
@@ -267,7 +266,7 @@ sub is_false_positive
 sub is_false_positive_ix86_32
 {
 	my ($match) = @_;
-	state $page_offset = get_page_offset(); # only gets called once
+	state $page_offset = eval get_page_offset(); # only gets called once
 
 	if ($match =~ '\b(0x)?(f|F){8}\b') {
 		return 1;
@@ -293,7 +292,7 @@ sub get_page_offset
 	}
 
 	# Allow --kernel-config-file to override.
-	if ($kernel_config_file != "") {
+	if ($kernel_config_file ne "") {
 		@config_files = ($kernel_config_file);
 	} else {
 		my $config_file = '/boot/config-' . `uname -r`;
@@ -314,14 +313,16 @@ sub get_page_offset
 	}
 
 	foreach my $config_file (@config_files) {
-		$page_offset = parse_kernel_config($config_file);
+		$page_offset = parse_kernel_config_file($config_file);
 		if ($page_offset ne "") {
 			return $page_offset;
 		}
 	}
 
-	printf STDERR "Failed to parse kernel config files\n";
-	printf STDERR "Falling back to %s\n", $default_offset;
+	printf STDERR "\nFailed to parse kernel config files\n";
+	printf STDERR "*** NOTE ***\n";
+	printf STDERR "Falling back to PAGE_OFFSET = %s\n\n", $default_offset;
+
 	return $default_offset;
 }
 
@@ -329,11 +330,13 @@ sub parse_kernel_config_file
 {
 	my ($file) = @_;
 	my $config = 'CONFIG_PAGE_OFFSET';
+	my $str = "";
+	my $val = "";
 
 	open(my $fh, "<", $file) or return "";
 	while (my $line = <$fh> ) {
 		if ($line =~ /^$config/) {
-			my ($str, $val) = split /=/, $line;
+			($str, $val) = split /=/, $line;
 			chomp($val);
 			last;
 		}
-- 
2.14.3

On Thu, 2017-11-30 at 07:48 +1100, Tobin C. Harding wrote:
> On Wed, Nov 29, 2017 at 04:32:54PM +0530, Kaiwan N Billimoria wrote:
> > Hi,
> > 
> > On Wed, Nov 29, 2017 at 3:46 PM, Tobin C. Harding <me@tobin.cc> wrote:
> > > On Wed, Nov 29, 2017 at 09:59:59AM +0200, Alexander Kapshuk wrote:
> > > > On Tue, Nov 28, 2017 at 11:10 PM, Tobin C. Harding <me@tobin.cc> wrote:
> > > > > On Tue, Nov 28, 2017 at 03:16:24PM +0200, Alexander Kapshuk wrote:
> > > > > > On Tue, Nov 28, 2017 at 8:32 AM, Tobin C. Harding <me@tobin.cc> wrote:
> > > > > > >  Options:
> > > > > > > 
> > > > > > > -       -o, --output-raw=<file>  Save results for future processing.
> > > > > > > -       -i, --input-raw=<file>   Read results from file instead of scanning.
> > > > > > > -           --raw                Show raw results (default).
> > > > > > > -           --suppress-dmesg     Do not show dmesg results.
> > > > > > > -           --squash-by-path     Show one result per unique path.
> > > > > > > -           --squash-by-filename Show one result per unique filename.
> > > > > > > -       -d, --debug              Display debugging output.
> > > > > > > -       -h, --help, --version    Display this help and exit.
> > > > > > > +       -o, --output-raw=<file>         Save results for future processing.
> > > > > > > +       -i, --input-raw=<file>          Read results from file instead of scanning.
> > > > > > > +             --raw                       Show raw results (default).
> > > > > > > +             --suppress-dmesg            Do not show dmesg results.
> > > > > > > +             --squash-by-path            Show one result per unique path.
> > > > > > > +             --squash-by-filename        Show one result per unique filename.
> > > > > > > +           --page-offset-32bit=<hex>   PAGE_OFFSET value (for 32-bit kernels).
> > > > > > > +           --kernel-config-file=<file> Kernel configuration file (e.g /boot/config)
> > > > > > > +       -d, --debug                     Display debugging output.
> > > > > > > +       -h, --help, --version           Display this help and exit.
> > > > > > > 
> > 
> > Thanks for the whitespace fixes..
> > 
> > > > > > 
> > > > > > Get_page_offset attempts to build a list of config files, which are
> > > > > > then passed into the parsing function for further processing.
> > > > > > This splits up the code to do with the config files between
> > > > > > get_page_offset() and parse_kernel_config_file().
> > > > > > May I suggest putting the kernel config file processing code into the
> > > > > > parse_kernel_config_file() instead, and let the parsing function
> > > > > > handle the config files and either return the page_offset or an empty
> > > > > > string.
> > > > > > 
> > > > > > See below for the proposed implementation.
> > 
> > Thanks Alexander..
> > 
> > > > > 
> > > > > Nice, this is much better! Thanks.
> > > > > 
> > > > > > Apologies for the absence of indentation.
> > > > > 
> > > > > Re-posting with indentation, comments in line.
> > > > > 
> > > > > > Disclaimer: I did not test-run the code being proposed.
> > > > > 
> > > > > I also did not test my comments ;)
> > > > > 
> > > > > > sub get_page_offset
> > > > > > {
> > > > > >       my $default_offset = "0xc0000000";
> > > > > >       my $page_offset;
> > > > > > 
> > > > > >       # Allow --page-offset-32bit to over ride.
> > > > > >       if ($page_offset_32bit != 0) {
> > > > > >               return $page_offset_32bit;
> > > > > >       }
> > > > > > 
> > > > > >       $page_offset = parse_kernel_config_file();
> > > > > >       if ($page_offset ne "") {
> > > > > >               return $page_offset
> > > > > >       }
> > > > > > 
> > > > > >       printf STDERR "Failed to parse kernel config files\n";
> > > > > >       printf STDERR "Falling back to %s\n", $default_offset;
> > > > > > 
> > > > > >       return $default_offset;
> > 
> > This "fallback to 0xc0000000" I don't really agree with.
> > Obviously, there are platforms out there that do not use a PAGE_OFFSET value of
> > 0xc0000000. So I think that defaulting to this is kinda presumptive;
> > much better, IMHO,
> > if we just fail and ask the user to pass the "correct" PAGE_OFFSET value via
> > the '--page-offset-32bit=' option switch.
> > What do you say?
> 
> If we fallback to some sane value (it does not have to be 0xc0000000
> but that seems the most obvious) then the script has more chance of
> running by default. Why do I think it is better to run by default even
> with the wrong virtual address spilt, well since the correct value is
> basically just eliminating false positives (non-kernel addresses) it
> seems more right to run by default with extra false positives than to
> fail and place demands on the user. This will be especially useful if we
> get the script running in any continuous integration tools.
> 
> We should definitely be noisy if we fallback to the default value
> though.
> 
> > > > > > }
> > > > > > 
> > > > > perhaps
> > > > >                 my $tmpkconf = '/tmp/tmpkconf';
> > > > 
> > > > my $tmpkconf is almost as long as /tmp/tmpkconf. The name of the tmp
> > > > file is self explanatory.
> > > > Using a variable instead of the filename in this particular context is
> > > > a matter of personal preference. If you prefer to use the variable
> > > > here, it's your call.
> > > 
> > > I'm a stickler for no const strings or magic numbers but it's Kaiwan's
> > > patch, if he puts it in with const strings I'll apply it as is :)
> > 
> > I'd say in this case it's self-evident; IMO, we could leave it as a
> > const string..
> > 
> > > > > 
> > > > > >               if (system("gunzip < /proc/config.gz > /tmp/tmpkconf") == 0) {
> > > > > >                       push @config_files, "/tmp/tmpkconf";
> > > > > >               }
> > > > > >       }
> > > > > 
> > > > > Won't there only ever be a single config file? So if /proc/config.gz is
> > > > > readable we could do
> > > > 
> > > > The code above builds a list of config files.
> > > > Assigning to @config_files as shown below would wipe out the config
> > > > files appended to the list so far, would it not?
> > > > So $tmpkconf needs appending to the list.
> > > 
> > > You are correct, since the beginning of this function that has been the
> > > algorithm. My observation is that if /proc/config.gz is present then we
> > > don't need to parse the other files so it is better to blow them away.
> > > 
> > > I don't know enough about the whole Linux-sphere to know if this is
> > > correct. But it seems reasonable that even if there is more than one way
> > > to look at the running kernels config file they will all be the same,
> > > the system would be pretty broken if they were different.
> > > 
> > > So once we have found a readable config file just parse it and be done
> > > with it, no need to loop over any others.
> > 
> > Agreed.
> > 
> > > thanks,
> > > Tobin.
> > 
> > Tobin, am unsure why but I can't seem to apply your patch (on the
> > commit you specified: 4.15-rc1).
> > So have been unable to test so far.. Am copying the patch off the
> > email, saving and trying:
> > 
> > linux $ git apply --check ../tobin_patch_28nov17.patch
> > error: patch failed: scripts/leaking_addresses.pl:35
> > error: scripts/leaking_addresses.pl: patch does not apply
> > linux $
> 
> I just tried to save and apply it on my end and it works. How are you
> saving it? What email client are you using? Perhaps try to create a
> simple patch yourself, email to yourself, save it and apply it to a
> clean branch.
> 
> Also, if you want the commit message also you can use
> 
> 	$ git am < this.patch
> 
> Sometimes you need to perform a 3 way merge, pass '-3' to `git am` to do
> so.
> 
> Let me know how you go.
> 
> thanks,
> Tobin.
