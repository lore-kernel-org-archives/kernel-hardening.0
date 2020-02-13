Return-Path: <SRS0=LlEr=4B=lists.openwall.com=kernel-hardening-return-17817-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98CBAC352A3
	for <kernel-hardening@archiver.kernel.org>; Thu, 13 Feb 2020 22:48:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EA3932073A
	for <kernel-hardening@archiver.kernel.org>; Thu, 13 Feb 2020 22:48:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dRYW8Mem"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EA3932073A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17817-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7596 invoked by uid 550); 13 Feb 2020 22:48:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7573 invoked from network); 13 Feb 2020 22:48:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rVdHJ1r/9FxJmwhDqRkVHSIn1Ry+lO3z+KpnaUuqwYk=;
        b=dRYW8MemR37cE0uru6NTUES5Od7vEqzfZmb/KMY93QEjURoq6DE5QcXLZ6JJL9HB8V
         KfvM/ZKQbYsF7Zy+x1PnUgqdmV3x1lbxpWU+BFmhJglL6UqALgYvF3IltbUH8c3PxzFq
         KRLtkM5e8bHrUc0004IuGa/Hy6940Rjrv4zzw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rVdHJ1r/9FxJmwhDqRkVHSIn1Ry+lO3z+KpnaUuqwYk=;
        b=nhA70XOf+uumc8zNCPMnExWUErog0kuffxL1b6w/67EWdxTiMgJDwBmz9+2OsbEde4
         X66lIaP7OL6lUe3p6Zu36JdIXDsq7uN51LSqIxYmxjADNTbDvVD6o6UYQVc1YMwOd9iu
         iZyrWhzd/fIoyCIiamXoblO4LrRJOSvP/gMBRZIm3cCQNwe8XyS+/Dq/WSgI1kxNs9yy
         uJkniiVn2SCe6kOywHSLUWmIPUlXClYUwJd6KViX5jSOa24UfWzjOy+/3Vjq+uv9EA2l
         MCuBIWYLPfqbwGjgIPWK/BIMGhmdiNJQANMzWNsBIgBZiAJ2ecns+ftBsQ5+w+leJdP3
         +MdA==
X-Gm-Message-State: APjAAAXI7F3rPjI86SP0WmgJUPSviHtsdkiOqjHTfmXYEZD123Xw06V4
	bt18gBiAmr2/Ei3oQxpKlBRBAkKvQOI=
X-Google-Smtp-Source: APXvYqwruhxY3I98YsQtzDkSyyL0e2ANkyjTFWI4IC1Q87Nn88R70c5WR9JqRUqRNhmqauZtpAiynw==
X-Received: by 2002:a2e:9587:: with SMTP id w7mr65201ljh.42.1581634086719;
        Thu, 13 Feb 2020 14:48:06 -0800 (PST)
X-Received: by 2002:a2e:88c5:: with SMTP id a5mr35496ljk.201.1581634084790;
 Thu, 13 Feb 2020 14:48:04 -0800 (PST)
MIME-Version: 1.0
References: <20200212200335.GO23230@ZenIV.linux.org.uk> <CAHk-=wi+1CPShMFvJNPfnrJ8DD8uVKUOQ5TQzQUNGLUkeoahkg@mail.gmail.com>
 <20200212203833.GQ23230@ZenIV.linux.org.uk> <20200212204124.GR23230@ZenIV.linux.org.uk>
 <CAHk-=wi5FOGV_3tALK3n6E2fK3Oa_yCYkYQtCSaXLSEm2DUCKg@mail.gmail.com>
 <87lfp7h422.fsf@x220.int.ebiederm.org> <CAHk-=wgmn9Qds0VznyphouSZW6e42GWDT5H1dpZg8pyGDGN+=w@mail.gmail.com>
 <87pnejf6fz.fsf@x220.int.ebiederm.org> <20200213055527.GS23230@ZenIV.linux.org.uk>
 <CAHk-=wgQnNHYxV7-SyRP=g9vTHyNAK9g1juLLB=eho4=DHVZEQ@mail.gmail.com> <20200213222350.GU23230@ZenIV.linux.org.uk>
In-Reply-To: <20200213222350.GU23230@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 13 Feb 2020 14:47:48 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjePLiQqUfQGCrNb0wp+EtgRddQbcK-pHH=6rxbdYNNOA@mail.gmail.com>
Message-ID: <CAHk-=wjePLiQqUfQGCrNb0wp+EtgRddQbcK-pHH=6rxbdYNNOA@mail.gmail.com>
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

On Thu, Feb 13, 2020 at 2:23 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> I'd been thinking of ->d_fsdata pointing to a structure with list_head
> and a (non-counting) task_struct pointer for those guys.  Allocated
> on lookup, of course (as well as readdir ;-/) and put on the list
> at the same time.

Hmm. That smells like potentially a lot of small allocations, and
making readdir() even nastier.

Do we really want to create the dentries at readdir time? We do now
(with proc_fill_cache()) but do we actually _need_ to?

I guess a lot of readdir users end up doing a stat on it immediately
afterwards. I think right now we do it to get the inode number, and
maybe that is a basic requirement (even if I don't think it's really
stable - an inode could be evicted and then the ino changes, no?)

Ho humm. This all doesn't make me happy. But I guess the proof is in
the pudding - and if you come up with a good patch, I won't complain.

              Linus
