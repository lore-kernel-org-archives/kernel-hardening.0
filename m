Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1477507968.2263.125.camel@cvidal.org>
From: Colin Vidal <colin@cvidal.org>
Date: Wed, 26 Oct 2016 20:52:48 +0200
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41BF8D57@IRSMSX102.ger.corp.intel.com>
References: <1476959131-6153-1-git-send-email-elena.reshetova@intel.com>
	 <20161020131350.GA18331@thigreal>
	 <CAGXu5jK1MNzM5Qi8o+HHekWm38n-WVPQ1Q3_EPpjYqE0kk8X0w@mail.gmail.com>
	 <20161025090559.eqsll3d7y2ifdaug@thigreal>
	 <1477415895.2263.43.camel@cvidal.org>
	 <CAEXv5_jk+2KOxL9UdZ5+6B8+JV2CBtNGi65a7ddtvxwUGmnPkA@mail.gmail.com>
	 <1477428836.2263.70.camel@cvidal.org>
	 <2236FBA76BA1254E88B949DDB74E612B41BF8C68@IRSMSX102.ger.corp.intel.com>
	 <1477471489.2263.107.camel@cvidal.org>
	 <2236FBA76BA1254E88B949DDB74E612B41BF8D57@IRSMSX102.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [kernel-hardening] [RFC v2 PATCH 00/13] HARDENED_ATOMIC
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: David Windsor <dave@progbits.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

> > > > Perhaps the cleaner solution would be to define prototypes (of
> > > > real functions, not macros) of atomic64_*_wrap functions in
asm-
> > > > generic/atomic64.h. If the arch has its own implementation of
> > > > atomic64, no problems (asm-generic/atomic64.h is not
>included),
> > > > and if CONFIG_GENERIC_ATOMIC64 is set, we just need to
> > > > implements atomic64_*_wrap functions (in a arch/lib/atomic64.c,
> > > > for instance).
> > > 
> > > Why not in lib/atomic64.c? Because this is what would be used in
> > > the case when CONFIG_GENERIC_ATOMIC is set. Also, when you say
> > > "implement", do you mean actually provide "protected" versions of
> > > wrap functions or just wrap functions themselves operating on
> > > wrap_t types but providing no difference from non-wrap functions?
> > 
> > The point is if CONFIG_GENERIC_ATOMIC64 is unset, asm-
> > generic/atomic64.h and lib/atomic64.c (see lib/Makefile) are not
> > included in compilation, therefore we don't care about that: the
> > architecture has its own implementation of atomic64 (protected
> > >and wrap version).
> 
> I would still break this case into two cases to have full picture:
> 
> (1) CONFIG_GENERIC_ATOMIC64 is unset, architecture has its own
> implementation of atomic64, but no protected and wrap versions
> (yet), CONFIG_ARCH_HARDENED_ATOMIC is unset and cannot be set.

Precision for that case. I think we have a conflict in definition of
atomic64_*_wrap macro if GENERIC_ATOMIC64 is set and HARDEDNED_ATOMIC
is set: all atomic64_*_wrap macro will be defined are in
linux/atomic.h. As GENERIC_ATOMIC64 is set too, asm-generic/atomic64.h
will be loaded, but this header also defines atomic64_*_wrap macro.

Therefore, should the macro definitions of atomic64_*_wrap if
linux/atomic.h be bounded by
CONFIG_HARDENED_ATOMIC && !CONFIG_GENERIC_ATOMIC64 ?

Of course, this is not mandatory if we decide to forbid
HARDENED_ATOMIC with GENERIC_ATOMIC64.

> (2) CONFIG_GENERIC_ATOMIC64 is unset, architecture has its own
> implementation of atomic64, with protected and wrap version,
> CONFIG_ARCH_HARDENED_ATOMIC can be both set and unset.
>
> The latter case is supported for x86 and work is going for arm and
> arm64 now.  The first case still requires that *_wrap functions are
> defined in one way or another and since we cannot rely on all
> arch. to provide them, they are currently defined in linux/atomic.h
> and simply redirect to non-wrap functions.
> 
> I guess we all agree with the above behavior?

Absolutely!

> > If CONFIG_GENERIC_ATOMIC64 is set, the common implementation is in
> > lib/atomic64.c. Therefore, any functions in lib/atomic64.c should
> > be renamed to be suffixed by _wrap (unprotected versions), and
> > prototypes with _wrap suffix should be added in
> > asm-generic/atomic64.h.
> 
> So, again for clarity, let's break this case into two cases also:
> (3) CONFIG_GENERIC_ATOMIC64 is set, architecture does not provide
> any atomic64 implementations, CONFIG_ARCH_HARDENED_ATOMIC is set
> 
> (4) CONFIG_GENERIC_ATOMIC64 is set, architecture does not provide
> any atomic64 implementations, CONFIG_ARCH_HARDENED_ATOMIC is unset
> 
> The current implementation what we have in the
> hardened_atomic_on_next branch actually treats both of these cases
> in the same way (this is what Hans was explaining before): it does
> define atomic64*_wrap functions in both cases, but they point to the
> same normal functions. So, no protection provided in any case. Based
> on the current thread it seems that we might want to have protection
> in the case (3) after all, which is not really straightforward
> (maybe that's why grsecurity didn't have support for it).
>
> Also, what's why we first wanted to know how common this case (3)
> would be in practice? Should we just merge first the common cases
> and for example as Colin was proposing make it impossible for now to
> select CONFIG_HARDENED_ATOMIC for the case (3)?

Yes, maybe this is the wiser solution for now. Say "HARDENED_ATOMIC
can't be used with CONFIG_GENERIC_ATOMIC64". It would be "dangerous"
to allows to set CONFIG_GENERIC_ATOMIC64 && HARDENED_ATOMIC if non
_wrap functions silently redirect to _wrap version.

BTW, I just looked to the generic implementation of atomic64. It seems
quite understandable: methods use spinlock to access/modify to the
value of an atomic64 variable. It seems possible to check the value
before the increment/decrements and if the resulting value is 0, but
the value before the operation was different of -1 or 1, is that an
overflow just happened (well, it is not exactly right, but this is the
global idea). Hence, we revert the change, release the lock, and kill
the process.

If this idea is correct, it would avoid specific implementation of
protected version of atomic64 for architecture with
GENERIC_ATOMIC64. And case (3) would be easily protected. What do you
think?

> Actually I believe it is not even really possible to select it now
> in this case, or am I wrong? IMO we don't have anything providing
> CONFIG_ARCH_HARDENED_ATOMIC in this case.

This is what it currently happens in practice, with a compile error.
As you said, the macro definitions of atomic64_*_wrap functions in
asm-generic/atomic64.h are translated into a call to atomic64_*
version. But as HARDENED_ATOMIC is set, atomic64_wrap_t and atomic64_t
are different types. Therefore, atomic64_* functions are called with a
atomic64_wrap_t pointer as argument, which trigger a type error.
 
> > The protected versions of functions depends of each architecture,
> > therefore they can't be generic. That why I propose to add
> > implements them in arch/lib/atomic64.c (or even
> > arch/lib/atomic64_wrap.c, it is much clear).  And yes, by
> > "implement" I means write "protected" versions. Err... Yes, in
> > that case, we don't have the "examples" implemented in PAX. But
> > the other solution would be leave GENERIC_ATOMIC64 unprotected,
> > which is really unclear from the "user" point->of-view.  If
> > CONFIG_GENERIC_ATOMIC64 is set and CONFIG_HARDENED_ATOMIC is
> > unset, the implementations in arch/lib/atomic64_wrap.c just does
> > not include the overflow test on the add/sub operations, like the
> > current protected arm/x64 implementations.
> 
> Not sure I fully follow here... In x86 case rch-specific atomic64*
> functions are defined in arch/x86/include/asm/atomic64_32/64.h. What
> location would correspond to arch/lib/atomic64.c in that case?

As x86 has its own implementation of atomic64, there is no need of a
arch/lib/atomic64.c. It is only for architecture that has
GENERIC_ATOMIC64 set. However, no problem at all if we decides to
forbid the combination HARDENED_ATOMIC && GENERIC_ATOMIC64 for now :-)

> > > Overall, I agree, there is no magic, but IMO definitions are so
> > > confusing even without wrap added (local_t and its functions is
> > > a good example), that tracking them all down is a pain.  At some
> > > point we used this table to track functions and their
> > > definition:
> > > https://docs.google.com/spreadsheets/d/12wX-csPY8tnHpQVRKVFPSOoV8
o6WXt
> > > AwKKTAkx8uUIQ/edit?usp=sharing Maybe it can be extended to
> > > include more info that people would like to see there.
> > 
> > That would be useful and avoid numerous post-it on my desk :-)
Thanks!
> 
> So, what info do you want to see there? :) Should I make one more
> table with different CONFIG on/off options and link where function
> is defined/implemented in that case?

I cannot re-open the link (it worked this morning). Do you change
something? Overall, yes, I think it would be very useful to have
written where functions are defined according the options combinations
(GENERIC_ATOMIC64 and CONFIG_HARDENED_ATOMIC). As David said, it
probably be useful to write it in the final documentation.

Thanks for this analysis, it helps to clarify that mess! :-)

Colin
