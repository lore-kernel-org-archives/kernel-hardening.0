Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJqo99Vheuod5DPobzBpGMz7zw_CHvG4iNuOU87x-REFA@mail.gmail.com>
References: <CAPDLWs8g5CRTDwDuuLuuGh8K30Py_kGkjVfuT++Q09rT6XaQ=A@mail.gmail.com>
 <CAGXu5j+oOJoJ3JFzEpv4jNeCLu95-QVfYQ8mP-M-waqyvoDDRg@mail.gmail.com>
 <CAPDLWs_DwbB7ZJJ55W8Hz6vnNGDPVvbSw__+1qh42jjNrcCQYA@mail.gmail.com> <CAGXu5jJqo99Vheuod5DPobzBpGMz7zw_CHvG4iNuOU87x-REFA@mail.gmail.com>
From: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Date: Thu, 12 Jan 2017 09:01:05 +0530
Message-ID: <CAPDLWs8dMyk3CGpt49w0Nyd59ZDDOSMz87vkm5k7NkObAZNzog@mail.gmail.com>
Content-Type: multipart/alternative; boundary=089e012285be2753eb0545dd5a5f
Subject: Re: [kernel-hardening] New to KSPP, would like to contribute
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

--089e012285be2753eb0545dd5a5f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Okay, thanks, I see it better now :)

Forgive my silly qs:
so as I understand it, the objective is to start merging in some of the
grsec code into mainline, yes? So, which kernel do we work on? the latest
rc or do I work on the one where the above patch applies (i.e. 4.8.17)?
(Also, fyi, i'll be travelling from tomm so will not be able to work on
this for a few days at least).

TIA!

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

On Wed, Jan 11, 2017 at 1:55 AM, Kees Cook <keescook@chromium.org> wrote:

> On Tue, Jan 10, 2017 at 4:42 AM, Kaiwan N Billimoria
> <kaiwan@kaiwantech.com> wrote:
> > Thanks Kees,
> >>
> >>
> >> Welcome to the list! If you're familiar with mm areas, I'd say a great
> >> place to start would be to help finish up the zero-poisoning work,
> >> especially extracting the optimizations that PaX did for slabs to
> >> avoid, etc.
> >
> > Ok so I really have no idea reg PaX and optimizations done for slab via
> it..
> > Could you
> > enlighten me pl? Point me to relevant links perhaps..
>
> Sure thing! I would recommend downloading the latest grsecurity patchset:
> https://grsecurity.net/download.php#test
> (currently for a 4.8.7 kernel) and apply it there. Once you have a
> tree you can examine, I would look at how CONFIG_PAX_MEMORY_SANITIZE
> works, and especially note this from the security/Kconfig:
>
>           The tradeoff is performance impact, on a single CPU system kern=
el
>           compilation sees a 3% slowdown, other systems and workloads may
> vary
>           and you are advised to test this feature on your expected
> workload
>           before deploying it.
>
>           The slab sanitization feature excludes a few slab caches per
> default
>           for performance reasons.  To extend the feature to cover those =
as
>           well, pass "pax_sanitize_slab=3Dfull" as kernel command line
> parameter.
>
>           To reduce the performance penalty by sanitizing pages only,
> albeit
>           limiting the effectiveness of this feature at the same time, sl=
ab
>           sanitization can be disabled with the kernel command line
> parameter
>           "pax_sanitize_slab=3Doff".
>
> I'd like to see the mentioned excluded slab caches also done in the
> kernel, along with similar kernel command line options. Additionally,
> getting all the upstream stuff behind a single CONFIG (similar to
> CONFIG_PAX_MEMORY_SANITIZE) would be great, instead of having to set 3
> CONFIGs and 2 kernel parameters. :)
>
> Let me know if you need more details...
>
> -Kees
>
> --
> Kees Cook
> Nexus Security
>
>

--089e012285be2753eb0545dd5a5f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_default" style=3D"font-size:small">Oka=
y, thanks, I see it better now :)</div><div class=3D"gmail_default" style=
=3D"font-size:small"><br></div><div class=3D"gmail_default" style=3D"font-s=
ize:small">Forgive my silly qs:=C2=A0</div><div class=3D"gmail_default" sty=
le=3D"font-size:small">so as I understand it, the objective is to start mer=
ging in some of the grsec code into mainline, yes? So, which kernel do we w=
ork on? the latest rc or do I work on the one where the above patch applies=
 (i.e. 4.8.17)?</div><div class=3D"gmail_default" style=3D"font-size:small"=
>(Also, fyi, i&#39;ll be travelling from tomm so will not be able to work o=
n this for a few days at least).</div><div class=3D"gmail_default" style=3D=
"font-size:small"><br></div><div class=3D"gmail_default" style=3D"font-size=
:small">TIA!</div></div><div class=3D"gmail_extra"><br clear=3D"all"><div><=
div class=3D"gmail_signature" data-smartmail=3D"gmail_signature">Regards,<b=
r>Kaiwan.<br><br>Kaiwan N Billimoria<br>=E2=9C=89 <a href=3D"mailto:kaiwan@=
kaiwantech.com" target=3D"_blank">kaiwan@kaiwantech.com</a><br>=E2=9C=89 <a=
 href=3D"mailto:kaiwan.billimoria@gmail.com" target=3D"_blank">kaiwan.billi=
moria@gmail.com</a><br><br>kaiwanTECH<br><a href=3D"http://kaiwantech.in" t=
arget=3D"_blank">http://kaiwantech.in</a> =C2=A0 <br>Do visit our enhanced =
website.<br><br>4931, 11th Floor, Highpoint IV, 45 Palace Road, Bangalore 5=
60 001.<br>=E2=98=8E +91.9845016788 (M)<br>=E2=98=8E TeleFax: +91.80.223893=
96 | Alt. Tel: +91.80.64500257<br><br>LinkedIn: <a href=3D"https://in.linke=
din.com/in/kaiwanbillimoria" target=3D"_blank">https://in.linkedin.com/in/k=
aiwanbillimoria</a><br><br>I blog here:<br>Tech : <a href=3D"http://kaiwant=
ech.wordpress.com" target=3D"_blank">http://kaiwantech.wordpress.com</a> =
=C2=A0| <br>Running : <a href=3D"http://kaiwanbill.blogspot.in/" target=3D"=
_blank">http://kaiwanbill.blogspot.in/</a><br><br>&quot;Don&#39;t be afraid=
 that your life will end,<br>be afraid that it will never begin.&quot;</div=
></div>
<br><div class=3D"gmail_quote">On Wed, Jan 11, 2017 at 1:55 AM, Kees Cook <=
span dir=3D"ltr">&lt;<a href=3D"mailto:keescook@chromium.org" target=3D"_bl=
ank">keescook@chromium.org</a>&gt;</span> wrote:<br><blockquote class=3D"gm=
ail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-le=
ft:1ex"><span class=3D"">On Tue, Jan 10, 2017 at 4:42 AM, Kaiwan N Billimor=
ia<br>
&lt;<a href=3D"mailto:kaiwan@kaiwantech.com">kaiwan@kaiwantech.com</a>&gt; =
wrote:<br>
&gt; Thanks Kees,<br>
&gt;&gt;<br>
&gt;&gt;<br>
&gt;&gt; Welcome to the list! If you&#39;re familiar with mm areas, I&#39;d=
 say a great<br>
&gt;&gt; place to start would be to help finish up the zero-poisoning work,=
<br>
&gt;&gt; especially extracting the optimizations that PaX did for slabs to<=
br>
&gt;&gt; avoid, etc.<br>
&gt;<br>
&gt; Ok so I really have no idea reg PaX and optimizations done for slab vi=
a it..<br>
&gt; Could you<br>
&gt; enlighten me pl? Point me to relevant links perhaps..<br>
<br>
</span>Sure thing! I would recommend downloading the latest grsecurity patc=
hset:<br>
<a href=3D"https://grsecurity.net/download.php#test" rel=3D"noreferrer" tar=
get=3D"_blank">https://grsecurity.net/<wbr>download.php#test</a><br>
(currently for a 4.8.7 kernel) and apply it there. Once you have a<br>
tree you can examine, I would look at how CONFIG_PAX_MEMORY_SANITIZE<br>
works, and especially note this from the security/Kconfig:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 The tradeoff is performance impact, on a=
 single CPU system kernel<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 compilation sees a 3% slowdown, other sy=
stems and workloads may vary<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 and you are advised to test this feature=
 on your expected workload<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 before deploying it.<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 The slab sanitization feature excludes a=
 few slab caches per default<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for performance reasons.=C2=A0 To extend=
 the feature to cover those as<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 well, pass &quot;pax_sanitize_slab=3Dful=
l&quot; as kernel command line parameter.<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 To reduce the performance penalty by san=
itizing pages only, albeit<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 limiting the effectiveness of this featu=
re at the same time, slab<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sanitization can be disabled with the ke=
rnel command line parameter<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 &quot;pax_sanitize_slab=3Doff&quot;.<br>
<br>
I&#39;d like to see the mentioned excluded slab caches also done in the<br>
kernel, along with similar kernel command line options. Additionally,<br>
getting all the upstream stuff behind a single CONFIG (similar to<br>
CONFIG_PAX_MEMORY_SANITIZE) would be great, instead of having to set 3<br>
CONFIGs and 2 kernel parameters. :)<br>
<br>
Let me know if you need more details...<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
-Kees<br>
<br>
--<br>
Kees Cook<br>
Nexus Security<br>
<br>
</div></div></blockquote></div><br></div>

--089e012285be2753eb0545dd5a5f--
