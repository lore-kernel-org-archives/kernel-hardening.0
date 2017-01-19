Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Thu, 19 Jan 2017 08:31:58 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C3F028@IRSMSX102.ger.corp.intel.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
 <20170118215247.GA129388@gmail.com>
In-Reply-To: <20170118215247.GA129388@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: RE: [kernel-hardening] [RFCv2 PATCH 00/18] refcount_t API + usage
To: Eric Biggers <ebiggers3@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: "keescook@chromium.org" <keescook@chromium.org>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "peterz@infradead.org" <peterz@infradead.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "dwindsor@gmail.com" <dwindsor@gmail.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

> On Wed, Jan 18, 2017 at 11:11:29AM +0200, Elena Reshetova wrote:
> > Changes since v1:
> >  - kref INIT fixes are moved to a proper separate commit
> >  - Peter's commits are now properly integrated into series
> >  - various small fixes are incorporated based on testing
> >    results and feedback
> >
> > This patch series is build on top of Peter's Zijlstra patches
> > that provide refcount_t type and API definition.
>=20
> Hi Elena,

Hi Erik,

To be honest this is all tricky and I will have to explain at least some of=
 our reasoning below.
I guess some of us (me included) would prefer the PaX/grsecurity implementa=
tion for the main reason that=20
it was providing security by default to atomic_t type. That's why we first =
took PaX patches and did the porting
and etc. However, that approach was strongly objected and it seemed that we=
 need to change the approach
if we want at least to start somewhere. I guess it is classical example of =
"disagree and commit" principle in action :)
We all afterall want a better kernel security, so small steps better than n=
o steps.=20
As for this and earlier discussions I think some of your questions with reg=
ards to the initial 7 patches in the series should be answered by Peter.

> There seems to be a lot of focus on converting things to use refcount_t b=
ut much
> less focus on providing a refcount_t implementation that actually meets t=
he
> performance and security goals of the feature. =20

Together with Hans we spent a lot of time working on conversions and lookin=
g on what code needs API-wise.
We haven't really put our attention to the insides of interface since Peter=
 was behind that work and he simply
has more knowledge on the subsystem.=20

Notably, the proposed patchset
> provides no information about why the proposed implementation was chosen =
over
> the PaX implementation (note that I'm talking about the actual implementa=
tion of
> safe reference counts, not the atomic_t/atomic_unchecked_t division) whic=
h as
> I've already mentioned is much more efficient (less bloated and faster) w=
hile
> still meeting the security goal.  I'm especially worried that people will=
 be put
> in a position where they need to take performance concerns into account w=
hen
> deciding whether to use refcount_t or not. =20

We were initially thinking that these are just RFCs that we keep testing an=
d polishing, so I=20
think maybe that's why Peter had a very short description on it. However, i=
t does seem that it is already in linux-next now...
I guess maybe now it should be added to the documentation section? I agree =
that it is important to explain these things
Otherwise people either get it wrong or simply don't use refcount_t at all.=
=20

And the patch even still includes
> the "don't allow incrementing a zero refcount" check which AFAICS is bogu=
s from
> a security perspective.

Again, we mentioned this before and I am especially worried about this part=
 also from
practical point of view: it is such a big change that kernel might not be r=
eady for and it=20
would keep coming with bugs after.=20

>=20
> Even if you and Peter disagree with the comments that I and also PaX Team=
 have
> made, the patch must at least explain the design decisions made.

I personally don't disagree with some comments, but you are right we need m=
ore documentation provided.=20

Peter given that your patches are already in linux-next, where should docum=
entation/reasoning land?=20
Including it to the subsystem patches doesn't seem to make any sense to me.=
..

Best Regards,
Elena.

>=20
> I also find it strange that the actual refcount_t implementation is hidde=
n in
> patch 7/18 in the series and has subject "kref: ...", when in fact it's a=
ctually
> the most important patch and will affect much more than kref.
>=20
> Thanks,
>=20
> Eric
