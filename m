Message-ID: <1487024441.6214.12.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Mon, 13 Feb 2017 14:20:41 -0800
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC562305F62F@ORSMSX103.amr.corp.intel.com>
References: <1486755469-21573-1-git-send-email-william.c.roberts@intel.com>
	 <1486757549.2192.20.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305C559@ORSMSX103.amr.corp.intel.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305C5BA@ORSMSX103.amr.corp.intel.com>
	 <1486766996.2192.30.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305DC7B@ORSMSX103.amr.corp.intel.com>
	 <1486783428.2192.44.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305F372@ORSMSX103.amr.corp.intel.com>
	 <1487016251.6214.6.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305F62F@ORSMSX103.amr.corp.intel.com>
Content-Type: multipart/mixed; boundary="=-PCsE5mlzObcbwP6nyfkI"
Mime-Version: 1.0
Subject: [kernel-hardening] Re: [PATCH] checkpatch: add warning on %pk instead of %pK usage
To: "Roberts, William C" <william.c.roberts@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-PCsE5mlzObcbwP6nyfkI
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit

(Adding back the cc's)

On Mon, 2017-02-13 at 21:28 +0000, Roberts, William C wrote:
> <snip>
> > No worries.
> > No idea why it doesn't work for you.
> > Maybe the hand applying was somehow
> > faulty?
> > 
> > The attached is on top of -next so it does have offsets on Linus' tree, but it seems
> > to work.
> > 
> > (on -linux)
> > 
> > $ patch -p1 < cp_vsp.diff
> > patching file scripts/checkpatch.pl
> > Hunk #1 succeeded at 5634 (offset -36 lines).
> > 
> > $ cat t_block.c
> > {
> > 	MY_DEBUG(drv->foo,
> > 		 "%pk",
> > 		 foo->boo);
> > }
> > $ ./scripts/checkpatch.pl -f t_block.c
> > WARNING: Invalid vsprintf pointer extension '%pk'
> > #2: FILE: t_block.c:2:
> > +	MY_DEBUG(drv->foo,
> > +		 "%pk",
> > +		 foo->boo);
> > 
> > total: 0 errors, 1 warnings, 5 lines checked
> > 
> > NOTE: For some of the reported defects, checkpatch may be able to
> >       mechanically convert to the typical style using --fix or --fix-inplace.
> > 
> > t_block.c has style problems, please review.
> > 
> > NOTE: If any of the errors are false positives, please report
> >       them to the maintainer, see CHECKPATCH in MAINTAINERS.
> 
> 
> Applied. It works fine with your example (see attached 0001-tblock.patch) but it doesn't provide
> Output for me with 0002-drv-hack.patch (attached as well)
> 
> $ ./scripts/checkpatch.pl 0002-drv-hack.patch 
> total: 0 errors, 0 warnings, 10 lines checked
> 
> 0002-drv-hack.patch has no obvious style problems and is ready for submission.
> 
> ./scripts/checkpatch.pl 0001-tblock.patch 
> WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
> #13: 
> new file mode 100644
> 
> WARNING: Invalid vsprintf pointer extension '%pk'
> #19: FILE: t_block.c:2:
> +	MY_DEBUG(drv->foo,
> +		"%pk",
> +		 foo->boo);
> 
> total: 0 errors, 2 warnings, 6 lines checked
> 
> NOTE: For some of the reported defects, checkpatch may be able to
>       mechanically convert to the typical style using --fix or --fix-inplace.
> 
> 0001-tblock.patch has style problems, please review.
> 
> NOTE: If any of the errors are false positives, please report
>       them to the maintainer, see CHECKPATCH in MAINTAINERS.

This means _all_ the $stat checks aren't being done
on patches that add just a single multi-line statement.

Andrew?  Any thoughts on how to enable $stat appropriately
for patch contexts with a single multi-line statement?

--=-PCsE5mlzObcbwP6nyfkI
Content-Disposition: attachment; filename="1.patch"
Content-Type: text/x-patch; name="1.patch"; charset="ISO-8859-1"
Content-Transfer-Encoding: base64

RnJvbSAwMDE5MTY2MTE0MWZiMTFhYmFjMjJlZmU5OGVlNThkMzdhOWQ5MzkxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXaWxsaWFtIFJvYmVydHMgPHdpbGxpYW0uYy5yb2JlcnRzQGlu
dGVsLmNvbT4KRGF0ZTogTW9uLCAxMyBGZWIgMjAxNyAxMTozNTowMyAtMDgwMApTdWJqZWN0OiBb
UEFUQ0ggMi8yXSBkcnYgaGFjawoKU2lnbmVkLW9mZi1ieTogV2lsbGlhbSBSb2JlcnRzIDx3aWxs
aWFtLmMucm9iZXJ0c0BpbnRlbC5jb20+Ci0tLQogZHJpdmVycy9jaGFyL2FwcGxpY29tLmMgfCA0
ICsrKysKIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKykKCmRpZmYgLS1naXQgYS9kcml2
ZXJzL2NoYXIvYXBwbGljb20uYyBiL2RyaXZlcnMvY2hhci9hcHBsaWNvbS5jCmluZGV4IGU1YzYy
ZGMuLjRmNjkzNGQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY2hhci9hcHBsaWNvbS5jCisrKyBiL2Ry
aXZlcnMvY2hhci9hcHBsaWNvbS5jCkBAIC0xNTMsNiArMTUzLDEwIEBAIHN0YXRpYyBpbnQgYWNf
cmVnaXN0ZXJfYm9hcmQodW5zaWduZWQgbG9uZyBwaHlzbG9jLCB2b2lkIF9faW9tZW0gKmxvYywK
IAkJcmV0dXJuIDA7CiAJfQoKKwlNWV9ERUJVRyhkcnYtPmZvbywKKwkJIiVwayIsCisJCWZvby0+
Ym9vKTsKKwogCWJvYXJkbm8tLTsKIAogCWFwYnNbYm9hcmRub10uUGh5c0lPID0gcGh5c2xvYzsK
LS0gCjIuNy40Cgo=


--=-PCsE5mlzObcbwP6nyfkI--
