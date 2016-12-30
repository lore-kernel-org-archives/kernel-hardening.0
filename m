Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Fri, 30 Dec 2016 12:50:45 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C32F19@IRSMSX102.ger.corp.intel.com>
References: <1482994571-18687-1-git-send-email-elena.reshetova@intel.com>
 <1482994571-18687-2-git-send-email-elena.reshetova@intel.com>
 <20161229164109.GA5891@kroah.com>
 <2236FBA76BA1254E88B949DDB74E612B41C31D08@IRSMSX102.ger.corp.intel.com>
 <20161230075804.GA6781@kroah.com>
In-Reply-To: <20161230075804.GA6781@kroah.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: RE: [kernel-hardening] Re: [RFC PATCH 01/19] Since we need to
 change the implementation, stop exposing internals. Provide kref_read() to
 read the current reference count; typically used for debug messages.
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: "keescook@chromium.org" <keescook@chromium.org>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "peterz@infradead.org" <peterz@infradead.org>, "will.deacon@arm.com" <will.deacon@arm.com>, "dwindsor@gmail.com" <dwindsor@gmail.com>, "ishkamiel@gmail.com" <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

> On Thu, Dec 29, 2016 at 04:49:26PM +0000, Reshetova, Elena wrote:
> > > On Thu, Dec 29, 2016 at 08:55:53AM +0200, Elena Reshetova wrote:
> > > > Kills two anti-patterns:
> > > >
> > > > 	atomic_read(&kref->refcount)
> > > > 	kref->refcount.counter
> > > >
> > > > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > >
> > > If you are going to send patches out, do it right, with a correct
> > > subject, your signed-off-by: added, and the rest.  Otherwise it just
> > > makes some of us cringe when we have to read these...
> >
> > I didn't want to touch Peter's patches, since I assume he would send th=
em
> separately by himself
> > and then we don't have to carry them around. However until that happens=
,
> > for testing compilation on different archs, they need to be included in=
 the series.
>=20
> Why not fix them up properly, they should be part of this series, as you
> are relying on them.  To not do so seems very strange to me...

Peter, do you have any preferences on how to handle your patches? =20
I am not sure if you wanted to send it yourself and had some plans to do sm=
th to it?=20
I can also incorporate them fully in this series, just didn't want to overr=
un any plans you had for it. =20
