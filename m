Return-Path: <SRS0=woRk=4I=lists.openwall.com=kernel-hardening-return-17873-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B71C11D00
	for <kernel-hardening@archiver.kernel.org>; Thu, 20 Feb 2020 23:08:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E4D60208E4
	for <kernel-hardening@archiver.kernel.org>; Thu, 20 Feb 2020 23:08:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eERYNg5p"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E4D60208E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17873-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28104 invoked by uid 550); 20 Feb 2020 23:08:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28084 invoked from network); 20 Feb 2020 23:08:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8oe6NGrWHTfgph3/inQD25AzfwK01P8Rirv0Se4y4rY=;
        b=eERYNg5pIV17feq4MuZzbw+6+6UOz8wPDMox8sHvl6LW5lyeCJiNPLjaaiAnC6tgNr
         k4eFpoUVZrOY+nWuuaeOf69/y2kMFcR2Xyd4iQCdWpyjSB4kE6JLltV8O5wbI2adfQ2q
         gkwegZ8+VoH9h8WqrHWMh85pZ16PVGc+EW3II=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8oe6NGrWHTfgph3/inQD25AzfwK01P8Rirv0Se4y4rY=;
        b=MULcFupczTUhpRj2B23/rDNzEH5UQF7H4j8vE41yJQow/u8+qJuDE/kODOOj4UoxlX
         XWBFIS/dI9Ubx43gVLXW9ZjMPH6JzBreTSyQOOYhLJBgJydGLRVs82vVq1WFTaCUKcQ1
         eAOG+/SQb+P5usLERp6S+5T2sWv+Tnlyxnlquwh000YW68u+3nPhbho/bqFtsW+REvxo
         rry+4+a41JNG1Jqt/yslBitKKbP04kxB/DLDbvZTpSvd3c9IuE/qVoSl7qp7R/bLMvvx
         Ogx0aXmAP6bU4W7Bj0t2ka58XZlOGFWhT5DNcMAWkuly4hUpdXMYJqrwDHNJWD1aZQ/w
         xBJQ==
X-Gm-Message-State: APjAAAUMPPhQRJqhtH9cP03x/9sw5au2jDOCMovgwV1VrGLKpAQLxYgW
	vfkO8CNkBUr5YQNBWwAWiQ5hWjG9aqQ=
X-Google-Smtp-Source: APXvYqzgpGPhh7mvyxr1rielk3zboBfB6IjUzGJTMstY/pMEHGl2vMjSASyfh3Mr/jOpCnWaAJX8aw==
X-Received: by 2002:a17:906:2596:: with SMTP id m22mr31923395ejb.167.1582240108449;
        Thu, 20 Feb 2020 15:08:28 -0800 (PST)
X-Received: by 2002:a2e:97cc:: with SMTP id m12mr19768759ljj.241.1582239758414;
 Thu, 20 Feb 2020 15:02:38 -0800 (PST)
MIME-Version: 1.0
References: <20200210150519.538333-8-gladkov.alexey@gmail.com>
 <87v9odlxbr.fsf@x220.int.ebiederm.org> <20200212144921.sykucj4mekcziicz@comp-core-i7-2640m-0182e6>
 <87tv3vkg1a.fsf@x220.int.ebiederm.org> <CAHk-=wg52stFtUxMOxs3afkwDWmWn1JXC7RJ7dPsTrJbnxpZVg@mail.gmail.com>
 <87v9obipk9.fsf@x220.int.ebiederm.org> <CAHk-=wgwmu4jpmOqW0+Lz0dcem1Fub=ThLHvmLobf_WqCq7bwg@mail.gmail.com>
 <20200212200335.GO23230@ZenIV.linux.org.uk> <CAHk-=wi+1CPShMFvJNPfnrJ8DD8uVKUOQ5TQzQUNGLUkeoahkg@mail.gmail.com>
 <20200212203833.GQ23230@ZenIV.linux.org.uk> <20200212204124.GR23230@ZenIV.linux.org.uk>
 <CAHk-=wi5FOGV_3tALK3n6E2fK3Oa_yCYkYQtCSaXLSEm2DUCKg@mail.gmail.com>
 <87lfp7h422.fsf@x220.int.ebiederm.org> <CAHk-=wgmn9Qds0VznyphouSZW6e42GWDT5H1dpZg8pyGDGN+=w@mail.gmail.com>
 <87pnejf6fz.fsf@x220.int.ebiederm.org> <871rqpaswu.fsf_-_@x220.int.ebiederm.org>
In-Reply-To: <871rqpaswu.fsf_-_@x220.int.ebiederm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Feb 2020 15:02:22 -0800
X-Gmail-Original-Message-ID: <CAHk-=whX7UmXgCKPPvjyQFqBiKw-Zsgj22_rH8epDPoWswAnLA@mail.gmail.com>
Message-ID: <CAHk-=whX7UmXgCKPPvjyQFqBiKw-Zsgj22_rH8epDPoWswAnLA@mail.gmail.com>
Subject: Re: [PATCH 0/7] proc: Dentry flushing without proc_mnt
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>, 
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

On Thu, Feb 20, 2020 at 12:48 PM Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Linus, does this approach look like something you can stand?

A couple of worries, although one of them seem to have already been
resolved by Al.

I think the real gatekeeper should be Al in general.  But other than
the small comments I had, I think this might work just fine.

Al?

           Linus
