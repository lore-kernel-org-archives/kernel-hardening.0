Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <26467.1447105487@turing-police.cc.vt.edu>
References: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
	<n1iirh$q7o$1@ger.gmane.org>
	<CAGXu5j+ponF+a3aoCnLqEVfBy545BsxT4w=8KGikNCb_24ZgyQ@mail.gmail.com>
	<n1khkt$lc7$1@ger.gmane.org>
	<CAGXu5jLuEBUYFNmWOVNvMnTbwyy_+0R1_SywBVhcxkCcm83e-g@mail.gmail.com>
	<26467.1447105487@turing-police.cc.vt.edu>
Date: Mon, 9 Nov 2015 16:55:34 -0500
Message-ID: <CAEXv5_hcqjdbSKArKRgbqr_A=AR6E0H1Zg3GgL8UGQezg0GeKg@mail.gmail.com>
From: David Windsor <dave@0x4141.net>
Content-Type: multipart/alternative; boundary=001a114086c41565e3052422a7d4
Subject: Re: [kernel-hardening] Re: Kernel Self Protection Project
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--001a114086c41565e3052422a7d4
Content-Type: text/plain; charset=UTF-8

The problem is cherrypicking these things from the original patchsets.  I'm
doing that now for PAX_REFCOUNT, and it's proving more difficult than I
originally expected.

On Mon, Nov 9, 2015 at 4:44 PM, <Valdis.Kletnieks@vt.edu> wrote:

> On Sat, 07 Nov 2015 22:50:04 -0800, Kees Cook said:
>
> > Yeah. Does anyone want to also extract PAX_USERCOPY or
> > GRKERNSEC_KSTACKOVERFLOW ? No one has mentioned an interest in those
> > yet.
>
> I'll commit to at least looking at PAX_USERCOPY.  Looks reasonably
> stand-alone.
>

--001a114086c41565e3052422a7d4
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">The problem is cherrypicking these things from the origina=
l patchsets.=C2=A0 I&#39;m doing that now for PAX_REFCOUNT, and it&#39;s pr=
oving more difficult than I originally expected.=C2=A0 <br></div><div class=
=3D"gmail_extra"><br><div class=3D"gmail_quote">On Mon, Nov 9, 2015 at 4:44=
 PM,  <span dir=3D"ltr">&lt;<a href=3D"mailto:Valdis.Kletnieks@vt.edu" targ=
et=3D"_blank">Valdis.Kletnieks@vt.edu</a>&gt;</span> wrote:<br><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex"><span class=3D"">On Sat, 07 Nov 2015 22:50:04 -0800, Kee=
s Cook said:<br>
<br>
&gt; Yeah. Does anyone want to also extract PAX_USERCOPY or<br>
&gt; GRKERNSEC_KSTACKOVERFLOW ? No one has mentioned an interest in those<b=
r>
&gt; yet.<br>
<br>
</span>I&#39;ll commit to at least looking at PAX_USERCOPY.=C2=A0 Looks rea=
sonably<br>
stand-alone.<br>
</blockquote></div><br></div>

--001a114086c41565e3052422a7d4--
