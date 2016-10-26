Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1477471489.2263.107.camel@cvidal.org>
From: Colin Vidal <colin@cvidal.org>
Date: Wed, 26 Oct 2016 10:44:49 +0200
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41BF8C68@IRSMSX102.ger.corp.intel.com>
References: <1476959131-6153-1-git-send-email-elena.reshetova@intel.com>
	 <20161020131350.GA18331@thigreal>
	 <CAGXu5jK1MNzM5Qi8o+HHekWm38n-WVPQ1Q3_EPpjYqE0kk8X0w@mail.gmail.com>
	 <20161025090559.eqsll3d7y2ifdaug@thigreal>
	 <1477415895.2263.43.camel@cvidal.org>
	 <CAEXv5_jk+2KOxL9UdZ5+6B8+JV2CBtNGi65a7ddtvxwUGmnPkA@mail.gmail.com>
	 <1477428836.2263.70.camel@cvidal.org>
	 <2236FBA76BA1254E88B949DDB74E612B41BF8C68@IRSMSX102.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [RFC v2 PATCH 00/13] HARDENED_ATOMIC
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, David Windsor <dave@progbits.org>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Elena,

> > Perhaps the cleaner solution would be to define prototypes (of real functions, not macros) of atomic64_*_wrap functions in asm- generic/atomic64.h. If the arch has its own implementation of atomic64, no problems (asm-generic/atomic64.h is not >included), and if
> > CONFIG_GENERIC_ATOMIC64 is set, we just need to implements atomic64_*_wrap functions (in a arch/lib/atomic64.c, for instance).
> 
> Why not in lib/atomic64.c? Because this is what would be used in the case when CONFIG_GENERIC_ATOMIC is set. Also, when you say "implement", do you mean actually provide "protected" versions of wrap functions or just wrap functions themselves operating on wrap_t types but providing no difference from non-wrap functions?
> 

The point is if CONFIG_GENERIC_ATOMIC64 is unset, asm-
generic/atomic64.h and lib/atomic64.c (see lib/Makefile) are not
included in compilation, therefore we don't care about that: the
architecture has its own implementation of atomic64 (protected and wrap
version).

If CONFIG_GENERIC_ATOMIC64 is set, the common implementation is in
lib/atomic64.c. Therefore, any functions in lib/atomic64.c should be
renamed to be suffixed by _wrap (unprotected versions), and prototypes
with _wrap suffix should be added in asm-generic/atomic64.h.

The protected versions of functions depends of each architecture,
therefore they can't be generic. That why I propose to add implements
them in arch/lib/atomic64.c (or even arch/lib/atomic64_wrap.c, it is
much clear).

And yes, by "implement" I means write "protected" versions. Err... Yes,
in that case, we don't have the "examples" implemented in PAX. But the
other solution would be leave GENERIC_ATOMIC64 unprotected, which is
really unclear from the "user" point-of-view.

If CONFIG_GENERIC_ATOMIC64 is set and CONFIG_HARDENED_ATOMIC is unset,
the implementations in arch/lib/atomic64_wrap.c just does not include
the overflow test on the add/sub operations, like the current protected
arm/x64 implementations.

> Overall, I agree, there is no magic, but IMO definitions are so confusing even without wrap added (local_t and its functions is a good example), that tracking them all down is a pain. 
> At some point we used this table to track functions and their definition:  https://docs.google.com/spreadsheets/d/12wX-csPY8tnHpQVRKVFPSOoV8o6WXtAwKKTAkx8uUIQ/edit?usp=sharing 
> Maybe it can be extended to include more info that people would like to see there. 

That would be useful and avoid numerous post-it on my desk :-) Thanks!

Best regards,

Colin
