From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Mon, 23 Jan 2017 08:52:00 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C417EE@IRSMSX102.ger.corp.intel.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
 <20170118103031.GB15169@kroah.com>
 <2236FBA76BA1254E88B949DDB74E612B41C417BD@IRSMSX102.ger.corp.intel.com>
 <20170123083619.GA32010@kroah.com>
In-Reply-To: <20170123083619.GA32010@kroah.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [RFCv2 PATCH 00/18] refcount_t API + usage
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "keescook@chromium.org" <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "peterz@infradead.org" <peterz@infradead.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "dwindsor@gmail.com" <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Monday, January 23, 2017 10:36 AM
> To: Reshetova, Elena <elena.reshetova@intel.com>
> Cc: keescook@chromium.org; kernel-hardening@lists.openwall.com;
> arnd@arndb.de; tglx@linutronix.de; mingo@redhat.com; Anvin, H Peter
> <h.peter.anvin@intel.com>; peterz@infradead.org; will.deacon@arm.com;
> dwindsor@gmail.com
> Subject: Re: [RFCv2 PATCH 00/18] refcount_t API + usage
>=20
> On Mon, Jan 23, 2017 at 07:52:17AM +0000, Reshetova, Elena wrote:
> > > Then comes the real work :)
> > >
> > > You will need to break up the remaining patches into "one-per-type" a=
nd
> > > start submitting them to the various submaintainers for inclusion.
> >
> > Could you please elaborate more on "one-per-type"? Sorry if the questio=
n is
> > too basic, but I could not find any proper explanations anywhere now.
>=20
> One patch per atomic_t variable that you change to refcount_t.

Oh, I didn't understand you meant this granularity, yes now it is clear and=
 actually pretty easy
to break down :)

>=20
> > If I run get_maintainer.pl, it sometimes produces rather big list (like=
 it was the
> > case with atomic changes for example) and for a big patch like for exam=
ple
> networking
> > it might not be straightforward to determine how to break it up properl=
y.
>=20
> I doubt that you will have a "touch the whole network stack" patch if
> you break it up into one-per-variable, but I don't really know.  See
> what it looks like when you are done.
>=20
> > If there any BKMs or generic heuristics that people use in this case?
>=20
> "BKM"?  What's that

Sorry, I was thinking it is a general English-speakers acronym (Best Known =
Method).=20

>=20
> > Does it help to send it to a general subsystem maintainer and mailing l=
ist first
> > for a look and ask how they prefer it to be broken up?
>=20
> Again, one per variable should be fine.  Then send all of the patches
> for a specific subsystem (i.e. wireless drivers) to that list and
> maintainer for the subsystem and individual driver authors.  I'm sure
> that others at Intel can help you out with this, it should be documented
> pretty well somewhere in your internal system :)

Sure, this makes sense: I was thinking we need to do smth more clever than =
this to minimize patches,
but this way it is clear. =20

Thank you very much for explaining!

Best Regards,
Elena.

>=20
> good luck!
>=20
> greg k-h
