From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Mon, 23 Jan 2017 07:52:17 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C417BD@IRSMSX102.ger.corp.intel.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
 <20170118103031.GB15169@kroah.com>
In-Reply-To: <20170118103031.GB15169@kroah.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [RFCv2 PATCH 00/18] refcount_t API + usage
To: Greg KH <gregkh@linuxfoundation.org>, "keescook@chromium.org" <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "peterz@infradead.org" <peterz@infradead.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "dwindsor@gmail.com" <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Wednesday, January 18, 2017 12:31 PM
> To: Reshetova, Elena <elena.reshetova@intel.com>
> Cc: kernel-hardening@lists.openwall.com; keescook@chromium.org;
> arnd@arndb.de; tglx@linutronix.de; mingo@redhat.com; Anvin, H Peter
> <h.peter.anvin@intel.com>; peterz@infradead.org; will.deacon@arm.com;
> dwindsor@gmail.com
> Subject: Re: [RFCv2 PATCH 00/18] refcount_t API + usage
>=20
> On Wed, Jan 18, 2017 at 11:11:29AM +0200, Elena Reshetova wrote:
> > Changes since v1:
> >  - kref INIT fixes are moved to a proper separate commit
> >  - Peter's commits are now properly integrated into series
> >  - various small fixes are incorporated based on testing
> >    results and feedback
> >
> > This patch series is build on top of Peter's Zijlstra patches
> > that provide refcount_t type and API definition.
> > The rest of patches convert various places of kernel subsystems
> > where atomic_t was used for reference counting to new refcount_t type a=
nd
> API.
> > By doing this, we make sure that underflows and overflows
> > cannot occur in these places and therefore no use-after-free situation
> > can be created and misused by an attacker.
>=20
> Your first 7 patches are fine, and most of them are already in the tip
> tree and getting use in linux-next now.  I'd recommend submitting the
> remaining one(s?) that are not there yet to be included, that will get
> refcount_t into 4.11-rc1.

Ok, so then I assume that I don't have to worry about the first 7 patches a=
nd
I just wait for them to show up.=20

>=20
> Then comes the real work :)
>=20
> You will need to break up the remaining patches into "one-per-type" and
> start submitting them to the various submaintainers for inclusion. =20

Could you please elaborate more on "one-per-type"? Sorry if the question is
too basic, but I could not find any proper explanations anywhere now.=20
If I run get_maintainer.pl, it sometimes produces rather big list (like it =
was the
case with atomic changes for example) and for a big patch like for example =
networking
it might not be straightforward to determine how to break it up properly.=20

If there any BKMs or generic heuristics that people use in this case?=20
Does it help to send it to a general subsystem maintainer and mailing list =
first
for a look and ask how they prefer it to be broken up?


>You
> can do that once 4.11-rc1 is out.  That's going to be a lot of different
> patches, and your patch-maintaince skills are going to be tested here...
>=20
> With those submissions, lots of them will start to trickly into
> linux-next and start to show up in 4.12-rc1.  You'll then need to
> refresh your patchset, drop the ones that were accepted, and do it all
> over again.  If some maintainers are just ignoring you, you'll have to
> go through some other tree for them (I can take the driver ones through
> my driver tree.)
>=20
> It's going to be work, but is totally doable.  I recommend setting up a
> separate git or quilt tree that can get included into linux-next and
> kbuild for testing and refreshing as the patches start to flow upstream.

Kees do you have preference on how to do this? Can we setup a builder on ou=
r
github tree or is it better to do on your kernel.org tree? If latter, then =
I guess=20
we would need to have rights to manage it all the time.

I would prefer git-managed tree since I feel more familiar with git than qu=
ilt. =20

>=20
> Kernel development isn't always a lot of coding, it's primarily dealing
> with stuff like this, welcome to the club :)

Thanks :)


Best Regards,
Elena.

>=20
> hope this helps,
>=20
> greg k-h
