Message-ID: <1487275371.9667.1.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 16 Feb 2017 15:02:51 -0500
In-Reply-To: <63b8eab1-4384-688a-33cd-b648c99497a8@schaufler-ca.com>
References: <alpine.LRH.2.20.1702150016220.32759@namei.org>
	 <201702142324.IFB95862.MOSJLOVFQFtFHO@I-love.SAKURA.ne.jp>
	 <alpine.LRH.2.20.1702150952360.6813@namei.org>
	 <201702152342.GBH04183.FOFJFHQOLMOtVS@I-love.SAKURA.ne.jp>
	 <a5022e72-287b-e0d1-aa54-888eb569ac1f@schaufler-ca.com>
	 <201702162000.EAC43726.FOSVQtJFHMFOLO@I-love.SAKURA.ne.jp>
	 <63b8eab1-4384-688a-33cd-b648c99497a8@schaufler-ca.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-FZfOg9QKKnK4L3n6XYNy"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] Re: [RFC v2 PATCH 1/2] security: introduce
 CONFIG_SECURITY_WRITABLE_HOOKS
To: Casey Schaufler <casey@schaufler-ca.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>


--=-FZfOg9QKKnK4L3n6XYNy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> > =C2=A0At least one antivirus software (which allows
> > anonymous download of LKM source code) is using LSM hooks since
> > Linux 2.6.32
> > instead of rewriting syscall tables. We are already allowing
> > multiple concurrent
> > LSM modules (up to one fully armored module which uses "struct
> > cred"->security
> > field or exclusive hooks like security_xfrm_state_pol_flow_match(),
> > plus
> > unlimited number of lightweight modules which do not use "struct
> > cred"->security
> > nor exclusive hooks) as long as they are built into the kernel.
> > There is no
> > reason to keep LKM based LSM modules from antivirus software or
> > alike away.
>=20
> We're not to the point where in-kernel modules are stacking fully.
> Not everyone is on board for that, but hope springs eternal. Part
> of the design criteria I'm working under is that it shouldn't
> preclude loadable modules, and I still think that's doable. The
> patch James proposed is completely compatible with this philosophy.
> You can argue that it requires a loadable module configuration be
> less "hardened", but the opponents of loadable modules say that is
> inherent to loadable modules.

FWIW, the full infrastructure for read-only data from PaX includes a way
to make data temporary writable for a kernel thread. In PaX,
__ro_after_init was/is called __read_only and pax_open_kernel /
pax_close_kernel make it usable for rarely written data. That could
easily land before loadable LSMs.
--=-FZfOg9QKKnK4L3n6XYNy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQJKBAABCAA0FiEEZe7+AiEI4rcIy/z3+ecS5Zr18ioFAlimBWsWHGRhbmllbG1p
Y2F5QGdtYWlsLmNvbQAKCRD55xLlmvXyKhmnD/9Vy+Sh1MErIqJVpgQNyDVsZV0k
lahm3Qjpv2O6LMl6EVc4jtkZ6lPLkE1oM39k3VIE0t/p6bh/iJVS9gU9/P5HxZZu
cec9YUY5DyPjT0PBRsOMalFAFOwIF/b8BQpKqz+kGm9cs4S0MyT0pW04TQcHGE1n
tKrWKUKT7yKA4RcslcmJ9VeHpzLx18IM24JIoOpybvxmn6czxdQV86ld/SN2etob
XK3TFNQtSTu9f/B58XoB1iWd2leZiEJ+rE4ymorX+JQq6smZunSr4ORu8qJlpV7+
9q7aYLGICXvWGZaPJgmT6OkG/+E3fzXRinYehef38ePxP19QUWqtAI04n6UCaxJ+
TRXOL0O1Oql41PRCeCoi0FmeZ9zuL4ovTpZ2WZc4mntRPUYk90UxFJEDq4onyE9U
Pb4tMvJCZwxv68hIuX/T4boW00SL7NS9TjbNalyt0yeiqSxniU7iHu6IfQsDpgkd
IVJM/XwrYRib4bJe6DpCL/xK88sSntISpJBZ/vvgertqgsn1mp0A6bkIHROS2yv8
bTSJM8oMytCt7rK7Hazc4TrRj6SOc53Sjt1/NIhq5nMl6CuhObetYF1ISCzO0uid
einFo5Hte7jYLpiO5AecIJoVPGsjpmT0cGTnEVplzsEt5MLNYDwrVFrPsHayJC3k
vn2X+wNbkZ0nK82YNg==
=iSro
-----END PGP SIGNATURE-----

--=-FZfOg9QKKnK4L3n6XYNy--
