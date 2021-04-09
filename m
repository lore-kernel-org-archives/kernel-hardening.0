Return-Path: <SRS0=hbm7=JG=lists.openwall.com=kernel-hardening-return-21187-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33125C433B4
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Apr 2021 16:08:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 11763600D4
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Apr 2021 16:08:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11763600D4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21187-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29739 invoked by uid 550); 9 Apr 2021 16:08:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29707 invoked from network); 9 Apr 2021 16:08:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1617984506;
	bh=HEzSNgADWM4JdH/UP4RWxfXteS7uGjPvcCoUhETis/w=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TMp7qmyOTZ06xZtd3IkwSP3IInsseEcEgh3JgzcGx4qzd7o1uncrGzYdEvgq3C4gr
	 ZeNAoaODnWiuEHh0wNKdPbc50soCpSvVH5eWBOnn4/+2KbADchHCCp9XPQXKz03Qjo
	 IxL72Qyu0QN3YHxTfKAb+TGUGDug2AIXg2tmFXN0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Fri, 9 Apr 2021 18:08:14 +0200
From: John Wood <john.wood@gmx.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: John Wood <john.wood@gmx.com>,
	Valdis =?utf-8?Q?Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
	kernelnewbies@kernelnewbies.org, Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com
Subject: Re: Notify special task kill using wait* functions
Message-ID: <20210409160814.GA4937@ubuntu>
References: <145687.1617485641@turing-police>
 <20210404094837.GA3263@ubuntu>
 <193167.1617570625@turing-police>
 <20210405073147.GA3053@ubuntu>
 <115437.1617753336@turing-police>
 <20210407175151.GA3301@ubuntu>
 <184666.1617827926@turing-police>
 <20210408015148.GB3762101@tassilo.jf.intel.com>
 <20210409142933.GA3150@ubuntu>
 <20210409150621.GJ3762101@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409150621.GJ3762101@tassilo.jf.intel.com>
X-Provags-ID: V03:K1:IsLAyPnMEKrzZmnegL9MyBRHawdUyxil//3hcCrquCaKFVNVr0o
 g0p6Jc7cmZTcu5XqE+R8rFrnselUZm4OY3Ky5j/XxQcaJHWZUDPhYP6OIyAS4HH31LN/Uxx
 +TP1OGTLcIBB/VSUjq5h0tC7MSC7eR5Z+gvUicuIghTDCn3aZcYsXHHY7nV6GeUYPkVwu5W
 gNDsv+QhpRI0FOeZP8Bsw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:w/ghK7fOuso=:HM2XrcA+UBAA6skFfEdrJf
 qH8ZitfDacjhM9eBr22yNOkWWyXGT2XHxoGBXw1KP3RZRQSRx5rKLOU7ZPcRa84pu72onwApT
 XRD4NIs1V848Ixkdg2z7QJvh7x5ECDCLy1m8zmmVX5QufVaYPH1SUCw5RlS2FxxtrMvHqXCsj
 sCeqSn7VUMlA0PQ8JG1Z01g07euXSoqB25fs10z5AZuUZGjO8IB+QTqH//E4zdAlzCxTgx2lR
 5j6fPTgLEhFHBwYc6OWCS4/NZbyJxLa7Zl9jjp0Pon5q1YjM4q1DeDE0/mX3gEb0GBl6zKFdq
 wtM51eCe5hBC9o6MlVwAixQh6+nkaPcSu+O2h5aoM1O/dG7fNj3Vlj8T/Mp9fKYvUbP3cCXAD
 VqykZ5YcxveVf6eKg2xW3aGbmPV5uqgiP0agBBEFMloW7rXyEM7+VzOVrb1WwOXIalaMGVESn
 RmACrhQ4Nem6+2Rq2GZSaG+FmAyo4bGvBzeq36RXaG50EhulLFCbHfzM5qQmD+d1PKYUYetEI
 +BBgyBKvUjt9fuawDPMEDpIDgVKt75cwrGuiWMn9fGDtZIi4vi3cgiMMbb3QI0254ClRgM5X9
 SBjYQqE5J0RMhD3d4MZO7GY88Z+v8te6B6ffP1nTuCcOn/rXTJyTflJxWvHUmMWxxU8X7FxUV
 cNSE41BSpu/Ao2RIYgwdALDXpeoQwPNdOlTi8VZyZ2C1MUQXMzcgyWt8sQxUkH4P79EOo8fGL
 abSSzgAD1Ym7jfIKujzgleneBeah4Y3CTFku4JEAVKNHQPofnjOV0vci/z1wi/rA/8qr+Gcap
 1n3T7dkVLTTk8smDNVU0Byh/3rEnf8s7xQwburuqZAPH6Id11RQHf3yHuYb5U6xTwERyRtJ6N
 TR3M89mOKh6gpYly1lAzrrB+x6D1ycM2W71sjz4FxK13cu3CxhttaS/kM3zawzGKHhwH6IOS1
 C8lEVSg3BYaITasxxMD3Zfp1YiQtFlXJZ5oP/zl7LRk9GEj4Ey24pVOBtQZbvX3yRyFT1gTgJ
 RWKWCVeefVGamp4CpwUdRz7Aq6m5XaOy+FBWoE1CVlhfEbmlBzyzDTOjLodpTvGFVlhUu1Tyy
 IUN9EiJVhTWCgISl8LRR2HAjd70Hi9AJXmC3N5lI6atzbobMQMepoRYN7F1zfzTDPaKb5FHpd
 bl23eqQOUsmWPUWLFIMgNe0E2T4R7JZYV6JoG9+a+LifEeqb4SWesatDkLNcQRcdGn2uA=
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Apr 09, 2021 at 08:06:21AM -0700, Andi Kleen wrote:
> > > Any caching of state is inherently insecure because any caches of li=
mited
> > > size can be always thrashed by a purposeful attacker. I suppose the
> > > only thing that would work is to actually write something to the
> > > executable itself on disk, but of course that doesn't always work ei=
ther.
> >
> > I'm also working on this. In the next version I will try to find a way=
 to
> > prevent brute force attacks through the execve system call with more t=
han
> > one level of forking.
>
> Thanks.
>
> Thinking more about it what I wrote above wasn't quite right. The cache
> would only need to be as big as the number of attackable services/suid
> binaries. Presumably on many production systems that's rather small,
> so a cache (which wouldn't actually be a cache, but a complete database)
> might actually work.

Thanks. I will keep it in mind.

>
> -Andi

Regards,
John Wood
