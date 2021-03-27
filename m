Return-Path: <SRS0=gwO/=IZ=lists.openwall.com=kernel-hardening-return-21071-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8EADC433C1
	for <kernel-hardening@archiver.kernel.org>; Sat, 27 Mar 2021 18:55:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B8462619B1
	for <kernel-hardening@archiver.kernel.org>; Sat, 27 Mar 2021 18:55:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B8462619B1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21071-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21958 invoked by uid 550); 27 Mar 2021 18:55:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21926 invoked from network); 27 Mar 2021 18:55:46 -0000
Subject: Re: [PATCH v5 1/1] fs: Allow no_new_privs tasks to call chroot(2)
To: Askar Safin <safinaskar@mail.ru>
References: <1616800362.522029786@f737.i.mail.ru>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Cc: kernel-hardening@lists.openwall.com, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Message-ID: <7d9c2a08-89da-14ea-6550-527a3f2c9c9e@digikod.net>
Date: Sat, 27 Mar 2021 19:56:23 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <1616800362.522029786@f737.i.mail.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit


On 27/03/2021 00:12, Askar Safin wrote:
> Hi. Unprivileged users already can do chroot. He should simply create userns and then call "chroot" inside. As an LWN commenter noted, you can simply run 
> "unshare -r /usr/sbin/chroot some-dir". (I recommend reading all comments: https://lwn.net/Articles/849125/ .)

We know that userns can be use to get the required capability in a new
namespace, but this patch is to not require to use this namespace, as
explained in the commit message. I already added some comments in the
LWN article though.

> 
> Also: if you need chroot for path resolving only, consider openat2 with RESOLVE_IN_ROOT ( https://lwn.net/Articles/796868/ ).

openat2 was also discussed in previous versions of this patch.
