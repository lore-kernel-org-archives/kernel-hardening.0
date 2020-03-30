Return-Path: <SRS0=XcPO=5P=lists.openwall.com=kernel-hardening-return-18306-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67518C43331
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 15:13:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2706E206F5
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Mar 2020 15:13:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b1g9mfT7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2706E206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18306-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16170 invoked by uid 550); 30 Mar 2020 15:13:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16136 invoked from network); 30 Mar 2020 15:13:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=3zhHJ/DCytaCuAszpbS/hUFHNDzc25lAR/e+TAM3FvA=;
        b=b1g9mfT7+hCJlZ2qKk1A2/KjSmDhfhZrp2k/QDB+GoMe90XDjvZVpTkD1Quqq8RXPG
         XHMeNUG2lsx18PPqEb2RZqtPBkQFuFdZh+8WyOuEy7idAV4NA4DHje1v6tdPNbchsRMU
         sPJrqjE5q12hNhdwtWRlqF7dde0qTvvn9zvzMEippqW90FtsUx850yV2dNPO/4Ao2+19
         0WiEptGZgp6aorkn2G2R7hZxA4LH7dPeMBGGIr0Sz6x11s2ohtEMHU/VKTK13fPuFByi
         oc/VeE5DdstAXj5NMymPjtoQDMzExDNY83Hb6TvQk3QmEEGV8W+jnf0ukmaVpvr9ZiIH
         roiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=3zhHJ/DCytaCuAszpbS/hUFHNDzc25lAR/e+TAM3FvA=;
        b=B2KPOIlfEaoh8ANW/cU4t01hOSvCzWuE2VNT3jUjLiHaQPqweqb3uxpH4IlBuAoFlB
         UcX/Z9dD2IaSqaLhuDpvI2DKkw2aNMoq/4P1V4ZUUvKKATznZnUGkidKINHaHpzcSiGh
         yl0A+NHoC704U6xMohhi9cC2WGs5hyRSYBosu7M8jxVQF1UobyCyXqeqmxl7qPydsBBm
         COSLU+czi2z7cbhJ5y4f0KtJB9jc0fsL+6HBKtSJpBfBlS0H3gH9sNSc1dsXC/2Hc4zn
         lY5xCWSafq0LpcfgaR5HEimSog85tJy1p3wviV2WbKWObHJfTWaduIWtY5nrkPo0FMy8
         mHqQ==
X-Gm-Message-State: AGi0Pubz/CCC52h+AQ1oc8QbxuXjOgGUh0OD8oco1p4KIyRD0M4ws5ug
	Gl17pgR+gYLbJfSGbToy7fqdyBnpyD6q8brUeKii8w==
X-Google-Smtp-Source: APiQypKjh+WkyDatfuRaqsJIWVYj6833rQXqHPTM2kFjV1K+d/bJb+qjmVUlb8InVLbgDDlgjgBnfuaImpmvoCN6QG4=
X-Received: by 2002:ac2:5ede:: with SMTP id d30mr8236138lfq.157.1585581204841;
 Mon, 30 Mar 2020 08:13:24 -0700 (PDT)
MIME-Version: 1.0
From: Jann Horn <jannh@google.com>
Date: Mon, 30 Mar 2020 17:12:58 +0200
Message-ID: <CAG48ez2sZ58VQ4+LJu39H1M0Y98LhRYR19G_fDAPJPBf7imxuw@mail.gmail.com>
Subject: CONFIG_DEBUG_INFO_BTF and CONFIG_GCC_PLUGIN_RANDSTRUCT
To: bpf@vger.kernel.org, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

I noticed that CONFIG_DEBUG_INFO_BTF seems to partly defeat the point
of CONFIG_GCC_PLUGIN_RANDSTRUCT.

CONFIG_GCC_PLUGIN_RANDSTRUCT randomizes the layout of (some)
kernel-internal structs, which AFAIK is intended to make exploitation
harder in two ways:
1) by ensuring that an attacker can't use a single exploit relying on
specific structure offsets against every target
2) by keeping structure offsets secret from the attacker, so that the
attacker can't rely on knowledge of structure offsets even when trying
to exploit a specific target - only relevant for the few people who
build their kernel themselves (since nobody was crazy enough to
implement generating relocations for structure offsets so far).

When CONFIG_DEBUG_INFO_BTF is on, the kernel exposes the layouts of
kernel structures via the mode-0444 file /sys/kernel/btf/vmlinux, so a
local attacker can easily see structure offsets, defeating part 2.

I wonder whether these kconfig knobs should be mutually exclusive, or
whether /sys/kernel/btf/vmlinux should have a different mode, or
something like that.
