Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: jwboyer@gmail.com
In-Reply-To: <20160126171523.GA13715@ubuntumail>
References: <1453502345-30416-1-git-send-email-keescook@chromium.org>
	<8737tp0zhr.fsf@x220.int.ebiederm.org>
	<CALCETrWYRvqhyCwx5RX6L3TEYCfW0j6ThFUc+ASL7BpxgO5dEQ@mail.gmail.com>
	<CAGXu5j+mx+6BOKb42yfyKnL7VTCUBNC0Nk9aCOd0D5tSD6DbCg@mail.gmail.com>
	<CALCETrXNZhJdjbxYH8x3wr3EyQVJzp2fhNyXwzgmuiKzoKO24A@mail.gmail.com>
	<CAGXu5jJ6fQ5E17jKoC3kFZ0RgbcNLuzW6zdunaXV+jiQPSo+Lg@mail.gmail.com>
	<87bn89sbc2.fsf@x220.int.ebiederm.org>
	<CAGXu5jLwwCw9wZA8QYNVrZ2+kHJn7G3sXQZchvqFMYj3bN=DpQ@mail.gmail.com>
	<87zivtj5tv.fsf@x220.int.ebiederm.org>
	<CA+5PVA5Q0_sv5MsETa9u79MLOcYbsf-vdeEe3gdxgJ8f1KAbdQ@mail.gmail.com>
	<20160126171523.GA13715@ubuntumail>
Date: Tue, 26 Jan 2016 18:47:15 -0500
Message-ID: <CA+5PVA5_x05a=2twmfx3FjqbaLHsQL3Yug3kW_WS=UYxs1nKqA@mail.gmail.com>
From: Josh Boyer <jwboyer@fedoraproject.org>
Content-Type: multipart/alternative; boundary=001a1143ad0825e44e052a454e56
Subject: Re: [kernel-hardening] Re: [PATCH 0/2] sysctl: allow CLONE_NEWUSER to
 be disabled
To: "Serge E. Hallyn" <serge.hallyn@ubuntu.com>
Cc: Kostya Serebryany <kcc@google.com>, linux-doc@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@amacapital.net>, "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Potapenko <glider@google.com>, Kees Cook <keescook@chromium.org>, Eric Dumazet <edumazet@google.com>, =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>, Miklos Szeredi <mszeredi@suse.cz>, Dmitry Vyukov <dvyukov@google.com>, Richard Weinberger <richard@nod.at>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Sasha Levin <sasha.levin@oracle.com>
List-ID: <kernel-hardening.lists.openwall.com>

--001a1143ad0825e44e052a454e56
Content-Type: text/plain; charset=UTF-8

On Jan 26, 2016 3:58 PM, "Serge Hallyn" <serge.hallyn@ubuntu.com> wrote:
>
> Quoting Josh Boyer (jwboyer@fedoraproject.org):
> > On Mon, Jan 25, 2016 at 11:57 PM, Eric W. Biederman
> > <ebiederm@xmission.com> wrote:
> > > Kees Cook <keescook@chromium.org> writes:
> > >
> > >> On Mon, Jan 25, 2016 at 11:33 AM, Eric W. Biederman
> > >> <ebiederm@xmission.com> wrote:
> > >>> Kees Cook <keescook@chromium.org> writes:
> > >>>>
> > >>>> Well, I don't know about less weird, but it would leave a unneeded
> > >>>> hole in the permission checks.
> > >>>
> > >>> To be clear the current patch has my:
> > >>>
> > >>> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> > >>>
> > >>> The code is buggy, and poorly thought through.  Your lack of
interest in
> > >>> fixing the bugs in your patch is distressing.
> > >>
> > >> I'm not sure where you see me having a "lack of interest". The
> > >> existing cap-checking sysctls have a corner-case bug, which is
> > >> orthogonal to this change.
> > >
> > > That certainly doesn't sound like you have any plans to change
anything
> > > there.
> > >
> > >>> So broken code, not willing to fix.  No. We are not merging this
sysctl.
> > >>
> > >> I think you're jumping to conclusions. :)
> > >
> > > I think I am the maintainer.
> > >
> > > What you are proposing is very much something that is only of interst
to
> > > people who are not using user namespaces.  It is fatally flawed as
> > > a way to avoid new attack surfaces for people who don't care as the
> > > sysctl leaves user namespaces enabled by default.  It is fatally
flawed
> > > as remediation to recommend to people to change if a new user
namespace
> > > related but is discovered.  Any running process that happens to be
> > > created while user namespace creation was enabled will continue to
> > > exist.  Effectively a reboot will be required as part of a mitigation.
> > > Many sysadmins will get that wrong.
> > >
> > > I can't possibly see your sysctl as proposed achieving it's goals.  A
> > > person has to be entirely too aware of subtlety and nuance to use it
> > > effectively.
> >
> > What you're saying is true for the "oh crap" case of a new userns
> > related CVE being found.  However, there is the case where sysadmins
> > know for a fact that a set of machines should not allow user
> > namespaces to be enabled.  Currently they have 2 choices, 1) use their
>
> Hi - can you give a specific example of this?  (Where users really should
> not be able to use them - not where they might not need them)  I think
> it'll help the discussion tremendously.  Because so far the only good
> arguments I've seen have been about actual bugs in the user namespaces,
> which would not warrant a designed-in permanent disable switch.  If
> there are good use cases where such a disable switch will always be
> needed (and compiling out can't satisfy) that'd be helpful.

I already did in the email you quoted.  Limiting the surface where the
admin knows that shouldn't be used without having to rebuild a distribution
kernel.  Think of it like blacklisting a module, except user namespaces
can't be modules.

josh

--001a1143ad0825e44e052a454e56
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr"><br>
On Jan 26, 2016 3:58 PM, &quot;Serge Hallyn&quot; &lt;<a href=3D"mailto:ser=
ge.hallyn@ubuntu.com">serge.hallyn@ubuntu.com</a>&gt; wrote:<br>
&gt;<br>
&gt; Quoting Josh Boyer (<a href=3D"mailto:jwboyer@fedoraproject.org">jwboy=
er@fedoraproject.org</a>):<br>
&gt; &gt; On Mon, Jan 25, 2016 at 11:57 PM, Eric W. Biederman<br>
&gt; &gt; &lt;<a href=3D"mailto:ebiederm@xmission.com">ebiederm@xmission.co=
m</a>&gt; wrote:<br>
&gt; &gt; &gt; Kees Cook &lt;<a href=3D"mailto:keescook@chromium.org">keesc=
ook@chromium.org</a>&gt; writes:<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;&gt; On Mon, Jan 25, 2016 at 11:33 AM, Eric W. Biederman<br>
&gt; &gt; &gt;&gt; &lt;<a href=3D"mailto:ebiederm@xmission.com">ebiederm@xm=
ission.com</a>&gt; wrote:<br>
&gt; &gt; &gt;&gt;&gt; Kees Cook &lt;<a href=3D"mailto:keescook@chromium.or=
g">keescook@chromium.org</a>&gt; writes:<br>
&gt; &gt; &gt;&gt;&gt;&gt;<br>
&gt; &gt; &gt;&gt;&gt;&gt; Well, I don&#39;t know about less weird, but it =
would leave a unneeded<br>
&gt; &gt; &gt;&gt;&gt;&gt; hole in the permission checks.<br>
&gt; &gt; &gt;&gt;&gt;<br>
&gt; &gt; &gt;&gt;&gt; To be clear the current patch has my:<br>
&gt; &gt; &gt;&gt;&gt;<br>
&gt; &gt; &gt;&gt;&gt; Nacked-by: &quot;Eric W. Biederman&quot; &lt;<a href=
=3D"mailto:ebiederm@xmission.com">ebiederm@xmission.com</a>&gt;<br>
&gt; &gt; &gt;&gt;&gt;<br>
&gt; &gt; &gt;&gt;&gt; The code is buggy, and poorly thought through.=C2=A0=
 Your lack of interest in<br>
&gt; &gt; &gt;&gt;&gt; fixing the bugs in your patch is distressing.<br>
&gt; &gt; &gt;&gt;<br>
&gt; &gt; &gt;&gt; I&#39;m not sure where you see me having a &quot;lack of=
 interest&quot;. The<br>
&gt; &gt; &gt;&gt; existing cap-checking sysctls have a corner-case bug, wh=
ich is<br>
&gt; &gt; &gt;&gt; orthogonal to this change.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; That certainly doesn&#39;t sound like you have any plans to =
change anything<br>
&gt; &gt; &gt; there.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt;&gt;&gt; So broken code, not willing to fix.=C2=A0 No. We are=
 not merging this sysctl.<br>
&gt; &gt; &gt;&gt;<br>
&gt; &gt; &gt;&gt; I think you&#39;re jumping to conclusions. :)<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; I think I am the maintainer.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; What you are proposing is very much something that is only o=
f interst to<br>
&gt; &gt; &gt; people who are not using user namespaces.=C2=A0 It is fatall=
y flawed as<br>
&gt; &gt; &gt; a way to avoid new attack surfaces for people who don&#39;t =
care as the<br>
&gt; &gt; &gt; sysctl leaves user namespaces enabled by default.=C2=A0 It i=
s fatally flawed<br>
&gt; &gt; &gt; as remediation to recommend to people to change if a new use=
r namespace<br>
&gt; &gt; &gt; related but is discovered.=C2=A0 Any running process that ha=
ppens to be<br>
&gt; &gt; &gt; created while user namespace creation was enabled will conti=
nue to<br>
&gt; &gt; &gt; exist.=C2=A0 Effectively a reboot will be required as part o=
f a mitigation.<br>
&gt; &gt; &gt; Many sysadmins will get that wrong.<br>
&gt; &gt; &gt;<br>
&gt; &gt; &gt; I can&#39;t possibly see your sysctl as proposed achieving i=
t&#39;s goals.=C2=A0 A<br>
&gt; &gt; &gt; person has to be entirely too aware of subtlety and nuance t=
o use it<br>
&gt; &gt; &gt; effectively.<br>
&gt; &gt;<br>
&gt; &gt; What you&#39;re saying is true for the &quot;oh crap&quot; case o=
f a new userns<br>
&gt; &gt; related CVE being found.=C2=A0 However, there is the case where s=
ysadmins<br>
&gt; &gt; know for a fact that a set of machines should not allow user<br>
&gt; &gt; namespaces to be enabled.=C2=A0 Currently they have 2 choices, 1)=
 use their<br>
&gt;<br>
&gt; Hi - can you give a specific example of this?=C2=A0 (Where users reall=
y should<br>
&gt; not be able to use them - not where they might not need them)=C2=A0 I =
think<br>
&gt; it&#39;ll help the discussion tremendously.=C2=A0 Because so far the o=
nly good<br>
&gt; arguments I&#39;ve seen have been about actual bugs in the user namesp=
aces,<br>
&gt; which would not warrant a designed-in permanent disable switch.=C2=A0 =
If<br>
&gt; there are good use cases where such a disable switch will always be<br=
>
&gt; needed (and compiling out can&#39;t satisfy) that&#39;d be helpful.</p=
>
<p dir=3D"ltr">I already did in the email you quoted.=C2=A0 Limiting the su=
rface where the admin knows that shouldn&#39;t be used without having to re=
build a distribution kernel.=C2=A0 Think of it like blacklisting a module, =
except user namespaces can&#39;t be modules.</p>
<p dir=3D"ltr">josh<br>
</p>

--001a1143ad0825e44e052a454e56--
