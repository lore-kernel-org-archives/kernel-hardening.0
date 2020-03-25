Return-Path: <SRS0=Zx46=5K=lists.openwall.com=kernel-hardening-return-18229-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACAB3C43331
	for <kernel-hardening@archiver.kernel.org>; Wed, 25 Mar 2020 23:21:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0878620714
	for <kernel-hardening@archiver.kernel.org>; Wed, 25 Mar 2020 23:21:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZM/jTUyJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0878620714
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18229-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24447 invoked by uid 550); 25 Mar 2020 23:20:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24415 invoked from network); 25 Mar 2020 23:20:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h3mXdOIBxbqqeyxP+0PXoxoXMdv9AQuRrD+qyz/H71o=;
        b=ZM/jTUyJNrHVVxOxf+9oynRmIW13ku5twP/1npQnFCofNysPZwbL5csUYzSS3+Qonv
         AuyoCrSZgF9tMzDWcjH4Ayri4cfQUejUxUTkxyf7HhJ85VjFzQAFmcoKFqqeo+1rgLxY
         r17QyqhpDtYkkDVeBMM0CubiCaAf4Hf+EILg4VmbjWVnQy/TJ6rVYwYESi+/n2fsnDdF
         xq9WsWLpvdxZGXTru6VrL8sZ0YJ+lliBAv5w6ErmlYsdgQ93PE2Kax7fAjlQHehHFmGZ
         lbBwJi0eXjXn/OKyNZenxUPLA9V8S40cduQ49rIEHZdvgdvScOcOp6242BXAOfMfk5dn
         /4Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h3mXdOIBxbqqeyxP+0PXoxoXMdv9AQuRrD+qyz/H71o=;
        b=pDX+Z83uaPuD/YCRG4s9QQnx7pbTA7DVxx8/VANlRt9MGkVNwZezdwMhd2B5w94iyv
         zo8JYja1CwcyEb1aEjAvcuUBeoI/WYW9/6nlWqgz9J6Kng/GhD3rknW87u/DT61Jkk/l
         JsI2qQGSvlH1qaQ7V7GvLm6eXJ2bDLgybEJeAGHk32DNnmFF4b297JvoZMxRBnI+27nT
         7UKW0bGb2cGzaFItI1kdmUeRZR9A2m/nMtSnRlicN+y0BypHjRJaoiBZqGyZGmgy/OkH
         s5I6q2u7YpismB32xAMk1S99vG7CTy6hHfLgTkUQd0xQWiIZas+mRScNcS16lWL4HyWG
         NFag==
X-Gm-Message-State: ANhLgQ2Wysdol5E03Adstl3hbEm4J8igQbEZGH7JgOlTHGRZdeT0CGg1
	Hi1U5f+NGI2QA5ZZBUvjHC31w82WD5UiXcx1Atj3DA==
X-Google-Smtp-Source: APiQypKvrgnwc8js63C8N+zp0rmTpf4QKnXvTcIJYOznDtakeHU4hmQ2qW9tl4eaWWYwNL8tBGg+KWaWzxXvkE+1NWA=
X-Received: by 2002:a2e:b5d1:: with SMTP id g17mr3279884ljn.139.1585178445467;
 Wed, 25 Mar 2020 16:20:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200324203231.64324-1-keescook@chromium.org> <CAG48ez3yYkMdxEEW6sJzBC5BZSbzEZKnpWzco32p-TJx7y_srg@mail.gmail.com>
 <202003241604.7269C810B@keescook> <BL0PR11MB3281D8D615FA521401B8E320E7CE0@BL0PR11MB3281.namprd11.prod.outlook.com>
 <202003251322.180F2536E@keescook>
In-Reply-To: <202003251322.180F2536E@keescook>
From: Jann Horn <jannh@google.com>
Date: Thu, 26 Mar 2020 00:20:19 +0100
Message-ID: <CAG48ez1RfvayCpNVkVQrdNbb6tNv1Wc=337Q7kZu80PrbMOP_A@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Optionally randomize kernel stack offset each syscall
To: Kees Cook <keescook@chromium.org>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, Thomas Gleixner <tglx@linutronix.de>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Potapenko <glider@google.com>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Linux-MM <linux-mm@kvack.org>, 
	kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Mar 25, 2020 at 9:27 PM Kees Cook <keescook@chromium.org> wrote:
> On Wed, Mar 25, 2020 at 12:15:12PM +0000, Reshetova, Elena wrote:
> > > > Also, are you sure that it isn't possible to make the syscall that
> > > > leaked its stack pointer never return to userspace (via ptrace or
> > > > SIGSTOP or something like that), and therefore never realign its
> > > > stack, while keeping some controlled data present on the syscall's
> > > > stack?
> >
> > How would you reliably detect that a stack pointer has been leaked
> > to userspace while it has been in a syscall? Does not seem to be a trivial
> > task to me.
>
> Well, my expectation is that folks using this defense are also using
> panic_on_warn sysctl, etc, so attackers don't get a chance to actually
> _use_ register values spilled to dmesg.

Uh... I thought that thing was exclusively for stuff like syzkaller,
because nuking the entire system because of a WARN is far too
excessive? WARNs should be safe to add almost anywhere in the kernel,
so that developers can put their assumptions about system behavior
into code without having to worry about bringing down the entire
system if that assumption turns out to have been false in some
harmless edgecase.

Also, there are other places that dump register state. In particular
the soft lockup detection, which you can IIRC easily trip even
accidentally if you play around with stuff like FUSE filesystems, or
if a disk becomes unresponsive. Sure, *theoretically* you can also set
the "panic on soft lockup" flag, but that seems like a really terrible
idea to me.

As far as I can tell, the only clean way to fix this is to tell
distros that give non-root users access to dmesg (Ubuntu in
particular) that they have to stop doing that. E.g. Debian seems to
get by just fine with root-restricted dmesg.
