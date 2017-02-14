MIME-Version: 1.0
References: <20170118095155.5e3bf976@kaiwan-T460> <90224a2d-2bfc-8c1e-1f2c-ca5bfbdb4879@redhat.com>
 <20170203101949.4c6908be@kaiwan-T460> <CAGXu5jLUdxDkjZ8Qndui1=5LC-_eavCpsgAqRa7RbdBUVdSsEg@mail.gmail.com>
 <20170209090714.63ce6333@kaiwan-T460> <CAGXu5jLDnsaJ-PXZB6fwGEvi8pt9rehk76VWeVsq9m66pnrrVQ@mail.gmail.com>
 <CAPDLWs8iS_xU0uQHKU1h6HmqP-oqAfK1qAxDpis_JyPSGVGLug@mail.gmail.com> <20170214161902.GH23718@leverpostej>
In-Reply-To: <20170214161902.GH23718@leverpostej>
From: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Date: Tue, 14 Feb 2017 16:33:31 +0000
Message-ID: <CAPDLWs-m4ESK-5p4bKW7g9xo=D+9ZSkW-YcsgQd5QGdxwit-FQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a11443e568aab1c0548802068
Subject: Re: [kernel-hardening] Merge in PAX_MEMORY_SANITIZE work from grsec
 to linux-next
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

--001a11443e568aab1c0548802068
Content-Type: text/plain; charset=UTF-8

Thanks for your succinct explanation Mark! Makes sense.
Will incorporate it, as Kees suggests..

On Tue, 14 Feb 2017, 9:49 pm Mark Rutland, <mark.rutland@arm.com> wrote:

> On Tue, Feb 14, 2017 at 01:34:38PM +0530, Kaiwan N Billimoria wrote:
> > >> diff --git a/mm/page_poison.c b/mm/page_poison.c
> > >> index 2e647c6..b45bc0a 100644
> > >> --- a/mm/page_poison.c
> > >> +++ b/mm/page_poison.c
> > >> @@ -49,6 +49,19 @@ struct page_ext_operations page_poisoning_ops = {
> > >>          .init = init_page_poisoning,
> > >>  };
> > >>
> > >> +#ifdef CONFIG_MEMORY_SANITIZE
> > >> +static int __init memory_sanitize_init(void)
> > >> +{
> > >> +    /* With 'memory sanitize' On, page poisoning Must be turned on */
> > >> +    if (IS_ENABLED(CONFIG_MEMORY_SANITIZE)) {
> > >> +        want_page_poisoning = true;
> > >> +        __page_poisoning_enabled = true;
> > >> +    }
> > >> +    return 0;
> > >> +}
> > >> +early_initcall(memory_sanitize_init);
> > >> +#endif
> > >
> > > The ifdef and the IS_ENABLED seem redundant to me. I'd drop the ifdef.
> >
> > An academic question perhaps- am not clear as to why the IS_ENABLED()
> > is preferable to an #ifdef. I thought eliminating a runtime 'if'
> > condition (by using an ifdef) is more optimal than the "if
> > IS_ENABLED(foo)"? Or (probably) does the compiler optimize it out
> > regardless (assuming that CONFIG_MEMORY_SANITIZE is not selected of
> > course)?
>
> We expect the compiler to optimize the code out, since IS_ENABLED(x) is
> a compile-time constant.
>
> As for why it's preferable, it has several benefits.
>
> For one thing, using if (IS_ENABLED(x)) means that we always get build
> coverage of the code predicated on the config option, so it's harder to
> accidentally break some build configurations.
>
> For another, it composes more nicely with other conditionals, which is
> useful when you have a condition that depends on several config options,
> or config options and runtime expressions.
>
> e.g. something like:
>
>         if (IS_ENABLED(FOO) && IS_ENABLED(BAR) && runtime_option)
>                 do_combination_thing();
>         else if (IS_ENABLED(BAR))
>                 do_bar_only_thing();
>         else
>                 do_other_thing();
>
> ... is much more painful to write using ifdefs.
>
> Generally, it's nicer for people to deal with than ifdeffery. It's
> easier for people to match braces in well-formatted code than it is to
> match #ifdef #endif pairs.
>
> Thanks,
> Mark.
>
>

--001a11443e568aab1c0548802068
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr">Thanks for your succinct explanation Mark! Makes sense. <br>
Will incorporate it, as Kees suggests.. </p>
<br><div class=3D"gmail_quote"><div dir=3D"ltr">On Tue, 14 Feb 2017, 9:49 p=
m Mark Rutland, &lt;<a href=3D"mailto:mark.rutland@arm.com">mark.rutland@ar=
m.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"ma=
rgin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">On Tue, Feb 14=
, 2017 at 01:34:38PM +0530, Kaiwan N Billimoria wrote:<br class=3D"gmail_ms=
g">
&gt; &gt;&gt; diff --git a/mm/page_poison.c b/mm/page_poison.c<br class=3D"=
gmail_msg">
&gt; &gt;&gt; index 2e647c6..b45bc0a 100644<br class=3D"gmail_msg">
&gt; &gt;&gt; --- a/mm/page_poison.c<br class=3D"gmail_msg">
&gt; &gt;&gt; +++ b/mm/page_poison.c<br class=3D"gmail_msg">
&gt; &gt;&gt; @@ -49,6 +49,19 @@ struct page_ext_operations page_poisoning_=
ops =3D {<br class=3D"gmail_msg">
&gt; &gt;&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .init =3D init_page_poisoni=
ng,<br class=3D"gmail_msg">
&gt; &gt;&gt;=C2=A0 };<br class=3D"gmail_msg">
&gt; &gt;&gt;<br class=3D"gmail_msg">
&gt; &gt;&gt; +#ifdef CONFIG_MEMORY_SANITIZE<br class=3D"gmail_msg">
&gt; &gt;&gt; +static int __init memory_sanitize_init(void)<br class=3D"gma=
il_msg">
&gt; &gt;&gt; +{<br class=3D"gmail_msg">
&gt; &gt;&gt; +=C2=A0 =C2=A0 /* With &#39;memory sanitize&#39; On, page poi=
soning Must be turned on */<br class=3D"gmail_msg">
&gt; &gt;&gt; +=C2=A0 =C2=A0 if (IS_ENABLED(CONFIG_MEMORY_SANITIZE)) {<br c=
lass=3D"gmail_msg">
&gt; &gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 want_page_poisoning =3D true;<br=
 class=3D"gmail_msg">
&gt; &gt;&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 __page_poisoning_enabled =3D tru=
e;<br class=3D"gmail_msg">
&gt; &gt;&gt; +=C2=A0 =C2=A0 }<br class=3D"gmail_msg">
&gt; &gt;&gt; +=C2=A0 =C2=A0 return 0;<br class=3D"gmail_msg">
&gt; &gt;&gt; +}<br class=3D"gmail_msg">
&gt; &gt;&gt; +early_initcall(memory_sanitize_init);<br class=3D"gmail_msg"=
>
&gt; &gt;&gt; +#endif<br class=3D"gmail_msg">
&gt; &gt;<br class=3D"gmail_msg">
&gt; &gt; The ifdef and the IS_ENABLED seem redundant to me. I&#39;d drop t=
he ifdef.<br class=3D"gmail_msg">
&gt;<br class=3D"gmail_msg">
&gt; An academic question perhaps- am not clear as to why the IS_ENABLED()<=
br class=3D"gmail_msg">
&gt; is preferable to an #ifdef. I thought eliminating a runtime &#39;if&#3=
9;<br class=3D"gmail_msg">
&gt; condition (by using an ifdef) is more optimal than the &quot;if<br cla=
ss=3D"gmail_msg">
&gt; IS_ENABLED(foo)&quot;? Or (probably) does the compiler optimize it out=
<br class=3D"gmail_msg">
&gt; regardless (assuming that CONFIG_MEMORY_SANITIZE is not selected of<br=
 class=3D"gmail_msg">
&gt; course)?<br class=3D"gmail_msg">
<br class=3D"gmail_msg">
We expect the compiler to optimize the code out, since IS_ENABLED(x) is<br =
class=3D"gmail_msg">
a compile-time constant.<br class=3D"gmail_msg">
<br class=3D"gmail_msg">
As for why it&#39;s preferable, it has several benefits.<br class=3D"gmail_=
msg">
<br class=3D"gmail_msg">
For one thing, using if (IS_ENABLED(x)) means that we always get build<br c=
lass=3D"gmail_msg">
coverage of the code predicated on the config option, so it&#39;s harder to=
<br class=3D"gmail_msg">
accidentally break some build configurations.<br class=3D"gmail_msg">
<br class=3D"gmail_msg">
For another, it composes more nicely with other conditionals, which is<br c=
lass=3D"gmail_msg">
useful when you have a condition that depends on several config options,<br=
 class=3D"gmail_msg">
or config options and runtime expressions.<br class=3D"gmail_msg">
<br class=3D"gmail_msg">
e.g. something like:<br class=3D"gmail_msg">
<br class=3D"gmail_msg">
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (IS_ENABLED(FOO) &amp;&amp; IS_ENABLED(BAR) =
&amp;&amp; runtime_option)<br class=3D"gmail_msg">
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 do_combination_thin=
g();<br class=3D"gmail_msg">
=C2=A0 =C2=A0 =C2=A0 =C2=A0 else if (IS_ENABLED(BAR))<br class=3D"gmail_msg=
">
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 do_bar_only_thing()=
;<br class=3D"gmail_msg">
=C2=A0 =C2=A0 =C2=A0 =C2=A0 else<br class=3D"gmail_msg">
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 do_other_thing();<b=
r class=3D"gmail_msg">
<br class=3D"gmail_msg">
... is much more painful to write using ifdefs.<br class=3D"gmail_msg">
<br class=3D"gmail_msg">
Generally, it&#39;s nicer for people to deal with than ifdeffery. It&#39;s<=
br class=3D"gmail_msg">
easier for people to match braces in well-formatted code than it is to<br c=
lass=3D"gmail_msg">
match #ifdef #endif pairs.<br class=3D"gmail_msg">
<br class=3D"gmail_msg">
Thanks,<br class=3D"gmail_msg">
Mark.<br class=3D"gmail_msg">
<br class=3D"gmail_msg">
</blockquote></div>

--001a11443e568aab1c0548802068--
