From: "Roberts, William C" <william.c.roberts@intel.com>
Date: Fri, 10 Feb 2017 22:14:08 +0000
Message-ID: <476DC76E7D1DF2438D32BFADF679FC562305C559@ORSMSX103.amr.corp.intel.com>
References: <1486755469-21573-1-git-send-email-william.c.roberts@intel.com>
 <1486757549.2192.20.camel@perches.com>
In-Reply-To: <1486757549.2192.20.camel@perches.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH] checkpatch: add warning on %pk instead of %pK usage
To: Joe Perches <joe@perches.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>, Andew Morton <akpm@linux-foundation.org>
Cc: "keescook@chromium.org" <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>



> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Friday, February 10, 2017 12:12 PM
> To: Roberts, William C <william.c.roberts@intel.com>; linux-
> kernel@vger.kernel.org; apw@canonical.com; Andew Morton <akpm@linux-
> foundation.org>
> Cc: keescook@chromium.org; kernel-hardening@lists.openwall.com
> Subject: Re: [PATCH] checkpatch: add warning on %pk instead of %pK usage
>=20
> On Fri, 2017-02-10 at 11:37 -0800, william.c.roberts@intel.com wrote:
> > From: William Roberts <william.c.roberts@intel.com>
> >
> > Sample output:
> > WARNING: %pk is close to %pK, did you mean %pK?.
> > \#20: FILE: drivers/char/applicom.c:230:
> > +			printk(KERN_INFO "Could not allocate IRQ %d for PCI
> Applicom
> > +device. %pk\n", dev->irq, pci_get_class);
>=20
> There isn't a single instance of this in the kernel tree.
>=20
> Maybe if this is really useful, then all the %p<foo> extensions should be
> enumerated and all unknown uses should have warnings.

I was thinking of doing that, but I figured I would start with the bare min=
imum patch.

>=20
> Something like:
>=20
> ---
>  scripts/checkpatch.pl | 9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl index
> ad5ea5c545b2..8a90b457e8b5 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -5305,6 +5305,15 @@ sub process {
>  			}
>  		}
>=20
> +# check for vsprintf extension %p<foo> misuses
> +		if ($line =3D~ /\b$logFunctions\s*\(.*$String/) {
> +			my $format =3D get_quoted_string($line, $rawline);
> +			if ($format =3D~
> /(\%[\*\d\.]*p(?![\WFfSsBKRraEhMmIiUDdgVCbGN]).)/) {
> +				WARN("VSPRINTF_POINTER_EXTENSION",
> +				     "Invalid vsprintf pointer extension '$1'\n" .
> $herecurr);
> +			}
> +		}
> +
>  # check for logging continuations
>  		if ($line =3D~ /\bprintk\s*\(\s*KERN_CONT\b|\bpr_cont\s*\(/) {
>  			WARN("LOGGING_CONTINUATION",
