Message-ID: <1487016895.6214.8.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Mon, 13 Feb 2017 12:14:55 -0800
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC562305F372@ORSMSX103.amr.corp.intel.com>
References: <1486755469-21573-1-git-send-email-william.c.roberts@intel.com>
	 <1486757549.2192.20.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305C559@ORSMSX103.amr.corp.intel.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305C5BA@ORSMSX103.amr.corp.intel.com>
	 <1486766996.2192.30.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305DC7B@ORSMSX103.amr.corp.intel.com>
	 <1486783428.2192.44.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305F372@ORSMSX103.amr.corp.intel.com>
Content-Type: multipart/mixed; boundary="=-Y49BIzQNT1qOrE9qTkFp"
Mime-Version: 1.0
Subject: [kernel-hardening] Re: [PATCH] checkpatch: add warning on %pk instead of %pK usage
To: "Roberts, William C" <william.c.roberts@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-Y49BIzQNT1qOrE9qTkFp
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit

(resending including cc's)

On Mon, 2017-02-13 at 19:46 +0000, Roberts, William C wrote:
> > -----Original Message-----
> > From: Joe Perches [mailto:joe@perches.com]
> > Sent: Friday, February 10, 2017 7:24 PM
> > To: Roberts, William C <william.c.roberts@intel.com>; linux-
> > kernel@vger.kernel.org; apw@canonical.com
> > Cc: kernel-hardening@lists.openwall.com
> > Subject: Re: [PATCH] checkpatch: add warning on %pk instead of %pK usage
> > 
> > On Sat, 2017-02-11 at 01:32 +0000, Roberts, William C wrote:
> > > <snip>
> > > > > By "normal" I'm referring to things that call into pointer(), just
> > > > > casually looking I see bstr_printf vsnprintf kvasprintf, which
> > > > > would be easy enough to add
> > > > > 
> > > > > > What do you think is missing?  sn?printf ? That's easy to add.
> > > > > 
> > > > > The problem starts to get hairy when we think of how often folks
> > > > > roll their own logging macros (see some small sampling at the end).
> > > > > 
> > > > > I think we would want to add DEBUG DBG and sn?printf and maybe
> > > > > consider dropping the \b on the regex so it's a bit more matchy
> > > > > but still shouldn't end up matching on any ASM as you pointed out in the V2
> > 
> > nack.
> > > > > 
> > > > > Ill break this down into:
> > > > > 1. the patch as I know you'll take it, as you wrote it :-P 2.
> > > > > Adding to the logging macros 3. exploring making it less matchy
> > > 
> > > -Kees and Andrew they likely don't care about the rest of this...
> > > 
> > > I have been working up a regex (I suck at these) to match C functions
> > > that have an invalid %p format string and take arguments:
> > > http://www.regexr.com/3f92k
> > > 
> > > This could be a way to get better coverage in a more generic approach,
> > 
> > thoughts?
> > 
> > Maybe this: (attached too because Evolution is a bad email client)
> > 
> > It's still kind of hacky, but it does find multiple line statements like:
> > 
> > +		printf(KERN_INFO
> > +		       "a %pX",
> > +		       foo);
> > 
> 
> I downloaded your checkpatch.pl patch wouldn't apply for some reason... I applied it by hand and
> couldn't get it to trigger on either the case you show above or below:
> 
> +	MY_DEBUG(drv->foo,
> +		"%pk",
> +		foo->boo);
> +
> 
> > ---
> > Subject: [PATCH] checkpatch: Add ability to find bad uses of vsprintf %p
> > extensions
> > 
> > %pK was at least once misused at %pk in an out-of-tree module.
> > This lead to some security concerns.  Add the ability to track single and multiple
> > line statements for misuses of %p.
> > 
> > Signed-off-by: Joe Perches
> > ---
> >  scripts/checkpatch.pl | 26 ++++++++++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> > 
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl index
> > ad5ea5c545b2..0eaf6b8580d6 100755
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -5676,6 +5676,32 @@ sub process {
> >  			}
> >  		}
> > 
> > +		# check for vsprintf extension %p misuses
> > +		if ($^V && $^V ge 5.10.0 &&
> > +		    defined $stat &&
> > +		    $stat =~ /^\+(?![^\{]*\{\s*).*\b(\w+)\s*\(.*$String\s*,/s &&
> > +		    $1 !~ /^_*volatile_*$/) {
> > +			my $bad_extension = "";
> > +			my $lc = $stat =~ tr@\n@@;
> > +			$lc = $lc + $linenr;
> > +		        for (my $count = $linenr; $count <= $lc; $count++) {
> > +				my $fmt = get_quoted_string($lines[$count - 1],
> > raw_line($count, 0));
> > +				$fmt =~ s/%%//g;
> > +				if ($fmt =~
> > /(\%[\*\d\.]*p(?![\WFfSsBKRraEhMmIiUDdgVCbGN]).)/) {
> > +					$bad_extension = $1;
> > +					last;
> > +				}
> > +			}
> > +			if ($bad_extension ne "") {
> > +				my $stat_real = raw_line($linenr, 0);
> > +				for (my $count = $linenr + 1; $count <= $lc;
> > $count++) {
> > +					$stat_real = $stat_real . "\n" .
> > raw_line($count, 0);
> > +				}
> > +				WARN("VSPRINTF_POINTER_EXTENSION",
> > +				     "Invalid vsprintf pointer extension
> > '$bad_extension'\n" . "$here\n$stat_real\n");
> > +			}
> > +		}
> > +
> >  # Check for misused memsets
> >  		if ($^V && $^V ge 5.10.0 &&
> >  		    defined $stat &&
> > --
> 
> Mixed tabs/spaces issues. But I like the concept of matching across multiple lines. My tree was set to:
> 
> commit 7089db84e356562f8ba737c29e472cc42d530dbc
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Sun Feb 12 13:03:20 2017 -0800
> 
>     Linux 4.10-rc8
> 
> $ git apply --check ~/Downloads/0001-checkpatch-Add-ability-to-find-bad-uses-of-vsprintf-.patch
> error: patch failed: scripts/checkpatch.pl:5676
> error: scripts/checkpatch.pl: patch does not apply
> 

No worries.
No idea why it doesn't work for you.
Maybe the hand applying was somehow
faulty?

The attached is on top of -next so it does have offsets
on Linus' tree, but it seems to work.

(on -linux)

$ patch -p1 < cp_vsp.diff 
patching file scripts/checkpatch.pl
Hunk #1 succeeded at 5634 (offset -36 lines).

$ cat t_block.c
{
	MY_DEBUG(drv->foo,
		 "%pk",
		 foo->boo);
}
$ ./scripts/checkpatch.pl -f t_block.c
WARNING: Invalid vsprintf pointer extension '%pk'
#2: FILE: t_block.c:2:
+	MY_DEBUG(drv->foo,
+		 "%pk",
+		 foo->boo);

total: 0 errors, 1 warnings, 5 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

t_block.c has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

--=-Y49BIzQNT1qOrE9qTkFp
Content-Disposition: attachment; filename="cp_vsp.diff"
Content-Type: text/x-patch; name="cp_vsp.diff"; charset="ISO-8859-1"
Content-Transfer-Encoding: base64

IHNjcmlwdHMvY2hlY2twYXRjaC5wbCB8IDI2ICsrKysrKysrKysrKysrKysrKysrKysrKysrCiAx
IGZpbGUgY2hhbmdlZCwgMjYgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL3NjcmlwdHMvY2hl
Y2twYXRjaC5wbCBiL3NjcmlwdHMvY2hlY2twYXRjaC5wbAppbmRleCA4ZTk2YWY1MzYxMWMuLjRj
YjkwZDVmMDRjZSAxMDA3NTUKLS0tIGEvc2NyaXB0cy9jaGVja3BhdGNoLnBsCisrKyBiL3Njcmlw
dHMvY2hlY2twYXRjaC5wbApAQCAtNTY3MCw2ICs1NjcwLDMyIEBAIHN1YiBwcm9jZXNzIHsKIAkJ
CX0KIAkJfQogCisJCSMgY2hlY2sgZm9yIHZzcHJpbnRmIGV4dGVuc2lvbiAlcDxmb28+IG1pc3Vz
ZXMKKwkJaWYgKCReViAmJiAkXlYgZ2UgNS4xMC4wICYmCisJCSAgICBkZWZpbmVkICRzdGF0ICYm
CisJCSAgICAkc3RhdCA9fiAvXlwrKD8hW15ce10qXHtccyopLipcYihcdyspXHMqXCguKiRTdHJp
bmdccyosL3MgJiYKKwkJICAgICQxICF+IC9eXyp2b2xhdGlsZV8qJC8pIHsKKwkJCW15ICRiYWRf
ZXh0ZW5zaW9uID0gIiI7CisJCQlteSAkbGMgPSAkc3RhdCA9fiB0ckBcbkBAOworCQkJJGxjID0g
JGxjICsgJGxpbmVucjsKKwkJICAgICAgICBmb3IgKG15ICRjb3VudCA9ICRsaW5lbnI7ICRjb3Vu
dCA8PSAkbGM7ICRjb3VudCsrKSB7CisJCQkJbXkgJGZtdCA9IGdldF9xdW90ZWRfc3RyaW5nKCRs
aW5lc1skY291bnQgLSAxXSwgcmF3X2xpbmUoJGNvdW50LCAwKSk7CisJCQkJJGZtdCA9fiBzLyUl
Ly9nOworCQkJCWlmICgkZm10ID1+IC8oXCVbXCpcZFwuXSpwKD8hW1xXRmZTc0JLUnJhRWhNbUlp
VURkZ1ZDYkdOXSkuKS8pIHsKKwkJCQkJJGJhZF9leHRlbnNpb24gPSAkMTsKKwkJCQkJbGFzdDsK
KwkJCQl9CisJCQl9CisJCQlpZiAoJGJhZF9leHRlbnNpb24gbmUgIiIpIHsKKwkJCQlteSAkc3Rh
dF9yZWFsID0gcmF3X2xpbmUoJGxpbmVuciwgMCk7CisJCQkJZm9yIChteSAkY291bnQgPSAkbGlu
ZW5yICsgMTsgJGNvdW50IDw9ICRsYzsgJGNvdW50KyspIHsKKwkJCQkJJHN0YXRfcmVhbCA9ICRz
dGF0X3JlYWwgLiAiXG4iIC4gcmF3X2xpbmUoJGNvdW50LCAwKTsKKwkJCQl9CisJCQkJV0FSTigi
VlNQUklOVEZfUE9JTlRFUl9FWFRFTlNJT04iLAorCQkJCSAgICAgIkludmFsaWQgdnNwcmludGYg
cG9pbnRlciBleHRlbnNpb24gJyRiYWRfZXh0ZW5zaW9uJ1xuIiAuICIkaGVyZVxuJHN0YXRfcmVh
bFxuIik7CisJCQl9CisJCX0KKwogIyBDaGVjayBmb3IgbWlzdXNlZCBtZW1zZXRzCiAJCWlmICgk
XlYgJiYgJF5WIGdlIDUuMTAuMCAmJgogCQkgICAgZGVmaW5lZCAkc3RhdCAmJgo=


--=-Y49BIzQNT1qOrE9qTkFp--
