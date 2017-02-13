MIME-Version: 1.0
In-Reply-To: <20170209090714.63ce6333@kaiwan-T460>
References: <20170118095155.5e3bf976@kaiwan-T460> <90224a2d-2bfc-8c1e-1f2c-ca5bfbdb4879@redhat.com>
 <20170203101949.4c6908be@kaiwan-T460> <CAGXu5jLUdxDkjZ8Qndui1=5LC-_eavCpsgAqRa7RbdBUVdSsEg@mail.gmail.com>
 <20170209090714.63ce6333@kaiwan-T460>
From: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Date: Mon, 13 Feb 2017 17:12:01 +0530
Message-ID: <CAPDLWs-b-LPdQCA8ABzUQykMsfYVPGkmcNCW9EurvejKPbmJUA@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a11443e56c6584b054867f0e3
Subject: Re: [kernel-hardening] Merge in PAX_MEMORY_SANITIZE work from grsec
 to linux-next
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

--001a11443e56c6584b054867f0e3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<Nudge>, kindly check out the patch, thanks.


Regards,
Kaiwan.

Kaiwan N Billimoria
=E2=9C=89 kaiwan@kaiwantech.com
=E2=9C=89 kaiwan.billimoria@gmail.com

kaiwanTECH
http://kaiwantech.in
Do visit our enhanced website.

4931, 11th Floor, Highpoint IV, 45 Palace Road, Bangalore 560 001.
=E2=98=8E +91.9845016788 (M)
=E2=98=8E TeleFax: +91.80.22389396 | Alt. Tel: +91.80.64500257

LinkedIn: https://in.linkedin.com/in/kaiwanbillimoria

I blog here:
Tech : http://kaiwantech.wordpress.com  |
Running : http://kaiwanbill.blogspot.in/

"Don't be afraid that your life will end,
be afraid that it will never begin."

On Thu, Feb 9, 2017 at 9:07 AM, Kaiwan N Billimoria <kaiwan@kaiwantech.com>
wrote:

> Hi Kees,
>
> > I think CONFIG_MEMORY_SANITIZE would enable:
> >
> > CONFIG_SLUB_DEBUG=3Dy
> > CONFIG_PAGE_POISONING=3Dy
> > CONFIG_PAGE_POISONING_NO_SANITY=3Dy
> >
> > but it would _also_ need to set these kernel command-line variables as
> > if they had been set:
> >
> > page_poison=3D1
> > slub_debug=3DP
> >
> > No, the first step would be for the config to only provide the above
> > changes.
>
> Have made a first cut (below). Pl take a look and let me know if okay
> and how I should proceed.
>
> Note-
>  - the printks' are just for checking that options are enabled as require=
d
> (will get rid of them later)
>  - this is on linux-next (x86_64)
>  - dmesg filtered output when booted with this kernel (no page_posion or
> slub_debug
> cmdline options passed):
>
> $ dmesg |grep "MEMORY_SANITIZE"
> kern  :info  : [  +0.000387] [CONFIG_MEMORY_SANITIZE]: slub_debug =3D P? =
yes
> [0x800]
> kern  :debug : [  +0.000000] [CONFIG_MEMORY_SANITIZE]:
> page_poisoning_enabled? yes
> $
>
> =3D=3D=3D
> diff --git a/init/main.c b/init/main.c
> index ef47035..ba44574 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -1028,6 +1028,11 @@ static noinline void __init
> kernel_init_freeable(void)
>
>          do_basic_setup();
>
> +#ifdef CONFIG_MEMORY_SANITIZE
> +    pr_debug("[CONFIG_MEMORY_SANITIZE]: page_poisoning_enabled? %s\n",
> +        page_poisoning_enabled() ? "yes" : "no");
> +#endif
> +
>          /* Open the /dev/console on the rootfs, this should never fail *=
/
>          if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < =
0)
>                  pr_err("Warning: unable to open an initial console.\n");
> diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> index 3e5eada..8eed6ca 100644
> --- a/mm/Kconfig.debug
> +++ b/mm/Kconfig.debug
> @@ -97,3 +97,11 @@ config DEBUG_RODATA_TEST
>         ---help---
>         This option enables a testcase for the setting rodata read-only.
>
> +config MEMORY_SANITIZE
> +       bool "Enable memory sanitization features"
> +       select SLUB_DEBUG
> +       select PAGE_POISONING
> +       select PAGE_POISONING_NO_SANITY if HIBERNATION
> +       ---help---
> +       This option enables ...
> +
> diff --git a/mm/page_poison.c b/mm/page_poison.c
> index 2e647c6..b45bc0a 100644
> --- a/mm/page_poison.c
> +++ b/mm/page_poison.c
> @@ -49,6 +49,19 @@ struct page_ext_operations page_poisoning_ops =3D {
>          .init =3D init_page_poisoning,
>  };
>
> +#ifdef CONFIG_MEMORY_SANITIZE
> +static int __init memory_sanitize_init(void)
> +{
> +    /* With 'memory sanitize' On, page poisoning Must be turned on */
> +    if (IS_ENABLED(CONFIG_MEMORY_SANITIZE)) {
> +        want_page_poisoning =3D true;
> +        __page_poisoning_enabled =3D true;
> +    }
> +    return 0;
> +}
> +early_initcall(memory_sanitize_init);
> +#endif
> +
>  static inline void set_page_poison(struct page *page)
>  {
>          struct page_ext *page_ext;
> diff --git a/mm/slub.c b/mm/slub.c
> index d24e1ce..ed26b10 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -449,10 +449,15 @@ static inline void *restore_red_left(struct
> kmem_cache *s, void *p)
>   * Debug settings:
>   */
>  #if defined(CONFIG_SLUB_DEBUG_ON)
> +#if defined(CONFIG_MEMORY_SANITIZE)
> +/* With 'memory sanitize' On, slub_debug should be 'P' */
> +static int slub_debug =3D SLAB_POISON;
> +#else
>  static int slub_debug =3D DEBUG_DEFAULT_FLAGS;
> +#endif /* CONFIG_MEMORY_SANITIZE */
>  #else
>  static int slub_debug;
> -#endif
> +#endif /* CONFIG_SLUB_DEBUG_ON */
>
>  static char *slub_debug_slabs;
>  static int disable_higher_order_debug;
> @@ -5675,6 +5680,11 @@ static int __init slab_sysfs_init(void)
>          struct kmem_cache *s;
>          int err;
>
> +#ifdef CONFIG_MEMORY_SANITIZE
> +    pr_info("[CONFIG_MEMORY_SANITIZE]: slub_debug =3D P? %s [0x%x]\n",
> +        slub_debug & SLAB_POISON ? "yes" : "no", slub_debug);
> +#endif
> +
>          mutex_lock(&slab_mutex);
>
>          slab_kset =3D kset_create_and_add("slab", &slab_uevent_ops,
> kernel_kobj);
> =3D=3D=3D
>
> Regards,
> Kaiwan.
>
> > Then, we'd want to add the poison value defaults as you mention:
> >
> > > -Would include the 'new' poison / sanitize values of 0xfe and 0xff
> > > for slab (64 and 32-bit resp), etc etc.
> >
> > And then finally add the exceptions for the "frequently freed" slub
> > caches, as identified by PaX already. This would need the flag
> > defined, the poisoning logic adjusted to check the flag, and for the
> > new kernel command-line options for changing the whether or not the
> > flag is respected (like PaX's "pax_sanitize_slab").
> >
> > > Even if this is (somewhat) correct, my thinking is - correct me I'm
> > > totally wrong here - that the whole purpose of the exercise is to
> > > improve _security_; hence, tying this code into the "debug
> > > features" of the kernel isn't really what we want, yes?
> >
> > In the discussions Laura had with the mm folks, the only realistic
> > path to landing this in the upstream kernel is through these debug
> > features.
> >
> > > Most folks would only use debug during development, if at all -
> > > given all the concerns regarding performance. Here, the objective
> > > is to enable a powerful security feature set. Hence, the config
> > > directives should come under the 'Security Options' menu.
> >
> > We're not close to having a "Kernel Security" menu, so for now, I've
> > wanted to focus on getting the features, and then making the Kconfig
> > menus pretty later.
> >
> > Hopefully that all makes sense! :)
> >
> > -Kees
> >
>
>
>

--001a11443e56c6584b054867f0e3
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-size:small">&lt=
;Nudge&gt;, kindly check out the patch, thanks.</div><div class=3D"gmail_de=
fault" style=3D"font-size:small"><br></div></div><div class=3D"gmail_extra"=
><br clear=3D"all"><div><div class=3D"gmail_signature" data-smartmail=3D"gm=
ail_signature">Regards,<br>Kaiwan.<br><br>Kaiwan N Billimoria<br>=E2=9C=89 =
<a href=3D"mailto:kaiwan@kaiwantech.com" target=3D"_blank">kaiwan@kaiwantec=
h.com</a><br>=E2=9C=89 <a href=3D"mailto:kaiwan.billimoria@gmail.com" targe=
t=3D"_blank">kaiwan.billimoria@gmail.com</a><br><br>kaiwanTECH<br><a href=
=3D"http://kaiwantech.in" target=3D"_blank">http://kaiwantech.in</a> =C2=A0=
 <br>Do visit our enhanced website.<br><br>4931, 11th Floor, Highpoint IV, =
45 Palace Road, Bangalore 560 001.<br>=E2=98=8E +91.9845016788 (M)<br>=E2=
=98=8E TeleFax: +91.80.22389396 | Alt. Tel: +91.80.64500257<br><br>LinkedIn=
: <a href=3D"https://in.linkedin.com/in/kaiwanbillimoria" target=3D"_blank"=
>https://in.linkedin.com/in/kaiwanbillimoria</a><br><br>I blog here:<br>Tec=
h : <a href=3D"http://kaiwantech.wordpress.com" target=3D"_blank">http://ka=
iwantech.wordpress.com</a> =C2=A0| <br>Running : <a href=3D"http://kaiwanbi=
ll.blogspot.in/" target=3D"_blank">http://kaiwanbill.blogspot.in/</a><br><b=
r>&quot;Don&#39;t be afraid that your life will end,<br>be afraid that it w=
ill never begin.&quot;</div></div>
<br><div class=3D"gmail_quote">On Thu, Feb 9, 2017 at 9:07 AM, Kaiwan N Bil=
limoria <span dir=3D"ltr">&lt;<a href=3D"mailto:kaiwan@kaiwantech.com" targ=
et=3D"_blank">kaiwan@kaiwantech.com</a>&gt;</span> wrote:<br><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;p=
adding-left:1ex">Hi Kees,<br>
<span class=3D""><br>
&gt; I think CONFIG_MEMORY_SANITIZE would enable:<br>
&gt;<br>
&gt; CONFIG_SLUB_DEBUG=3Dy<br>
&gt; CONFIG_PAGE_POISONING=3Dy<br>
&gt; CONFIG_PAGE_POISONING_NO_<wbr>SANITY=3Dy<br>
&gt;<br>
&gt; but it would _also_ need to set these kernel command-line variables as=
<br>
&gt; if they had been set:<br>
&gt;<br>
&gt; page_poison=3D1<br>
&gt; slub_debug=3DP<br>
&gt;<br>
</span><span class=3D"">&gt; No, the first step would be for the config to =
only provide the above<br>
&gt; changes.<br>
<br>
</span>Have made a first cut (below). Pl take a look and let me know if oka=
y<br>
and how I should proceed.<br>
<br>
Note-<br>
=C2=A0- the printks&#39; are just for checking that options are enabled as =
required<br>
(will get rid of them later)<br>
=C2=A0- this is on linux-next (x86_64)<br>
=C2=A0- dmesg filtered output when booted with this kernel (no page_posion =
or slub_debug<br>
cmdline options passed):<br>
<br>
$ dmesg |grep &quot;MEMORY_SANITIZE&quot;<br>
kern=C2=A0 :info=C2=A0 : [=C2=A0 +0.000387] [CONFIG_MEMORY_SANITIZE]: slub_=
debug =3D P? yes [0x800]<br>
kern=C2=A0 :debug : [=C2=A0 +0.000000] [CONFIG_MEMORY_SANITIZE]: page_poiso=
ning_enabled? yes<br>
$<br>
<br>
=3D=3D=3D<br>
diff --git a/init/main.c b/init/main.c<br>
index ef47035..ba44574 100644<br>
--- a/init/main.c<br>
+++ b/init/main.c<br>
@@ -1028,6 +1028,11 @@ static noinline void __init kernel_init_freeable(voi=
d)<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0do_basic_setup();<br>
<br>
+#ifdef CONFIG_MEMORY_SANITIZE<br>
+=C2=A0 =C2=A0 pr_debug(&quot;[CONFIG_MEMORY_<wbr>SANITIZE]: page_poisoning=
_enabled? %s\n&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 page_poisoning_enabled() ? &quot;yes&quot; : &=
quot;no&quot;);<br>
+#endif<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Open the /dev/console on the rootfs, t=
his should never fail */<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (sys_open((const char __user *) &quot;=
/dev/console&quot;, O_RDWR, 0) &lt; 0)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pr_err(&quot;=
Warning: unable to open an initial console.\n&quot;);<br>
diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug<br>
index 3e5eada..8eed6ca 100644<br>
--- a/mm/Kconfig.debug<br>
+++ b/mm/Kconfig.debug<br>
@@ -97,3 +97,11 @@ config DEBUG_RODATA_TEST<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ---help---<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 This option enables a testcase for the setting =
rodata read-only.<br>
<br>
+config MEMORY_SANITIZE<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0bool &quot;Enable memory sanitization features&=
quot;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0select SLUB_DEBUG<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0select PAGE_POISONING<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0select PAGE_POISONING_NO_SANITY if HIBERNATION<=
br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0---help---<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0This option enables ...<br>
+<br>
diff --git a/mm/page_poison.c b/mm/page_poison.c<br>
index 2e647c6..b45bc0a 100644<br>
--- a/mm/page_poison.c<br>
+++ b/mm/page_poison.c<br>
@@ -49,6 +49,19 @@ struct page_ext_operations page_poisoning_ops =3D {<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0.init =3D init_page_poisoning,<br>
=C2=A0};<br>
<br>
+#ifdef CONFIG_MEMORY_SANITIZE<br>
+static int __init memory_sanitize_init(void)<br>
+{<br>
+=C2=A0 =C2=A0 /* With &#39;memory sanitize&#39; On, page poisoning Must be=
 turned on */<br>
+=C2=A0 =C2=A0 if (IS_ENABLED(CONFIG_MEMORY_<wbr>SANITIZE)) {<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 want_page_poisoning =3D true;<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 __page_poisoning_enabled =3D true;<br>
<span class=3D"">+=C2=A0 =C2=A0 }<br>
+=C2=A0 =C2=A0 return 0;<br>
+}<br>
</span>+early_initcall(memory_<wbr>sanitize_init);<br>
+#endif<br>
+<br>
=C2=A0static inline void set_page_poison(struct page *page)<br>
=C2=A0{<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct page_ext *page_ext;<br>
diff --git a/mm/slub.c b/mm/slub.c<br>
index d24e1ce..ed26b10 100644<br>
--- a/mm/slub.c<br>
+++ b/mm/slub.c<br>
@@ -449,10 +449,15 @@ static inline void *restore_red_left(struct kmem_cach=
e *s, void *p)<br>
=C2=A0 * Debug settings:<br>
=C2=A0 */<br>
=C2=A0#if defined(CONFIG_SLUB_DEBUG_ON)<br>
+#if defined(CONFIG_MEMORY_<wbr>SANITIZE)<br>
+/* With &#39;memory sanitize&#39; On, slub_debug should be &#39;P&#39; */<=
br>
+static int slub_debug =3D SLAB_POISON;<br>
+#else<br>
=C2=A0static int slub_debug =3D DEBUG_DEFAULT_FLAGS;<br>
+#endif /* CONFIG_MEMORY_SANITIZE */<br>
=C2=A0#else<br>
=C2=A0static int slub_debug;<br>
-#endif<br>
+#endif /* CONFIG_SLUB_DEBUG_ON */<br>
<br>
=C2=A0static char *slub_debug_slabs;<br>
=C2=A0static int disable_higher_order_debug;<br>
@@ -5675,6 +5680,11 @@ static int __init slab_sysfs_init(void)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct kmem_cache *s;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int err;<br>
<br>
+#ifdef CONFIG_MEMORY_SANITIZE<br>
+=C2=A0 =C2=A0 pr_info(&quot;[CONFIG_MEMORY_<wbr>SANITIZE]: slub_debug =3D =
P? %s [0x%x]\n&quot;,<br>
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 slub_debug &amp; SLAB_POISON ? &quot;yes&quot;=
 : &quot;no&quot;, slub_debug);<br>
+#endif<br>
+<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mutex_lock(&amp;slab_mutex);<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0slab_kset =3D kset_create_and_add(&quot;s=
lab&quot;, &amp;slab_uevent_ops, kernel_kobj);<br>
=3D=3D=3D<br>
<br>
Regards,<br>
Kaiwan.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
&gt; Then, we&#39;d want to add the poison value defaults as you mention:<b=
r>
&gt;<br>
&gt; &gt; -Would include the &#39;new&#39; poison / sanitize values of 0xfe=
 and 0xff<br>
&gt; &gt; for slab (64 and 32-bit resp), etc etc.<br>
&gt;<br>
&gt; And then finally add the exceptions for the &quot;frequently freed&quo=
t; slub<br>
&gt; caches, as identified by PaX already. This would need the flag<br>
&gt; defined, the poisoning logic adjusted to check the flag, and for the<b=
r>
&gt; new kernel command-line options for changing the whether or not the<br=
>
&gt; flag is respected (like PaX&#39;s &quot;pax_sanitize_slab&quot;).<br>
&gt;<br>
&gt; &gt; Even if this is (somewhat) correct, my thinking is - correct me I=
&#39;m<br>
&gt; &gt; totally wrong here - that the whole purpose of the exercise is to=
<br>
&gt; &gt; improve _security_; hence, tying this code into the &quot;debug<b=
r>
&gt; &gt; features&quot; of the kernel isn&#39;t really what we want, yes?<=
br>
&gt;<br>
&gt; In the discussions Laura had with the mm folks, the only realistic<br>
&gt; path to landing this in the upstream kernel is through these debug<br>
&gt; features.<br>
&gt;<br>
&gt; &gt; Most folks would only use debug during development, if at all -<b=
r>
&gt; &gt; given all the concerns regarding performance. Here, the objective=
<br>
&gt; &gt; is to enable a powerful security feature set. Hence, the config<b=
r>
&gt; &gt; directives should come under the &#39;Security Options&#39; menu.=
<br>
&gt;<br>
&gt; We&#39;re not close to having a &quot;Kernel Security&quot; menu, so f=
or now, I&#39;ve<br>
&gt; wanted to focus on getting the features, and then making the Kconfig<b=
r>
&gt; menus pretty later.<br>
&gt;<br>
&gt; Hopefully that all makes sense! :)<br>
&gt;<br>
&gt; -Kees<br>
&gt;<br>
<br>
<br>
</div></div></blockquote></div><br></div>

--001a11443e56c6584b054867f0e3--
