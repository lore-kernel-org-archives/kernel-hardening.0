Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAPeXnHtWBkC24D2mHQk7C=dg5-+7N8Z+pZkQWveYmwyutWvigw@mail.gmail.com>
References: <20170103225831.GA113525@beast> <20170104093236.GB31677@kroah.com>
 <CAPeXnHudW-YDmoK8NrFzQgAq4WuRDgFNC5-0GaG0+jVkq+3meQ@mail.gmail.com>
 <CAPeXnHue8hKFiMsddMTN7Hb5RWBGXWUgy2-kpXNLwBfOdf0QVA@mail.gmail.com>
 <20170104194707.GD25268@kroah.com> <CAPeXnHs1=jCGtSgOO859bp2chMWBX1L6VaKn65RKoLaTbVq_0A@mail.gmail.com>
 <20170104204704.GA17642@kroah.com> <CAPeXnHvpp7OkNz=auKXbCPTQcf8NVSmPwz3r89ZckUMQ9Gkf_g@mail.gmail.com>
 <CAPeXnHtWBkC24D2mHQk7C=dg5-+7N8Z+pZkQWveYmwyutWvigw@mail.gmail.com>
From: Matthew Garrett <mjg59@coreos.com>
Date: Wed, 4 Jan 2017 14:59:12 -0600
Message-ID: <CAPeXnHv0NNsBqf4Sqsba1CLRrocn3=WbPLhuMB6gK_ARcPGK9A@mail.gmail.com>
Content-Type: multipart/alternative; boundary=94eb2c03f4fa949d7505454b0efb
Subject: [kernel-hardening] Re: [PATCH] Allow userspace control of runtime disabling/enabling of
 driver probing
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Petr Tesarik <ptesarik@suse.com>, linux-pm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Madalin Bucur <madalin.bucur@nxp.com>, kernel-hardening@lists.openwall.com, Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ulf Hansson <ulf.hansson@linaro.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Kees Cook <keescook@chromium.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Len Brown <len.brown@intel.com>, Tomeu Vizoso <tomeu.vizoso@collabora.com>, Arnd Bergmann <arnd@arndb.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Russell King <rmk+kernel@arm.linux.org.uk>, Lukas Wunner <lukas@wunner.de>
List-ID: <kernel-hardening.lists.openwall.com>

--94eb2c03f4fa949d7505454b0efb
Content-Type: text/plain; charset=UTF-8

On Jan 4, 2017 12:47, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
wrote:

On Wed, Jan 04, 2017 at 02:01:00PM -0600, Matthew Garrett wrote:
> On Wed, Jan 4, 2017 at 1:47 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > You know the device type and vendor/product id before you authorize it,
> > you should be able to do this type of detection otherwise it seems
> > pretty pointless :)
>
> You know the vendor and product ID, which doesn't tell you whether one
> of the endpoints is a network device or a keyboard. You need to know
> that.

Are you sure you don't have the configuration information as well?  That
should tell you...


choose_config() isn't called until after authorisation, so even if scrape
that data you don't know what the kernel is going to choose.

And for network devices, they are almost all just vendor/product ids,
not many use the class protocol.


Plenty of stuff uses cdc.

--94eb2c03f4fa949d7505454b0efb
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><div class=3D"gmail_extra"><div class=3D"gmail_quote=
">On Jan 4, 2017 12:47, &quot;Greg Kroah-Hartman&quot; &lt;<a href=3D"mailt=
o:gregkh@linuxfoundation.org">gregkh@linuxfoundation.org</a>&gt; wrote:<br =
type=3D"attribution"><blockquote class=3D"quote" style=3D"margin:0 0 0 .8ex=
;border-left:1px #ccc solid;padding-left:1ex"><div class=3D"elided-text">On=
 Wed, Jan 04, 2017 at 02:01:00PM -0600, Matthew Garrett wrote:<br>
&gt; On Wed, Jan 4, 2017 at 1:47 PM, Greg Kroah-Hartman<br>
&gt; &lt;<a href=3D"mailto:gregkh@linuxfoundation.org">gregkh@linuxfoundati=
on.org</a>&gt; wrote:<br>
&gt; &gt; You know the device type and vendor/product id before you authori=
ze it,<br>
&gt; &gt; you should be able to do this type of detection otherwise it seem=
s<br>
&gt; &gt; pretty pointless :)<br>
&gt;<br>
&gt; You know the vendor and product ID, which doesn&#39;t tell you whether=
 one<br>
&gt; of the endpoints is a network device or a keyboard. You need to know<b=
r>
&gt; that.<br>
<br>
</div>Are you sure you don&#39;t have the configuration information as well=
?=C2=A0 That<br>
should tell you...<br></blockquote></div></div></div><div dir=3D"auto"><br>=
</div><div dir=3D"auto">choose_config() isn&#39;t called until after author=
isation, so even if scrape that data you don&#39;t know what the kernel is =
going to choose.=C2=A0</div><div dir=3D"auto"><br></div><div dir=3D"auto"><=
div class=3D"gmail_extra"><div class=3D"gmail_quote"><blockquote class=3D"q=
uote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1e=
x">
And for network devices, they are almost all just vendor/product ids,<br>
not many use the class protocol.<br></blockquote></div><br></div><div class=
=3D"gmail_extra" dir=3D"auto">Plenty of stuff uses cdc.=C2=A0</div></div></=
div>

--94eb2c03f4fa949d7505454b0efb--
