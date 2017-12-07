MIME-Version: 1.0
In-Reply-To: <CAOFm3uFzFpDrc4KhH0qOLkXLioz=Fcz56hN-+POwuUHTAerv5g@mail.gmail.com>
References: <20171207105319.GA10075@pjb1027-Latitude-E5410> <CAOFm3uFzFpDrc4KhH0qOLkXLioz=Fcz56hN-+POwuUHTAerv5g@mail.gmail.com>
From: Jinbum Park <jinb.park7@gmail.com>
Date: Fri, 8 Dec 2017 08:39:45 +0900
Message-ID: <CAErMHp9iHA0+_dUa7ts2wgchyadVeQGjvyBORO6khq3YGZbjNw@mail.gmail.com>
Content-Type: multipart/alternative; boundary="94eb2c0944de431df5055fc8958c"
Subject: Re: [kernel-hardening][PATCH v5 1/3] arm: mm: dump: make page table
 dumping reusable
To: Philippe Ombredanne <pombredanne@nexb.com>
Cc: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, afzal.mohd.ma@gmail.com, Mark Rutland <mark.rutland@arm.com>, labbott@redhat.com, Russell King <linux@armlinux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, keescook@chromium.org, vladimir.murzin@arm.com, Arnd Bergmann <arnd@arndb.de>
List-ID: <kernel-hardening.lists.openwall.com>

--94eb2c0944de431df5055fc8958c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I agree with you.
I'll consider your suggestion in next patch.



2017. 12. 7. =EC=98=A4=ED=9B=84 8:31=EC=97=90 "Philippe Ombredanne" <pombre=
danne@nexb.com>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:

Dear Jinbum,

On Thu, Dec 7, 2017 at 11:53 AM, Jinbum Park <jinb.park7@gmail.com> wrote:
> This patch refactors the arm page table dumping code,
> so multiple tables may be registered with the framework.
>
> This patch refers below commits of arm64.
> (4674fdb9f149 ("arm64: mm: dump: make page table dumping reusable"))
> (4ddb9bf83349 ("arm64: dump: Make ptdump debugfs a separate option"))
>
> Tested-by: Laura Abbott <labbott@redhat.com>
> Reviewed-by: Laura Abbott <labbott@redhat.com>
> Signed-off-by: Jinbum Park <jinb.park7@gmail.com>
[]
> diff --git a/arch/arm/include/asm/ptdump.h b/arch/arm/include/asm/ptdump.=
h
> new file mode 100644
> index 0000000..3a6c0b7
> --- /dev/null
> +++ b/arch/arm/include/asm/ptdump.h
> @@ -0,0 +1,48 @@
> +/*
> + * Copyright (C) 2014 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */

Sorry if I am nitpicking, but have you considered replacing this
beautiful piece of fine legalese with the new SPDX ids?
e.g. this:
// SPDX-License-Identifier: GPL-2.0
// Copyright (C) 2014 ARM Ltd.

Or if this does not work and your includes break something if they are
used in assembly, then this can work out too

> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2014 ARM Ltd. */

See Thomas doc patches, and Greg and Linus comments on these topics.

This is much leaner, is it?
Less legalese comment also means more code and a better, smaller
boilerplate lines/total lines ratio!
Thank you for your kind consideration.

--
Cordially
Philippe Ombredanne

--94eb2c0944de431df5055fc8958c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div dir=3D"auto">I agree with you.</div><div dir=3D"auto=
">I&#39;ll consider your suggestion in next patch.</div><div dir=3D"auto"><=
br></div><br><div class=3D"gmail_extra" dir=3D"auto"><br><div class=3D"gmai=
l_quote">2017. 12. 7. =EC=98=A4=ED=9B=84 8:31=EC=97=90 &quot;Philippe Ombre=
danne&quot; &lt;<a href=3D"mailto:pombredanne@nexb.com">pombredanne@nexb.co=
m</a>&gt;=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:<br type=3D"attribution"><bl=
ockquote class=3D"quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc so=
lid;padding-left:1ex">Dear Jinbum,<br>
<div class=3D"quoted-text"><br>
On Thu, Dec 7, 2017 at 11:53 AM, Jinbum Park &lt;<a href=3D"mailto:jinb.par=
k7@gmail.com">jinb.park7@gmail.com</a>&gt; wrote:<br>
&gt; This patch refactors the arm page table dumping code,<br>
&gt; so multiple tables may be registered with the framework.<br>
&gt;<br>
&gt; This patch refers below commits of arm64.<br>
&gt; (4674fdb9f149 (&quot;arm64: mm: dump: make page table dumping reusable=
&quot;))<br>
&gt; (4ddb9bf83349 (&quot;arm64: dump: Make ptdump debugfs a separate optio=
n&quot;))<br>
&gt;<br>
&gt; Tested-by: Laura Abbott &lt;<a href=3D"mailto:labbott@redhat.com">labb=
ott@redhat.com</a>&gt;<br>
&gt; Reviewed-by: Laura Abbott &lt;<a href=3D"mailto:labbott@redhat.com">la=
bbott@redhat.com</a>&gt;<br>
&gt; Signed-off-by: Jinbum Park &lt;<a href=3D"mailto:jinb.park7@gmail.com"=
>jinb.park7@gmail.com</a>&gt;<br>
</div>[]<br>
<div class=3D"quoted-text">&gt; diff --git a/arch/arm/include/asm/ptdump.<w=
br>h b/arch/arm/include/asm/ptdump.<wbr>h<br>
&gt; new file mode 100644<br>
&gt; index 0000000..3a6c0b7<br>
&gt; --- /dev/null<br>
&gt; +++ b/arch/arm/include/asm/ptdump.<wbr>h<br>
&gt; @@ -0,0 +1,48 @@<br>
&gt; +/*<br>
&gt; + * Copyright (C) 2014 ARM Ltd.<br>
&gt; + *<br>
&gt; + * This program is free software; you can redistribute it and/or modi=
fy<br>
&gt; + * it under the terms of the GNU General Public License version 2 as<=
br>
&gt; + * published by the Free Software Foundation.<br>
&gt; + *<br>
&gt; + * This program is distributed in the hope that it will be useful,<br=
>
&gt; + * but WITHOUT ANY WARRANTY; without even the implied warranty of<br>
&gt; + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.=C2=A0 See the=
<br>
&gt; + * GNU General Public License for more details.<br>
&gt; + *<br>
&gt; + * You should have received a copy of the GNU General Public License<=
br>
&gt; + * along with this program.=C2=A0 If not, see &lt;<a href=3D"http://w=
ww.gnu.org/licenses/" rel=3D"noreferrer" target=3D"_blank">http://www.gnu.o=
rg/licenses/</a>&gt;<wbr>.<br>
&gt; + */<br>
<br>
</div>Sorry if I am nitpicking, but have you considered replacing this<br>
beautiful piece of fine legalese with the new SPDX ids?<br>
e.g. this:<br>
// SPDX-License-Identifier: GPL-2.0<br>
// Copyright (C) 2014 ARM Ltd.<br>
<br>
Or if this does not work and your includes break something if they are<br>
used in assembly, then this can work out too<br>
<br>
&gt; +/* SPDX-License-Identifier: GPL-2.0 */<br>
&gt; +/* Copyright (C) 2014 ARM Ltd. */<br>
<br>
See Thomas doc patches, and Greg and Linus comments on these topics.<br>
<br>
This is much leaner, is it?<br>
Less legalese comment also means more code and a better, smaller<br>
boilerplate lines/total lines ratio!<br>
Thank you for your kind consideration.<br>
<font color=3D"#888888"><br>
--<br>
Cordially<br>
Philippe Ombredanne<br>
</font></blockquote></div><br></div></div>

--94eb2c0944de431df5055fc8958c--
