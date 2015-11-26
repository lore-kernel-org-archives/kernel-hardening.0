Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: saoret.one@gmail.com
In-Reply-To: <CAPM5UJ2G_hWRYs-J3qsRV1E=aBZqPOacntT2ZA5zcNfZeibHzQ@mail.gmail.com>
References: <CAJpd-bFvTNQK=qGCPdnB1ec=yJ+jZuzaoR9pNbn01pgim=0aLg@mail.gmail.com>
 <CAPM5UJ2G_hWRYs-J3qsRV1E=aBZqPOacntT2ZA5zcNfZeibHzQ@mail.gmail.com>
From: =?UTF-8?B?U2FsdmEgUGVpcsOz?= <speirofr@gmail.com>
Date: Thu, 26 Nov 2015 16:32:02 +0100
Message-ID: <CAJpd-bFsdK-hqMwr8tirr3EYVaZE2e55sH5ZY3vjYkuTERZsMg@mail.gmail.com>
Content-Type: multipart/alternative; boundary=047d7bd91af2ee31a205257347ba
Subject: Re: [kernel-hardening] On techniques for preventing commit_creds()
 user-space abuse
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--047d7bd91af2ee31a205257347ba
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 26, 2015 at 8:43 AM, comex <comexk@gmail.com> wrote:

> On Wed, Nov 25, 2015 at 6:14 PM, Salva Peir=C3=B3 <speirofr@gmail.com> wr=
ote:
> > - *Indirect jump*
> > An attacker can perform an indirect jump to a kernel location that does
> > the commit_creds() for him, but it complicates the task of the
> > attacker. To prevent indirect calls check the rest of the stack trace.
>
> The added complication of indirection is minimal, and checking the
> frame pointer/return address chain on the stack would be far from
> sufficient to prevent it: even if you had full control flow integrity
> on returns (see e.g. RAP), if the attacker was already executing
> arbitrary code, they could overwrite the whole stack to simulate a
> call stack that would normally be allowed to call commit_creds and
> won't crash on return, e.g. setuid returning to userland.
>
> > - *Direct override*
> > Another route to bypass would be to figure out the location of the
> > process creds in memory, and perform the change directly in memory,
> > but AFAIK SMAP and its ARM equivalent would deter this route.
>
> SMEP (not SMAP) already makes it impossible to directly execute code
> from userspace mapped addresses.  SMAP prevents accessing those
> addresses, but has no effect on kernel mapped addresses such as the
> data structures containing credentials.
>
> In general there's not much point trying to defend against an attacker
> who is already running arbitrary code in kernel mode.  Even executing
> a ROP chain, once the attacker gets past any initial hurdles such as
> stack pivoting, is pretty much game over (the possibility of it being
> complicated to find gadgets with unusual instruction sequences, find a
> large number of gadgets, or use a long chain of them /might/ make some
> additional measures valuable, but not very - e.g. [1]); true code
> execution generally makes working around any 'harassment' measures
> trivial.
>
> [1]
> http://vulnfactory.org/blog/2011/09/21/defeating-windows-8-rop-mitigation=
/
>

Thanks for explaining the flaws I was wondering why it wasn't done.
Implementing such a thing is pointless, since by the time the attacker
is executing code he can already bypass the protections as shown in [1].

--047d7bd91af2ee31a205257347ba
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><br><div class=3D"gmail_quo=
te">On Thu, Nov 26, 2015 at 8:43 AM, comex <span dir=3D"ltr">&lt;<a href=3D=
"mailto:comexk@gmail.com" target=3D"_blank">comexk@gmail.com</a>&gt;</span>=
 wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.=
8ex;border-left-width:1px;border-left-color:rgb(204,204,204);border-left-st=
yle:solid;padding-left:1ex"><span class=3D"">On Wed, Nov 25, 2015 at 6:14 P=
M, Salva Peir=C3=B3 &lt;<a href=3D"mailto:speirofr@gmail.com">speirofr@gmai=
l.com</a>&gt; wrote:<br>
&gt; - *Indirect jump*<br>
&gt; An attacker can perform an indirect jump to a kernel location that doe=
s<br>
&gt; the commit_creds() for him, but it complicates the task of the<br>
&gt; attacker. To prevent indirect calls check the rest of the stack trace.=
<br>
<br>
</span>The added complication of indirection is minimal, and checking the<b=
r>
frame pointer/return address chain on the stack would be far from<br>
sufficient to prevent it: even if you had full control flow integrity<br>
on returns (see e.g. RAP), if the attacker was already executing<br>
arbitrary code, they could overwrite the whole stack to simulate a<br>
call stack that would normally be allowed to call commit_creds and<br>
won&#39;t crash on return, e.g. setuid returning to userland.<br>
<span class=3D""><br>
&gt; - *Direct override*<br>
&gt; Another route to bypass would be to figure out the location of the<br>
&gt; process creds in memory, and perform the change directly in memory,<br=
>
&gt; but AFAIK SMAP and its ARM equivalent would deter this route.<br>
<br>
</span>SMEP (not SMAP) already makes it impossible to directly execute code=
<br>
from userspace mapped addresses.=C2=A0 SMAP prevents accessing those<br>
addresses, but has no effect on kernel mapped addresses such as the<br>
data structures containing credentials.<br>
<br>
In general there&#39;s not much point trying to defend against an attacker<=
br>
who is already running arbitrary code in kernel mode.=C2=A0 Even executing<=
br>
a ROP chain, once the attacker gets past any initial hurdles such as<br>
stack pivoting, is pretty much game over (the possibility of it being<br>
complicated to find gadgets with unusual instruction sequences, find a<br>
large number of gadgets, or use a long chain of them /might/ make some<br>
additional measures valuable, but not very - e.g. [1]); true code<br>
execution generally makes working around any &#39;harassment&#39; measures<=
br>
trivial.<br>
<br>
[1] <a href=3D"http://vulnfactory.org/blog/2011/09/21/defeating-windows-8-r=
op-mitigation/" rel=3D"noreferrer" target=3D"_blank">http://vulnfactory.org=
/blog/2011/09/21/defeating-windows-8-rop-mitigation/</a><br>
</blockquote></div><br></div><div class=3D"gmail_extra"><div class=3D"gmail=
_extra">Thanks for explaining the flaws I was wondering why it wasn&#39;t d=
one.</div><div class=3D"gmail_extra">Implementing such a thing is pointless=
, since by the time the attacker</div><div class=3D"gmail_extra">is executi=
ng code he can already bypass the protections as shown in [1].</div><div cl=
ass=3D"gmail_extra"><br></div></div></div>

--047d7bd91af2ee31a205257347ba--
