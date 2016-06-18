Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1466211114.849.66.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Fri, 17 Jun 2016 20:51:54 -0400
In-Reply-To: <20160617200050.GL13337@kernel.org>
References: <20160111151958.GQ28542@decadent.org.uk>	
 <1466180207.849.50.camel@gmail.com> <20160617200050.GL13337@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-c0S7yik/Vk1HgEIpvEtI"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] [PATCH 2/2] security,perf: Allow further
 restriction of perf_event_open
To: Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, linux-doc@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


--=-c0S7yik/Vk1HgEIpvEtI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2016-06-17 at 17:00 -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jun 17, 2016 at 12:16:47PM -0400, Daniel Micay escreveu:
> > On Fri, 2016-06-17 at 08:54 +0200, Peter Zijlstra wrote:
> > > This Changelog is completely devoid of information. _WHY_ are you
> > > doing this?
> =C2=A0
> > Attack surface reduction. It's possible to use seccomp-bpf for some
> > limited cases, but it's not flexible enough. There are lots of
> > information leaks and local privilege escalation vulnerabilities via
> > perf events, yet on most Linux installs it's not ever being used. So
> > turning it off by default on those installs is an easy win. The
> > holes
> > are reduced to root -> kernel (and that's not a meaningful boundary
> > in
> > mainline right now - although as is the case here, Debian has a
> > bunch of
> > securelevel patches for that).
>=20
> Is ptrace also disabled on such systems, or any of the other more
> recent
> syscalls? The same arguments could probably be used to disable those:
> reduce attack surface, possibly the new ones have bugs as they are
> relatively new and it takes a long time for new syscalls to be more
> generally used, if we go on disabling them in such a way, they will
> probably never get used :-\

ptrace is allowed for third party apps within their SELinux domain, but
they all run as different users (so the kernel attack surface is there).
It's now disabled for privileged platform apps and most other domains. A
bit backwards, but removing it for third party apps would break
compatibility so it would have to be done at an API level bump. At
least, without deciding it is worth the cost like hidepid=3D2 in Android N
(which exposes no mechanism for exceptions in 3rd party apps, only the
base system).

If seccomp-bpf didn't imply such high system call overhead outside of
x86_64, Android would probably be walling off some new system calls. It
needs 2-phase lookup similar to x86 on ARM. Android kernels do avoid
enabling lots of kernel functionality from System V IPC to USERNS
though. New features wouldn't end up enabled if they were behind config
options without an explicit choice.

> Wouldn't the recent bump in perf_event_paranoid to 2 enough? I.e. only
> allow profiling of user tasks?

Most of the vulnerabilities are still exposed at 2. That prevents
leaking information about the kernel WITHOUT vulnerabilities though, and
would be an improvement when perf is disabled - but that doesn't really
matter much (Android kernel debugging and profiling would also still
work with 2).

> Or is there something more specific that we should disable/constrain
> to
> reduce such surface contact without using such a big hammer?

It's desired to have it globally disabled by default. Could use seccomp-
bpf to globally disable it, but that's a bigger hammer because it can't
be globally turned off without a reboot (could only profile newly
spawned processes after disabling it). Since it's only going to be
enabled by developers, trying to make it more fine-grained wouldn't
really pay off.
--=-c0S7yik/Vk1HgEIpvEtI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXZJsqAAoJEPnnEuWa9fIqUKYP/1xfOpnhHcWGOnCH7EGsxowF
Bf0fK4FnKloLEMVojT7CSF54SfbrsNMrV1WiSKqBx8HoopZqr8A2FGGrVkZ5OnMm
Tnc2ZrXFv0tS4yFpoh6VHI04xuXgkUp9bpi+W8oyNkcT87tCYWVuzYnZWywSsA9W
SzXNisNNcDwlH6Lgw6TIWzjxkDsQ/DpN6QRlo7EjHB7DZgxqRhmLpIQsW9v1uziy
CTRwBKct+FuMu6JQQKi+vzEBSk468gLKcowN//5ng2lRP32QB5oKRjkyknhMoiHE
H03Hi1wMDLR8lD++1BPY1W9+o+ldzfb0w/e6CGqeLEBd0zRHkaWQb5xSMO7pJwHx
4rjOKVT6GAlK4S876cqAw2vOzfljAnh4QTjp3qhnKMIvtjKpqXuba2duZK14tM3s
uRPYn0ej+OPPf3eKWHGRr2TP8ryfm7u0h76uldpR+esfktNP/EO8hG6Oj+jpd9sA
qodbV/8r+sjzheN+sZgsWvD8FRtX9v4WotD8o0hb3TXs3bLxIA+QE87GVC2qSDak
3Vm9OxOThLPEYtNTlsLfBjsOcokAMXb0eQTav451CdyJlAuJNubxUaGzOSURNNiR
7dYyLdOxB72BHRewhmVMxVIbgWvlVa5IsQutcbhhe9z03/MkGJWP8bbSVVs8g6EM
yEMpn0CPcTdaT5JjrFSM
=h0s6
-----END PGP SIGNATURE-----

--=-c0S7yik/Vk1HgEIpvEtI--
