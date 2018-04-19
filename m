MIME-Version: 1.0
In-Reply-To: <20180419100935.011090923@linutronix.de>
References: <20180419100441.548834519@linutronix.de> <20180419100935.011090923@linutronix.de>
From: Kate Stewart <kstewart@linuxfoundation.org>
Date: Thu, 19 Apr 2018 10:32:10 -0500
Message-ID: <CAG_66ZQJGhwKaVMyR8Vijd1Ew6YRrc6mO-Ci8zsqz5S2uuPJ6g@mail.gmail.com>
Subject: Re: [patch V2 3/8] rslib: Add SPDX identifiers
Content-Type: multipart/alternative; boundary="0000000000006e6abe056a35462b"
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Segher Boessenkool <segher@kernel.crashing.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linuxfoundation.org>, Boris Brezillon <boris.brezillon@free-electrons.com>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

--0000000000006e6abe056a35462b
Content-Type: text/plain; charset="UTF-8"

On Thu, Apr 19, 2018 at 5:04 AM, Thomas Gleixner <tglx@linutronix.de> wrote:

> From: Thomas Gleixner <tglx@linutronix.de>
>
> The Reed-Solomon library is based on code from Phil Karn who granted
> permission to import it into the kernel under the GPL V2.
>
> See commit 15b5423757a7 ("Shared Reed-Solomon ECC library") in the history
> git tree at: git://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.
> git
>
>   ...
>   The encoder/decoder code is lifted from the GPL'd userspace RS-library
>   written by Phil Karn. I modified/wrapped it to provide the different
>   functions which we need in the MTD/NAND code.
>   ...
>   Signed-Off-By: Thomas Gleixner <tglx@linutronix.de>
>   Signed-Off-By: David Woodhouse <dwmw2@infradead.org>
>   "No objections at all. Just keep the authorship notices." -- Phil Karn
>
> Add the proper SPDX identifiers according to
> Documentation/process/license-rules.rst.
>
>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Boris Brezillon <boris.brezillon@free-electrons.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Segher Boessenkool <segher@kernel.crashing.org>
> Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Anton Vorontsov <anton@enomsg.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Colin Cross <ccross@android.com>
> Cc: Andrew Morton <akpm@linuxfoundation.org>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Alasdair Kergon <agk@redhat.com>
>
>  Reviewed-by: Kate Stewart <kstewart@linuxfoundation.org>

--0000000000006e6abe056a35462b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Thu, Apr 19, 2018 at 5:04 AM, Thomas Gleixner <span dir=3D"ltr">&lt;=
<a href=3D"mailto:tglx@linutronix.de" target=3D"_blank">tglx@linutronix.de<=
/a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:=
0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">From: Thomas Gleixn=
er &lt;<a href=3D"mailto:tglx@linutronix.de">tglx@linutronix.de</a>&gt;<br>
<br>
The Reed-Solomon library is based on code from Phil Karn who granted<br>
permission to import it into the kernel under the GPL V2.<br>
<br>
See commit 15b5423757a7 (&quot;Shared Reed-Solomon ECC library&quot;) in th=
e history<br>
git tree at: git://<a href=3D"http://git.kernel.org/pub/scm/linux/kernel/gi=
t/tglx/history.git" rel=3D"noreferrer" target=3D"_blank">git.kernel.org/pub=
/scm/<wbr>linux/kernel/git/tglx/history.<wbr>git</a><br>
<br>
=C2=A0 ...<br>
=C2=A0 The encoder/decoder code is lifted from the GPL&#39;d userspace RS-l=
ibrary<br>
=C2=A0 written by Phil Karn. I modified/wrapped it to provide the different=
<br>
=C2=A0 functions which we need in the MTD/NAND code.<br>
=C2=A0 ...=C2=A0 =C2=A0 <br>
=C2=A0 Signed-Off-By: Thomas Gleixner &lt;<a href=3D"mailto:tglx@linutronix=
.de">tglx@linutronix.de</a>&gt;<br>
=C2=A0 Signed-Off-By: David Woodhouse &lt;<a href=3D"mailto:dwmw2@infradead=
.org">dwmw2@infradead.org</a>&gt;<br>
=C2=A0 &quot;No objections at all. Just keep the authorship notices.&quot; =
-- Phil Karn<br>
<br>
Add the proper SPDX identifiers according to<br>
Documentation/process/license-<wbr>rules.rst.<br>
<br>
<br>
Signed-off-by: Thomas Gleixner &lt;<a href=3D"mailto:tglx@linutronix.de">tg=
lx@linutronix.de</a>&gt;<br>
Cc: Boris Brezillon &lt;<a href=3D"mailto:boris.brezillon@free-electrons.co=
m">boris.brezillon@free-<wbr>electrons.com</a>&gt;<br>
Cc: Tony Luck &lt;<a href=3D"mailto:tony.luck@intel.com">tony.luck@intel.co=
m</a>&gt;<br>
Cc: Kees Cook &lt;<a href=3D"mailto:keescook@chromium.org">keescook@chromiu=
m.org</a>&gt;<br>
Cc: Segher Boessenkool &lt;<a href=3D"mailto:segher@kernel.crashing.org">se=
gher@kernel.crashing.org</a>&gt;<br>
Cc: Kernel Hardening &lt;<a href=3D"mailto:kernel-hardening@lists.openwall.=
com">kernel-hardening@lists.<wbr>openwall.com</a>&gt;<br>
Cc: Richard Weinberger &lt;<a href=3D"mailto:richard@nod.at">richard@nod.at=
</a>&gt;<br>
Cc: Mike Snitzer &lt;<a href=3D"mailto:snitzer@redhat.com">snitzer@redhat.c=
om</a>&gt;<br>
Cc: Anton Vorontsov &lt;<a href=3D"mailto:anton@enomsg.org">anton@enomsg.or=
g</a>&gt;<br>
Cc: Greg Kroah-Hartman &lt;<a href=3D"mailto:gregkh@linuxfoundation.org">gr=
egkh@linuxfoundation.org</a>&gt;<br>
Cc: Colin Cross &lt;<a href=3D"mailto:ccross@android.com">ccross@android.co=
m</a>&gt;<br>
Cc: Andrew Morton &lt;<a href=3D"mailto:akpm@linuxfoundation.org">akpm@linu=
xfoundation.org</a>&gt;<br>
Cc: David Woodhouse &lt;<a href=3D"mailto:dwmw2@infradead.org">dwmw2@infrad=
ead.org</a>&gt;<br>
Cc: Alasdair Kergon &lt;<a href=3D"mailto:agk@redhat.com">agk@redhat.com</a=
>&gt;<br>
<br></blockquote><div><span style=3D"color:rgb(34,34,34);font-family:arial,=
sans-serif;font-size:small;font-style:normal;font-variant-ligatures:normal;=
font-variant-caps:normal;font-weight:400;letter-spacing:normal;text-align:s=
tart;text-indent:0px;text-transform:none;white-space:normal;word-spacing:0p=
x;background-color:rgb(255,255,255);text-decoration-style:initial;text-deco=
ration-color:initial;float:none;display:inline">=C2=A0</span><span style=3D=
"color:rgb(34,34,34);font-family:arial,sans-serif;font-style:normal;font-va=
riant-ligatures:normal;font-variant-caps:normal;font-weight:400;letter-spac=
ing:normal;text-align:start;text-indent:0px;text-transform:none;white-space=
:normal;word-spacing:0px;text-decoration-style:initial;text-decoration-colo=
r:initial;font-size:12.8px;background-color:rgb(255,255,255);float:none;dis=
play:inline">Reviewed-by:=C2=A0<span style=3D"color:rgb(80,0,80);font-famil=
y:arial,sans-serif;font-size:12.8px;font-style:normal;font-variant-ligature=
s:normal;font-variant-caps:normal;font-weight:400;letter-spacing:normal;tex=
t-align:start;text-indent:0px;text-transform:none;white-space:normal;word-s=
pacing:0px;background-color:rgb(255,255,255);text-decoration-style:initial;=
text-decoration-color:initial;float:none;display:inline">Kate Stewart &lt;<=
/span><a href=3D"mailto:kstewart@linuxfoundation.org" style=3D"color:rgb(17=
,85,204);font-family:arial,sans-serif;font-size:12.8px;font-style:normal;fo=
nt-variant-ligatures:normal;font-variant-caps:normal;font-weight:400;letter=
-spacing:normal;text-align:start;text-indent:0px;text-transform:none;white-=
space:normal;word-spacing:0px;background-color:rgb(255,255,255)">kstewart@l=
inuxfoundation.org</a><span style=3D"color:rgb(80,0,80);font-family:arial,s=
ans-serif;font-size:12.8px;font-style:normal;font-variant-ligatures:normal;=
font-variant-caps:normal;font-weight:400;letter-spacing:normal;text-align:s=
tart;text-indent:0px;text-transform:none;white-space:normal;word-spacing:0p=
x;background-color:rgb(255,255,255);text-decoration-style:initial;text-deco=
ration-color:initial;float:none;display:inline">&gt;</span></span></div><di=
v>=C2=A0</div></div></div></div>

--0000000000006e6abe056a35462b--
