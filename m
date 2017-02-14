MIME-Version: 1.0
In-Reply-To: <CAGXu5jLDnsaJ-PXZB6fwGEvi8pt9rehk76VWeVsq9m66pnrrVQ@mail.gmail.com>
References: <20170118095155.5e3bf976@kaiwan-T460> <90224a2d-2bfc-8c1e-1f2c-ca5bfbdb4879@redhat.com>
 <20170203101949.4c6908be@kaiwan-T460> <CAGXu5jLUdxDkjZ8Qndui1=5LC-_eavCpsgAqRa7RbdBUVdSsEg@mail.gmail.com>
 <20170209090714.63ce6333@kaiwan-T460> <CAGXu5jLDnsaJ-PXZB6fwGEvi8pt9rehk76VWeVsq9m66pnrrVQ@mail.gmail.com>
From: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Date: Tue, 14 Feb 2017 08:31:08 +0530
Message-ID: <CAPDLWs_75A08esqUGkkCBpfGDKaVH8LEtvqcM4fNZ-Ue2beZeA@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a114692e8c988f6054874c7bc
Subject: Re: [kernel-hardening] Merge in PAX_MEMORY_SANITIZE work from grsec
 to linux-next
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

--001a114692e8c988f6054874c7bc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=E2=80=8BThanks for your response...=E2=80=8B

>
>
> +config MEMORY_SANITIZE
> > +       bool "Enable memory sanitization features"
> > +       select SLUB_DEBUG
> > +       select PAGE_POISONING
> > +       select PAGE_POISONING_NO_SANITY if HIBERNATION
> > +       ---help---
> > +       This option enables ...
>
> Good start! Why the "if HIBERNATION" bit? It seems like sanity checks
> are very expensive, so we'd not want it as part of this config?
>
> =E2=80=8BOkay, I wasn't sure. So would it be (more) correct to retain the=
 first
two configs plus
=E2=80=8BPAGE_POISONING_NO_SANITY (without the if)?

>
> > +#ifdef CONFIG_MEMORY_SANITIZE
> > +static int __init memory_sanitize_init(void)
> > +{
> > +    /* With 'memory sanitize' On, page poisoning Must be turned on */
> > +    if (IS_ENABLED(CONFIG_MEMORY_SANITIZE)) {
> > +        want_page_poisoning =3D true;
> > +        __page_poisoning_enabled =3D true;
> > +    }
> > +    return 0;
> > +}
> > +early_initcall(memory_sanitize_init);
> > +#endif
>
> The ifdef and the IS_ENABLED seem redundant to me. I'd drop the ifdef.
>
> =E2=80=8BAgree on the redundancy, will do.


> >  #if defined(CONFIG_SLUB_DEBUG_ON)
> > +#if defined(CONFIG_MEMORY_SANITIZE)
> > +/* With 'memory sanitize' On, slub_debug should be 'P' */
> > +static int slub_debug =3D SLAB_POISON;
> > +#else
> >  static int slub_debug =3D DEBUG_DEFAULT_FLAGS;
> > +#endif /* CONFIG_MEMORY_SANITIZE */
> >  #else
> >  static int slub_debug;
> > -#endif
> > +#endif /* CONFIG_SLUB_DEBUG_ON */
>
> Could the definition of DEBUG_DEFAULT_FLAGS be adjusted instead of
> doing the ifdefs here in the .c file? Or, perhaps do a slub_debug |=3D
> SLAB_POISON in memory_sanitize_init()?
>
> Yes, the latter sounds good but the init function is in mm/page_poison.c
and the slub_debug var is a static in mm/slub.c . Any suggestions?
=E2=80=8B

>
> > +#ifdef CONFIG_MEMORY_SANITIZE
> > +    pr_info("[CONFIG_MEMORY_SANITIZE]: slub_debug =3D P? %s [0x%x]\n",
> > +        slub_debug & SLAB_POISON ? "yes" : "no", slub_debug);
> > +#endif
> > +
> >          mutex_lock(&slab_mutex);
> >
> >          slab_kset =3D kset_create_and_add("slab", &slab_uevent_ops,
> kernel_kobj);
>
> Good first step to getting the CONFIG to do something meaningful, thanks!
>
> -Kees
>
> =E2=80=8BThanks, happy to help!
- Kaiwan.=E2=80=8B

> --
> Kees Cook
> Pixel Security
>
>

--001a114692e8c988f6054874c7bc
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><div class=3D"gmail_quote"><div=
 class=3D"gmail_default" style=3D"font-size:small">=E2=80=8BThanks for your=
 response...=E2=80=8B</div><blockquote class=3D"gmail_quote" style=3D"margi=
n:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex=
"><div class=3D"gmail-HOEnZb"><div class=3D"gmail-h5"><div class=3D"gmail_d=
efault" style=3D"font-size:small">=C2=A0</div></div></div></blockquote><blo=
ckquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left=
:1px solid rgb(204,204,204);padding-left:1ex"><div class=3D"gmail-HOEnZb"><=
div class=3D"gmail-h5">
&gt; +config MEMORY_SANITIZE<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0bool &quot;Enable memory sanitization feat=
ures&quot;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0select SLUB_DEBUG<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0select PAGE_POISONING<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0select PAGE_POISONING_NO_SANITY if HIBERNA=
TION<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0---help---<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0This option enables ...<br>
<br>
</div></div>Good start! Why the &quot;if HIBERNATION&quot; bit? It seems li=
ke sanity checks<br>
are very expensive, so we&#39;d not want it as part of this config?<br>
<span class=3D"gmail-"><br></span></blockquote><div class=3D"gmail_default"=
 style=3D"font-size:small">=E2=80=8BOkay, I wasn&#39;t sure. So would it be=
 (more) correct to retain the first two configs plus=C2=A0</div><div class=
=3D"gmail_default" style=3D"font-size:small">=E2=80=8BPAGE_POISONING_NO_SAN=
ITY (without the if)?</div><blockquote class=3D"gmail_quote" style=3D"margi=
n:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex=
"><span class=3D"gmail-"><br>
&gt; +#ifdef CONFIG_MEMORY_SANITIZE<br>
&gt; +static int __init memory_sanitize_init(void)<br>
&gt; +{<br>
&gt; +=C2=A0 =C2=A0 /* With &#39;memory sanitize&#39; On, page poisoning Mu=
st be turned on */<br>
&gt; +=C2=A0 =C2=A0 if (IS_ENABLED(CONFIG_MEMORY_<wbr>SANITIZE)) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 want_page_poisoning =3D true;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 __page_poisoning_enabled =3D true;<br>
&gt; +=C2=A0 =C2=A0 }<br>
&gt; +=C2=A0 =C2=A0 return 0;<br>
&gt; +}<br>
&gt; +early_initcall(memory_<wbr>sanitize_init);<br>
&gt; +#endif<br>
<br>
</span>The ifdef and the IS_ENABLED seem redundant to me. I&#39;d drop the =
ifdef.<br>
<span class=3D"gmail-"><br></span></blockquote><div class=3D"gmail_default"=
 style=3D"font-size:small">=E2=80=8BAgree on the redundancy, will do.</div>=
<div class=3D"gmail_default" style=3D"font-size:small"><br></div><blockquot=
e class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px s=
olid rgb(204,204,204);padding-left:1ex"><span class=3D"gmail-"><br>
&gt;=C2=A0 #if defined(CONFIG_SLUB_DEBUG_ON)<br>
&gt; +#if defined(CONFIG_MEMORY_<wbr>SANITIZE)<br>
&gt; +/* With &#39;memory sanitize&#39; On, slub_debug should be &#39;P&#39=
; */<br>
&gt; +static int slub_debug =3D SLAB_POISON;<br>
&gt; +#else<br>
&gt;=C2=A0 static int slub_debug =3D DEBUG_DEFAULT_FLAGS;<br>
&gt; +#endif /* CONFIG_MEMORY_SANITIZE */<br>
&gt;=C2=A0 #else<br>
&gt;=C2=A0 static int slub_debug;<br>
&gt; -#endif<br>
&gt; +#endif /* CONFIG_SLUB_DEBUG_ON */<br>
<br>
</span>Could the definition of DEBUG_DEFAULT_FLAGS be adjusted instead of<b=
r>
doing the ifdefs here in the .c file? Or, perhaps do a slub_debug |=3D<br>
SLAB_POISON in memory_sanitize_init()?<br>
<span class=3D"gmail-"><br></span></blockquote><div class=3D"gmail_default"=
 style=3D"font-size:small">Yes, the latter sounds good but the init functio=
n is in mm/page_poison.c and the slub_debug var is a static in mm/slub.c . =
Any suggestions?</div><div class=3D"gmail_default" style=3D"font-size:small=
">=E2=80=8B</div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px =
0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex"><span cl=
ass=3D"gmail-"><br>
&gt; +#ifdef CONFIG_MEMORY_SANITIZE<br>
&gt; +=C2=A0 =C2=A0 pr_info(&quot;[CONFIG_MEMORY_<wbr>SANITIZE]: slub_debug=
 =3D P? %s [0x%x]\n&quot;,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 slub_debug &amp; SLAB_POISON ? &quot;yes&=
quot; : &quot;no&quot;, slub_debug);<br>
&gt; +#endif<br>
&gt; +<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mutex_lock(&amp;slab_mutex);<br>
&gt;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 slab_kset =3D kset_create_and_add(&q=
uot;slab&quot;, &amp;slab_uevent_ops, kernel_kobj);<br>
<br>
</span>Good first step to getting the CONFIG to do something meaningful, th=
anks!<br>
<div class=3D"gmail-HOEnZb"><div class=3D"gmail-h5"><br>
-Kees<br>
<br></div></div></blockquote><div class=3D"gmail_default" style=3D"font-siz=
e:small">=E2=80=8BThanks, happy to help!</div><div class=3D"gmail_default" =
style=3D"font-size:small">- Kaiwan.=E2=80=8B</div><blockquote class=3D"gmai=
l_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,20=
4,204);padding-left:1ex"><div class=3D"gmail-HOEnZb"><div class=3D"gmail-h5=
">
--<br>
Kees Cook<br>
Pixel Security<br>
<br>
</div></div></blockquote></div><br></div></div>

--001a114692e8c988f6054874c7bc--
