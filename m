Return-Path: <SRS0=NhEE=XM=lists.openwall.com=kernel-hardening-return-16892-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E8FCC4CECD
	for <kernel-hardening@archiver.kernel.org>; Tue, 17 Sep 2019 11:06:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ABD6421881
	for <kernel-hardening@archiver.kernel.org>; Tue, 17 Sep 2019 11:06:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="Je08zzCn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ABD6421881
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=axtens.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16892-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 8178 invoked by uid 550); 17 Sep 2019 11:06:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13889 invoked from network); 17 Sep 2019 07:20:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=1b+U1Nzm9O0QA4glqcmO/uZ3v1M7siGCSMhNnLK7FJs=;
        b=Je08zzCnm0q36re4AEp6Lm98FBHaGD/6HQc6Lz3CHLTLdlE7ZRQNwFu706iBexv5Se
         SpoUWWulP3fy8ggO2a+Xi+laO5ygySjsu3oIqFibNbnR7fyOwFX/iXa5BvbfSwODOsA3
         2etUXUaTCkZIIih5GG80xwxdF5vbesZDj7sKs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=1b+U1Nzm9O0QA4glqcmO/uZ3v1M7siGCSMhNnLK7FJs=;
        b=XcxA2MPxQT7xhp4FUj8XoxKwmCFWTC1+y/8VQZXMWWB0y3oyTt2YzLHIcFk9c/Fk64
         pDjTileJX36GmxLymVWFhAgq3w7kX1FsSvfb27kd2MbPTui47c46pET82XQASMWBBNMU
         jB1VPFC68yU3bbYt+6RDEejZaAwZtGgYvAoe5hXD3MfrUA/eBL9aJbk70Ys0Q2NJD3Ke
         jOvalf2By2E4VQ/nBgy8nK0AqCbMQk4jF1rv7CKvwScbH7x/PWSTDERaas1Bg4PnpMGe
         Y5UqS/G49smHxbAKPh7kr/O7ft6nX5ks58BWdNWklAwFfTTbpV3m2XsZi4ezBxWxCpLL
         Q8wQ==
X-Gm-Message-State: APjAAAULZOcoR7GCTdbkD0X5q9RkcYl2wbiE+YggSkwG1uCAPJOTqAQR
	R2/alosxgDLRZ2GeWJoQul/4vg==
X-Google-Smtp-Source: APXvYqy4kjiS5gpcI18fBUp34VEwJV58XddHH7tBOwgSkIm6SPQlr/wW6um4nq2Q5IUwAWuNNG+3ug==
X-Received: by 2002:a63:67c6:: with SMTP id b189mr1994224pgc.163.1568704808022;
        Tue, 17 Sep 2019 00:20:08 -0700 (PDT)
From: Daniel Axtens <dja@axtens.net>
To: "Christopher M. Riedl" <cmr@informatik.wtf>, linuxppc-dev@ozlabs.org, kernel-hardening@lists.openwall.com, Matthew Garrett <mjg59@google.com>
Cc: ajd@linux.ibm.com
Subject: Re: [PATCH v7 0/2] Restrict xmon when kernel is locked down
In-Reply-To: <20190907061124.1947-1-cmr@informatik.wtf>
References: <20190907061124.1947-1-cmr@informatik.wtf>
Date: Tue, 17 Sep 2019 17:20:03 +1000
Message-ID: <87y2yngzj0.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain

Hi,

So Matthew Garrett and I talked about this at Linux Plumbers. Matthew,
if I understood correctly, your concern was that this doesn't sit well
with the existing threat model for lockdown. As I understand it, the
idea is that if you're able to get access to the physical console,
you're already able to get around most restictions by just dropping into
the BIOS/UEFI configuration, disabling secure boot and booting something
of your choice. xmon, being a Linux feature that only operates on the
physical console, therefore falls outside the threat model for lockdown.

I've had a few chats with powerpc people about this, and I think our
consensus is that the boundaries of our threat model are slightly
different. Power machines are almost all server-class*, and therefore the
console is almost always accessed over IPMI or the BMC. As such, we
don't consider console access to be the same as physical access but
instead consider it a form of, or akin to, remote access.

This makes more sense on bare-metal powerpc than it does on x86: we
don't have a boot-time configuration system that's accessible on the
console, so you can't get around secure boot or any other lockdown
restrictions that way.

It's also consistent across our future plans: our planned assertion of
physical presence for authorising unsigned keys for secureboot involves
pressing a physical button on the case at a particular point in the boot
sequence, rather than typing in something at the console.

So I think that given that this doesn't disrupt anything else in
lockdown or affect any other platforms, it's worth taking.

Kind regards,
Daniel

* yes, there are 32-bit and even some 64-bit embedded systems still. But
  I don't think that should preclude xmon going in to lockdown: the
  existence of powerpc boxes where the physical console may be trusted
  doesn't mean that this is true of all the powerpc systems.


> Xmon should be either fully or partially disabled depending on the
> kernel lockdown state.
>
> Put xmon into read-only mode for lockdown=integrity and completely
> disable xmon when lockdown=confidentiality. Since this can occur
> dynamically, there may be pre-existing, active breakpoints in xmon when
> transitioning into read-only mode. These breakpoints will still trigger,
> so allow them to be listed and cleared using xmon.
>
> Changes since v6:
>  - Add lockdown check in sysrq-trigger to prevent entry into xmon_core
>  - Add lockdown check during init xmon setup for the case when booting
>    with compile-time or cmdline lockdown=confidentialiaty
>
> Changes since v5:
>  - Do not spam print messages when attempting to enter xmon when
>    lockdown=confidentiality
>
> Changes since v4:
>  - Move lockdown state checks into xmon_core
>  - Allow clearing of breakpoints in xmon read-only mode
>  - Test simple scenarios (combinations of xmon and lockdown cmdline
>    options, setting breakpoints and changing lockdown state, etc) in
>    QEMU and on an actual POWER8 VM
>  - Rebase onto security/next-lockdown
>    b602614a81078bf29c82b2671bb96a63488f68d6
>
> Changes since v3:
>  - Allow active breakpoints to be shown/listed in read-only mode
>
> Changes since v2:
>  - Rebased onto v36 of https://patchwork.kernel.org/cover/11049461/
>    (based on: f632a8170a6b667ee4e3f552087588f0fe13c4bb)
>  - Do not clear existing breakpoints when transitioning from
>    lockdown=none to lockdown=integrity
>  - Remove line continuation and dangling quote (confuses checkpatch.pl)
>    from the xmon command help/usage string
>
> Christopher M. Riedl (2):
>   powerpc/xmon: Allow listing and clearing breakpoints in read-only mode
>   powerpc/xmon: Restrict when kernel is locked down
>
>  arch/powerpc/xmon/xmon.c     | 119 +++++++++++++++++++++++++++--------
>  include/linux/security.h     |   2 +
>  security/lockdown/lockdown.c |   2 +
>  3 files changed, 97 insertions(+), 26 deletions(-)
>
> -- 
> 2.23.0
