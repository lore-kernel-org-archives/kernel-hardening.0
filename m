Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 2 Nov 2016 23:23:10 +0200
From: Hans Liljestrand <ishkamiel@gmail.com>
Message-ID: <20161102212310.c7r2oyh2q2wfbupg@thigreal>
References: <1477914225-11298-1-git-send-email-elena.reshetova@intel.com>
 <1477914225-11298-2-git-send-email-elena.reshetova@intel.com>
 <1477993456.2236.7.camel@cvidal.org>
 <2236FBA76BA1254E88B949DDB74E612B41BFACA1@IRSMSX102.ger.corp.intel.com>
 <20161101113542.rofdy3cbgt6c3cvp@thigreal>
 <CAGXu5jL_7JQ-XKogBUo2f=7ZEX+FPdLQZQegfU1qTRBYX_ekgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jL_7JQ-XKogBUo2f=7ZEX+FPdLQZQegfU1qTRBYX_ekgw@mail.gmail.com>
Subject: Re: [kernel-hardening] [RFC v3 PATCH 01/13] Add architecture
 independent hardened atomic base
To: Kees Cook <keescook@chromium.org>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 01, 2016 at 10:19:47AM -0700, Kees Cook wrote:
> (List reply got dropped?)

Oh, sorry. Patching this back like this, hope that's okay.

> 
> On Tue, Nov 1, 2016 at 8:02 AM, Hans Liljestrand <ishkamiel@gmail.com> wrote:
> > Thanks, should probably have thought about that! :)
> >
> > Still would need to do some other changes too, the macro definitions are
> > currently repeated in several places, so we cannot just directly replace those
> > with inline functions (e.g. we have the same ifndef->defines both in atomic and
> > atomic-long, and perhaps elsewhere). Perhaps we should add a separate
> > atomic_wrap header for the atomic_wrap definitions similar to local_wrap.h?
> >
> > Would also need to decide how HARDENED_ATOMIC implemented archs manage this.
> > Currently, when not enabled, it doesn't matter whether arch _wrap functions
> > exist, they just get "hidden" by the macros. Admittedly it would probably be
> > better to get rid of this ambiguity too.
> 
> If it's going to be a lot of work, perhaps skip this for now, since
> maybe the other upstream folks interested in atomic won't share my
> opinion. :) We can re-address it in the future, if needed.

I did some quick testing with atomic_t and local_t, and got it put together
relatively easy. Most of the work spent on figuring out the macro define
approach applies here too.

Arch specific-wise (at least as far x86 goes) this required only minor
changes, mainly a bit more consistent approach to guarding _wrap definitions
depending on CONFIG_HARDENED_ATOMIC. So I don't expect this would require any
considerable changes for ARM either.

That said, I haven't yet played around with atomic64/atomic_long_t, and probably
need to take a closer look at default definitions linux/atomic.h, so I might be
celebrating too soon.

Best Regards,
-hans liljestrand
