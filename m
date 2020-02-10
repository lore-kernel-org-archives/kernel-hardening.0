Return-Path: <SRS0=b9VZ=36=lists.openwall.com=kernel-hardening-return-17759-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06052C35254
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 18:31:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5458C20838
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Feb 2020 18:31:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="dZmJEdXy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5458C20838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17759-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3308 invoked by uid 550); 10 Feb 2020 18:31:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3287 invoked from network); 10 Feb 2020 18:31:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581359458;
	bh=omPLg79kMPvUSKiyNNvd0/ylILD31wzwomGJPrNGyQg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dZmJEdXyo7TiCuP494908+DDQqiXuByAFM/5ZYZdUBh1RBbsjG4Nj8BtvNderACDu
	 buUtqSZaMUtzDuCNulwdaDkgV5kqZL7lno4QgAbQ/lGQBv705tgeTFjmzJtXJCSjQ1
	 BFRJCZcEs4eVwRoiOiwkJ6JclPVFDKSbcrF3PIR0=
X-Gm-Message-State: APjAAAUZ0hxqF2fmdEUK6QeYr60+7Vd5p7yYKN4vEgFCKPAL+wJH6glN
	s3Mcjw16qdCAyCa82K2IFz6q9VbB8l59eAYFTlFVGw==
X-Google-Smtp-Source: APXvYqzr7b50VDslir7PKIqAsDCapDo139eIqmv/8TM15nWdMYYpgSAHPnXtkGdcaP89mSWD9lXJHS+xhiOGpQ18who=
X-Received: by 2002:adf:ea85:: with SMTP id s5mr3242839wrm.75.1581359456683;
 Mon, 10 Feb 2020 10:30:56 -0800 (PST)
MIME-Version: 1.0
References: <20200210150519.538333-1-gladkov.alexey@gmail.com> <20200210150519.538333-6-gladkov.alexey@gmail.com>
In-Reply-To: <20200210150519.538333-6-gladkov.alexey@gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 10 Feb 2020 10:30:45 -0800
X-Gmail-Original-Message-ID: <CALCETrVjv04OOdzGNf7sRmRR-KUgY7xdMXA236nHZ1arn0KwVQ@mail.gmail.com>
Message-ID: <CALCETrVjv04OOdzGNf7sRmRR-KUgY7xdMXA236nHZ1arn0KwVQ@mail.gmail.com>
Subject: Re: [PATCH v8 05/11] proc: add helpers to set and get proc hidepid
 and gid mount options
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	Linux FS Devel <linux-fsdevel@vger.kernel.org>, 
	Linux Security Module <linux-security-module@vger.kernel.org>, 
	Akinobu Mita <akinobu.mita@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@kernel.org>, Daniel Micay <danielmicay@gmail.com>, 
	Djalal Harouni <tixxdz@gmail.com>, "Dmitry V . Levin" <ldv@altlinux.org>, 
	"Eric W . Biederman" <ebiederm@xmission.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Ingo Molnar <mingo@kernel.org>, "J . Bruce Fields" <bfields@fieldses.org>, 
	Jeff Layton <jlayton@poochiereds.net>, Jonathan Corbet <corbet@lwn.net>, 
	Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Oleg Nesterov <oleg@redhat.com>, Solar Designer <solar@openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Feb 10, 2020 at 7:06 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
>
> This is a cleaning patch to add helpers to set and get proc mount
> options instead of directly using them. This make it easy to track
> what's happening and easy to update in future.

On a cursory inspection, this looks like it obfuscates the code, and I
don't see where it does something useful later in the series.  What is
this abstraction for?

--Andy
