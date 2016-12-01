Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20161201191543.GG3124@twins.programming.kicks-ass.net>
References: <2236FBA76BA1254E88B949DDB74E612B41C1884B@IRSMSX102.ger.corp.intel.com>
 <20161128121347.GY3092@twins.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612B41C190FC@IRSMSX102.ger.corp.intel.com>
 <20161201191543.GG3124@twins.programming.kicks-ass.net>
From: David Windsor <dwindsor@gmail.com>
Date: Thu, 1 Dec 2016 16:31:16 -0500
Message-ID: <CAEXv5_isZ__znAw5vvE_srdP+irJW=TnUy2jQZxM33ZCAg037A@mail.gmail.com>
Content-Type: multipart/alternative; boundary=94eb2c07ddc2aa383d05429f8a29
Subject: [kernel-hardening] Re: Conversion from atomic_t to refcount_t: summary of issues
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@chromium.org>, "will.deacon@arm.com" <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, "aik@ozlabs.ru" <aik@ozlabs.ru>, "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

--94eb2c07ddc2aa383d05429f8a29
Content-Type: text/plain; charset=UTF-8

Also, I'd like to point out that while identifying stats_t instances, I
have found a similar distribution of non-standard functions (as agreed upon
for the stats_t API).

First, usage of atomic_long_wrap_t (there currently isn't a stats_long_t
planned for implementation):

(Use
https://github.com/ereshetova/linux-stable/blob/hardened_atomic_next_stats
to view these snippets in context.  Line numbers are accurate to within a
few lines).

include/linux/mm.h:2360:
    extern atomic_long_wrap_t num_poisoned_pages;

include/linux/mmzone.h:695
    atomic_long_wrap_t      vm_stat[NR_VM_NODE_STAT_ITEMS];

mm/memory-failure.c:64:
    atomic_long_wrap_t num_poisoned_pages __read_mostly =
ATOMIC_LONG_INIT(0);

... and several others.  Note, these are only from stats_t conversions for
the mm subsystem.

Next, API calls outside of the proposed stats_t API:

kernel/auditsc.c:2029:
   if (uid_valid(loginuid))
        sessionid = (unsigned int)atomic_inc_return_wrap(&session_id);

kernel/padata.c:58:
    seq_nr = atomic_inc_return_wrap(&pd->seq_nr);

kernel/rcu/tree_trace.c:192:
    s0 += atomic_long_read_wrap(&rdp->exp_workdone0);

kernel/trace/trace_mmiotrace.c:123
    atomic_xchg_wrap(&dropped_count, 0);

... and several others.  Note, these are only from stats_t conversions in
the kernel/ directory.

I haven't yet completed my audit of the entire kernel source tree in my
atomic_t-to-stats_t conversion efforts, so I don't yet have an exhaustive
list of non-supported functions, but will at some point soon.

Thanks,
David

On Thu, Dec 1, 2016 at 2:15 PM, Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Nov 29, 2016 at 03:35:15PM +0000, Reshetova, Elena wrote:
> > but Hans will be finishing processing
>
> > > > The following functions are also needed quite commonly:
> > >
> > > > refcount_inc_return()
> > > > refcount_dec_return()
> > >
> > > What for? They don't typicaly make sense for refcounting? Other than
> the
> > > trivial pattern of dec_return() == 0, which is already well covered.
>
> Hans, could you point me to a few users of {inc,dec}_return() that I can
> audit for (in)sanity?
>

--94eb2c07ddc2aa383d05429f8a29
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Also, I&#39;d like to point out that while identifying sta=
ts_t instances, I have found a similar distribution of non-standard functio=
ns (as agreed upon for the stats_t API).<br><br>First, usage of atomic_long=
_wrap_t (there currently isn&#39;t a stats_long_t planned for implementatio=
n):<br><br>(Use <a href=3D"https://github.com/ereshetova/linux-stable/blob/=
hardened_atomic_next_stats">https://github.com/ereshetova/linux-stable/blob=
/hardened_atomic_next_stats</a> to view these snippets in context.=C2=A0 Li=
ne numbers are accurate to within a few lines). =C2=A0<br><br>include/linux=
/mm.h:2360:<br>=C2=A0 =C2=A0 extern atomic_long_wrap_t num_poisoned_pages;<=
br><br>include/linux/mmzone.h:695<br>=C2=A0 =C2=A0 atomic_long_wrap_t =C2=
=A0 =C2=A0 =C2=A0vm_stat[NR_VM_NODE_STAT_ITEMS];<br><br>mm/memory-failure.c=
:64:<br>=C2=A0 =C2=A0 atomic_long_wrap_t num_poisoned_pages __read_mostly =
=3D ATOMIC_LONG_INIT(0);<br>=C2=A0<br>... and several others.=C2=A0 Note, t=
hese are only from stats_t conversions for the mm subsystem.<br><br>Next, A=
PI calls outside of the proposed stats_t API:<br><br>kernel/auditsc.c:2029:=
<br>=C2=A0 =C2=A0if (uid_valid(loginuid))<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 se=
ssionid =3D (unsigned int)atomic_inc_return_wrap(&amp;session_id);<br><br>k=
ernel/padata.c:58:<br>=C2=A0 =C2=A0 seq_nr =3D atomic_inc_return_wrap(&amp;=
pd-&gt;seq_nr);<br><br>kernel/rcu/tree_trace.c:192:<br>=C2=A0 =C2=A0 s0 +=
=3D atomic_long_read_wrap(&amp;rdp-&gt;exp_workdone0);<br><br>kernel/trace/=
trace_mmiotrace.c:123<br>=C2=A0 =C2=A0 atomic_xchg_wrap(&amp;dropped_count,=
 0);<br><br>... and several others.=C2=A0 Note, these are only from stats_t=
 conversions in the kernel/ directory. =C2=A0<br><br>I haven&#39;t yet comp=
leted my audit of the entire kernel source tree in my atomic_t-to-stats_t c=
onversion efforts, so I don&#39;t yet have an exhaustive list of non-suppor=
ted functions, but will at some point soon. =C2=A0<br><br>Thanks,<br>David<=
/div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">On Thu, Dec =
1, 2016 at 2:15 PM, Peter Zijlstra <span dir=3D"ltr">&lt;<a href=3D"mailto:=
peterz@infradead.org" target=3D"_blank">peterz@infradead.org</a>&gt;</span>=
 wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bor=
der-left:1px #ccc solid;padding-left:1ex"><span class=3D"">On Tue, Nov 29, =
2016 at 03:35:15PM +0000, Reshetova, Elena wrote:<br>
&gt; but Hans will be finishing processing<br>
<br>
</span><span class=3D"">&gt; &gt; &gt; The following functions are also nee=
ded quite commonly:<br>
&gt; &gt;<br>
&gt; &gt; &gt; refcount_inc_return()<br>
&gt; &gt; &gt; refcount_dec_return()<br>
&gt; &gt;<br>
&gt; &gt; What for? They don&#39;t typicaly make sense for refcounting? Oth=
er than the<br>
&gt; &gt; trivial pattern of dec_return() =3D=3D 0, which is already well c=
overed.<br>
<br>
</span>Hans, could you point me to a few users of {inc,dec}_return() that I=
 can<br>
audit for (in)sanity?<br>
</blockquote></div><br></div>

--94eb2c07ddc2aa383d05429f8a29--
