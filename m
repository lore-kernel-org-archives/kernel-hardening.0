Return-Path: <SRS0=5OIe=OK=lists.openwall.com=kernel-hardening-return-21388-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F6FC433EF
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Sep 2021 10:36:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EF95160F3A
	for <kernel-hardening@archiver.kernel.org>; Mon, 20 Sep 2021 10:36:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EF95160F3A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=spotco.us
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 14088 invoked by uid 550); 20 Sep 2021 10:35:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14017 invoked from network); 19 Sep 2021 20:44:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=spotco.us; s=gm1;
	t=1632084283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9uoIEIA3582w/7yrrFMK2dalpy8bbXkkhxY5yUGLWSg=;
	b=SH+9uiMelYRWQI1tkDc0TNyWpBkumSl0rW98JufpnpO7n+h/DnUtQok2TxCRtQ8ntjexhv
	B1FQfn2zPMziLpkH6DB+H0nQATuNb8os/fRRO0c5XrRnjyFYLOsHd1mz9fPc2aHh1SuJff
	sO+HgGs8ZVDlTI+Fc2NPT6cbU+haQDMD5reFKMd0fxKapODA5moFiDbvKkA8TI6+rlKTiO
	+W5USu0ZNBV5ia9N3RHibXIR+YV0U9dZ0QemN3yzvJzw6zyi/kYPm1pA4LeKYlmTCl//QT
	WOoE5E9nz9KVeg6dnTFPve5dIj9SDdQPD8wyQYuxPYiVJifNTkn9pNFE+E7dXA==
Message-ID: <67cf8b802fe868ba63b28d49f8d836e179df833a.camel@spotco.us>
Subject: Self introduction
From: Tad <tad@spotco.us>
To: kernel-hardening@lists.openwall.com
Cc: linux-hardening@vger.kernel.org
Date: Sun, 19 Sep 2021 16:44:40 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Hello!
My name is Tad.

I have a few personal projects for the past five or so years for making
available kernel hardening features to more users.

My main project is DivestOS, which provides more secure images for older/legacy
Android devices.
I harden all device kernels via the following:
 * My automatic CVE checker/patcher program [1]. It is able to apply many dozen
   to many hundred CVE patches to trees. It is backed by an extensive versioned
   list [2] of CVE patches that I origianlly maintained by hand. In the past
   year or so I pull in using a scraper I made for the CIP scripts [3].
 * My hardenDefconfig function [4], inspired by the KSPP recommendations and
   later Popov's kconfig-hardened-check. It simply enables and disables various
   options.
 * My hardenBootArgs function [5], currently just enables slub_debug=FZP for
   devices.
 * Some misc tweaks [6], currently for disabling slub/slab merging.
 * And lastly some sysctl tweaks [7].

I also maintain another project for providing some extra security to modern
distros, without recompilation.
It is called Brace [8] and compatible with Arch/Fedora/Debian/OpenSUSE.
In the kernel relations, it is mostly just sysctl [9] changes and kernel
commandline [10] changes.

Lastly some background:
Micay inspired me to work on this area back in mid-2015, after he helped me port
his Android PaX patchset to the OnePlus One phone [11].

Sharing for any comments.
Also most of you are likely working on mainline, not ancient kernels, so maybe
you'll find this interesting.

Best regards,
Tad.

[1] https://gitlab.com/divested-mobile/cve_checker
[2] https://gitlab.com/divested-mobile/kernel_patches/-/blob/master/Kernel_CVE_Patch_List.txt
[3] https://gitlab.com/cip-project/cip-kernel/cip-kernel-sec
[4] https://gitlab.com/divested-mobile/divestos-build/-/blob/e7dd0af4/Scripts/Common/Functions.sh#L657
[5] https://gitlab.com/divested-mobile/divestos-build/-/blob/e7dd0af4/Scripts/Common/Functions.sh#L493
[6] https://gitlab.com/divested-mobile/divestos-build/-/blob/e7dd0af4/Scripts/Common/Post.sh#L28
[7] https://gitlab.com/divested-mobile/divestos-build/-/blob/e7dd0af4/Patches/LineageOS-18.1/android_system_core/0001-Harden.patch
[8] https://gitlab.com/divested/brace
[9] https://gitlab.com/divested/brace/-/blob/1e4975c9/brace/usr/lib/sysctl.d/60-restrict.conf
[10] https://gitlab.com/divested/brace/-/blob/1e4975c9/brace/usr/bin/brace-supplemental-changes#L33
[11] https://divestos.org/images/screenshots/CopperheadOS-bacon.png


