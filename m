Message-ID: <1486783428.2192.44.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Fri, 10 Feb 2017 19:23:48 -0800
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC562305DC7B@ORSMSX103.amr.corp.intel.com>
References: <1486755469-21573-1-git-send-email-william.c.roberts@intel.com>
	 <1486757549.2192.20.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305C559@ORSMSX103.amr.corp.intel.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305C5BA@ORSMSX103.amr.corp.intel.com>
	 <1486766996.2192.30.camel@perches.com>
	   <476DC76E7D1DF2438D32BFADF679FC562305DC7B@ORSMSX103.amr.corp.intel.com>
Content-Type: multipart/mixed; boundary="=-HI7W5xdedkxGCZmNQ6ML"
Mime-Version: 1.0
Subject: [kernel-hardening] Re: [PATCH] checkpatch: add warning on %pk instead of %pK usage
To: "Roberts, William C" <william.c.roberts@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-HI7W5xdedkxGCZmNQ6ML
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On Sat, 2017-02-11 at 01:32 +0000, Roberts, William C wrote:
> <snip>
> > > By "normal" I'm referring to things that call into pointer(), just
> > > casually looking I see bstr_printf vsnprintf kvasprintf, which would
> > > be easy enough to add
> > > 
> > > > What do you think is missing?  sn?printf ? That's easy to add.
> > > 
> > > The problem starts to get hairy when we think of how often folks roll
> > > their own logging macros (see some small sampling at the end).
> > > 
> > > I think we would want to add DEBUG DBG and sn?printf and maybe
> > > consider dropping the \b on the regex so it's a bit more matchy but
> > > still shouldn't end up matching on any ASM as you pointed out in the V2 nack.
> > > 
> > > Ill break this down into:
> > > 1. the patch as I know you'll take it, as you wrote it :-P 2. Adding
> > > to the logging macros 3. exploring making it less matchy
> 
> -Kees and Andrew they likely don't care about the rest of this...
> 
> I have been working up a regex (I suck at these) to match C functions that have an invalid
> %p format string and take arguments:
> http://www.regexr.com/3f92k
> 
> This could be a way to get better coverage in a more generic approach, thoughts?

Maybe this: (attached too because Evolution is a bad email client)

It's still kind of hacky, but it does find multiple line
statements like:

+		printf(KERN_INFO
+		       "a %pX",
+		       foo);

---
Subject: [PATCH] checkpatch: Add ability to find bad uses of vsprintf %p extensions

%pK was at least once misused at %pk in an out-of-tree module.
This lead to some security concerns.  Add the ability to track
single and multiple line statements for misuses of %p.

Signed-off-by: Joe Perches 
---
 scripts/checkpatch.pl | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index ad5ea5c545b2..0eaf6b8580d6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -5676,6 +5676,32 @@ sub process {
 			}
 		}
 
+		# check for vsprintf extension %p misuses
+		if ($^V && $^V ge 5.10.0 &&
+		    defined $stat &&
+		    $stat =~ /^\+(?![^\{]*\{\s*).*\b(\w+)\s*\(.*$String\s*,/s &&
+		    $1 !~ /^_*volatile_*$/) {
+			my $bad_extension = "";
+			my $lc = $stat =~ tr@\n@@;
+			$lc = $lc + $linenr;
+		        for (my $count = $linenr; $count <= $lc; $count++) {
+				my $fmt = get_quoted_string($lines[$count - 1], raw_line($count, 0));
+				$fmt =~ s/%%//g;
+				if ($fmt =~ /(\%[\*\d\.]*p(?![\WFfSsBKRraEhMmIiUDdgVCbGN]).)/) {
+					$bad_extension = $1;
+					last;
+				}
+			}
+			if ($bad_extension ne "") {
+				my $stat_real = raw_line($linenr, 0);
+				for (my $count = $linenr + 1; $count <= $lc; $count++) {
+					$stat_real = $stat_real . "\n" . raw_line($count, 0);
+				}
+				WARN("VSPRINTF_POINTER_EXTENSION",
+				     "Invalid vsprintf pointer extension '$bad_extension'\n" . "$here\n$stat_real\n");
+			}
+		}
+
 # Check for misused memsets
 		if ($^V && $^V ge 5.10.0 &&
 		    defined $stat &&
-- 

--=-HI7W5xdedkxGCZmNQ6ML
Content-Disposition: attachment;
	filename*0=0001-checkpatch-Add-ability-to-find-bad-uses-of-vsprintf-.pat;
	filename*1=ch
Content-Type: text/x-patch;
	name="0001-checkpatch-Add-ability-to-find-bad-uses-of-vsprintf-.patch";
	charset="ISO-8859-1"
Content-Transfer-Encoding: base64

RnJvbSAzYmQ2ODY4NzExZWZlYjU4N2M1YzQ4ZTA2MGM0MTVhMTUwZmNjYWNhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8M2JkNjg2ODcxMWVmZWI1ODdjNWM0OGUwNjBjNDE1
YTE1MGZjY2FjYS4xNDg2NzgzMjI0LmdpdC5qb2VAcGVyY2hlcy5jb20+CkZyb206IEpvZSBQZXJj
aGVzIDxqb2VAcGVyY2hlcy5jb20+CkRhdGU6IEZyaSwgMTAgRmViIDIwMTcgMTk6MTc6NDIgLTA4
MDAKU3ViamVjdDogW1BBVENIXSBjaGVja3BhdGNoOiBBZGQgYWJpbGl0eSB0byBmaW5kIGJhZCB1
c2VzIG9mIHZzcHJpbnRmICVwPGZvbz4KIGV4dGVuc2lvbnMKCiVwSyB3YXMgYXQgbGVhc3Qgb25j
ZSBtaXN1c2VkIGF0ICVwayBpbiBhbiBvdXQtb2YtdHJlZSBtb2R1bGUuClRoaXMgbGVhZCB0byBz
b21lIHNlY3VyaXR5IGNvbmNlcm5zLiAgQWRkIHRoZSBhYmlsaXR5IHRvIHRyYWNrCnNpbmdsZSBh
bmQgbXVsdGlwbGUgbGluZSBzdGF0ZW1lbnRzIGZvciBtaXN1c2VzIG9mICVwPGZvbz4uCgpTaWdu
ZWQtb2ZmLWJ5OiBKb2UgUGVyY2hlcyA8am9lQHBlcmNoZXMuY29tPgotLS0KIHNjcmlwdHMvY2hl
Y2twYXRjaC5wbCB8IDI2ICsrKysrKysrKysrKysrKysrKysrKysrKysrCiAxIGZpbGUgY2hhbmdl
ZCwgMjYgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL3NjcmlwdHMvY2hlY2twYXRjaC5wbCBi
L3NjcmlwdHMvY2hlY2twYXRjaC5wbAppbmRleCBhZDVlYTVjNTQ1YjIuLjBlYWY2Yjg1ODBkNiAx
MDA3NTUKLS0tIGEvc2NyaXB0cy9jaGVja3BhdGNoLnBsCisrKyBiL3NjcmlwdHMvY2hlY2twYXRj
aC5wbApAQCAtNTY3Niw3ICs1Njc2LDMyIEBAIHN1YiBwcm9jZXNzIHsKIAkJCX0KIAkJfQogCisJ
CSMgY2hlY2sgZm9yIHZzcHJpbnRmIGV4dGVuc2lvbiAlcDxmb28+IG1pc3VzZXMKKwkJaWYgKCRe
ViAmJiAkXlYgZ2UgNS4xMC4wICYmCisJCSAgICBkZWZpbmVkICRzdGF0ICYmCisJCSAgICAkc3Rh
dCA9fiAvXlwrKD8hW15ce10qXHtccyopLipcYihcdyspXHMqXCguKiRTdHJpbmdccyosL3MgJiYK
KwkJICAgICQxICF+IC9eXyp2b2xhdGlsZV8qJC8pIHsKKwkJCW15ICRiYWRfZXh0ZW5zaW9uID0g
IiI7CisJCQlteSAkbGMgPSAkc3RhdCA9fiB0ckBcbkBAOworCQkJJGxjID0gJGxjICsgJGxpbmVu
cjsKKwkJICAgICAgICBmb3IgKG15ICRjb3VudCA9ICRsaW5lbnI7ICRjb3VudCA8PSAkbGM7ICRj
b3VudCsrKSB7CisJCQkJbXkgJGZtdCA9IGdldF9xdW90ZWRfc3RyaW5nKCRsaW5lc1skY291bnQg
LSAxXSwgcmF3X2xpbmUoJGNvdW50LCAwKSk7CisJCQkJJGZtdCA9fiBzLyUlLy9nOworCQkJCWlm
ICgkZm10ID1+IC8oXCVbXCpcZFwuXSpwKD8hW1xXRmZTc0JLUnJhRWhNbUlpVURkZ1ZDYkdOXSku
KS8pIHsKKwkJCQkJJGJhZF9leHRlbnNpb24gPSAkMTsKKwkJCQkJbGFzdDsKKwkJCQl9CisJCQl9
CisJCQlpZiAoJGJhZF9leHRlbnNpb24gbmUgIiIpIHsKKwkJCQlteSAkc3RhdF9yZWFsID0gcmF3
X2xpbmUoJGxpbmVuciwgMCk7CisJCQkJZm9yIChteSAkY291bnQgPSAkbGluZW5yICsgMTsgJGNv
dW50IDw9ICRsYzsgJGNvdW50KyspIHsKKwkJCQkJJHN0YXRfcmVhbCA9ICRzdGF0X3JlYWwgLiAi
XG4iIC4gcmF3X2xpbmUoJGNvdW50LCAwKTsKKwkJCQl9CisJCQkJV0FSTigiVlNQUklOVEZfUE9J
TlRFUl9FWFRFTlNJT04iLAorCQkJCSAgICAgIkludmFsaWQgdnNwcmludGYgcG9pbnRlciBleHRl
bnNpb24gJyRiYWRfZXh0ZW5zaW9uJ1xuIiAuICIkaGVyZVxuJHN0YXRfcmVhbFxuIik7CisJCQl9
CisJCX0KKwogIyBDaGVjayBmb3IgbWlzdXNlZCBtZW1zZXRzCiAJCWlmICgkXlYgJiYgJF5WIGdl
IDUuMTAuMCAmJgogCQkgICAgZGVmaW5lZCAkc3RhdCAmJgotLSAKMi4xMC4wLnJjMi4xLmcwNTM0
MzVjCgo=


--=-HI7W5xdedkxGCZmNQ6ML--
