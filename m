Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 92BC9606A32D
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Nov 2026 15:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=paul-moore.com header.i=@paul-moore.com header.a=rsa-sha256 header.s=google header.b=RQBO5ltN
Received: (qmail 27690 invoked by uid 550); 6 Nov 2026 15:13:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26612 invoked from network); 6 Nov 2026 15:13:32 -0000
ARC-Seal: i=1; a=rsa-sha256; t=1793978002; cv=none;
        d=google.com; s=arc-20260327;
        b=HiQLwSVA2Y/Y3w2M/7PWcLnXpMzpvDOGl6dBWxZ3TygweIQ5Z47N1zk9XtQECWZP98
         zVaXIvhWWE92atxXCDGEvWWE2FvLt/5Sm/A++Z8h7K4HgT7WuY2kXfS7n/xL5H7/dnCB
         KUV2mMubuF00q/fI0IPnu2LlqbqscwLGaJ276zOqrM6Yo/jxOltPMSKWBLJ3I2B7k7ox
         VAOXOi4aXNn2GKchx6nw+z9ffX7wynLKL9k85PoEGR0LNBxR/j5Az2zB8DVJlOIeLby7
         yIahSJ5lrA+MWaVIiSoqcu/wRr1/wQoKPG/mzU/y5XpeOLozmdjS9IGgKZwcBJ1zWy/p
         S/Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XBmSnRChClP6iNYWaXtFsz94mV4OC9GOlfJtmgX0gdU=;
        fh=TIDcaR0jxsDmfnhjG830Rp99MX37jSBRxecfjXW9nUQ=;
        b=IDjiZR3UN+FtEmk07dm+DprSM6dt2J7/7biFZ42q/oaiK4lEU7MzB8mbNDnaUteyQy
         LyOpzuMQPeAOWqPvGCxnFg4kbOmhhI0h8jq94pT7UQUkh/tfeIiR7BXUtNDDA2EyYVpG
         YvtoHy0al52+uXj0ExA3DIi4eopE9YOFZdnSbjDIS0N+7FAim+xf8/nk9gX559qgtG4k
         Khu2hlPyvKHuI3TXJFNiL68NZuAdjAgGRNWNSA+px/ZOr3UOB2jssqm/moWbkyd6F05k
         ohoMLGLVJKJunvRyvirMwQwcXyojTM0OeV2GhOOr2+zi7EkZIY9k05Y95FNQwhu70xUn
         fr0g==;
        darn=lists.openwall.com
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1793978002; x=1794582802; darn=lists.openwall.com;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XBmSnRChClP6iNYWaXtFsz94mV4OC9GOlfJtmgX0gdU=;
        b=RQBO5ltN+6JfI6bVC8Yi0z5mzu4WIP+XwrWJwKG0rDVbzsLTwD7sNxs1qnsXBENPv9
         Ti5BvqJZaMeggv5G+qXcJuU8tRgP1t2XB1eARMbQEGGt/1Ak9nqsfYzG+pv3hCYwbuZS
         8JV2bRj+s0sDnG7CRywVM85i5w/edbhIA4al82tZZswnR0iyXxY9k7OrO+a63DG7UDBC
         d+n2UXN2SHxtcee873x2Y9GUF9brNkc9lAThaM6n6jU73Bq1M2VuorTierFLM5/PVuVj
         JRusqtcASt39A1ESSB3WKBxMvuz8HADEMoe/5FoErkfUl2pIUZ7IKtd/qBq2LVs2W3g/
         7lSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793978002; x=1794582802;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XBmSnRChClP6iNYWaXtFsz94mV4OC9GOlfJtmgX0gdU=;
        b=IIU6aOxSrBRE+kdkvFA/Wz6geK7+b1GksSWj9iSdkfUWGt6UKp6zz3FOEY05SR+syg
         67aok7fEIvi6B19pZQADEHeWRHTMPw+a3qPcrx2a7Lngv89m2b9aLzJhQE7sWQ/1LnZ4
         JDL8qpCRj9T7YyGNbc+FqkgwJedI8Q58b3eKSv6sMUg2KG57+MTsMDgK4p9ssAYxRqRx
         UH5VJMPejaLtSLYBeZEvlEZJmdpdBM00jUt2frROBqjDPwxO9pcNjhrh3Uz351saa1my
         4Dyot0qnXBGcC+PetxO+RWkN7UEVFDAtfx6dwu+VYzwryS/wuntj6nXEG09MUT8RljRh
         9EbA==
X-Gm-Message-State: APuU4Z8XDQAsv1c2WFZDvPYLATcjuMnfLYbAV6vx2SuULAtuUry+8edh
	JutkdCbVxuTKDMPNPVk5qIBlzCj0kX5s7gfTzInsZdQvdjqLN87zLl5Vu39Fl2+vfHpbVhd7e6U
	0BnKprSALobRUvBjghert1rHMpPF/sN68F5fuE13I
X-Gm-Gg: AYBFou364+8uWUNuQFap9Hxfq0+jI4MIhxVC44sYEHHOu2tW5/FMUr/pQWZg0Uf365k
	siRWNbLho69LIvby70CW15VgdpWJkGUBOAcafVvPFIzdYdiO3Y/YFUfScgBdYfT59FWPk9mr/dl
	FO/CiSITZLW6xt2xGuERd9N3crMZ5frAffGx4acGp7ZOncotAi1QeG/BGzqq/n2KLBaPEZLR4GK
	LLW6z96fpM011oPsgszI1imDnfMW+jCw9tcvEYfkfi+SHa/ZRRV1dxyaQ6d/Y0271dO1W9v4l4Z
	QYv/Z2hErlOi3/FMwQE3VIfWyD++fRQXP3nMt48FYGr1kDIC2A0pR84OJGRoYiByyMkwyLfZxJj
	aJAi/mHlX/26lYBKsUVAE4nw4b6NcF89rUQgERuKr6td+4/Tc2sWH4Z62eg5/692e/3fM
X-Received: by 2002:a17:902:ea11:b0:2e9:5e06:3345 with SMTP id
 d9443c01a7336-2ed23e5428cmr47695025ad.2.1793978002129; Fri, 06 Nov 2026
 07:13:22 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <ca90b945049ac3c27f3e1d9b8181137feb892436.camel@kjb.biglobe.ne.jp>
In-Reply-To: <ca90b945049ac3c27f3e1d9b8181137feb892436.camel@kjb.biglobe.ne.jp>
From: Paul Moore <paul@paul-moore.com>
Date: Fri, 6 Nov 2026 10:13:10 -0500
X-Gm-Features: AclHuK-tlApNDEP2ZzEdt9Zr-7HOMsS-EkDGhCGPsqM9Fwqn-JDsHX-3WkpyEKQ
Message-ID: <CAHC9VhTB-obhgEM3g0VagzNaRUaF_tWTDu1FmX7SHeVU4pwfOA@mail.gmail.com>
Subject: Re: [RFC idea] Kernel API Firewall (kaf): subsystem-level attack
 surface reduction for the post-AI-CVE era
To: Nakashima Seiichi <s-nakashima@kjb.biglobe.ne.jp>
Cc: kernel-hardening@lists.openwall.com, keescook@kernel.org, mic@digikod.net, 
	linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 6:15=E2=80=AFAM Nakashima Seiichi
<s-nakashima@kjb.biglobe.ne.jp> wrote:
>
> Hi,
>
> This is an idea I've been thinking about as a Linux user
> who has seen the CVE flood firsthand.
> I don't have the kernel development skills to implement this,
> so I'm posting it here for feedback from people who do.
>
> (This RFC was drafted with the help of Sakana AI's Namazu assistant.)

...

> 2. The idea: Kernel API Firewall (kaf)
>
> Instead of whack-a-mole with individual CVEs, restrict the *classes* of
> kernel APIs that unprivileged processes can invoke.
>
> Key insight: many kernel CVEs require specific subsystems to be
> reachable.
> If we can restrict access to dangerous kernel APIs at runtime, we can
> mitigate entire vulnerability classes without waiting for patches.
>
> 3. What kaf would look like
>
> Not syscall-level filtering (seccomp already does that). Subsystem-
> level
> semantic restrictions:
>
> - bpf: disallow BPF_PROG_LOAD for unprivileged users entirely
> - module: disallow init_module/finit_module after early boot
> - kexec: always forbidden for non-root, even with CAP_SYS_BOOT
> - ptrace: restrict to same UID or explicit allowlist
> - userfaultfd: disable by default (historical exploitation vector)
> - perf_event_open: restrict to specific events, disable hardware PMC
> - io_uring: restrict ring size, disable specific opcodes
> - namespace: restrict unshare of specific namespaces
>
> These are semantic restrictions on kernel subsystems that multiple
> syscalls may touch -- not individual syscall filters.

It should be possible to do most, if not all, of these things with an
LSM.  Wearing my SELinux hat, I can say that SELinux currently
provides access controls for most of these things today.  I would
expect similar capabilities with the BPF LSM, although I can't speak
to the coverage of any specific BPF LSM tools.  I believe AppArmor and
Smack cover some of these things, but I can't say for certain.

--=20
paul-moore.com
