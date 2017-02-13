From: "Roberts, William C" <william.c.roberts@intel.com>
Date: Mon, 13 Feb 2017 19:46:16 +0000
Message-ID: <476DC76E7D1DF2438D32BFADF679FC562305F372@ORSMSX103.amr.corp.intel.com>
References: <1486755469-21573-1-git-send-email-william.c.roberts@intel.com>
	 <1486757549.2192.20.camel@perches.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305C559@ORSMSX103.amr.corp.intel.com>
	 <476DC76E7D1DF2438D32BFADF679FC562305C5BA@ORSMSX103.amr.corp.intel.com>
	 <1486766996.2192.30.camel@perches.com>
	   <476DC76E7D1DF2438D32BFADF679FC562305DC7B@ORSMSX103.amr.corp.intel.com>
 <1486783428.2192.44.camel@perches.com>
In-Reply-To: <1486783428.2192.44.camel@perches.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH] checkpatch: add warning on %pk instead of %pK usage
To: Joe Perches <joe@perches.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "apw@canonical.com" <apw@canonical.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>



> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Friday, February 10, 2017 7:24 PM
> To: Roberts, William C <william.c.roberts@intel.com>; linux-
> kernel@vger.kernel.org; apw@canonical.com
> Cc: kernel-hardening@lists.openwall.com
> Subject: Re: [PATCH] checkpatch: add warning on %pk instead of %pK usage
>=20
> On Sat, 2017-02-11 at 01:32 +0000, Roberts, William C wrote:
> > <snip>
> > > > By "normal" I'm referring to things that call into pointer(), just
> > > > casually looking I see bstr_printf vsnprintf kvasprintf, which
> > > > would be easy enough to add
> > > >
> > > > > What do you think is missing?  sn?printf ? That's easy to add.
> > > >
> > > > The problem starts to get hairy when we think of how often folks
> > > > roll their own logging macros (see some small sampling at the end).
> > > >
> > > > I think we would want to add DEBUG DBG and sn?printf and maybe
> > > > consider dropping the \b on the regex so it's a bit more matchy
> > > > but still shouldn't end up matching on any ASM as you pointed out i=
n the V2
> nack.
> > > >
> > > > Ill break this down into:
> > > > 1. the patch as I know you'll take it, as you wrote it :-P 2.
> > > > Adding to the logging macros 3. exploring making it less matchy
> >
> > -Kees and Andrew they likely don't care about the rest of this...
> >
> > I have been working up a regex (I suck at these) to match C functions
> > that have an invalid %p format string and take arguments:
> > http://www.regexr.com/3f92k
> >
> > This could be a way to get better coverage in a more generic approach,
> thoughts?
>=20
> Maybe this: (attached too because Evolution is a bad email client)
>=20
> It's still kind of hacky, but it does find multiple line statements like:
>=20
> +		printf(KERN_INFO
> +		       "a %pX",
> +		       foo);
>=20

I downloaded your checkpatch.pl patch wouldn't apply for some reason... I a=
pplied it by hand and
couldn't get it to trigger on either the case you show above or below:

+	MY_DEBUG(drv->foo,
+		"%pk",
+		foo->boo);
+

> ---
> Subject: [PATCH] checkpatch: Add ability to find bad uses of vsprintf %p
> extensions
>=20
> %pK was at least once misused at %pk in an out-of-tree module.
> This lead to some security concerns.  Add the ability to track single and=
 multiple
> line statements for misuses of %p.
>=20
> Signed-off-by: Joe Perches
> ---
>  scripts/checkpatch.pl | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>=20
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl index
> ad5ea5c545b2..0eaf6b8580d6 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -5676,6 +5676,32 @@ sub process {
>  			}
>  		}
>=20
> +		# check for vsprintf extension %p misuses
> +		if ($^V && $^V ge 5.10.0 &&
> +		    defined $stat &&
> +		    $stat =3D~ /^\+(?![^\{]*\{\s*).*\b(\w+)\s*\(.*$String\s*,/s &&
> +		    $1 !~ /^_*volatile_*$/) {
> +			my $bad_extension =3D "";
> +			my $lc =3D $stat =3D~ tr@\n@@;
> +			$lc =3D $lc + $linenr;
> +		        for (my $count =3D $linenr; $count <=3D $lc; $count++) {
> +				my $fmt =3D get_quoted_string($lines[$count - 1],
> raw_line($count, 0));
> +				$fmt =3D~ s/%%//g;
> +				if ($fmt =3D~
> /(\%[\*\d\.]*p(?![\WFfSsBKRraEhMmIiUDdgVCbGN]).)/) {
> +					$bad_extension =3D $1;
> +					last;
> +				}
> +			}
> +			if ($bad_extension ne "") {
> +				my $stat_real =3D raw_line($linenr, 0);
> +				for (my $count =3D $linenr + 1; $count <=3D $lc;
> $count++) {
> +					$stat_real =3D $stat_real . "\n" .
> raw_line($count, 0);
> +				}
> +				WARN("VSPRINTF_POINTER_EXTENSION",
> +				     "Invalid vsprintf pointer extension
> '$bad_extension'\n" . "$here\n$stat_real\n");
> +			}
> +		}
> +
>  # Check for misused memsets
>  		if ($^V && $^V ge 5.10.0 &&
>  		    defined $stat &&
> --

Mixed tabs/spaces issues. But I like the concept of matching across multipl=
e lines. My tree was set to:

commit 7089db84e356562f8ba737c29e472cc42d530dbc
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Feb 12 13:03:20 2017 -0800

    Linux 4.10-rc8

$ git apply --check ~/Downloads/0001-checkpatch-Add-ability-to-find-bad-use=
s-of-vsprintf-.patch
error: patch failed: scripts/checkpatch.pl:5676
error: scripts/checkpatch.pl: patch does not apply
