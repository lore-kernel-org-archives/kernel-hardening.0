Return-Path: <SRS0=O/cH=HD=lists.openwall.com=kernel-hardening-return-20714-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84190C433DB
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Feb 2021 18:32:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9D0BB64EA1
	for <kernel-hardening@archiver.kernel.org>; Mon,  1 Feb 2021 18:32:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D0BB64EA1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20714-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11675 invoked by uid 550); 1 Feb 2021 18:32:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11640 invoked from network); 1 Feb 2021 18:32:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1612204343; bh=GiZSgrTso7q1iR9ru6kPcZNU9A7ytMv138ZCLDU6r7g=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=Df70SYfVEWYcWkUQAn9oArG9tBiDr+6pr+fQnSw/NXGqLj5ZaFNw996RbzHLkErn2H1sY07tUINZj4E2WUbfvIJQPsOhbsMQG6B4kXaPxY0ByxO6F+jx33bAcvJJqBEn56r6zx5zbWHvbXrhQ+5ZXgBRYqM2mf02P4ImblpMguXYdYoslffOWzhyaDbx4rCrQYIK8riqQpvMT28FLrA2xp9GVs65dYMtDfxh4J85SoaCkSFnOBzcoC+nybtMF6vWGtBPjgvQRSVOhLVQX/365yfeG67PwIzRQ+jjwAdp3E7lLUn92y2MzbZWfAy9RDcs99Gzz/A3kZQu+Kf9jzxFdw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1612204343; bh=BPkNZZR5IYrrymoUJpJXkSwjLiL2JY8MM5AWZgEu9SG=; h=Subject:To:From:Date:From:Subject:Reply-To; b=qEg4qqmsVzvz6rFqVxVo4hu+9/6Xh6haWbmiL9l/DS8GTods8Nh4aIY1b0cYiBjJouQO1MY4YjcgvSRB5u7uzyhuKZChUUXGmy7QQEfO/H6XlGumt0Vsd7QbJfigP6cuXJLVlcXsjGIm7HaIvExBxZJJh+R5aW024iTH7IhDq37VtkcPJ2Pgku/1NEJFMdsSW+D3ES5X5HuBB3cUAwZow2aN64lq7ZucnrheEyNtnsgYeGkb9Tm0AY3aROn5dpBRFyqPEP2J1CSKyrtJ8z+rbm5EXwW8myIB+1JFQDNE0vhYjmyZq7b9Up1va9rHSDlCPP/xqNMGEA1Kbd3ngHq4tA==
X-YMail-OSG: BbV2v.oVM1nnVL6uBUatMqciJnvKNYkpfcdpqZoFOx8wxur_b9O9egUuNTvmwPw
 RVA8qh6HKMQHBenoBVGKRgg7ZH7a_DsDNl579LqnsDeC6U6Hihued336DLxwSbzq28mPHOYYNFc_
 M_K0EnslQx7ne6_UiRDAQI1cZoL9gdQ5ACnjzQVAuInXsmxcX1cTOWcCQbeK2rRtPfZeeazKYvL8
 Ne6Tc5ukBg6YsmGGr_p27PNnPkGsKCd..eJchXzR3JSw6SrDHXtOflP4Z94U5Bej1M4Vfo21WXrA
 YvWqNdcww33K_KAfzmRjQRJp_uTyMhE9YCxcohlz8UvCyhYDXePLX4x7lDcsKoU2oYoa1HjPktbw
 GshaEXiMS3eKf6dm0azhBG8tJ9.Om44BtbzYVisdQf67E1dFCRsijCcWI51SJKUJhv66cyhETx3u
 vNUrOjI0xE4vTMey39sz88G4StVT_P7dn1WsZjCcxxV60wz6Wv6G0Xs01fSKPGIp7sR3_CcI48pn
 Rg2Eb8Akc_Q.02ObvnCFofUUvK.fPR0Gpr5swaWyjNEtJkyA2N1fExBvH8c4xV1rwpKJh3bs5luQ
 ViTN1Ru5dGffqEDyMatimTHWgbmGSsrJdLAwACzK5buATzA87Ibmb024XKbZ4U8tOu3dOmx8PW2V
 QTnAakyo7e4zWrftd3DtLe6LCvoPNGPm1WY2qCjx.WHY737z94E81Qsgjm71r5dZ3H2QZorFxeZT
 dAVKHECqVCu4m6BoTfjkS5mM7iz3JW9bD8Hm2cXH6b3i10TfmsozlJq_.nRBy.OSgeaEd24cIeU8
 Jsts8oxU.MULCBgmqQazqLP4R8H2wcPYkPGvNyjcmmd67wT_oy2OVaKF.3j73qASeBu0rENhcM_l
 a7ap3Eb.YW52gVPyj.52q52QH2RamoEmJMWhDmsJfukanGB5qCnBdcL0eYmU7h.sxXxOL6SeZm.D
 Cqoeuroy4o7na9k98DPEyiQEL1e6OW_qbxtaQMMMm4Edx6Q7FQkuerCM9JaqIEb4xDQIkUn0agr8
 2c5iZmCLJH1knSK5b73Zuw8U30Eo7usVwivYgyemHeAzZNIFw1BfLxS0_PJg_T2n2cZc8YhHKGBj
 GO1OEA94RsPufNry6qY27JmU3ONy0dSu.ihO61sXXRY1lM8p8iEjiUcg6S1IiHQKkb7JXQoAzPmm
 3ocu0k4ZULQ5jXR679cnEzJ8HzreX.PiLIVebj55W3Mnx6.5bR.Z9rXsmIbAUkNNk.qyV5qAzxNt
 MAjTVuA.9OETb.cS1O5wSrgB7P4Y7Qwfbi.cqyeb7pbU4iDvI5TRyms9SeXh1gbtWNfR2GzULhV9
 NkeIiuktUVdM47L9IPzWS2jB0N9zcVUEf.nqNb1yPZ4rL6xKoNiDhoh3iKGQBmP_0UvKjgsQOBzP
 KDrWRT69ZKj410wAaMq1I3n0fRVCF.SZ1LlEtHU8YeD.i3XyoNV0.nDcXQcbOgYsMYnsVQ1G04LA
 QzhWdW1coEc_Mgaz5iOChuwk3JdJ8M2hC7lXDEkKzDSQQUvMY6CGWs.hDptJBFozpk24RPDXLHd1
 MOCvOk5OAtG3BstYEpjQFI7PT.ou2PWX7_YORQHgKdl3jqALCANiB6bVLDhEgE97ZhBjj3asHmwB
 ph22gDXsF9wcbze1iY476Yb_BK9PVv8ANaflNhnlnR.THGBySo6pDVLMKoLSjoqrQ1bR1GI.a_40
 GcFJkzyS1gOykf8RCWA8DWczNSYEANPPUMPGBwLG4r3qlxIh.kQfdtaC1Rpl0nbFk6SveVqe1RVn
 MAnbbMGuHoNTONDy0jXAhxdz3pQ2zhITE5IbPSxfHV_4IOgenEJsT7g7araWG3.aiH61.a5b0nxz
 jKcPU7iYC5rKN3vdzfRSMTBr93nzhxjLLCl.5cBiFT9eIlOz1VuDBTugRUVo.m63oHT5WQaeG1F9
 rHpIkK_KsLTc4uxqujvjvnTzBBt0CCU0Qx9h614Pl3i3mWT2UKAT5LWfU4bECBnZlqYOk0ihlpjn
 8VGJRZTclXPO19r8ZuyFCvtxv3Meko2olBIH01ZZR8pPqSBU9vy6W_9KnQ1HiSLsiurL6s9kP097
 t9jBHCWpA76kU9G66Yh76e14m180njCM9rULQPOWuYBSOA5rID0ACrCBgzztIj1FzmFvvcgb2qfb
 9oEtK2R9XfRrYE9ajh71aIjHYvba2eDMVVLeNsLcyRSNeyD1wcK6xBfDMqOIW7NXiGG9HhmD.Cms
 TkZoxTcRKRgbrfdDICBSTLc5ot8Ko0TI6AjPZU83z.yxxJS2sfdnhS_vsGQsZgbUBiBMEBlQb4TC
 A5uZ9lYpxfDO8qHvmBE46Wy55KR5.rRdX3310EmzzBQc48CsVDjLgAi72WYjF3OBJM4RD4gvkgyy
 3DU444q1SipTrlGxajS4906SXWN0LgXIhWG7c8TW1eR2xPSJDEn7.wCLCqasMa9LD_XYOldgAkRD
 zyxLFK6lZ36LeSj8Pifat1h1vzd2TGbiZ_p_9NRVcxuykzbu8j7v.Y7JhhP1dStXUKOKi09ZETJt
 G0SymRSdfTK7XjK8t8QRqzrNrBNRBAGb1p9ZZ1.qfwcSzde4g7xLlOMxTuIP_szWLRWTC711ndT_
 NNOmcHgdp63oAZHozpYBX21Yt0xmPyf9Q7gw7E5vw1VSiAB0PS.kEtjrWKC6_yejYEsFEJLtVkrQ
 cYvFjlpGnaS_UndmnIdJwGKNNGvwjZVEpqEHBurYwLlkr6VQnVm_D.MIDVgLBcZ7ViexSq1OJ4Py
 ueQ--
Subject: Re: forkat(int pidfd), execveat(int pidfd), other awful things?
To: "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Jann Horn <jann@thejh.net>,
 Christian Brauner <christian.brauner@canonical.com>
References: <CAHmME9oHBtR4fBBUY8E_Oi7av-=OjOGkSNhQuMJMHhafCjazBw@mail.gmail.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <9bb2406f-c293-9442-a0b9-c587f69f6ae1@schaufler-ca.com>
Date: Mon, 1 Feb 2021 10:32:17 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAHmME9oHBtR4fBBUY8E_Oi7av-=OjOGkSNhQuMJMHhafCjazBw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.17648 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo Apache-HttpAsyncClient/4.1.4 (Java/11.0.8)

On 2/1/2021 9:47 AM, Jason A. Donenfeld wrote:
> Hi Andy & others,
>
> I was reversing some NT stuff recently and marveling over how wild and
> crazy things are over in Windows-land. A few things related to process
> creation caught my interest:
>
> - It's possible to create a new process with an *arbitrary parent
> process*, which means it'll then inherit various things like handles
> and security attributes and tokens from that new parent process.
>
> - It's possible to create a new process with the memory space handle
> of a different process. Consider this on Linux, and you have some
> abomination like `forkat(int pidfd)`.
>
> The big question is "why!?" At first I was just amused by its presence
> in NT. Everything is an object and you can usually freely mix and
> match things, and it's very flexible, which is cool. But this is NT,
> not Linux.
>
> Jann and I were discussing, though, that maybe some variant of these
> features might be useful to get rid of setuid executables. Imagine
> something like `systemd-sudod`, forked off of PID 1 very early.
> Subsequently all new processes on the system run with
> PR_SET_NO_NEW_PRIVS or similar policies to prevent non-root->root
> transition. Then, if you want to transition, you ask systemd-sudod (or
> polkitd, or whatever else you have in mind) to make you a new process,
> and it then does the various policy checks, and executes a new process
> for you as the parent of the requesting process.
>
> So how would that work? Well, executing processes with arbitrary
> parents would be part of it, as above. But we'd probably want to more
> carefully control that new process. Which chroot is it in? How do
> cgroups work? And so on. And ultimately this design leads to something
> like ZwCreateProcess, where you have several arguments, each to a
> handle to some part of the new process state, or null to be inherited
> from its parent.
>
> int execve_parent(int parent_pidfd, int root_dirfd, int cgroup_fd, int
> namespace_fd, const char *pathname, char *const argv[], char *const
> envp[]);
>
> One could imagine this growing pretty unwieldy. There's also this
> other design aspect of Linux that's worth considering. Namespaces and
> other process-inherited resources are generally hierarchical, with
> children getting the resource from their parent. This makes sense and
> is simple to conceptualize. Everytime we add a new thing_fd as a
> pointer to one of these resources, and allow it to be used outside of
> that hierarchy, it introduces a kind of "escape hatch". That might be
> considered "bad design" by some; it might not be by others. Seen this
> way, NT is one massive escape hatch, with pretty much everything being
> an object with a handle.
>
> But! Maybe this is nonetheless an interesting design avenue to
> explore. The introduction of pidfd is sort of just the "beginning" of
> that kind of design.
>
> Is any of this interesting to you as a future of privilege escalation
> and management on Linux?

TL;DR - We have plenty of flayed cats.

My brief analysis of your proposal doesn't lead me to think
that there's anything you couldn't already do with systemd and
an application launcher. We already have a bunch of security
mechanisms and behaviors that the masses have decided are too
complicated or dangerous to use. And some that *are* too
complicated or dangerous to use. I wouldn't see these mechanisms
as "hardening" the kernel. I would see them as complicating
what passes for the Linux security policy.

>
> Jason

