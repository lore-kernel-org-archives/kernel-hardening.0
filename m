MIME-Version: 1.0
References: <CALS6=qWHytpevcJqB6TkgzUfUmpoxVeyJtvEKigJH3-cnw7vUQ@mail.gmail.com>
 <CAGXu5jKoHfPHadabqo=7FaOD1O-GRE1-GowfmZSs_oB+snWFaQ@mail.gmail.com>
In-Reply-To: <CAGXu5jKoHfPHadabqo=7FaOD1O-GRE1-GowfmZSs_oB+snWFaQ@mail.gmail.com>
From: Carter Cheng <cartercheng@gmail.com>
Date: Fri, 22 Feb 2019 00:20:19 +0800
Message-ID: <CALS6=qXN_UxEYV-6kG9_r6kv5joYdVpKU6xOhxLsPAkshzN80g@mail.gmail.com>
Subject: Re: classes of methods for gaining access to kernel memory
Content-Type: multipart/alternative; boundary="0000000000006673d2058269da97"
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

--0000000000006673d2058269da97
Content-Type: text/plain; charset="UTF-8"

I was looking over some recent papers for Usenix Security and there are a
couple on data oriented programming and I have been wondering if there are
known mitigation techniques for this kind of data corruption attack or
other attacks that don't involve control flow hijacking.

On Thu, Feb 21, 2019 at 9:17 AM Kees Cook <keescook@chromium.org> wrote:

> On Sun, Feb 10, 2019 at 3:13 AM Carter Cheng <cartercheng@gmail.com>
> wrote:
> > I was reading a paper on kernel data attacks and the paper mentions
> methods for gaining control of kernel memory beyond overflow type attacks.
> This would seem to suggest that methods exist for this in certain cases
> beyond what can be caught by spatial safety checks. Are there general
> classes of such methods that one needs to be aware of? And what are they?
>
> If I follow what you're asking, I'd think race conditions would be an
> example of another major class of attacks against the kernel. For
> example, look at the DirtyCOW attack: that was a race condition
> against the kernel's VFS that wouldn't get caught by bounds checking,
> etc, etc.
>
> --
> Kees Cook
>

--0000000000006673d2058269da97
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I was looking over some recent papers for Usenix Security =
and there are a couple on data oriented programming and I have been wonderi=
ng if there are known mitigation techniques for this kind of data corruptio=
n attack or other attacks that don&#39;t involve control flow hijacking.=C2=
=A0</div><br><div class=3D"gmail_quote"><div dir=3D"ltr" class=3D"gmail_att=
r">On Thu, Feb 21, 2019 at 9:17 AM Kees Cook &lt;<a href=3D"mailto:keescook=
@chromium.org">keescook@chromium.org</a>&gt; wrote:<br></div><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid=
 rgb(204,204,204);padding-left:1ex">On Sun, Feb 10, 2019 at 3:13 AM Carter =
Cheng &lt;<a href=3D"mailto:cartercheng@gmail.com" target=3D"_blank">carter=
cheng@gmail.com</a>&gt; wrote:<br>
&gt; I was reading a paper on kernel data attacks and the paper mentions me=
thods for gaining control of kernel memory beyond overflow type attacks. Th=
is would seem to suggest that methods exist for this in certain cases beyon=
d what can be caught by spatial safety checks. Are there general classes of=
 such methods that one needs to be aware of? And what are they?<br>
<br>
If I follow what you&#39;re asking, I&#39;d think race conditions would be =
an<br>
example of another major class of attacks against the kernel. For<br>
example, look at the DirtyCOW attack: that was a race condition<br>
against the kernel&#39;s VFS that wouldn&#39;t get caught by bounds checkin=
g,<br>
etc, etc.<br>
<br>
-- <br>
Kees Cook<br>
</blockquote></div>

--0000000000006673d2058269da97--
