Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Fri, 11 Nov 2016 09:20:25 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41BFF6F4@IRSMSX102.ger.corp.intel.com>
References: <1478809488-18303-1-git-send-email-elena.reshetova@intel.com>
 <1478809488-18303-13-git-send-email-elena.reshetova@intel.com>
 <20161110213334.GZ3117@twins.programming.kicks-ass.net>
In-Reply-To: <20161110213334.GZ3117@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [RFC v4 PATCH 12/13] x86: implementation for HARDENED_ATOMIC
To: Peter Zijlstra <peterz@infradead.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "keescook@chromium.org" <keescook@chromium.org>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, "will.deacon@arm.com" <will.deacon@arm.com>, Hans Liljestrand <ishkamiel@gmail.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

>On Thu, Nov 10, 2016 at 10:24:47PM +0200, Elena Reshetova wrote:
> +static __always_inline int atomic_cmpxchg_wrap(atomic_wrap_t *v, int=20
> +old, int new) {
> +	return cmpxchg(&v->counter, old, new); }

>WTH does that even mean, a wrap for a cmpxchg.

We need to provide *_wrap() alternatives to all basic atomic functions in t=
his patchset
since if we have (now or in the future) a variable in the kernel code somew=
here that
should be opt-out of protection, it should use a different type, and as a r=
esult different
functions, even if the function behind doesn't do anything differently. Peo=
ple were very
concerned on type checks and possible confusions, so we spent time adjustin=
g this to make
it hard to make mistake.=20

>I seriously detest this interface

Then we need to work further on finding a better one, if it isn't acceptabl=
e. Everyone's end goal is
to get protections in place. We knew it is going to be a long and bumpy roa=
d to get it done. At least
this shows how it can be done. Also remember that Grsecurity/PaX protected =
kernels have been running
around for a while with similar changes and their users don't seem to have =
all their drivers panicking and
machines collapsing.=20
