MIME-Version: 1.0
References: <CAJwLwmYQt2ae_Y-TDXhPGsX5im29ATwwKmg3FtUC=6HjrzH4HA@mail.gmail.com>
 <CAGXu5j+qgNMP1jt1-cssuY5qNkSPDde5MzH9YQUcuLepbHX0jg@mail.gmail.com>
 <alpine.DEB.2.20.1702072344520.8117@nanos> <CAEk6tEyzgCV5YWppu5OwxjFz6royvXmJM-Qs_mKTUSsqeR7wZw@mail.gmail.com>
 <alpine.DEB.2.20.1702081045440.3536@nanos>
In-Reply-To: <alpine.DEB.2.20.1702081045440.3536@nanos>
From: Jessica Frazelle <me@jessfraz.com>
Date: Wed, 08 Feb 2017 14:23:41 +0000
Message-ID: <CAEk6tEyQ1D=omQPLUL0+dAJFd_vRY2+UVER9VVZKaAu5L0Vn4w@mail.gmail.com>
Content-Type: multipart/alternative; boundary=94eb2c1cdab62556ac0548059dc9
Subject: [kernel-hardening] Re: /proc/timer_list leaks the real pids of the associated processes
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@google.com>, Xing Gao <xgao01@email.wm.edu>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

--94eb2c1cdab62556ac0548059dc9
Content-Type: text/plain; charset=UTF-8

Don't worry I wasn't saying it was useful.
It's unnecessary.

On Wed, Feb 8, 2017, 01:47 Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 7 Feb 2017, Jessica Frazelle wrote:
>
> > So I used to use this "feature" as a hack to see if something was
> > running in a k8s cluster or not because fluentd gives a lot of things
> > away.
>
> That file does not tell you at all whether something is running or not. It
> merily tells you that there are timers queued.
>
> > Runc basically decided to mask this file so it stopped happening
> > though. But I think namespace aware is the right decision.
>
> Unless you can come up with a real good argument why this is usefull beyond
> debugging and crystal ball hackery, it's going to go away.
>
> Thanks,
>
>         tglx
>

--94eb2c1cdab62556ac0548059dc9
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr">Don&#39;t worry I wasn&#39;t saying it was useful. <br>
It&#39;s unnecessary.</p>
<br><div class=3D"gmail_quote"><div dir=3D"ltr">On Wed, Feb 8, 2017, 01:47 =
Thomas Gleixner &lt;<a href=3D"mailto:tglx@linutronix.de">tglx@linutronix.d=
e</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin=
:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On Tue, 7 Feb 2017=
, Jessica Frazelle wrote:<br class=3D"gmail_msg">
<br class=3D"gmail_msg">
&gt; So I used to use this &quot;feature&quot; as a hack to see if somethin=
g was<br class=3D"gmail_msg">
&gt; running in a k8s cluster or not because fluentd gives a lot of things<=
br class=3D"gmail_msg">
&gt; away.<br class=3D"gmail_msg">
<br class=3D"gmail_msg">
That file does not tell you at all whether something is running or not. It<=
br class=3D"gmail_msg">
merily tells you that there are timers queued.<br class=3D"gmail_msg">
<br class=3D"gmail_msg">
&gt; Runc basically decided to mask this file so it stopped happening<br cl=
ass=3D"gmail_msg">
&gt; though. But I think namespace aware is the right decision.<br class=3D=
"gmail_msg">
<br class=3D"gmail_msg">
Unless you can come up with a real good argument why this is usefull beyond=
<br class=3D"gmail_msg">
debugging and crystal ball hackery, it&#39;s going to go away.<br class=3D"=
gmail_msg">
<br class=3D"gmail_msg">
Thanks,<br class=3D"gmail_msg">
<br class=3D"gmail_msg">
=C2=A0 =C2=A0 =C2=A0 =C2=A0 tglx<br class=3D"gmail_msg">
</blockquote></div>

--94eb2c1cdab62556ac0548059dc9--
