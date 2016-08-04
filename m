Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1470328352.22643.110.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 04 Aug 2016 12:32:32 -0400
In-Reply-To: <20160804161000.GA11673@leverpostej>
References: <20160802095243.GD6862@twins.programming.kicks-ass.net>
	 <CAGXu5j+q4qWFspRCPEd5-MM05Sh_r6VYSQhP7gcAuRMygeZwjg@mail.gmail.com>
	 <20160802203037.GC6879@twins.programming.kicks-ass.net>
	 <CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
	 <87shulix2z.fsf@x220.int.ebiederm.org>
	 <1470252976.22643.41.camel@gmail.com> <20160804102854.GB4483@leverpostej>
	 <1470318323.22643.70.camel@gmail.com>
	 <20160804141109.GM6879@twins.programming.kicks-ass.net>
	 <1470325468.22643.95.camel@gmail.com> <20160804161000.GA11673@leverpostej>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-6mNzZXwJf1XajooxiGYw"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow
 further restriction of perf_event_open
To: kernel-hardening@lists.openwall.com
Cc: Peter Zijlstra <peterz@infradead.org>, Kees Cook <keescook@chromium.org>, Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>
List-ID: <kernel-hardening.lists.openwall.com>


--=-6mNzZXwJf1XajooxiGYw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-08-04 at 17:10 +0100, Mark Rutland wrote:
> On Thu, Aug 04, 2016 at 11:44:28AM -0400, Daniel Micay wrote:
> >=20
> > Qualcomm's drivers might be lower quality than core kernel code, but
> > they're way above the baseline set by mainline kernel drivers...
>=20
> I don't think that's true for the arm/arm64 perf code.

The baseline architecture support is essentially core kernel code. I
agree it's much better than the SoC vendor code. You're spending a lot
of time auditing, fuzzing and improving the code in general, which is
not true for most drivers. They don't get that attention.

> I think we've done a reasonable job of testing and fixing those, along
> with core infrastructure issues. The perf fuzzer runs for a very long
> time on a mainline kernel without issues, while on my Nexus 5x I get a
> hard lockup after ~85 seconds (and prior to the last android update
> the
> lockup was instantaneous).
>
> From my personal experience (and as above), and talking specifically
> about PMU drivers, I think that the opposite is true. This is not to
> say
> there aren't issues; I would not be surprised if there are. But it's
> disingenuous to say that mainline code is worse than that which exists
> in a vendor kernel when the latter is demonstrably much easier to
> break
> than the former.

I wasn't talking specifically about perf.

> If there are issues you are aware of, please report them. If those
> issues only exist in non-upstream code, then the applicable concerns
> are
> somewhat different (though certainly still exist).

I'm not going to do volunteer work for a corporation. I've learned that
lesson after spending years doing it.

> But please, let's frame the argument to match reality.

The argument is framed in reality. Stating that it now often takes a few
hours to find a vulnerability with the unaltered, widely known public
perf fuzzer is not impressive. It's really an argument for claiming that
it's a significant security issue.
--=-6mNzZXwJf1XajooxiGYw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIzBAABCAAdBQJXo24gFhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8ir1Hg//WBuCvmojXN//kOkxYRzNY5nBo/ijvVlpFihf8sdKI1nqJCiletPnSH7F
DTwwktn38oo+G8h5cqWpYP1eKLmQ9KSTl7DbCaiCLJRME6hRXD2nrjcyko3hXLSk
tfkKxbiVzO++V8J7hlrOomUZFO2+r+j2NRQeEkd1aGSje5fkFGYci7VMRhiu/mco
o+NnaLejWFIy6IHym7K5mCSPUbMiXNCMvo1WgUaabSm2h3ZC/5yrLdDbXAoD4RJm
ijH5B9+yPThc5e9gJLgPaOkMC0+Oy5RXBF7X7vSUZnmVWY+GdY7UzstV7lemVI9A
bO0JkFrifo8O56mpik111h3gDBM5enZigVH/szERgaWzO+MXUzPfQWsub5SSIND2
BDOODlCtbhDoKoCqnSZ4zh7VKCaqfE3/KSGKguI+4h5HDUsudAaXp82dGg8/jTL3
+0VF8/xi22gZSQZXrK5yt2vT9BY9CmQ/iFbR7YcQIFi/wgF/ARUcTdPch1dayySf
ggrsqziBDFXb7bT3N9nGU0oo+XCxOIU/2y4xvND1w7p1iNWbSrtX3gflQV7dXWI+
JxgzBBg1s/wzhAGN/oMFUwqZKA5O8aWFh13ZudLevLUyp4R6UzpIRNAl0TEdzCQ0
eTSmha4aUHZ2eKpkivm6/h2XGyhf0oKc0OTv5ebI/4+iOFlCzPs=
=SnIe
-----END PGP SIGNATURE-----

--=-6mNzZXwJf1XajooxiGYw--
