Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
 <20160802095243.GD6862@twins.programming.kicks-ass.net> <CAGXu5j+q4qWFspRCPEd5-MM05Sh_r6VYSQhP7gcAuRMygeZwjg@mail.gmail.com>
 <20160802203037.GC6879@twins.programming.kicks-ass.net> <CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
In-Reply-To: <CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
From: Jeffrey Vander Stoep <jeffv@google.com>
Date: Tue, 02 Aug 2016 21:06:02 +0000
Message-ID: <CABXk95DyLX2WUi-2Q-yPzh_52BXdDrbPaLXxSbrLDyegdHNbTQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a113dd73a3d339405391d1661
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

--001a113dd73a3d339405391d1661
Content-Type: text/plain; charset=UTF-8

Far from trying to kill perf, we want (and require) perf to be available to
developers on Android. All that this patch enables us to do is gate it
behind developer settings - just like we do with other developer targeted
features.


On Tue, Aug 2, 2016 at 1:51 PM Kees Cook <keescook@chromium.org> wrote:

> On Tue, Aug 2, 2016 at 1:30 PM, Peter Zijlstra <peterz@infradead.org>
> wrote:
> > On Tue, Aug 02, 2016 at 12:04:34PM -0700, Kees Cook wrote:
> >
> >> Now, obviously, these API have huge value, otherwise they wouldn't
> >> exist in the first place, and they wouldn't be built into end-user
> >> kernels if they were universally undesirable. But that's not the
> >> situation: the APIs are needed, but they lack the appropriate knobs to
> >> control their availability.
> >
> > So far so good, but I take exception with the suggestion that the
> > proposed knob is appropriate.
> >
> >> And this isn't just about Android: regular
> >> distro kernels (like Debian, who also uses this patch) tend to build
> >> in everything so people can use whatever they want. But for admins
> >> that want to reduce their systems' attack surface, there needs to be
> >> ways to disable things like this.
> >
> > And here I think you're overestimating the knowledge of most admins.
>
> Well, I suspect that's why both Android and Debian default this to off
> right now. :) But, regardless, I think it's weird to block admins who
> DO understand about attack surface from being able to limit it.
>
> >> > So the problem I have with this is that it will completely inhibit
> >> > development of things like JITs that self-profile to re-compile
> >> > frequently used code.
> >>
> >> This is a good example of a use-case where this knob would be turned
> >> down. But for many many other use-cases, when presented with a
> >> pre-built kernel, there isn't a way to remove the attack surface.
> >
> > No, quite the opposite. Having this knob will completely inhibit
> > development of such applications. Worse it will probably render perf
> > dead for quite a large body of developers.
>
> I hear what you're saying, but I think there's a few problems: the
> proposed self-profiling JIT doesn't exist (so it's pointless to
> discuss), and the number of developers that don't have access to their
> own system is impossibly tiny when compared to the hundreds of
> millions of end-users for whom perf is not needed.
>
> > The moment you frame it like: perf or sekjurity, and even default to
> > no-perf-because-sekjurity, a whole bunch of corporate IT departments
> > will not enable this, even for their developers.
>
> It's not "vs security", it's a risk analysis of attack surface. The
> vast majority of people running Linux do not use perf (right now).
> I've never suggested it be default disabled: I'm wanting to upstream
> the sysctl setting that is already in use on distros where the distro
> kernel teams have deemed this is needed knob for their end-users. All
> of the objections you're talking about assume that the knob doesn't
> exist, but it does already. It's just not in upstream. :)
>
> > Have you never had to 'root' your work machine to get work done? I have.
> > Luckily this was pre-secure-boot times so it was trivial since I had
> > physical access to the machine. But it still sucked I had to fight IT
> > over mostly 'trivial' crap.
>
> Yeah, I've had to do similar. Frankly most people use VMs or non-corp
> hardware for doing development work, so I don't think this is a useful
> comparison.
>
> >
> >> > I would much rather have an LSM hook where the security stuff can do
> >> > more fine grained control of things. Allowing some apps perf usage
> while
> >> > denying others.
> >>
> >> I'm not against an LSM, but I think it's needless complexity when
> >> there is already a knob for this but it just doesn't go "high" enough.
> >> :)
> >
> > So what will you to the moment the Google Dalvik guys come to you and
> > say: "Hey, we want to do active profiling to do better on-line code
> > generation?".
>
> That hasn't happened yet. When it does, we can revisit this. But right
> now, today, there is a need for this knob.
>
> > I see 0 up-sides of this approach and, as per the above, a whole bunch
> > of very serious downsides.
> >
> > A global (esp. default inhibited) knob is too coarse and limiting.
>
> I haven't suggested it be default inhibit in the upstream Kconfig. And
> having this knob already with the 0, 1, and 2 settings seems
> incomplete to me without this highest level of restriction that 3
> would provide. That seems rather arbitrary to me. :)
>
> Let me take this another way instead. What would be a better way to
> provide a mechanism for system owners to disable perf without an LSM?
> (Since far fewer folks run with an enforcing "big" LSM: I'm seeking as
> wide a coverage as possible.)
>
> -Kees
>
> --
> Kees Cook
> Chrome OS & Brillo Security
>

--001a113dd73a3d339405391d1661
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Far from trying to kill perf, we want (and require) perf t=
o be available to developers on Android. All that this patch enables us to =
do is gate it behind developer settings - just like we do with other develo=
per targeted features.<br><br></div><br><div class=3D"gmail_quote"><div dir=
=3D"ltr">On Tue, Aug 2, 2016 at 1:51 PM Kees Cook &lt;<a href=3D"mailto:kee=
scook@chromium.org">keescook@chromium.org</a>&gt; wrote:<br></div><blockquo=
te class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc so=
lid;padding-left:1ex">On Tue, Aug 2, 2016 at 1:30 PM, Peter Zijlstra &lt;<a=
 href=3D"mailto:peterz@infradead.org" target=3D"_blank">peterz@infradead.or=
g</a>&gt; wrote:<br>
&gt; On Tue, Aug 02, 2016 at 12:04:34PM -0700, Kees Cook wrote:<br>
&gt;<br>
&gt;&gt; Now, obviously, these API have huge value, otherwise they wouldn&#=
39;t<br>
&gt;&gt; exist in the first place, and they wouldn&#39;t be built into end-=
user<br>
&gt;&gt; kernels if they were universally undesirable. But that&#39;s not t=
he<br>
&gt;&gt; situation: the APIs are needed, but they lack the appropriate knob=
s to<br>
&gt;&gt; control their availability.<br>
&gt;<br>
&gt; So far so good, but I take exception with the suggestion that the<br>
&gt; proposed knob is appropriate.<br>
&gt;<br>
&gt;&gt; And this isn&#39;t just about Android: regular<br>
&gt;&gt; distro kernels (like Debian, who also uses this patch) tend to bui=
ld<br>
&gt;&gt; in everything so people can use whatever they want. But for admins=
<br>
&gt;&gt; that want to reduce their systems&#39; attack surface, there needs=
 to be<br>
&gt;&gt; ways to disable things like this.<br>
&gt;<br>
&gt; And here I think you&#39;re overestimating the knowledge of most admin=
s.<br>
<br>
Well, I suspect that&#39;s why both Android and Debian default this to off<=
br>
right now. :) But, regardless, I think it&#39;s weird to block admins who<b=
r>
DO understand about attack surface from being able to limit it.<br>
<br>
&gt;&gt; &gt; So the problem I have with this is that it will completely in=
hibit<br>
&gt;&gt; &gt; development of things like JITs that self-profile to re-compi=
le<br>
&gt;&gt; &gt; frequently used code.<br>
&gt;&gt;<br>
&gt;&gt; This is a good example of a use-case where this knob would be turn=
ed<br>
&gt;&gt; down. But for many many other use-cases, when presented with a<br>
&gt;&gt; pre-built kernel, there isn&#39;t a way to remove the attack surfa=
ce.<br>
&gt;<br>
&gt; No, quite the opposite. Having this knob will completely inhibit<br>
&gt; development of such applications. Worse it will probably render perf<b=
r>
&gt; dead for quite a large body of developers.<br>
<br>
I hear what you&#39;re saying, but I think there&#39;s a few problems: the<=
br>
proposed self-profiling JIT doesn&#39;t exist (so it&#39;s pointless to<br>
discuss), and the number of developers that don&#39;t have access to their<=
br>
own system is impossibly tiny when compared to the hundreds of<br>
millions of end-users for whom perf is not needed.<br>
<br>
&gt; The moment you frame it like: perf or sekjurity, and even default to<b=
r>
&gt; no-perf-because-sekjurity, a whole bunch of corporate IT departments<b=
r>
&gt; will not enable this, even for their developers.<br>
<br>
It&#39;s not &quot;vs security&quot;, it&#39;s a risk analysis of attack su=
rface. The<br>
vast majority of people running Linux do not use perf (right now).<br>
I&#39;ve never suggested it be default disabled: I&#39;m wanting to upstrea=
m<br>
the sysctl setting that is already in use on distros where the distro<br>
kernel teams have deemed this is needed knob for their end-users. All<br>
of the objections you&#39;re talking about assume that the knob doesn&#39;t=
<br>
exist, but it does already. It&#39;s just not in upstream. :)<br>
<br>
&gt; Have you never had to &#39;root&#39; your work machine to get work don=
e? I have.<br>
&gt; Luckily this was pre-secure-boot times so it was trivial since I had<b=
r>
&gt; physical access to the machine. But it still sucked I had to fight IT<=
br>
&gt; over mostly &#39;trivial&#39; crap.<br>
<br>
Yeah, I&#39;ve had to do similar. Frankly most people use VMs or non-corp<b=
r>
hardware for doing development work, so I don&#39;t think this is a useful<=
br>
comparison.<br>
<br>
&gt;<br>
&gt;&gt; &gt; I would much rather have an LSM hook where the security stuff=
 can do<br>
&gt;&gt; &gt; more fine grained control of things. Allowing some apps perf =
usage while<br>
&gt;&gt; &gt; denying others.<br>
&gt;&gt;<br>
&gt;&gt; I&#39;m not against an LSM, but I think it&#39;s needless complexi=
ty when<br>
&gt;&gt; there is already a knob for this but it just doesn&#39;t go &quot;=
high&quot; enough.<br>
&gt;&gt; :)<br>
&gt;<br>
&gt; So what will you to the moment the Google Dalvik guys come to you and<=
br>
&gt; say: &quot;Hey, we want to do active profiling to do better on-line co=
de<br>
&gt; generation?&quot;.<br>
<br>
That hasn&#39;t happened yet. When it does, we can revisit this. But right<=
br>
now, today, there is a need for this knob.<br>
<br>
&gt; I see 0 up-sides of this approach and, as per the above, a whole bunch=
<br>
&gt; of very serious downsides.<br>
&gt;<br>
&gt; A global (esp. default inhibited) knob is too coarse and limiting.<br>
<br>
I haven&#39;t suggested it be default inhibit in the upstream Kconfig. And<=
br>
having this knob already with the 0, 1, and 2 settings seems<br>
incomplete to me without this highest level of restriction that 3<br>
would provide. That seems rather arbitrary to me. :)<br>
<br>
Let me take this another way instead. What would be a better way to<br>
provide a mechanism for system owners to disable perf without an LSM?<br>
(Since far fewer folks run with an enforcing &quot;big&quot; LSM: I&#39;m s=
eeking as<br>
wide a coverage as possible.)<br>
<br>
-Kees<br>
<br>
--<br>
Kees Cook<br>
Chrome OS &amp; Brillo Security<br>
</blockquote></div>

--001a113dd73a3d339405391d1661--
