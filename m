Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 4 Oct 2016 16:06:31 +0300
From: Hans Liljestrand <ishkamiel@gmail.com>
Message-ID: <20161004130631.GA17762@thigreal>
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com>
 <1475476886-26232-3-git-send-email-elena.reshetova@intel.com>
 <CAGXu5jJnJODOzv4Yk=c-n9wA=hP=qza57q1EBcD4sJboVqXr3g@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612B41BDAB84@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41BDAB84@IRSMSX102.ger.corp.intel.com>
Subject: [kernel-hardening] Re: [RFC PATCH 02/13] percpu-refcount: leave atomic counter
 unprotected
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 04, 2016 at 06:24:29AM +0000, Reshetova, Elena wrote:
> On Sun, Oct 2, 2016 at 11:41 PM, Elena Reshetova <elena.reshetova@intel.com> wrote:
> > From: Hans Liljestrand <ishkamiel@gmail.com>
> >
> > This is a temporary solution, and a deviation from the PaX/Grsecurity 
> > implementation where the counter in question is protected against 
> > overflows. That however necessitates decreasing the PERCPU_COUNT_BIAS 
> > which is used in lib/percpu-refcount.c. Such a change effectively cuts 
> > the safe counter range down by half, and still allows the counter to, 
> > without warning, prematurely reach zero (which is what the bias aims 
> > to prevent).
> 
> >It might be useful to include a link to the earlier discussions that led to this solution.
> 
> Big part of it was in private emails, not sure how to reference that. Maybe we can just add more explanation here?

I can try to summarize the discussion/reasoning here. Please correct me
if/when I'm wrong.

percpu-refcount uses an atomic, which should be protected similarly to
other reference counters that this patch series tries to address. But it
is not.

--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -81,7 +81,17 @@
...
 struct percpu_ref {
-       atomic_long_t           count;
...
+       atomic_long_wrap_t      count;

The way it works (before and after our patch) is that the count needs to
be updated in a non-atomic way. This means that before all the percpu
refs are added the value could be off in either direction, but no more
than the actual "true" value of the counter. In order to prevent the
counter prematurely reaching zero, a bias (defined in
lib/percup-refcount.c) is used to offset the range from [MIN,MAX] to
[1,MAX]+[MIN,-1] (with "zero" in the middle, as far from 0 as possible).

https://github.com/ereshetova/linux-stable/commit/af44298668d12bf79f48e14396568e9f29ca4bef#diff-be7e4fe901ed6a9d5292276fef233468R34

The problem is then that if the atomic is protected it cannot wrap (and
zero is already offset next to the "wrap-barrier", so it is practically
guaranteed to do just that). The PaX/Grsecurity solution is to decrease
this bias, effectively cutting the safe range in half (now [1,MAX]). And
while overflows at MAX would be caught, the counter could still
prematurely reach zero. (Although since the counter can be off at most
by it's true value, presumably an overflow would still trigger at some
point during the percpu ref additions, but not necessarily before zero
had been reached one or more times.)

The immediate solution would be to go with the bias decrease (and
document the repercussions), but we had already seen some objections to
that due to the reasons above. Other solutions would seem to require
more comprehensive changes percpu-ref, which we felt were not suited for
this patch series. We therefore decided to switch the counter to an
atomic_long_wrap_t and just document the issue for now.
