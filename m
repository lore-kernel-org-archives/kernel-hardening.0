Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Thu, 19 Jan 2017 14:15:36 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C3F2B3@IRSMSX102.ger.corp.intel.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
 <20170118215247.GA129388@gmail.com>
 <20170119091952.GH6485@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C3F0FD@IRSMSX102.ger.corp.intel.com>
 <20170119125247.GK6485@twins.programming.kicks-ass.net>
In-Reply-To: <20170119125247.GK6485@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: RE: [kernel-hardening] [RFCv2 PATCH 00/18] refcount_t API + usage
To: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Biggers <ebiggers3@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "keescook@chromium.org" <keescook@chromium.org>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "dwindsor@gmail.com" <dwindsor@gmail.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>


> On Thu, Jan 19, 2017 at 10:22:28AM +0000, Reshetova, Elena wrote:
> > > You again failed to reply to my last email on the subject. The initia=
l
> > > PaX thing was broken as heck, only later did you mention it got fixed=
. I
> > > told you we could change to that for x86 if it could be proven to be
> > > equivalent.
> >
> > I am confused on what is referred here as a fix..
>=20
> From http://lkml.kernel.org/r/20161230010627.GA9882@zzz where Eric said:
>=20
> "I do see they used to use a slightly different approach that did a decre=
ment
> instead of setting the counter to INT_MAX.  And that was clearly racy bec=
ause
> two concurrent increments could circumvent the overflow protection."

Oh, now I understand. I somehow missed this in the previous discussion, sor=
ry about this.=20
Thanks for explaining!
So, yes, I guess this is a cheap (performance wise) way to fix the race wit=
hout using cmpxchg, but
I guess this has the same issue you didn't like in it before: it ends up be=
ing not atomic when protection kicks in.=20
Whenever this a real issue or not, I am not so sure...=20

Best Regards,
Elena.
