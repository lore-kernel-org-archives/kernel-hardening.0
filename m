Return-Path: <SRS0=162Z=D4=lists.openwall.com=kernel-hardening-return-20244-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD024C388F9
	for <kernel-hardening@archiver.kernel.org>; Wed, 21 Oct 2020 15:02:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 914B02224E
	for <kernel-hardening@archiver.kernel.org>; Wed, 21 Oct 2020 15:02:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tyuzf6eg"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 914B02224E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20244-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3797 invoked by uid 550); 21 Oct 2020 15:02:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3765 invoked from network); 21 Oct 2020 15:02:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ue8Kphmgd/J9kkCdXQ6cXg3jN2T1s1VI/S6KEmBFYtA=;
        b=tyuzf6egZNg0bmL3iIxfmvVeRFhdDnfbewBqqrw7rPk8s9ezG7HKGJBYpz7qsa0C3r
         S3ppY6TNQS3s3qJ+E8SkywVt7v3Zd2bQYG9iNKkQ5ry9p4dyQxrKaJYxT3chX6RHizyC
         +GySRMRyhkvGqRuGv8ic4+o/rQfFyDhJwmYxpx2ibC7icYfN3L7KTnwPZmkGNg6waxt+
         /v0DHK/ocGmaG3hiyKz3lBsjXZFDm/NNr/l8Dh1bRHfhbCLOJwWvukIO73RcCWW7x5gT
         F/vLxIv6fFnSA+AZM/O1jatbKn8McCq487pE+2ewPegXQiEjjWXHbjNbBW5V5tKGcGQh
         Pzag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ue8Kphmgd/J9kkCdXQ6cXg3jN2T1s1VI/S6KEmBFYtA=;
        b=uD7ur1DkCRH5XWVuDU/ke0m2/1cLHqO89ycSDX5KeEkR9YvJ2HUV+BvwfTBjIHrU4o
         C5o7/GXtbeev93UMoOILNoTddAP+e/Sf/3hEMoH1C+z18DPVA0oxe0O0UEQ6NPhGCnQ4
         oPtuXFa/Pbis+Mc8IcAzxK08g9eiKw30X3iQYL73co830uEpTXzMy8BliS1xityT4ZGe
         qFx+c14cYWqBzKE2F4VHb6G721fj/Kcgv/Lp7qEQ13QD/HrHnFBEycNlDJda3Oh/u3pe
         ErpPkkfdmnLZeWz4dHirjzSEb8wlpv7kyA47h0ZORhH0NzMgOnoQI1AVIZhW0czbHs6q
         fhAg==
X-Gm-Message-State: AOAM533OoiGHGGbVZPwrP5NEtetjMOkgabZJ4jISmvWQCxrJK5W2S8HU
	MFdsu3WNtTy6s/ywG72HQLTi2tOOJ+/57cZlzAtjYg==
X-Google-Smtp-Source: ABdhPJxLbzy0h2+Icd7LIsy6zh10BR+u5qt0ykST0OUv8CPsJiNxNv60HEOhNh7tmnifd2hka1h/GcVQRH2ORVgJ1P0=
X-Received: by 2002:a05:6402:135a:: with SMTP id y26mr1563112edw.114.1603292509011;
 Wed, 21 Oct 2020 08:01:49 -0700 (PDT)
MIME-Version: 1.0
References: <20201013003203.4168817-1-samitolvanen@google.com>
 <20201013003203.4168817-23-samitolvanen@google.com> <CAG48ez2baAvKDA0wfYLKy-KnM_1CdOwjU873VJGDM=CErjsv_A@mail.gmail.com>
 <20201015102216.GB2611@hirez.programming.kicks-ass.net> <20201015203942.f3kwcohcwwa6lagd@treble>
 <CABCJKufDLmBCwmgGnfLcBw_B_4U8VY-R-dSNNp86TFfuMobPMw@mail.gmail.com>
 <20201020185217.ilg6w5l7ujau2246@treble> <CABCJKucVjFtrOsw58kn4OnW5kdkUh8G7Zs4s6QU9s6O7soRiAA@mail.gmail.com>
 <20201021085606.GZ2628@hirez.programming.kicks-ass.net>
In-Reply-To: <20201021085606.GZ2628@hirez.programming.kicks-ass.net>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Wed, 21 Oct 2020 08:01:38 -0700
Message-ID: <CABCJKuewXazmBpXz5irWgy+W537x1Lws5YAsFqMgo+Yio8iyRg@mail.gmail.com>
Subject: Re: [PATCH v6 22/25] x86/asm: annotate indirect jumps
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jannh@google.com>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Oct 21, 2020 at 1:56 AM Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, Oct 20, 2020 at 12:24:37PM -0700, Sami Tolvanen wrote:
> > > > Building allyesconfig with this series and LTO enabled, I still see
> > > > the following objtool warnings for vmlinux.o, grouped by source file:
> > > >
> > > > arch/x86/entry/entry_64.S:
> > > > __switch_to_asm()+0x0: undefined stack state
> > > > .entry.text+0xffd: sibling call from callable instruction with
> > > > modified stack frame
> > > > .entry.text+0x48: stack state mismatch: cfa1=7-8 cfa2=-1+0
> > >
> > > Not sure what this one's about, there's no OBJECT_FILES_NON_STANDARD?
> >
> > Correct, because with LTO, we won't have an ELF binary to process
> > until we compile everything into vmlinux.o, and at that point we can
> > no longer skip individual object files.
>
> I think what Josh was trying to say is; this file is subject to objtool
> on a normal build and does not generate warnings. So why would it
> generate warnings when subject to objtool as result of a vmlinux run
> (due to LTO or otherwise).

Ah, right. It also doesn't generate warnings when I build defconfig
with LTO, so clearly something confuses objtool here.

Sami
