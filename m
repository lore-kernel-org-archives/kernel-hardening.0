Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20151109190224.GD20491@io.lakedaemon.net>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
	<CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
	<563F4A78.21151.23C6852D@pageexec.freemail.hu>
	<5640E0DD.6040107@labbott.name>
	<20151109182832.GB20491@io.lakedaemon.net>
	<13041.1447095477@turing-police.cc.vt.edu>
	<20151109190224.GD20491@io.lakedaemon.net>
Date: Mon, 9 Nov 2015 14:11:35 -0500
Message-ID: <CAGagf4d4A8ZN2hVDDUFge78D_AZKFwkh6ZCV9faEZe=DO_fwKQ@mail.gmail.com>
From: Theodore Tso <tytso@google.com>
Content-Type: multipart/alternative; boundary=001a114295d0adf4e20524205c96
Subject: Re: [kernel-hardening] Re: Proposal for kernel self protection features
To: Jason Cooper <kernel-hardening@lakedaemon.net>
Cc: kernel-hardening@lists.openwall.com, Emese Revfy <re.emese@gmail.com>, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Greg KH <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>
List-ID: <kernel-hardening.lists.openwall.com>

--001a114295d0adf4e20524205c96
Content-Type: text/plain; charset=UTF-8

On Mon, Nov 9, 2015 at 2:02 PM, Jason Cooper <
kernel-hardening@lakedaemon.net> wrote:

> /var/lib/misc/random-seed has served that role for years, I'm only
> advocating loading it earlier in the boot process.  It's *much* harder
> to guess the state of random-seed than the dtb or mac address(es)...
>

If the bootloader is willing to reach into the file system, which means (a)
having a minimal file system layer, like Grub does, and (b) can find the
block device where the file is found, that's a perfectly *fine*
implementation.    I'm not sure mobile handset vendors will be all that
psyched into either using or replicating all of Grub's functionality so it
could do that, though....

-- Ted

--001a114295d0adf4e20524205c96
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">=
On Mon, Nov 9, 2015 at 2:02 PM, Jason Cooper <span dir=3D"ltr">&lt;<a href=
=3D"mailto:kernel-hardening@lakedaemon.net" target=3D"_blank" class=3D"crem=
ed">kernel-hardening@lakedaemon.net</a>&gt;</span> wrote:<br><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;p=
adding-left:1ex"><div id=3D":346" class=3D"a3s" style=3D"overflow:hidden">/=
var/lib/misc/random-seed has served that role for years, I&#39;m only<br>
advocating loading it earlier in the boot process.=C2=A0 It&#39;s *much* ha=
rder<br>
to guess the state of random-seed than the dtb or mac address(es)...<br></d=
iv></blockquote></div><br>If the bootloader is willing to reach into the fi=
le system, which means (a) having a minimal file system layer, like Grub do=
es, and (b) can find the block device where the file is found, that&#39;s a=
 perfectly *fine* implementation. =C2=A0 =C2=A0I&#39;m not sure mobile hand=
set vendors will be all that psyched into either using or replicating all o=
f Grub&#39;s functionality so it could do that, though....</div><div class=
=3D"gmail_extra"><br></div><div class=3D"gmail_extra">-- Ted</div><div clas=
s=3D"gmail_extra"><br></div></div>

--001a114295d0adf4e20524205c96--
