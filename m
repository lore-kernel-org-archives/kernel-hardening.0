Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20170119091952.GH6485@twins.programming.kicks-ass.net>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
 <20170118215247.GA129388@gmail.com> <20170119091952.GH6485@twins.programming.kicks-ass.net>
From: David Windsor <dwindsor@gmail.com>
Date: Thu, 19 Jan 2017 10:20:41 -0500
Message-ID: <CAEXv5_hXQxr=n_CPVKiqVjVwXU5FdHNhNfMDeygFOb30BcuWGw@mail.gmail.com>
Content-Type: multipart/alternative; boundary=f403045f8b3892e9250546741329
Subject: [kernel-hardening] Re: [RFCv2 PATCH 00/18] refcount_t API + usage
To: Peter Zijlstra <peterz@infradead.org>
Cc: Eric Biggers <ebiggers3@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "keescook@chromium.org" <keescook@chromium.org>, "arnd@arndb.de" <arnd@arndb.de>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "h.peter.anvin@intel.com" <h.peter.anvin@intel.com>, "will.deacon@arm.com" <will.deacon@arm.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, Elena Reshetova <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

--f403045f8b3892e9250546741329
Content-Type: text/plain; charset=UTF-8

On Thursday, January 19, 2017, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Jan 18, 2017 at 01:52:47PM -0800, Eric Biggers wrote:
>> There seems to be a lot of focus on converting things to use refcount_t
but much
>> less focus on providing a refcount_t implementation that actually meets
the
>> performance and security goals of the feature.
>
> And here you go again... :-(
>
> The refcount_t implementation does meet the security goals afaict, it
> has full saturation semantics, which means an overflow bug gets turned
> into a resource leak.
>
> That covers the entirely of the security goal. If there is more, you'll
> need to spell it out.
>
> As for performance, you didn't reply to my earlier email on the subject.
>
>> Notably, the proposed patchset
>> provides no information about why the proposed implementation was chosen
over
>> the PaX implementation (note that I'm talking about the actual
implementation of
>> safe reference counts, not the atomic_t/atomic_unchecked_t division)
which as
>> I've already mentioned is much more efficient (less bloated and faster)
while
>> still meeting the security goal.
>
> You again failed to reply to my last email on the subject. The initial
> PaX thing was broken as heck, only later did you mention it got fixed. I
> told you we could change to that for x86 if it could be proven to be
> equivalent.
>
> If you want to expedite matters, provide said proof.
>
> The scheme does not make sense for LL/SC based architectures though, so
> its not something that belongs in generic code.
>
>> I'm especially worried that people will be put
>> in a position where they need to take performance concerns into account
when
>> deciding whether to use refcount_t or not.
>
> First show a place where refcounting is performance critical, then we
> can see how much effort is required.
>
>> And the patch even still includes
>> the "don't allow incrementing a zero refcount" check which AFAICS is
bogus from
>> a security perspective.
>
> Because use-after-free isn't a security problem, right? Reference
> counting semantics are fairly clear that 0 means it is, or is going to
> be, free()'ed. How does allowing to increment at that point make any
> sense?
>
>> Even if you and Peter disagree with the comments that I and also PaX
Team have
>> made, the patch must at least explain the design decisions made.
>
> It was constructed as a generic atomic with saturation semantics because
> what was said PaX had was broken as hell (note, I have myself never
> looked at PaX code and have only seen what was sent me as derived code).
> If that later got fixed, or the derived code was buggy or whatever, your
> earlier email was the first I heard of that, and that was well after I
> wrote refcount_t.
>
> So the design decision was broken vs not-broken.
>
> Also, refcount_t is written using generic primitives (not arch
> specific), to avoid arch dependencies and provide a common
> implementation to determine semantics. That does not mean architectures
> cannot implement their own later on (matching semantics).
>

I think it's important to emphasize this: the generic refcount_t
implementation you provided is the default, arch-independent
implementation. The original PaX code had a similar system in which
default, arch-independent implementations were provided (defined in
include/asm-generic/atomic*.h, if memory serves). Individual architectures
overrode those definitions with their own, possibly optimized, versions.

Note that figuring out how this system of overridden implementations works
was pretty difficult, so we may want to investigate whether or not there's
an easier way to do what we want, or at least document where/how these
types' definitions are resolved. I have notes on this, and I bet Elena and
Hans do as well.

> Also, I agree GCC does a very poor job generating code from it. But
> again, I've not had a report where refcounting is performance critical.
> I've also been very busy with other work and haven't spend much if any
> time on this since your last email.
>
> If you want something done, contribute.
>

--f403045f8b3892e9250546741329
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<br><br>On Thursday, January 19, 2017, Peter Zijlstra &lt;<a href=3D"mailto=
:peterz@infradead.org">peterz@infradead.org</a>&gt; wrote:<br>&gt; On Wed, =
Jan 18, 2017 at 01:52:47PM -0800, Eric Biggers wrote:<br>&gt;&gt; There see=
ms to be a lot of focus on converting things to use refcount_t but much<br>=
&gt;&gt; less focus on providing a refcount_t implementation that actually =
meets the<br>&gt;&gt; performance and security goals of the feature.<br>&gt=
;<br>&gt; And here you go again... :-(<br>&gt;<br>&gt; The refcount_t imple=
mentation does meet the security goals afaict, it<br>&gt; has full saturati=
on semantics, which means an overflow bug gets turned<br>&gt; into a resour=
ce leak.<br>&gt;<br>&gt; That covers the entirely of the security goal. If =
there is more, you&#39;ll<br>&gt; need to spell it out.<br>&gt;<br>&gt; As =
for performance, you didn&#39;t reply to my earlier email on the subject.<b=
r>&gt;<br>&gt;&gt; Notably, the proposed patchset<br>&gt;&gt; provides no i=
nformation about why the proposed implementation was chosen over<br>&gt;&gt=
; the PaX implementation (note that I&#39;m talking about the actual implem=
entation of<br>&gt;&gt; safe reference counts, not the atomic_t/atomic_unch=
ecked_t division) which as<br>&gt;&gt; I&#39;ve already mentioned is much m=
ore efficient (less bloated and faster) while<br>&gt;&gt; still meeting the=
 security goal.<br>&gt;<br>&gt; You again failed to reply to my last email =
on the subject. The initial<br>&gt; PaX thing was broken as heck, only late=
r did you mention it got fixed. I<br>&gt; told you we could change to that =
for x86 if it could be proven to be<br>&gt; equivalent.<br>&gt;<br>&gt; If =
you want to expedite matters, provide said proof.<br>&gt;<br>&gt; The schem=
e does not make sense for LL/SC based architectures though, so<br>&gt; its =
not something that belongs in generic code.<br>&gt;<br>&gt;&gt; I&#39;m esp=
ecially worried that people will be put<br>&gt;&gt; in a position where the=
y need to take performance concerns into account when<br>&gt;&gt; deciding =
whether to use refcount_t or not.<br>&gt;<br>&gt; First show a place where =
refcounting is performance critical, then we<br>&gt; can see how much effor=
t is required.<br>&gt;<br>&gt;&gt; And the patch even still includes<br>&gt=
;&gt; the &quot;don&#39;t allow incrementing a zero refcount&quot; check wh=
ich AFAICS is bogus from<br>&gt;&gt; a security perspective.<br>&gt;<br>&gt=
; Because use-after-free isn&#39;t a security problem, right? Reference<br>=
&gt; counting semantics are fairly clear that 0 means it is, or is going to=
<br>&gt; be, free()&#39;ed. How does allowing to increment at that point ma=
ke any<br>&gt; sense?<br>&gt;<br>&gt;&gt; Even if you and Peter disagree wi=
th the comments that I and also PaX Team have<br>&gt;&gt; made, the patch m=
ust at least explain the design decisions made.<br>&gt;<br>&gt; It was cons=
tructed as a generic atomic with saturation semantics because<br>&gt; what =
was said PaX had was broken as hell (note, I have myself never<br>&gt; look=
ed at PaX code and have only seen what was sent me as derived code).<br>&gt=
; If that later got fixed, or the derived code was buggy or whatever, your<=
br>&gt; earlier email was the first I heard of that, and that was well afte=
r I<br>&gt; wrote refcount_t.<br>&gt;<br>&gt; So the design decision was br=
oken vs not-broken.<br>&gt;<br>&gt; Also, refcount_t is written using gener=
ic primitives (not arch<br>&gt; specific), to avoid arch dependencies and p=
rovide a common<br>&gt; implementation to determine semantics. That does no=
t mean architectures<br>&gt; cannot implement their own later on (matching =
semantics).<br>&gt;<br><br>I think it&#39;s important to emphasize this: th=
e generic refcount_t implementation you provided is the default, arch-indep=
endent implementation. The original PaX code had a similar system in which =
default, arch-independent implementations were provided (defined in include=
/asm-generic/atomic*.h, if memory serves). Individual architectures overrod=
e those definitions with their own, possibly optimized, versions. =C2=A0<br=
><br>Note that figuring out how this system of overridden implementations w=
orks was pretty difficult, so we may want to investigate whether or not the=
re&#39;s an easier way to do what we want, or at least document where/how t=
hese types&#39; definitions are resolved. I have notes on this, and I bet E=
lena and Hans do as well.<br><br>&gt; Also, I agree GCC does a very poor jo=
b generating code from it. But<br>&gt; again, I&#39;ve not had a report whe=
re refcounting is performance critical.<br>&gt; I&#39;ve also been very bus=
y with other work and haven&#39;t spend much if any<br>&gt; time on this si=
nce your last email.<br>&gt;<br>&gt; If you want something done, contribute=
.<br>&gt;

--f403045f8b3892e9250546741329--
