Return-Path: <SRS0=xx52=4A=lists.openwall.com=kernel-hardening-return-17807-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B7AC352A4
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Feb 2020 21:03:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 221E62168B
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Feb 2020 21:03:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q58W0NiV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 221E62168B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17807-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20164 invoked by uid 550); 12 Feb 2020 21:03:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20139 invoked from network); 12 Feb 2020 21:03:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WySKsoF25f/J4EpIF80nlYeN07mmY9MX1gph6T2llNA=;
        b=Q58W0NiVVgTX+oNnbx2yak8H3LqZJhOMXKR6Ng/loJu7bqEx0qJqJdUgYoD/Insl5V
         0bdfWlwpi7ZWdHerxvV1fP32PeO3Q+Sr+beCxumaLAw59xU5UE6TavPtsaLJeIdwxKCP
         /m8KW47+oG3MYjz8Wo+heg9mc0RztoSq3bL84=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WySKsoF25f/J4EpIF80nlYeN07mmY9MX1gph6T2llNA=;
        b=M/tb9fIPXSagrKFmcJsb+80BHtofbpnMHx8vi4mnuvw8dN3IqgckBpuAINcbUqo+6v
         nYaqT1UPCDqZCe09wDSPGO2bTNZgSiDpJKQA7l41IyTZ0Irw/z9TVoDMf+9OtN52ZF3+
         G0ivKY5xiD/ZRXdVY7iJi1stynPFQBl86l29LsbIGri0Fw8pxKipPvcOHgy7q6HhnTu1
         yWZzkvCSksaYEkB268qwXKKaJ4pgQHZ06A2HL+vdGcRxiR5twbORPjVVG0u40/wFor6p
         c/J703Z7ek4DtBzCQFwsED82CfuU1hCPBlahcXs57VwL9yl2A0kDVjjL9yq6ozU5tu7l
         c8Ig==
X-Gm-Message-State: APjAAAWUztI80UdjRfm1aMkWqzVK3bpZH2vDZ3voL1JaA1u5e8n4MmLD
	DRIlUbjIaZrM2zI2Sn2M60+5jv0Fbig=
X-Google-Smtp-Source: APXvYqz6rC1PTMW2HM88m21anT5g31b/acjnRI1gQFH2tuFjMolpM1Do+m8ssabrN0FFQQnm4ZHVDg==
X-Received: by 2002:a05:651c:102c:: with SMTP id w12mr8911617ljm.53.1581541378704;
        Wed, 12 Feb 2020 13:02:58 -0800 (PST)
X-Received: by 2002:a2e:97cc:: with SMTP id m12mr8729073ljj.241.1581541376733;
 Wed, 12 Feb 2020 13:02:56 -0800 (PST)
MIME-Version: 1.0
References: <20200210150519.538333-8-gladkov.alexey@gmail.com>
 <87v9odlxbr.fsf@x220.int.ebiederm.org> <20200212144921.sykucj4mekcziicz@comp-core-i7-2640m-0182e6>
 <87tv3vkg1a.fsf@x220.int.ebiederm.org> <CAHk-=wg52stFtUxMOxs3afkwDWmWn1JXC7RJ7dPsTrJbnxpZVg@mail.gmail.com>
 <87v9obipk9.fsf@x220.int.ebiederm.org> <CAHk-=wgwmu4jpmOqW0+Lz0dcem1Fub=ThLHvmLobf_WqCq7bwg@mail.gmail.com>
 <20200212200335.GO23230@ZenIV.linux.org.uk> <CAHk-=wi+1CPShMFvJNPfnrJ8DD8uVKUOQ5TQzQUNGLUkeoahkg@mail.gmail.com>
 <20200212203833.GQ23230@ZenIV.linux.org.uk> <20200212204124.GR23230@ZenIV.linux.org.uk>
In-Reply-To: <20200212204124.GR23230@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Feb 2020 13:02:40 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi5FOGV_3tALK3n6E2fK3Oa_yCYkYQtCSaXLSEm2DUCKg@mail.gmail.com>
Message-ID: <CAHk-=wi5FOGV_3tALK3n6E2fK3Oa_yCYkYQtCSaXLSEm2DUCKg@mail.gmail.com>
Subject: Re: [PATCH v8 07/11] proc: flush task dcache entries from all procfs instances
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, LKML <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	Linux FS Devel <linux-fsdevel@vger.kernel.org>, 
	Linux Security Module <linux-security-module@vger.kernel.org>, 
	Akinobu Mita <akinobu.mita@gmail.com>, Alexey Dobriyan <adobriyan@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, 
	"Dmitry V . Levin" <ldv@altlinux.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Ingo Molnar <mingo@kernel.org>, "J . Bruce Fields" <bfields@fieldses.org>, 
	Jeff Layton <jlayton@poochiereds.net>, Jonathan Corbet <corbet@lwn.net>, 
	Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, 
	Solar Designer <solar@openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 12, 2020 at 12:41 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Wed, Feb 12, 2020 at 08:38:33PM +0000, Al Viro wrote:
> >
> > Wait, I thought the whole point of that had been to allow multiple
> > procfs instances for the same userns?  Confused...
>
> s/userns/pidns/, sorry

Right, but we still hold the ref to it here...

[ Looks more ]

Oooh. No we don't. Exactly because we don't hold the lock, only the
rcu lifetime, the ref can go away from under us. I see what your
concern is.

Ouch, this is more painful than I expected - the code flow looked so
simple. I really wanted to avoid a new lock during process shutdown,
because that has always been somewhat painful.

            Linus
