Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 0A819606A32C
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Nov 2026 21:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sempervictus-com.20260707.gappssmtp.com header.i=@sempervictus-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=PFw29HxN
Received: (qmail 5372 invoked by uid 550); 6 Nov 2026 21:01:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5305 invoked from network); 6 Nov 2026 21:01:09 -0000
ARC-Seal: i=1; a=rsa-sha256; t=1793998861; cv=none;
        d=google.com; s=arc-20260327;
        b=WUvhvXY0MbJ4O0UvwkOG3Vc8PYIKCXcsO9QyNci2kVOCeq7HmF7G+PzqYpt3/yFw6f
         QwRLcL/SA+UJgd/VB7V+4vuyqCEh9sR2IgRBvqLnB7TZNrjObiIUMAGpfIyiV707Gnl8
         FVMzFxdS9eVVVplSFcEAiHvcocgMxVyOMegpsyOdKHEsbOoCBUq/gw6j7qfjKAGNqJdY
         8k99YoP6Y3gtz01+/FiQdrq9b8xor0nSSr/VQ5d0ygtg47tp2F9bs5hz0yv98xKGytyP
         6oLsrSLkEqreE819cAyqn5rI+rjqvNhiEfrkmB9WJfQmVXvjbIFfuHjeouCW1KdoF15E
         Uc9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=iszjoaRMLLpBwvriP5VRt3pVR11j8LHDpgNeAeeeRmw=;
        fh=EFz/vM6MwyR/UuCdItFZ+vYEaViYQWZ+FMcFQjJt/MA=;
        b=jc5AIZ4HhCt5aQPrCnaxzEzwyBC76s33ex+cmEh0CRu1Jxt8cU2RqNOc3PD7S+j27b
         94DHVlhs4m8Sa3Zfj1eMCo1YMm0kOI023aRohgvt+CeyeQQWIptttMVYs3lYk49iJBA4
         JUu5Jsm2QL7rO7ASO0nRkwOMCBB6oNCVIc7LlP5ud8Sd/IxxU9Cqy/l4js0fkgCv4pmy
         AIPq9PhGgbTbhqzHdkFB72Cxi4VMMobzHhleJNNlKHsiBQ/6Jm3NKs0/+26PLg7jXDxr
         uqsjU9rzlJatDZ5xga05N0xg2AyKZEtWMbNt/RAfS82M7Is4XtoevjqNih+f3AnbDwm+
         BRMw==;
        darn=lists.openwall.com
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sempervictus-com.20260707.gappssmtp.com; s=20260707; t=1793998861; x=1794603661; darn=lists.openwall.com;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iszjoaRMLLpBwvriP5VRt3pVR11j8LHDpgNeAeeeRmw=;
        b=PFw29HxNpH95CdYmu1ndcH02KXradTJctE4WrsnsyfxvYRCgCRr/f6oINMF+9HKd0V
         ggQsVaC5qpKyfQL+RN/d4dD5JSCwkM0UTgot9PRQ/cYrY4gP0fQZbLCCV4YzBdpo7tZI
         kwBiqIA3Bfj5PYF5iFrtIyPwavMBbiL5POzX8emfKqt7+DYTWm+u2byEM0ZujifaszV9
         a62Kuys6KlMjyX5Q0rT72uC0ugxvoHi4oWbThVcaZoHkxQ1/lvN4hbdHdLTyfgjm5+i/
         S3hl2sx7CUpe5yP0SBgujCf90FLnySld43KJATrK709xbI4F5Ics871GvhofBZx0PoFz
         9U2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793998861; x=1794603661;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=iszjoaRMLLpBwvriP5VRt3pVR11j8LHDpgNeAeeeRmw=;
        b=WF4mNjOVUYd9WGH3oKANiayS4z73Nyb1uljb/gxRAupm2Qq0QryV8PJxLL/nmG+T0b
         ZUb16XjK9cE2c1pM85Zvb0mcrdwz9v4iNZmYPnU/ipkH2N4Txp0XeqzQ5RbxN0wKPXjt
         8fu/GQ6+HIjRJ8QVeZw0FMk1YXIhKvcdaEe4Jz5x1GEb72Gl77bgXUdI2Tshg9omSC6I
         AdVtm8YiXR9iaSMkFiO5Oc1bJRihz7GKCi7SM3uoZUhXNkLNyKxdxXANgQtTfSdxbs/6
         tmX8OBlCw4O7sDejKslw7MvxeezirKvkZt3EzMezGP88VEl39qas+3qZU2vey5SezGmu
         sJLQ==
X-Forwarded-Encrypted: i=1; AL+hErHfLm+SPQLJyTod0PyDlHrHpS9S7wxzNl952cEKkY5LeL9gP4tekn/HV4dmbOcZr1NLGkyId3g4CTJjJMMooQNI@lists.openwall.com
X-Gm-Message-State: APuU4Z9VCTIQPEGe/Oq9bHDrC40hpriV24n/VAduVrs22ZQq/EiYwcGB
	xO5RiFG9OGOU5DrbF2h1lteHk2sr6k6c2R8Ih+bhOOu+xa4lBQaurFcugHNZSc1B7OGZZQidsy5
	qAELSrUVQvkBCWJkhBgCu+HfcB+snue37CDjWK7YSgw==
X-Gm-Gg: AYBFou3A0FB2SJ2Y//kjjoUXPps/oC2RZ7zj5K4AFBZiUB8Fbj958ZBREus3EQrtwnq
	8p8FGX7kyOhKDEcFx/Y3W1/W4ZuqrVkr5G2UaJ8GViXqx3h9SYgPzfUByuBdi9qDqzIg0s/tZ9y
	TMgZmw6CKFfQat+H6x18dWvikR1qS4+uYAGq4IulbJ7MiRRfVG+63M76pWNtteAjFtwZO9BQGi6
	JbNWSzaIUgQKkjUJfOtSBMhmRwWUU0ExKtrr94oUeW+O0Rr624l+VVnDK6H1zqbtqOvc2bMTEwR
	kXqi3ZYdhCHUEHScCPYMGxoGzusLBveL7lypJShSnK+Tk6RdB+NN8/zJnYZ4QU+aC9BCS7/BpH7
	nUeDo7oFjUD3W3y+o9GYJOvmDdRzYHeyoOBFLDnCRepDjzmgaqMgz7pQbLFebNIGQxBEABdtigm
	xZ5Rs0Dg==
X-Received: by 2002:a05:6512:1288:b0:5bf:d738:a5a9 with SMTP id
 2adb3069b0e04-5c00b7795bemr29056e87.22.1793998860435; Fri, 06 Nov 2026
 13:01:00 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <ca90b945049ac3c27f3e1d9b8181137feb892436.camel@kjb.biglobe.ne.jp>
 <2026110611-tassel-bubble-dc09@gregkh> <1cd0f5e304584ab9d0a595a5d35b5649dc232fb2.camel@kjb.biglobe.ne.jp>
In-Reply-To: <1cd0f5e304584ab9d0a595a5d35b5649dc232fb2.camel@kjb.biglobe.ne.jp>
From: Boris Lukashev <blukashev@sempervictus.com>
Date: Fri, 6 Nov 2026 16:00:48 -0500
X-Gm-Features: AclHuK_heHrklKnEI4z27iy0J7Ra6Hm6bWcmPtZ63Iq5LbsBiMbNZ5H0kG20a5s
Message-ID: <CAFUG7CciO_ZUMdjcOCfOtoi+YEni2+a-9QkcsCj1nox0NqHj0A@mail.gmail.com>
Subject: Re: [RFC idea] Kernel API Firewall (kaf): subsystem-level attack
 surface reduction for the post-AI-CVE era
To: Nakashima Seiichi <s-nakashima@kjb.biglobe.ne.jp>
Cc: Greg KH <gregkh@linuxfoundation.org>, kernel-hardening@lists.openwall.com, 
	mic@digikod.net, paul@paul-moore.com
Content-Type: multipart/alternative; boundary="000000000000cdd324065fa1e85c"
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--000000000000cdd324065fa1e85c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

@Nakashima Seiichi: To be fair it's actually "pick a better kernel" such as
one with a security model starting at the execution and MMU layers since
the fundamental problem with doing this at higher-levels comes down to
mutable, type-confused, and improperly accessible memory (on-stack or via
alloc) atop which the rest of what you describe has to be built. Castles
built on sand with the added twist of ML tech adding grandfather worms
straight from Dune.

@Greg KH:  there is no practical choice for using anything but what's
prescribed by the vendor and contractually supported in the commercial
world (further complicated by binary blobs/device trees/intellectual
property concerns/etc). You cant ask the hotel to change the kiosk
distribution to a safer one in order to check you in despite them having
your PII and payment data running through it any more than the rest of us
despite your undeniable awareness of the threat involved. It would be far
more realistic and practical for the Linux Foundation to assign its
seasoned talent to work on downstream distributions of economic relevance
to its member entities than to swap out the OS' in the clustered engine of
today's economy.

-Boris

On Fri, Nov 6, 2026 at 2:07=E2=80=AFPM Nakashima Seiichi <
s-nakashima@kjb.biglobe.ne.jp> wrote:

>
> >
> > Pick a better distro.  Seriously, if the distro you are paying for
> > isn't
> > keeping it up to date and secure, what are you paying them for?
> > Seems
> > like an odd choice to stick with them given you have a contract
> > saying
> > they need to abide by it...
> >
> > good luck!
> >
> > greg k-h
>
>
> Thank you for your comment. Given the high volume of vulnerability-
> related issues lately, I simply shared some ideas in the hope that they
> might help with improvements.
>


--=20
Boris Lukashev
Systems Architect
Semper Victus <https://www.sempervictus.com>

--000000000000cdd324065fa1e85c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>@Nakashima Seiichi: To be fair it&#39;s actually &quo=
t;pick a better kernel&quot; such as one with a security model starting at =
the execution and MMU layers since the fundamental problem with doing this =
at higher-levels comes down to mutable, type-confused, and improperly acces=
sible memory (on-stack or via alloc) atop which the rest of what you descri=
be has to be built. Castles built on sand with the added twist of ML tech a=
dding grandfather worms straight from Dune.</div><div><br></div><div>@Greg =
KH:=C2=A0 there is no practical choice for using anything but what&#39;s pr=
escribed by the vendor and contractually supported in the commercial world =
(further complicated by binary blobs/device trees/intellectual property con=
cerns/etc). You cant ask the hotel to change the kiosk distribution to a sa=
fer one in order to check you in despite them having your PII and payment d=
ata running through it any more than the rest of us despite your undeniable=
 awareness of the threat involved. It would be far more realistic and pract=
ical for the Linux Foundation to assign its seasoned talent to work on down=
stream distributions of economic relevance to its member entities than to s=
wap out the OS&#39; in the clustered engine of today&#39;s economy.</div><d=
iv><br></div><div>-Boris</div></div><br><div class=3D"gmail_quote gmail_quo=
te_container"><div dir=3D"ltr" class=3D"gmail_attr">On Fri, Nov 6, 2026 at =
2:07=E2=80=AFPM Nakashima Seiichi &lt;<a href=3D"mailto:s-nakashima@kjb.big=
lobe.ne.jp">s-nakashima@kjb.biglobe.ne.jp</a>&gt; wrote:<br></div><blockquo=
te class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px =
solid rgb(204,204,204);padding-left:1ex"><br>
&gt; <br>
&gt; Pick a better distro.=C2=A0 Seriously, if the distro you are paying fo=
r<br>
&gt; isn&#39;t<br>
&gt; keeping it up to date and secure, what are you paying them for?=C2=A0<=
br>
&gt; Seems<br>
&gt; like an odd choice to stick with them given you have a contract<br>
&gt; saying<br>
&gt; they need to abide by it...<br>
&gt; <br>
&gt; good luck!<br>
&gt; <br>
&gt; greg k-h<br>
<br>
<br>
Thank you for your comment. Given the high volume of vulnerability-<br>
related issues lately, I simply shared some ideas in the hope that they<br>
might help with improvements.<br>
</blockquote></div><div><br clear=3D"all"></div><br><span class=3D"gmail_si=
gnature_prefix">-- </span><br><div dir=3D"ltr" class=3D"gmail_signature"><d=
iv dir=3D"ltr"><div><div dir=3D"ltr"><div><div dir=3D"ltr">Boris Lukashev<b=
r>Systems Architect<br><a href=3D"https://www.sempervictus.com" target=3D"_=
blank">Semper Victus</a><br></div></div></div></div></div></div>

--000000000000cdd324065fa1e85c--
