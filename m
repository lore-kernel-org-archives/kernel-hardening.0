Return-Path: <SRS0=Fd24=I3=lists.openwall.com=kernel-hardening-return-21074-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C246C433DB
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Mar 2021 07:27:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B1BFD60232
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Mar 2021 07:27:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1BFD60232
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21074-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9492 invoked by uid 550); 29 Mar 2021 07:27:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9460 invoked from network); 29 Mar 2021 07:27:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=ckpsHoDKgFngCLUfM87BDYrlW7qCOOTH9Due5aEVXPo=;
        b=Vnxn6EHQar4YIaAkLoMjZhXhcDPeBtaf0y4daCiotSFIytvye/mjVEotB6pgCZ2Don
         wYeIANOo1CnnBkjcbv79FZLALLtZvK893RkfnA6W1mMYZTbI5w5QJMVT2VD6phmjaE+e
         wBL+iqjtCzBhkNEfLAtaUgdIMYDgYM96M3ob/ojVZRrIUnZf5+w3hfSbSKH8YBFaJi9V
         TZEJcIwDp4oLm3la4yWVzpxdCtPzBXpa7UDucSCoJbhC2PlviELDA9jyQWPxOo429u6G
         GFKr4nPzONt++XxkzKTsC3Ri9MlkTC82SLBqeyBe7j/GINPPbbR5KACnf77BUq+doxVw
         gKGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ckpsHoDKgFngCLUfM87BDYrlW7qCOOTH9Due5aEVXPo=;
        b=bgApQCgO2qHGAotfEDxCNqyklA9cAbNpYZ2KMPGdc4f/HUxXNHc7jsXlU5KISWG2/E
         hbj3HwhUWi9kxw6Vz+kFUM0fTjGRM4iMUMAMCVLyES6urZ4Ian9g178lBVqkvHaAFQ8R
         IZx9fFMulu9vD7Lc5dpXtcf8WG3F26acIBDCffIGOa6IIdhGygaonBBAO2EdmllQ6iou
         jtrqZpZPJ+VBvt7SDo/Y2qduIBHWg3FY/fVq7VRSLXcLj0Dt4S6Mp7l8zsPg1Ar0Vggf
         MNOOK9ZRiEJMla9UD5713QwOM+LH6bA1fWOabTTSstxqL8xXK0aKVc51Oj/57tExbxu5
         tURA==
X-Gm-Message-State: AOAM5302w4le7NMhzFsI0AyUlzTxOHVFpv8z1ZAb88UofYdTWcx6KcWY
	QBb0H2aUC/hwqxl+I9P4j2dAmE9rOTukKlvfW/fK43qYIMmlQQ==
X-Google-Smtp-Source: ABdhPJzF9iBqVROLAJDnHPMAMwLdweU59YTp7KCAIkg5WqG521YUt8+Dsj2dB0j9FRWpM/ciWDrl/vp4QG/Pr8taip4=
X-Received: by 2002:a2e:9a98:: with SMTP id p24mr17160839lji.86.1617002822619;
 Mon, 29 Mar 2021 00:27:02 -0700 (PDT)
MIME-Version: 1.0
From: Jann Horn <jannh@google.com>
Date: Mon, 29 Mar 2021 09:26:35 +0200
Message-ID: <CAG48ez1Mr1FNCDGFscVg0SpuuA_Z4tn=WJhEqJVWW1rOuRiG2w@mail.gmail.com>
Subject: two potential randstruct improvements
To: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kees Cook <keescook@chromium.org>, 
	Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>
Content-Type: text/plain; charset="UTF-8"

Hi!

I'm currently in the middle of writing a blogpost on some Linux kernel
stuff; while working on that I looked at the randstruct version in
Linus' tree a bit and noticed two potential areas for improvement. I
have no idea whether any of this (still) applies to the PaX/grsecurity
version, but since the code originates from there, I figured I should
also send this to the original authors.


=== no explicit randomization of padding holes ===
The randstruct plugin works by shuffling the list of C struct members.
So if you have a struct like this:

struct foo { u32 a; /*4-byte hole*/ u64 b; u64 c; };

randstruct might rearrange it into one of the following layouts:

struct foo { u32 a; /*4-byte hole*/ u64 b; u64 c; };
struct foo { u32 a; /*4-byte hole*/ u64 c; u64 b; };
struct foo { u64 b; u32 a; /*4-byte hole*/ u64 c; };
struct foo { u64 b; u64 c; u32 a; /*4-byte hole*/ };
struct foo { u64 c; u32 a; /*4-byte hole*/ u64 b; };
struct foo { u64 c; u64 b; u32 a; /*4-byte hole*/ };

So if there is only a single 4-byte member among multiple 8-byte
members, the 4-byte member "a" will still always be 8-byte aligned;
and if there is a small number of 4-byte members among lots of 8-byte
members, it'll probably still end up that way. This means that if an
attacker e.g. manages to type-confuse "struct foo" and an array of
pointers on a little-endian system, they'll be able to use arithmetic
operations on "a" to shift one of the pointers in "a" up and down.
This wouldn't be possible if, after the existing randomization, struct
members with following padding holes were explicitly randomized with
regard to the padding (subject to alignment constraints, of course).
(In practice I guess that might be implemented in the existing
randstruct plugin by computing padding holes after elements and then
randomly inserting dummy members in front of those members, with
dummy_size%member_alignment==0 and dummy_size<=padding_size.)

(Yes, I realize that this becomes less interesting if you have a
different mitigation that makes type confusion between single-struct
allocations and arrays harder.)


=== non-cryptographic RNG used for randomization ===
I haven't looked at this in detail; but randstruct uses a
non-cryptographic RNG
(http://burtleburtle.net/bob/rand/smallprng.html) to derive randomized
structs from a 256-bit seed. In theory, this means that an attacker
with knowledge of at least 256 bits worth of information about
structure layouts in a given build _may_ be able to recover the seed,
and from there, the layouts of all other structs.

It might be possible to indirectly determine some amount of
information on structure layouts through various side channels; for
example:

 - cacheline grouping might change if performance-mode is disabled,
   which might be measurable through false sharing effects
 - function sizes might change slightly because the encoding of an access
   to the first element is shorter, which might be measurable e.g. through
   icache and branch predictor state

I don't know whether the amount of information leakage would be enough
to actually determine the seed - and I'm not a cryptographer, I have
no clue how much output from the RNG you'd actually need to recover
the seed (and an attacker would not even be getting raw RNG output,
but RNG output after additional modulo operations). But if the goal
here is to ensure that an attacker without access to the binary kernel
image can't determine struct layouts without a proper leak primitive,
even if they know exactly from which sources and with what
configuration the kernel was built, then I think this needs a
cryptographically secure RNG.
