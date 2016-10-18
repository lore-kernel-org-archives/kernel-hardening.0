Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1476825301.4032.7.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Tue, 18 Oct 2016 17:15:01 -0400
In-Reply-To: <CAGXu5jLnjWV5i3-6+wE2ME0fr4QcMsvtwQ2Q2AZNurxrxKBfRA@mail.gmail.com>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
	 <20161017134413.GK29095@leverpostej>
	 <CAGXu5jLnjWV5i3-6+wE2ME0fr4QcMsvtwQ2Q2AZNurxrxKBfRA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-jnoLMcsBK/XB0fKR/S+J"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: kernel-hardening@lists.openwall.com, Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jeff Vander Stoep <jeffv@google.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-jnoLMcsBK/XB0fKR/S+J
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-10-18 at 13:48 -0700, Kees Cook wrote:
> On Mon, Oct 17, 2016 at 6:44 AM, Mark Rutland <mark.rutland@arm.com>
> wrote:
> > Hi,
> >=20
> > Attempt to revive discussions below...
> >=20
> > On Wed, Jul 27, 2016 at 07:45:46AM -0700, Jeff Vander Stoep wrote:
> > > When kernel.perf_event_paranoid is set to 3 (or greater), disallow
> > > all access to performance events by users without CAP_SYS_ADMIN.
> > >=20
> > > This new level of restriction is intended to reduce the attack
> > > surface of the kernel. Perf is a valuable tool for developers but
> > > is generally unnecessary and unused on production systems. Perf
> > > may
> > > open up an attack vector to vulnerable device-specific drivers as
> > > recently demonstrated in CVE-2016-0805, CVE-2016-0819,
> > > CVE-2016-0843, CVE-2016-3768, and CVE-2016-3843. This new level of
> > > restriction allows for a safe default to be set on production
> > > systems
> > > while leaving a simple means for developers to grant access [1].
> > >=20
> > > This feature is derived from CONFIG_GRKERNSEC_PERF_HARDEN by Brad
> > > Spengler. It is based on a patch by Ben Hutchings [2]. Ben's
> > > patches
> > > have been modified and split up to address on-list feedback.
> > >=20
> > > kernel.perf_event_paranoid=3D3 is the default on both Debian [2] and
> > > Android [3].
> >=20
> > While people weren't particularly happy with this global toggle
> > approach, my understanding from face-to-face discussions at LSS2016
> > was
> > that people were happy with a more scoped restriction (e.g. using
> > capabilities or some other access control mechanism), but no-one had
> > the
> > time to work on that.
> >=20
> > Does that match everyone's understanding, or am I mistaken?
>=20
> That's correct: some kind of finer-grain control would be preferred to
> the maintainer, but no one has had time to work on it. (The =3D3 sysctl
> setting present in Android, Debian, and Ubuntu satisfies most people.)
>=20
> -Kees

It's also worth noting that fine-grained control via a scoped mechanism
would likely only be used to implement *more restrictions* on Android,
not to make the feature less aggressive. It's desirable for perf events
to be disabled by default for non-root across the board on Android. The
part that's imperfect is that when a developer uses a profiling tool,
unprivileged usage is automatically enabled across the board until
reboot. Ideally, it would be enabled only for the scope where it's
needed. It would be very tricky to implement though, especially without
adding friction, and it would only have value for protecting devices
being used for development. It really doesn't seem to be worth the
trouble, especially since it doesn't persist on reboot. It's only a
temporary security hole and only for developer devices.
--=-jnoLMcsBK/XB0fKR/S+J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdBQJYBpDVFhxkYW5pZWxtaWNheUBnbWFpbC5jb20ACgkQ+ecS5Zr1
8irCghAAjiFSR0UnyNXeA8gyVCrfMbYiO5syNWSoWq++G9kowJh5+iC8R9urvinW
RjUBgWym+0rZYxn0PepNoVI2xNKLUIAgFqpiLh985U9kQGh3mog7lszWjCNpSDZl
ALmcsGLdRd/HBT0AE98gfjE865K7OdRq9FrC9nws6uq/pJT3TNXXBGyAj0jxoDEM
Ly5fyBmEBvM2KSwCCzBKkqgoqlrdqemh9ApLg04eSL199iS0/ddS4mJIFbFmz1go
m+ZTbhccKnU+ya8h7ytIvSGNtISB1dnQLqRq/6xASo4Kv+wyGlSsEuR8I9FCOkm2
AHRSNw5tiCtHn5oDFrlPbgMrRukHs293b2IU2gR1hgqvBsxrR6ZZnCFT+fxU1Jzk
tQNLm3cn1wss72zSWs88bmBYNzJdfqKM9pf2uFVIw0MmMWQtEUn24SZmF/8eXdnd
jnPaPTeqFBn1xfYNT7cvPokMjSq90X303VE1hRMbBH2FTnFMPGIdosfRsomUukTI
onAPCnCck/rph/pKw8ApiVln1DSVjJQXC+aRamp+BmPtGyV+CXZqqxNeiy0t0ToY
q2/o/MSJEZSdA7L3t9nNNqcdW6w/bbdByicQ73NkC5h4LdY2iV8DuL7jhl4xPTjD
RwdjgIK0qrXFfkDzSWyWj2ZUHqPMqz3PvVGsFvpsbCnwfQEt0n8=
=nicZ
-----END PGP SIGNATURE-----

--=-jnoLMcsBK/XB0fKR/S+J--
