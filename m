Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 23D0E606A32D
	for <kernel-hardening@archiver.kernel.org>; Sat,  7 Nov 2026 17:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sempervictus-com.20260707.gappssmtp.com header.i=@sempervictus-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=cxz7VQZX
Received: (qmail 4035 invoked by uid 550); 7 Nov 2026 17:10:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3951 invoked from network); 7 Nov 2026 17:10:19 -0000
ARC-Seal: i=1; a=rsa-sha256; t=1794071409; cv=none;
        d=google.com; s=arc-20260327;
        b=b04SiwdEdhOxtJg5LPlR8m5q1osf1CYk9n8PgL2IPaTKpFnoKGkRssDShi2QSmEofm
         hEr47bC+/sIEuBNXrUsXW0WP5zRLoa/9cj8KFDH/jWIoX0PxlH6PDU+8NwXq8C3O79d3
         8/Zuhf+CW1IHNwxdf/hno0+1uBXUNJYiKTUYdHfFG9GlIypyyjMt+XV8veYFBfqe6Npq
         AruSJNmYHAFD/4vuXljMirNefYx5XpNVWuoYFLfloscrc0Z47zxP0MxWe0wnas+7dXei
         GAHB+jvvHxDtXL1v8lilvzbzLZ/fs6E6KTiiDE0Kj0xAxU4/b2CYZTnNRMK9/xf9VvEs
         hbUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=0H9tCjnmwlo9uZk/gC6/Bvliz1xXJNfxJ1DkxcLrAS0=;
        fh=HcdUer+h4qVvg64BJwGcIZHKNRQMCtOGuJ1J3u3E6/M=;
        b=miWhWgcp4egTPcm4ZwneG0ZGNKpEgFPx9+vwWvXoelG7JO+7jtIgw3PXHeqvfuS9JC
         KNjHZGobsuBQXVzTicsNgW+DN1yroNUKopmgoaH4HB7GgBxlEqpZsKk0LIjTYuDRj7H6
         So09r2Ol4tU46tTkWEO0qBePMXHp4wJrCivTriRclvVnNVy8eXCy4GwJTnwVKezvv6hN
         c7hbmWXixKboZtezpFllxTXn1mKc9tPn2/z9TwfSzHcnKsQhFwIl9XtoGKInGY80GttH
         PdU5OmFw5GsCDlF+92CwujvVMTYC5B/dq5NBbi/R/E7uLQGSrOxbk/vrQKUK4oECockI
         f5Dg==;
        darn=lists.openwall.com
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sempervictus-com.20260707.gappssmtp.com; s=20260707; t=1794071409; x=1794676209; darn=lists.openwall.com;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0H9tCjnmwlo9uZk/gC6/Bvliz1xXJNfxJ1DkxcLrAS0=;
        b=cxz7VQZXaYyg95FlZ6nN4N2pm8+5XlkkcviIMTcMPdGFUExmgXTivGqEkSYTunEiHo
         1A6DXHk7+/8e4dt+Gxs8erkD12ylXc+9xlPzaJAqyBgEkizar7No3Kmsd/14jednRZYP
         91zRR2PQ45oKeLhs/BZcAWzXVVhEH3DzGUoGQRd7YvvtLwchElfW2dmwttBQvcosQGY4
         FUgVcy343wbhhPSLxiJvtUDvKfA53g4lMaIbqs4Y8QzvwYLx+weisDLiBeTJedY/Zsyz
         jiqQBGx1BQMycq5wjD28J5iRdZ0+F1UXBIvZLV53ZTmFM16yBUdcJiTYwvszbIbtv60O
         RXqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794071409; x=1794676209;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=0H9tCjnmwlo9uZk/gC6/Bvliz1xXJNfxJ1DkxcLrAS0=;
        b=Q/JofujuaUeBfwqUd/fyu2KgjG6ErS+ycMzXBMb4SvJxg2mXa9LLa+lZed+Sdn2a9N
         1M6o7O4RTVYQZlrWgrs7CR3rwX5CJMJHdZd+5DM+Z78oRUB75GRuIB1xlZL4ka2kI6XK
         gg4KNvZRaIZ1NCVK44UXfGjlAO5XqzvjQGtacN+qdfrPWm6fw51cwADgw4o29canCflX
         tJfrkhOIoXoF8txuSEBDzmk5JvjjpGcxYRCV6lXpQfhrmfIlhGO7G6/nKrN88tzHlu1X
         uVrZYTTUvc7aZTWMZ6/0p+7dG/P2T8mE43s29Fk09jvMYqz/LbVYx5ImEcncs+ZGN/WR
         TWOA==
X-Forwarded-Encrypted: i=1; AL+hErHAdEumMRsp746f5EONsRkuFIfiMeOREMyrXqoiV45VC9NskC0DmLyrqMFso6A8IQ/1hhLxiqX5VorxxO/NU5EH@lists.openwall.com
X-Gm-Message-State: APuU4Z9BYWSAdHqorPIInGyf6wBuAWPTqTzeHv68z4UM7oRO6wjHPoQE
	/lCUqBmGnhmfQA+3R5VxB0WuwhAqVOEJknRSypuCkZ0SHk3AY/eGjIM012Sc4PhRtGERMKg4D80
	mjMi/gEMa6756A47SWsi6n0TMa+lQN/wa75n4KA49dw==
X-Gm-Gg: AYBFou0AdQ8xbc4cYUjBoUp+PTiY74OykzZn+3KqmXz4aXvpVY5XzmiWT5wYiNlauG2
	U37Llr4ZAjbcmVCvJZ0hXiXm63vpl79DV5pkgJHr19lI7bwBZB2qGJ2+/PwRKJrzWHjbIRDPTEV
	CgjZfmWYRDtq6KWNlxQEuVQybzot08qojG9qTR1NoaXFn8zrIvXrvY6dK27wxcT0yByHWjTYcj2
	ZLYapRw+f1RF7p96+mWGBNCtFoS3tnaLGxKpWvRCPrGP/e/RJyqV3nSXdpeYCwpoG7KQzglnbf1
	9OFMPzpEwQ/C2ScG4dLbKFXyOxKC8JttipciWRw2e84jK2ZNf+JdfANgUwyo+p/E7kXKdmEM+GK
	jDOGVyxQvzLWnHd8oHWfbM/3gZyy08c5pOk5YzIxS/ofd94e5OCi30UaIcoke85G5biWY/086bZ
	1fgdGeBg==
X-Received: by 2002:a05:6512:b1c:b0:5bf:caa5:14e2 with SMTP id
 2adb3069b0e04-5c00b784c7cmr605948e87.26.1794071409146; Sat, 07 Nov 2026
 09:10:09 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <ca90b945049ac3c27f3e1d9b8181137feb892436.camel@kjb.biglobe.ne.jp>
 <2026110611-tassel-bubble-dc09@gregkh> <1cd0f5e304584ab9d0a595a5d35b5649dc232fb2.camel@kjb.biglobe.ne.jp>
 <CAFUG7CciO_ZUMdjcOCfOtoi+YEni2+a-9QkcsCj1nox0NqHj0A@mail.gmail.com> <2026110719-zipping-silliness-2443@gregkh>
In-Reply-To: <2026110719-zipping-silliness-2443@gregkh>
From: Boris Lukashev <blukashev@sempervictus.com>
Date: Sat, 7 Nov 2026 12:09:57 -0500
X-Gm-Features: AclHuK9LWQTGPfDbrIk9dp37bJ0DL2mJo7MoVdHjfeOtsQv2l6nQwsJcL6GdFec
Message-ID: <CAFUG7CeRy7FOhdnqWHUY_Veb3rU8PbxDj5jk+qy-QvQTdC3A8w@mail.gmail.com>
Subject: Re: [RFC idea] Kernel API Firewall (kaf): subsystem-level attack
 surface reduction for the post-AI-CVE era
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Nakashima Seiichi <s-nakashima@kjb.biglobe.ne.jp>, kernel-hardening@lists.openwall.com, 
	mic@digikod.net, paul@paul-moore.com
Content-Type: multipart/alternative; boundary="0000000000000b4cb1065fb2cd4e"
X-Spam-Status: No, score=2.2 required=3.0 tests=BAYES_20,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--0000000000000b4cb1065fb2cd4e
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I try not to get into the politics involved so please don't put me in the
position of having to rebuke facile deflections predicated on evoking a
feeling shame in those of us managing the downstream effects by referencing
the nonexistent plight of overworked unpaid developers - devs are paid and
nobody at the top of the organization is taking a bus anywhere unless its a
shuttle between airport terminals connecting two first class flights.
That's an old and disingenuous argument which hasn't gotten any more
effective in the years its been made. Offhand we can look at the ongoing
convert proto_ops_bind callbacks situation: paid amazon employee so not
free, fixing regression in stable backports so not tested, and the rest of
the argument flies in its own face when 55 CVEs a day mean testing didn't
cover those previously (very naively) bringing the 75 fixes a day to 20 not
being for prior misses of which some are regressions themselves and some
fixes for the regressions. Linux maintenance isn't a gratis service done
out of the good of anyone's hearts for the world at large - as documented
here https://projects.propublica.org/nonprofits/organizations/460503801 it
takes in money, it pays people, and it participates in the commercial
ecosystem like any other vendor (producing profit as evidenced by a fair
deal of publications claiming 7f personal income for at least one of the
maintainers from the work - not exactly the image your stipulation seems
meant to evoke). There is nothing wrong with making money, it makes life
and enjoyment of it possible but please don't pretend there are noble and
altruistic motivations driving a commercial operation branding itself a
non-profit in 2026 - we live in an age when childrens cancer charities are
slush funds for politicians, its a thin veil at best. The GPL wall is still
used to prevent defense contractors and other innovators who harden linux
in a small closed space from taking that work commercial and directly
profitting from their forks despite upstream using non GPL code extracted
from LLMs; really puts the "care about security of the users" and "freedom"
premises into question. Finally, the ops engineer having to patch 10k
systems every 2d without losing revenue for the business takes home far
less than the maintainers but that person is the one who's job is on the
line/health getting trainwrecked when the patches themselves do not meet
muster/cause loss of revenue to the org. Mechanically, LF gets
compensated/early access to advanced LLMs from various providers, tools to
proactively find/remedy pathologies and classes of concern, and the
aforementioned contributions of cash and code from those same commercial
entities - that is monetary value which needs to come back as ROI to the
stake/shareholders of the companies providing it per the fiduciary
responsibility of executives signing off on the outflow, don't you agree?

To the point i was making before that unfortunate reiteration of what
industry already knows: the proposed approach isn't to send some heroic
contributors preloaded with tech debt into indentured corporate servitude
but to redirect commercial resources (however branded for legal purposes)
paid for by the revenue those downstream companies generate and put back
into LF as cash or tools to improve the products and services which they
sell.

-Boris

On Sat, Nov 7, 2026 at 7:04=E2=80=AFAM Greg KH <gregkh@linuxfoundation.org>=
 wrote:

> On Fri, Nov 06, 2026 at 04:00:48PM -0500, Boris Lukashev wrote:
> > @Greg KH:  there is no practical choice for using anything but what's
> > prescribed by the vendor and contractually supported in the commercial
> > world (further complicated by binary blobs/device trees/intellectual
> > property concerns/etc). You cant ask the hotel to change the kiosk
> > distribution to a safer one in order to check you in despite them havin=
g
> > your PII and payment data running through it any more than the rest of =
us
> > despite your undeniable awareness of the threat involved. It would be f=
ar
> > more realistic and practical for the Linux Foundation to assign its
> > seasoned talent to work on downstream distributions of economic relevan=
ce
> > to its member entities than to swap out the OS' in the clustered engine
> of
> > today's economy.
>
> So, it's not enough that the kernel developers and stable maintainers
> provide a free feed of 75 fixes a day in a tested and released kernel,
> and 55 documented CVE fixes a day, they then are required to, for free,
> take those patches and integrate them into for-profit company's kernels
> for them because that for-profit company doesn't want to pay for that
> effort to meet the contractual requirements that their customers pay for
> them to meet?
>
> If you take the "pure numbers" point of view, that means that we should
> do this only for Debian and Yocto as those distros hold the huge
> majority of all of the server and embedded systems numbers in the world,
> everything else is just a tiny percent.  Oh wait, the LF already does
> this for you, for Yocto, and Debian is also free and up to date with all
> of these security issues for you to rely on.
>
> So again, why not hold the companies that you feel are worth paying for
> this service, responsible for meeting their own self-defined
> contractural requirements?  Given that the community is giving all of
> this to them for free, it's odd that anyone would ask for us to do more
> work than that, don't you agree?
>
> greg k-h
>


--=20
Boris Lukashev
Systems Architect
Semper Victus <https://www.sempervictus.com>

--0000000000000b4cb1065fb2cd4e
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>I try not to get into the politics involved so please=
 don&#39;t put me in the position of having to rebuke facile deflections pr=
edicated on evoking a feeling shame in those of us managing the downstream =
effects by referencing the nonexistent plight of overworked unpaid develope=
rs - devs are paid and nobody at the top of the organization is taking a bu=
s anywhere unless its a shuttle between airport terminals connecting two fi=
rst class flights.=C2=A0 That&#39;s an old and disingenuous argument which =
hasn&#39;t gotten any more effective in the years its been made. Offhand we=
 can look at the ongoing convert proto_ops_bind callbacks situation: paid a=
mazon employee so not free, fixing regression in stable backports so not te=
sted, and the rest of the argument flies in its own face when 55 CVEs a day=
 mean testing didn&#39;t cover those previously (very naively) bringing the=
 75 fixes a day to 20 not being for prior misses of which some are regressi=
ons themselves and some fixes for the regressions. Linux maintenance isn&#3=
9;t a gratis service done out of the good of anyone&#39;s hearts for the wo=
rld at large - as documented here <a href=3D"https://projects.propublica.or=
g/nonprofits/organizations/460503801">https://projects.propublica.org/nonpr=
ofits/organizations/460503801</a> it takes in money, it pays people, and it=
 participates in the commercial ecosystem like any other vendor (producing =
profit as evidenced by a fair deal of publications claiming 7f personal inc=
ome for at least one of the maintainers from the work - not exactly the ima=
ge your stipulation seems meant to evoke). There is nothing wrong with maki=
ng money, it makes life and enjoyment of it possible but please don&#39;t p=
retend there are noble and altruistic motivations driving a commercial oper=
ation branding itself a non-profit in 2026 - we live in an age when childre=
ns cancer charities are slush funds for politicians, its a thin veil at bes=
t. The GPL wall=C2=A0is still used to prevent defense contractors and other=
 innovators who harden linux in a small closed space from taking that work =
commercial and directly profitting from their forks despite upstream using =
non GPL code extracted from LLMs; really puts the &quot;care about security=
 of the users&quot; and &quot;freedom&quot; premises into question. Finally=
, the ops engineer having to patch 10k systems every 2d without losing reve=
nue for the business takes home far less than the maintainers but that pers=
on is the one who&#39;s job is on the line/health getting trainwrecked when=
 the patches themselves do not meet muster/cause loss of revenue to the org=
. Mechanically, LF gets compensated/early access to advanced LLMs from vari=
ous providers, tools to proactively find/remedy pathologies and classes of =
concern, and the aforementioned contributions of cash and code from those s=
ame commercial entities - that is monetary value which needs to come back a=
s ROI to the stake/shareholders of the companies providing it per the fiduc=
iary responsibility of executives signing off on the outflow, don&#39;t you=
 agree?</div><div><br></div><div>To the point i was making before that unfo=
rtunate reiteration of what industry already knows: the proposed approach i=
sn&#39;t to send some heroic contributors preloaded with tech debt into ind=
entured corporate=C2=A0servitude but to redirect commercial resources (howe=
ver branded for legal purposes) paid for by the revenue those downstream co=
mpanies generate and put back into LF as cash or tools to improve the produ=
cts and services which they sell.</div><div><br></div><div>-Boris</div></di=
v><br><div class=3D"gmail_quote gmail_quote_container"><div dir=3D"ltr" cla=
ss=3D"gmail_attr">On Sat, Nov 7, 2026 at 7:04=E2=80=AFAM Greg KH &lt;<a hre=
f=3D"mailto:gregkh@linuxfoundation.org">gregkh@linuxfoundation.org</a>&gt; =
wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0=
px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">On Fri, N=
ov 06, 2026 at 04:00:48PM -0500, Boris Lukashev wrote:<br>
&gt; @Greg KH:=C2=A0 there is no practical choice for using anything but wh=
at&#39;s<br>
&gt; prescribed by the vendor and contractually supported in the commercial=
<br>
&gt; world (further complicated by binary blobs/device trees/intellectual<b=
r>
&gt; property concerns/etc). You cant ask the hotel to change the kiosk<br>
&gt; distribution to a safer one in order to check you in despite them havi=
ng<br>
&gt; your PII and payment data running through it any more than the rest of=
 us<br>
&gt; despite your undeniable awareness of the threat involved. It would be =
far<br>
&gt; more realistic and practical for the Linux Foundation to assign its<br=
>
&gt; seasoned talent to work on downstream distributions of economic releva=
nce<br>
&gt; to its member entities than to swap out the OS&#39; in the clustered e=
ngine of<br>
&gt; today&#39;s economy.<br>
<br>
So, it&#39;s not enough that the kernel developers and stable maintainers<b=
r>
provide a free feed of 75 fixes a day in a tested and released kernel,<br>
and 55 documented CVE fixes a day, they then are required to, for free,<br>
take those patches and integrate them into for-profit company&#39;s kernels=
<br>
for them because that for-profit company doesn&#39;t want to pay for that<b=
r>
effort to meet the contractual requirements that their customers pay for<br=
>
them to meet?<br>
<br>
If you take the &quot;pure numbers&quot; point of view, that means that we =
should<br>
do this only for Debian and Yocto as those distros hold the huge<br>
majority of all of the server and embedded systems numbers in the world,<br=
>
everything else is just a tiny percent.=C2=A0 Oh wait, the LF already does<=
br>
this for you, for Yocto, and Debian is also free and up to date with all<br=
>
of these security issues for you to rely on.<br>
<br>
So again, why not hold the companies that you feel are worth paying for<br>
this service, responsible for meeting their own self-defined<br>
contractural requirements?=C2=A0 Given that the community is giving all of<=
br>
this to them for free, it&#39;s odd that anyone would ask for us to do more=
<br>
work than that, don&#39;t you agree?<br>
<br>
greg k-h<br>
</blockquote></div><div><br clear=3D"all"></div><br><span class=3D"gmail_si=
gnature_prefix">-- </span><br><div dir=3D"ltr" class=3D"gmail_signature"><d=
iv dir=3D"ltr"><div><div dir=3D"ltr"><div><div dir=3D"ltr">Boris Lukashev<b=
r>Systems Architect<br><a href=3D"https://www.sempervictus.com" target=3D"_=
blank">Semper Victus</a><br></div></div></div></div></div></div>

--0000000000000b4cb1065fb2cd4e--
