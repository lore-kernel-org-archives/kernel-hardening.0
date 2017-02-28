From: "Roberts, William C" <william.c.roberts@intel.com>
Date: Tue, 28 Feb 2017 15:34:41 +0000
Message-ID: <476DC76E7D1DF2438D32BFADF679FC562307CFC1@ORSMSX103.amr.corp.intel.com>
References: <476DC76E7D1DF2438D32BFADF679FC562307BAE6@ORSMSX103.amr.corp.intel.com>
 <163a690510e636a23187c0dc9caa09ddac6d4cde.1488228427.git.joe@perches.com>
In-Reply-To: <163a690510e636a23187c0dc9caa09ddac6d4cde.1488228427.git.joe@perches.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH] checkpatch: Add ability to find bad uses of vsprintf
 %p<foo> extensions
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Whitcroft <apw@canonical.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>



> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Monday, February 27, 2017 12:55 PM
> To: Andrew Morton <akpm@linux-foundation.org>; Andy Whitcroft
> <apw@canonical.com>
> Cc: Roberts, William C <william.c.roberts@intel.com>; kernel-
> hardening@lists.openwall.com; linux-kernel@vger.kernel.org
> Subject: [PATCH] checkpatch: Add ability to find bad uses of vsprintf %p<=
foo>
> extensions
>=20
> %pK was at least once misused at %pk in an out-of-tree module.
> This lead to some security concerns.  Add the ability to track single and=
 multiple
> line statements for misuses of %p<foo>.
>=20
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-By: William Roberts <william.c.roberts@intel.com>

> ---
>=20
> Andrew, this has gone back and forth a few times.
>=20
> It's imperfect as a patch context with just a single function addition ca=
n be
> missed, but that's not new with $stat tests and just this patch.  Perhaps=
 one day
> the $stat identification mechanism can be improved.
>=20
> Until then, can you please apply this?  Thanks.
>=20
>  scripts/checkpatch.pl | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>=20
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl index
> ad5ea5c545b2..9293b8a1c121 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -5676,6 +5676,32 @@ sub process {
>  			}
>  		}
>=20
> +		# check for vsprintf extension %p<foo> misuses
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
> 2.10.0.rc2.1.g053435c
