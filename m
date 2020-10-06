Return-Path: <SRS0=wW/t=DN=lists.openwall.com=kernel-hardening-return-20103-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB54FC4363A
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Oct 2020 00:49:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CDF5020760
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Oct 2020 00:49:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="deEOQpGo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDF5020760
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20103-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1632 invoked by uid 550); 6 Oct 2020 00:49:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1612 invoked from network); 6 Oct 2020 00:49:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DSqKb3Tej8m7nFeWjbSYdo/k6NG+xT3qX97daJHfAaE=;
        b=deEOQpGoKw7XNYSPULzK/Fx+6FgNXN/khjYZmJenTlrPkh3dV8pR9GRMbNMshg3WBV
         mIhmaC0prowNnpBBfAOgciFl8Aodl0rSQD0jjxo98zbVcb/lVK/w4xzZ8RH7ut5R65D4
         8in1ydpN21OQa+pm2/egla8YAjlb0ivT9qFVlicuCHeu1OSW7e91KAVeVD8rfu51aRDF
         qMQv329ZsWOgNyP21r8aTq6vFJInOWaztNfk0KHDhN4hKlc+rb6zcKrDeoSYKitO8zvC
         oTJCmeqSuf2Nyq1UbdDB7JdyBRZqPMuxwo7izVmribdAB7jmHG8WWxh41wYQuF3rNl4g
         AM2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DSqKb3Tej8m7nFeWjbSYdo/k6NG+xT3qX97daJHfAaE=;
        b=aglOHeYnhl/iOM3woEf3GNEZkhuuRpGU5SJD27gO28lIF5JTpex4wl3PC862uExPln
         rW0yKIwL36kFr8oAYYOn0ZAd8csIkDEHlJT4sKndNcOH+1gRtnGpN+5YFkuuWmfZGl+Q
         9QIyWXqizXCE483aW2SnGxjxnaj57efsByppOP105srjBZXgFSMllDvWIHw/jzZHr5FI
         Qp5mpFkY29bajS4TCsx5SElAdHI5DMY9AFz2/u+l5Tm05Lkdc6EOv6ofFmoXVxV394by
         Fv3R+h/PIITT8KEMApduBRBR0y7s365YwsUnUksDFZ/F4SEuJJWdD+jp+iJSEVK62g6c
         GH5g==
X-Gm-Message-State: AOAM530LjHSNm/vPx9zuFNmHsOBKjseTn1jUtBqXjdoovb7uaJT4DoUR
	YuxVEYSf8Y3CX8SITcFfUhOE2k9ipUkz3H2gPsOVpA==
X-Google-Smtp-Source: ABdhPJzX5TIoNNDa3K+sA4F6j+CIm71wUpd29DPTJfqfilZUUFmdG5N8+VeVzCx8F4tg0u5dyUACMyV8sE4qgDYzfPY=
X-Received: by 2002:a50:fe98:: with SMTP id d24mr2504183edt.223.1601945366080;
 Mon, 05 Oct 2020 17:49:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200929183513.380760-1-alex.popov@linux.com> <91d564a6-9000-b4c5-15fd-8774b06f5ab0@linux.com>
 <CAG48ez1tNU_7n8qtnxTYZ5qt-upJ81Fcb0P2rZe38ARK=iyBkA@mail.gmail.com> <20201006004414.GP20115@casper.infradead.org>
In-Reply-To: <20201006004414.GP20115@casper.infradead.org>
From: Jann Horn <jannh@google.com>
Date: Tue, 6 Oct 2020 02:48:59 +0200
Message-ID: <CAG48ez3VKw=B14r-BeAOxGtPExc-G4FYNymRPgFKUKUMsn5Osw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 0/6] Break heap spraying needed for exploiting use-after-free
To: Matthew Wilcox <willy@infradead.org>
Cc: Alexander Popov <alex.popov@linux.com>, Kees Cook <keescook@chromium.org>, 
	Will Deacon <will@kernel.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Christoph Lameter <cl@linux.com>, 
	Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, 
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Masahiro Yamada <masahiroy@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, 
	Krzysztof Kozlowski <krzk@kernel.org>, Patrick Bellasi <patrick.bellasi@arm.com>, 
	David Howells <dhowells@redhat.com>, Eric Biederman <ebiederm@xmission.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Laura Abbott <labbott@redhat.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Micay <danielmicay@gmail.com>, 
	Andrey Konovalov <andreyknvl@google.com>, Pavel Machek <pavel@denx.de>, 
	Valentin Schneider <valentin.schneider@arm.com>, kasan-dev <kasan-dev@googlegroups.com>, 
	Linux-MM <linux-mm@kvack.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	kernel list <linux-kernel@vger.kernel.org>, notify@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Oct 6, 2020 at 2:44 AM Matthew Wilcox <willy@infradead.org> wrote:
> On Tue, Oct 06, 2020 at 12:56:33AM +0200, Jann Horn wrote:
> > It seems to me like, if you want to make UAF exploitation harder at
> > the heap allocator layer, you could do somewhat more effective things
> > with a probably much smaller performance budget. Things like
> > preventing the reallocation of virtual kernel addresses with different
> > types, such that an attacker can only replace a UAF object with
> > another object of the same type. (That is not an idea I like very much
> > either, but I would like it more than this proposal.) (E.g. some
> > browsers implement things along those lines, I believe.)
>
> The slab allocator already has that functionality.  We call it
> TYPESAFE_BY_RCU, but if forcing that on by default would enhance security
> by a measurable amount, it wouldn't be a terribly hard sell ...

TYPESAFE_BY_RCU just forces an RCU grace period before the
reallocation; I'm thinking of something more drastic, like completely
refusing to give back the memory, or using vmalloc for slabs where
that's safe (reusing physical but not virtual addresses across types).
And, to make it more effective, something like a compiler plugin to
isolate kmalloc(sizeof(<type>)) allocations by type beyond just size
classes.
