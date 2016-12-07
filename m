Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 7 Dec 2016 14:36:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
Message-ID: <20161207133621.GH3107@twins.programming.kicks-ass.net>
References: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
 <20161128121347.GY3092@twins.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612B41C190FC@IRSMSX102.ger.corp.intel.com>
 <20161201191543.GG3124@twins.programming.kicks-ass.net>
 <CAEXv5_isZ__znAw5vvE_srdP+irJW=TnUy2jQZxM33ZCAg037A@mail.gmail.com>
 <20161201230328.GS3045@worktop.programming.kicks-ass.net>
 <CAGXu5jLHLoPPPSEiHq-faWHDxJQWEnfc=HeC=RJ=umaqWX2Yiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLHLoPPPSEiHq-faWHDxJQWEnfc=HeC=RJ=umaqWX2Yiw@mail.gmail.com>
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: Kees Cook <keescook@chromium.org>
Cc: David Windsor <dwindsor@gmail.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 01, 2016 at 03:20:29PM -0800, Kees Cook wrote:

> There doesn't seem to be a good reason NOT to have stats_t, beyond the
> work needed to create it and audit the places it should be used.

API proliferation is a negative. Esp. if you have APIs that provide
overlapping / redundant functionality.

Its why I currently detest kref, and why I never used it (and actively
moved people away from it for code that I work on). Its daft wrappery
(and I know Greg disagrees).

Sure, you can add atomic_stats_t or whatever name gets decided upon (I
think Boqun had a good point in that there's plenty stats that are
!atomic -- also, I don't see you proposing to split "int" into separate
types per use-case), but don't expect me to use it for the code that I
write.

refcount_t makes sense in that it has clearly defined semantics that are
not elsewhere provided and doesn't provide operations that defeat those
semantics or the use-case.
