Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Thu, 19 Jan 2017 10:22:28 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41C3F0FD@IRSMSX102.ger.corp.intel.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
 <20170118215247.GA129388@gmail.com>
 <20170119091952.GH6485@twins.programming.kicks-ass.net>
In-Reply-To: <20170119091952.GH6485@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: RE: [kernel-hardening] [RFCv2 PATCH 00/18] refcount_t API + usage
To: Peter Zijlstra <peterz@infradead.org>, Eric Biggers <ebiggers3@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "keescook@chromium.org" <keescook@chromium.org>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "dwindsor@gmail.com" <dwindsor@gmail.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

> You again failed to reply to my last email on the subject. The initial
> PaX thing was broken as heck, only later did you mention it got fixed. I
> told you we could change to that for x86 if it could be proven to be
> equivalent.

I am confused on what is referred here as a fix.. Do you mean the earlier p=
roposal
to use cmpxchg instead of addl in the x86 assembly code? If yes, that indee=
d removes
races, but when performance measurements were done, it was dismissed as bei=
ng too
costly to enforce on atomic by default.=20

This had numbers on addl vs. cmpxchg:
http://www.openwall.com/lists/kernel-hardening/2016/10/04/10

Best Regards,
Elena.
