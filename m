Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLqy1UchipmcgsUrXiWP0zfwjGAgfxcKUYkbQ9a_e2V_g@mail.gmail.com>
References: <CAEXv5_jnutg89zQLyLCupKf0AOZ=ubdgbJy7AgeeN=7yQicW0A@mail.gmail.com>
	<CAGXu5jLqy1UchipmcgsUrXiWP0zfwjGAgfxcKUYkbQ9a_e2V_g@mail.gmail.com>
Date: Tue, 24 Nov 2015 15:51:30 -0500
Message-ID: <CAEXv5_ga70LDyR3TmOenoY_-FD1A56GZ3KpgGW5BsegkSyufhA@mail.gmail.com>
From: David Windsor <dave@0x4141.net>
Content-Type: multipart/alternative; boundary=001a114d7290926e3a05254f8123
Subject: Re: [kernel-hardening] status: PAX_REFCOUNT
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--001a114d7290926e3a05254f8123
Content-Type: text/plain; charset=UTF-8

> That'll be a lot of patches. I wonder if we could break it up by
> top-level maintainer? i.e. everything in drivers would go in one
> patch, etc?
>
>
I can certainly do that, but the size of the drivers patch is going to be
tremendous.  I just figured that smaller patches would be less offensive to
upstream's delicate sensibilities =)

> I'm moving my way through the tree and will hopefully have an RFC
> submission
> > soon.
>
> Great! Are you working on this full-time? (If not, would potential CII
> funding help at all?)
>
>
Just working on this in my spare time.  I've wanted to see PaX/grsecurity
included upstream for a long while now.  Funding is unnecessary, as it
wouldn't enable me to get this finished any more quickly than I would
otherwise.  I'll publish my tree to github so others can help.


> I'll send an lkdtm patch that'll twiddle the atomic type, so you have
> something to validate it with.
>
>
Thanks!

--001a114d7290926e3a05254f8123
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><br><div class=3D"gmail_extra"><div class=3D"gmail_quote">=
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><span class=3D"">
</span>That&#39;ll be a lot of patches. I wonder if we could break it up by=
<br>
top-level maintainer? i.e. everything in drivers would go in one<br>
patch, etc?<br>
<span class=3D""><br></span></blockquote><div><br></div><div>I can certainl=
y do that, but the size of the drivers patch is going to be tremendous.=C2=
=A0 I just figured that smaller patches would be less offensive to upstream=
&#39;s delicate sensibilities =3D)<br><br></div><blockquote class=3D"gmail_=
quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1=
ex"><span class=3D"">
&gt; I&#39;m moving my way through the tree and will hopefully have an RFC =
submission<br>
&gt; soon.<br>
<br>
</span>Great! Are you working on this full-time? (If not, would potential C=
II<br>
funding help at all?)<br>
<br></blockquote><div><br></div><div>Just working on this in my spare time.=
=C2=A0 I&#39;ve wanted to see PaX/grsecurity included upstream for a long w=
hile now.=C2=A0 Funding is unnecessary, as it wouldn&#39;t enable me to get=
 this finished any more quickly than I would otherwise.=C2=A0 I&#39;ll publ=
ish my tree to github so others can help.<br></div><div>=C2=A0</div><blockq=
uote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc =
solid;padding-left:1ex">
I&#39;ll send an lkdtm patch that&#39;ll twiddle the atomic type, so you ha=
ve<br>
something to validate it with.<br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br></font></span></blockquo=
te><div><br></div><div>Thanks!<br></div></div><br></div></div>

--001a114d7290926e3a05254f8123--
