Return-Path: <SRS0=almQ=I4=lists.openwall.com=kernel-hardening-return-21091-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD15AC433C1
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Mar 2021 21:18:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 09A5F619C7
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Mar 2021 21:18:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 09A5F619C7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21091-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7205 invoked by uid 550); 30 Mar 2021 21:18:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7169 invoked from network); 30 Mar 2021 21:18:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EHZz0CH2PbVVqRv7QJkmrFjtEJPk2k0V6T7UFiDv3pY=;
        b=m5ZWm2C5ye+Gw/PfKvTXS0ZJy2ROSkEYIcy/qaB4jD9ugPVMEzxEguXT6k3N5U7lAt
         woNxovoTLejySpGiX5WR4bTAImGe7paFsUwhtGvII8YvdOcR28l7M471uKkzDdRPwBjI
         xwqc2eyr6FGUK1Rm5RSnkvoDEkL3uUHdf0Cdo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EHZz0CH2PbVVqRv7QJkmrFjtEJPk2k0V6T7UFiDv3pY=;
        b=R/KFpgLG25gM6UuKzsf50FHbJ/LS3wNL/W8yWWN+UP7cixbmULFPT7Q1DsXMAW/rK9
         fLTVxy0fP5WbzozazMWMFVsd4sxqvgmcv8LfUpnskd+s3K3X9hUVkV5qpEloxRMTQ+bA
         8lP3B+pCrqkYjNx1puyN6BR1IIztF8cqZ7Nsqp/2TxZoZkQHVIHGJvMvUFh06JD+QCqe
         anNFs3klQUiyfIMvxTwGipaTwySBYhVs1iR9B0jZeHqqsFHzPfzO4ePI8McXFmVHMvxH
         /SIl09QMWnbCQRqDlbrIJtlz/BzXp/65coxkLcqV6HcabGIPcY15xGNWsOSSm0IUqMdd
         iCGQ==
X-Gm-Message-State: AOAM530nS/jUT6kKhdI/D91vl+Ci85x8hx2i/c7c5i0tm34dz2u1HR+3
	eniwkr36/75o46xE30TQI8LwFA==
X-Google-Smtp-Source: ABdhPJxgbdL2qS8YgyYBZ6kjZ8PmLOutdptDj31H1GjVyBTt3EJl64RTCkDi3jsaGMyZuN+KZBCfng==
X-Received: by 2002:a17:90a:f2d5:: with SMTP id gt21mr257802pjb.197.1617139112859;
        Tue, 30 Mar 2021 14:18:32 -0700 (PDT)
Date: Tue, 30 Mar 2021 14:18:31 -0700
From: Kees Cook <keescook@chromium.org>
To: Jann Horn <jannh@google.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Brad Spengler <spender@grsecurity.net>,
	PaX Team <pageexec@freemail.hu>, linux-hardening@vger.kernel.org
Subject: Re: two potential randstruct improvements
Message-ID: <202103301407.C7E9F9F@keescook>
References: <CAG48ez1Mr1FNCDGFscVg0SpuuA_Z4tn=WJhEqJVWW1rOuRiG2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez1Mr1FNCDGFscVg0SpuuA_Z4tn=WJhEqJVWW1rOuRiG2w@mail.gmail.com>

On Mon, Mar 29, 2021 at 09:26:35AM +0200, Jann Horn wrote:
> Hi!
> 
> I'm currently in the middle of writing a blogpost on some Linux kernel
> stuff; while working on that I looked at the randstruct version in
> Linus' tree a bit and noticed two potential areas for improvement. I
> have no idea whether any of this (still) applies to the PaX/grsecurity
> version, but since the code originates from there, I figured I should
> also send this to the original authors.
> 
> 
> === no explicit randomization of padding holes ===
> The randstruct plugin works by shuffling the list of C struct members.
> So if you have a struct like this:
> 
> struct foo { u32 a; /*4-byte hole*/ u64 b; u64 c; };
> 
> randstruct might rearrange it into one of the following layouts:
> 
> struct foo { u32 a; /*4-byte hole*/ u64 b; u64 c; };
> struct foo { u32 a; /*4-byte hole*/ u64 c; u64 b; };
> struct foo { u64 b; u32 a; /*4-byte hole*/ u64 c; };
> struct foo { u64 b; u64 c; u32 a; /*4-byte hole*/ };
> struct foo { u64 c; u32 a; /*4-byte hole*/ u64 b; };
> struct foo { u64 c; u64 b; u32 a; /*4-byte hole*/ };
> 
> So if there is only a single 4-byte member among multiple 8-byte
> members, the 4-byte member "a" will still always be 8-byte aligned;
> and if there is a small number of 4-byte members among lots of 8-byte
> members, it'll probably still end up that way. This means that if an
> attacker e.g. manages to type-confuse "struct foo" and an array of
> pointers on a little-endian system, they'll be able to use arithmetic
> operations on "a" to shift one of the pointers in "a" up and down.
> This wouldn't be possible if, after the existing randomization, struct
> members with following padding holes were explicitly randomized with
> regard to the padding (subject to alignment constraints, of course).
> (In practice I guess that might be implemented in the existing
> randstruct plugin by computing padding holes after elements and then
> randomly inserting dummy members in front of those members, with
> dummy_size%member_alignment==0 and dummy_size<=padding_size.)
> 
> (Yes, I realize that this becomes less interesting if you have a
> different mitigation that makes type confusion between single-struct
> allocations and arrays harder.)

Yup, it would be a nice improvement. It would need some work to reorganize
the shuffler, which doesn't have a way to insert fields currently. It
can sort of calculate padding (see partition_struct()), but that likely
needs improvement too.

Patches welcome! I've opened an issue for this:
https://github.com/KSPP/linux/issues/122

> === non-cryptographic RNG used for randomization ===
> I haven't looked at this in detail; but randstruct uses a
> non-cryptographic RNG
> (http://burtleburtle.net/bob/rand/smallprng.html) to derive randomized
> structs from a 256-bit seed. In theory, this means that an attacker
> with knowledge of at least 256 bits worth of information about
> structure layouts in a given build _may_ be able to recover the seed,
> and from there, the layouts of all other structs.
> 
> It might be possible to indirectly determine some amount of
> information on structure layouts through various side channels; for
> example:
> 
>  - cacheline grouping might change if performance-mode is disabled,
>    which might be measurable through false sharing effects
>  - function sizes might change slightly because the encoding of an access
>    to the first element is shorter, which might be measurable e.g. through
>    icache and branch predictor state
> 
> I don't know whether the amount of information leakage would be enough
> to actually determine the seed - and I'm not a cryptographer, I have
> no clue how much output from the RNG you'd actually need to recover
> the seed (and an attacker would not even be getting raw RNG output,
> but RNG output after additional modulo operations). But if the goal
> here is to ensure that an attacker without access to the binary kernel
> image can't determine struct layouts without a proper leak primitive,
> even if they know exactly from which sources and with what
> configuration the kernel was built, then I think this needs a
> cryptographically secure RNG.

Since the RNG runs on every compilation unit on every randomized
structure, any performance hit from swapping the RNG could be large.
That said, folks using randstruct likely don't care. :)

This looks easier to do than the former idea, though. Again, patches
welcome! Issue captured at: https://github.com/KSPP/linux/issues/123

-Kees

-- 
Kees Cook
