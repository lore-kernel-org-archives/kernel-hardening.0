Message-ID: <1512362481.17323.9.camel@gmail.com>
From: kaiwan.billimoria@gmail.com
Date: Mon, 04 Dec 2017 10:11:21 +0530
In-Reply-To: <20171204001106.GB27780@eros>
References: <1511850724-2381-1-git-send-email-me@tobin.cc>
	 <CAJ1xhMXjSTV92DxRz269sB=fZLEXJimr7_8PX8viamm02+xN1w@mail.gmail.com>
	 <20171128211003.GY17858@eros>
	 <CAJ1xhMUV8G+-e8fO2MGEWvQGpLVBsETWTpyMZ5wb9evoszZEJg@mail.gmail.com>
	 <20171129101640.GC6217@eros>
	 <CAPDLWs8ooetPXhuHXyCLZ2LnPRKBf0CSMoESbXMD4sGnLLNFuA@mail.gmail.com>
	 <20171129204812.GE6217@eros> <1512133747.17323.3.camel@gmail.com>
	 <20171204001106.GB27780@eros>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] leaking_addresses: add support for 32-bit kernel
 addresses
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Alexander Kapshuk <alexander.kapshuk@gmail.com>, linux-kernel <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 2017-12-04 at 11:11 +1100, Tobin C. Harding wrote:
> On Fri, Dec 01, 2017 at 06:39:07PM +0530, kaiwan.billimoria@gmail.com wrote:

> > @@ -267,7 +266,7 @@ sub is_false_positive
> >  sub is_false_positive_ix86_32
> >  {
> >  	my ($match) = @_;
> > -	state $page_offset = get_page_offset(); # only gets called once
> > +	state $page_offset = eval get_page_offset(); # only gets called once
> 
> Why do you use 'eval' here?
> 
Without the eval:
i.e.
  state $page_offset = get_page_offset(); # only gets called once

$ ./leaking_addresses.pl  |head -200
Argument "0x80000000" isn't numeric in numeric lt (<) at ./leaking_addresses.pl line 277.
...

With the 'eval', no warning, it's fine.


Additional Comments:

a) When running in debug mode, print the arch we're currently running on
b) Also, while checking, I found another bug; requires the fix below (strip the filename of LF).

Patch follows:

---
diff --git a/scripts/leaking_addresses.pl b/scripts/leaking_addresses.pl
index 3a8691a642c8..9906dcf8b807 100755
--- a/scripts/leaking_addresses.pl
+++ b/scripts/leaking_addresses.pl
@@ -158,8 +158,8 @@ if (!$input_raw and ($squash_by_path or $squash_by_filename)) {
        exit(128);
 }
 
+show_detected_architecture() if $debug;
 if (!is_supported_architecture()) {
-       show_detected_architecture() if $debug;
        printf "\nScript does not support your architecture, sorry.\n";
        printf "\nCurrently we support: \n\n";
        foreach(@SUPPORTED_ARCHITECTURES) {
@@ -313,6 +313,7 @@ sub get_page_offset
        }
 
        foreach my $config_file (@config_files) {
+               $config_file =~ s/\R*//g;
                $page_offset = parse_kernel_config_file($config_file);
                if ($page_offset ne "") {
                        return $page_offset;



Thanks,
Kaiwan.


> thanks,
> Tobin.
