From: "Reshetova, Elena" <elena.reshetova@intel.com>
Subject: RE: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon
 system call
Date: Mon, 11 Feb 2019 06:05:22 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612BA4BBA6D0@IRSMSX102.ger.corp.intel.com>
References: <1549628149-11881-1-git-send-email-elena.reshetova@intel.com>
 <1549628149-11881-2-git-send-email-elena.reshetova@intel.com>
 <20190208130544.GI32511@hirez.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612BA4BB7580@IRSMSX102.ger.corp.intel.com>
 <20190208151502.GC32494@hirez.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612BA4BB96E7@IRSMSX102.ger.corp.intel.com>
 <20190209120912.GA17668@kroah.com>
In-Reply-To: <20190209120912.GA17668@kroah.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "luto@kernel.org" <luto@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "keescook@chromium.org" <keescook@chromium.org>, "tytso@mit.edu" <tytso@mit.edu>
List-ID: <kernel-hardening.lists.openwall.com>


> On Sat, Feb 09, 2019 at 11:38:00AM +0000, Reshetova, Elena wrote:
> >
> >  On Fri, Feb 08, 2019 at 01:20:09PM +0000, Reshetova, Elena wrote:
> > > > > On Fri, Feb 08, 2019 at 02:15:49PM +0200, Elena Reshetova wrote:
> > >
> > > > I can measure the impact with rdtsc(), I think it is *very* small.
> > > > Btw, what should be the good measurement test?
> > > > I am not that happy with just looping on fopen-fclose, too
> > > > much noise.
> > >
> > > IIRC amluto had a nice micro-bench for 'pure' syscall overhead
> > > somewhere.
> > >
> > > Something like getpid/gettid in a loop should work fairly well, that'=
s a
> > > really light syscall to make.
> >
> > Thanks! Let me try this for measurements next. I was surprise that
> > there nothing  ready-made in perf or rt-tools. You would think
> > this must be regularly in a need to measure.
>=20
> lmbench has traditionally been used for something like this in the past,
> you might want to look at that too.

Thank you! I will check!

Best Regards,
Elena.
