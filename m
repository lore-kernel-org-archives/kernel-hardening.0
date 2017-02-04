MIME-Version: 1.0
In-Reply-To: <CAGXu5jLUdxDkjZ8Qndui1=5LC-_eavCpsgAqRa7RbdBUVdSsEg@mail.gmail.com>
References: <20170118095155.5e3bf976@kaiwan-T460> <90224a2d-2bfc-8c1e-1f2c-ca5bfbdb4879@redhat.com>
 <20170203101949.4c6908be@kaiwan-T460> <CAGXu5jLUdxDkjZ8Qndui1=5LC-_eavCpsgAqRa7RbdBUVdSsEg@mail.gmail.com>
From: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Date: Sat, 4 Feb 2017 08:42:22 +0530
Message-ID: <CAPDLWs-LH=SOt+zpwiqXimirOPSnMGbWHn91Rhim_GCrno7VOQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a114b172690bc710547abc54b
Subject: Re: [kernel-hardening] Merge in PAX_MEMORY_SANITIZE work from grsec
 to linux-next
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

--001a114b172690bc710547abc54b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

>
>
> I think CONFIG_MEMORY_SANITIZE would enable:
>
> CONFIG_SLUB_DEBUG=3Dy
> CONFIG_PAGE_POISONING=3Dy
> CONFIG_PAGE_POISONING_NO_SANITY=3Dy
>
> but it would _also_ need to set these kernel command-line variables as
> if they had been set:
>
> page_poison=3D1
> slub_debug=3DP
>
> =E2=80=8BOkay got it.
=E2=80=8B

> > The new config now enables the CONFIG_PAX_MEMORY_SANITIZE code (my prev
> > email patch), correct? (leaving out the stuff we cannot get without the
> > full grsec implementation).
>
> No, the first step would be for the config to only provide the above
> changes.
>
> Then, we'd want to add the poison value defaults as you mention:
>
> =E2=80=8BRight.

>
> And then finally add the exceptions for the "frequently freed" slub
> caches, as identified by PaX already. This would need the flag
> defined, the poisoning logic adjusted to check the flag, and for the
> new kernel command-line options for changing the whether or not the
> flag is respected (like PaX's "pax_sanitize_slab").
>
> Yup..=E2=80=8B=E2=80=8B

>
> In the discussions Laura had with the mm folks, the only realistic
> path to landing this in the upstream kernel is through these debug
> features.
>
> =E2=80=8BHmm, ok.. naivete on my part :-)
=E2=80=8B

> > Most folks would only use debug during development, if at all - given
> all the
> > concerns regarding performance. Here, the objective is to enable a
> powerful
> > security feature set. Hence, the config directives should come under th=
e
> > 'Security Options' menu.
>
> We're not close to having a "Kernel Security" menu, so for now, I've
> wanted to focus on getting the features, and then making the Kconfig
> menus pretty later.
>
=E2=80=8BYeah; I meant under the existing 'Security options' menu actually.=
 But
still..=E2=80=8B

>
> Hopefully that all makes sense! :)
>
=E2=80=8BIndeed! Thanks very much..
-Kaiwan.=E2=80=8B

>
> -Kees
>
> --
> Kees Cook
> Pixel Security
>
>

--001a114b172690bc710547abc54b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote"><blo=
ckquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #c=
cc solid;padding-left:1ex"><br>I think CONFIG_MEMORY_SANITIZE would enable:=
<br>
<br>
CONFIG_SLUB_DEBUG=3Dy<br>
CONFIG_PAGE_POISONING=3Dy<br>
CONFIG_PAGE_POISONING_NO_<wbr>SANITY=3Dy<br>
<br>
but it would _also_ need to set these kernel command-line variables as<br>
if they had been set:<br>
<br>
page_poison=3D1<br>
slub_debug=3DP<br>
<span class=3D""><br></span></blockquote><div class=3D"gmail_default" style=
=3D"font-size:small">=E2=80=8BOkay got it.</div><div class=3D"gmail_default=
" style=3D"font-size:small">=E2=80=8B</div><blockquote class=3D"gmail_quote=
" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><=
span class=3D"">
&gt; The new config now enables the CONFIG_PAX_MEMORY_SANITIZE code (my pre=
v<br>
&gt; email patch), correct? (leaving out the stuff we cannot get without th=
e<br>
&gt; full grsec implementation).<br>
<br>
</span>No, the first step would be for the config to only provide the above=
 changes.<br>
<br>
Then, we&#39;d want to add the poison value defaults as you mention:<br>
<span class=3D""><br></span></blockquote><div class=3D"gmail_default" style=
=3D"font-size:small">=E2=80=8BRight.</div><blockquote class=3D"gmail_quote"=
 style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><s=
pan class=3D""><br>
</span>And then finally add the exceptions for the &quot;frequently freed&q=
uot; slub<br>
caches, as identified by PaX already. This would need the flag<br>
defined, the poisoning logic adjusted to check the flag, and for the<br>
new kernel command-line options for changing the whether or not the<br>
flag is respected (like PaX&#39;s &quot;pax_sanitize_slab&quot;).<br>
<span class=3D""><br></span></blockquote><div class=3D"gmail_default" style=
=3D"font-size:small">Yup..=E2=80=8B=E2=80=8B</div><blockquote class=3D"gmai=
l_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left=
:1ex"><span class=3D"">
<br>
</span>In the discussions Laura had with the mm folks, the only realistic<b=
r>
path to landing this in the upstream kernel is through these debug<br>
features.<br>
<span class=3D""><br></span></blockquote><div class=3D"gmail_default" style=
=3D"font-size:small">=E2=80=8BHmm, ok.. naivete on my part :-)</div><div cl=
ass=3D"gmail_default" style=3D"font-size:small">=E2=80=8B</div><blockquote =
class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid=
;padding-left:1ex"><span class=3D"">
&gt; Most folks would only use debug during development, if at all - given =
all the<br>
&gt; concerns regarding performance. Here, the objective is to enable a pow=
erful<br>
&gt; security feature set. Hence, the config directives should come under t=
he<br>
&gt; &#39;Security Options&#39; menu.<br>
<br>
</span>We&#39;re not close to having a &quot;Kernel Security&quot; menu, so=
 for now, I&#39;ve<br>
wanted to focus on getting the features, and then making the Kconfig<br>
menus pretty later.<br></blockquote><div class=3D"gmail_default" style=3D"f=
ont-size:small">=E2=80=8BYeah; I meant under the existing &#39;Security opt=
ions&#39; menu actually. But still..=E2=80=8B</div><blockquote class=3D"gma=
il_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-lef=
t:1ex">
<br>
Hopefully that all makes sense! :)<br></blockquote><div class=3D"gmail_defa=
ult" style=3D"font-size:small">=E2=80=8BIndeed! Thanks very much..</div><di=
v class=3D"gmail_default" style=3D"font-size:small">-Kaiwan.=E2=80=8B</div>=
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
-Kees<br>
<br>
--<br>
Kees Cook<br>
Pixel Security<br>
<br>
</font></span></blockquote></div><br></div></div>

--001a114b172690bc710547abc54b--
