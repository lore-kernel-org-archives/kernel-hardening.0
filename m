Return-Path: <SRS0=Isb2=4I=lists.openwall.com=kernel-hardening-return-17868-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 274FCC11D00
	for <kernel-hardening@archiver.kernel.org>; Thu, 20 Feb 2020 22:44:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 77442207FD
	for <kernel-hardening@archiver.kernel.org>; Thu, 20 Feb 2020 22:44:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HocGqZaP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77442207FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17868-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5985 invoked by uid 550); 20 Feb 2020 22:44:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5962 invoked from network); 20 Feb 2020 22:44:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IsBAqEZQag0ypHqg0PyTqrCBxrLtLK/vf3m5Pbo+Q1I=;
        b=HocGqZaPvPbj2Rc3tHfIsXtvsU9ZExNqDhyGTd1FkLfg2CixXSIhWg+lhtFLFy7LH5
         Ll9ajjeSCLGyVGJFCP3pr8MzRIUlhdaSf4zT2trYK3NmUY7kfmF8q56qyO7AFc70i6vi
         mx1gRvncgXwtZTQp0OujHwfoGsQovufSXPaY4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IsBAqEZQag0ypHqg0PyTqrCBxrLtLK/vf3m5Pbo+Q1I=;
        b=ADw3aab4yuJs/tIXKodda9CG6YIJ3HJZGpaTP2qgpcVzgMh3ciqD9/ErWc2OYJlik3
         fnfhJcsoIIpV+prjfub48iu4lOBBkCJE4rpdv6fEgXDzfWR2ey+MH8mklm5AeypPtBaQ
         sMChkPEhPng8UMMQs7zpVP0pDjhYURUb4Q7d2/FeuC9/ehR2dRZKhCRMJADvFgKOo4vR
         c5+FP/1doMa1vnAz70iGRinfzk2tcOkGf54IlJAodUctMuewB3WUXfRc83wUM/mNiNt7
         luT2tcxS0N7S9L6ent86Kgrafwk38OEjpJyWQYI+Zydu25fB0UWeMPySHu6HuPaMuMDy
         OSAA==
X-Gm-Message-State: APjAAAW6B+w4MKOJYww9IdtkDoNuKnQIaaLEpzZ+fKZ/XvNFDEy7kUZt
	cq/N2nU1rRfvvueAcvrwT/RaH/EWBbQ=
X-Google-Smtp-Source: APXvYqzeODsYUSUEi5juXEbc+W82/i/md/9CARls1oEpBp5nZAP8ZtRFcDBWL7gMVzSWSYd8VKga1g==
X-Received: by 2002:a05:6512:31c3:: with SMTP id j3mr2575724lfe.144.1582238635354;
        Thu, 20 Feb 2020 14:43:55 -0800 (PST)
X-Received: by 2002:a2e:88c5:: with SMTP id a5mr20465844ljk.201.1582238633679;
 Thu, 20 Feb 2020 14:43:53 -0800 (PST)
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
 <87blpt9e6m.fsf_-_@x220.int.ebiederm.org>
In-Reply-To: <87blpt9e6m.fsf_-_@x220.int.ebiederm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 20 Feb 2020 14:43:38 -0800
X-Gmail-Original-Message-ID: <CAHk-=whmwfv6zGwTRR8zTyTdfxgYoc7SE3Z0nKHu_srG_8NPWw@mail.gmail.com>
Message-ID: <CAHk-=whmwfv6zGwTRR8zTyTdfxgYoc7SE3Z0nKHu_srG_8NPWw@mail.gmail.com>
Subject: Re: [PATCH 4/7] proc: Use d_invalidate in proc_prune_siblings_dcache
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

On Thu, Feb 20, 2020 at 12:51 PM Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> To use d_invalidate replace d_prune_aliases with d_find_alias
> followed by d_invalidate and dput.  This is safe and complete
> because no inode in proc has any hardlinks or aliases.

Are you sure you can't create them some way?  This makes em go "what
if we had multiple dentries associated with that inode?" Then the code
would just invalidate the first one.

I guess we don't have export_operations or anything like that, but
this makes me worry...

            Linus
