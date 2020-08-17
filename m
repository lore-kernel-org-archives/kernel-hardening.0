Return-Path: <SRS0=/+dg=B3=lists.openwall.com=kernel-hardening-return-19644-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A38C433E1
	for <kernel-hardening@archiver.kernel.org>; Mon, 17 Aug 2020 11:54:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B2F2C20674
	for <kernel-hardening@archiver.kernel.org>; Mon, 17 Aug 2020 11:54:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cUo2YqnI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2F2C20674
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19644-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13482 invoked by uid 550); 17 Aug 2020 11:54:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13459 invoked from network); 17 Aug 2020 11:54:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CPagJq8bfLV5JHleSz/YdyHxTxcPKxeM2AT318YsVDU=;
        b=cUo2YqnIduCfkp3HRFHUsby0zIh4dQYG3sMlKf28FS6lSwIo6RgJH+LytxK18B2Xwv
         CKGCwVlOVoB0vdx09P+hquL2g0fnLEFIl6278frwEGWyWh0wgn/FvpnULmcjwCMz4P1m
         QvOeSCUuHTNcDLC2nwxNGjoTp1xDchiJDXN4AKsy9QdAk3z3fxrZukSimZOz1mSFoEIM
         oenaufwaX+LZD3rAy7UYelrnzOy5gZWXAtEiJJlBEQfRb+iUgUW/mdb4BbuOnqpNqx/A
         l6MKMdZZ/IeSpillNWWS64wACRvp7VRH+Zs+o5syOFhQFzaMuHD9BMXIMcqXebI9ga5j
         Xmkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CPagJq8bfLV5JHleSz/YdyHxTxcPKxeM2AT318YsVDU=;
        b=uXdCc8bJS+WzKhevRI8Ro0oBVv5B+S9b+uRWQMnVu+PNLvgd1drQx6kAZzDo/gd/5i
         l4G7wXH5n6W77Q3zQyAGcgnX4ZJD2dMgu8d3YoopKChTcBrS8nZDCOAYWJDqT6rp2hfM
         lpv+O8Vy1i1Muwo3UEjpKfH4kAGslIW8+D5Hibvj3chcPv3GJk0JZlGrxnHaZOKMQlvA
         KcCN2FsFLb+cfeorhU0UgJDR0sRcM7n/aRxnrsReCL44UizH3mWi0xkIJ4tJATIT2ibE
         TNqhpnjpbzwtx+wD5z8JoJW1QRF72PyVgVqPZkb9fjRRc4CcbARsDbNmfSXmEY+H1ff7
         Qgcg==
X-Gm-Message-State: AOAM533xfKLM4P9eIeHqH9aEAa109WCrbPYXWvT+Ds+sHB0SYrpf0Z7U
	lnLB+duhYOY6wJL825ASuCgcovyQdEfA2ka5KhVtfQ==
X-Google-Smtp-Source: ABdhPJxQsY+haVSQeWnKsAs3ixBm6FjQ0//5YkN0AYGeNZHDelu/iOrnxxlOSVO5MvjaUD8VZOIX74GJgLknb82gmsU=
X-Received: by 2002:a65:680b:: with SMTP id l11mr3369972pgt.440.1597665241999;
 Mon, 17 Aug 2020 04:54:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200813151922.1093791-1-alex.popov@linux.com>
 <20200813151922.1093791-2-alex.popov@linux.com> <202008150939.A994680@keescook>
In-Reply-To: <202008150939.A994680@keescook>
From: Andrey Konovalov <andreyknvl@google.com>
Date: Mon, 17 Aug 2020 13:53:51 +0200
Message-ID: <CAAeHK+yPFoQZanzjXBty8rM9eY4thv+ThdHX7mz-sgeg147F7w@mail.gmail.com>
Subject: Re: [PATCH RFC 1/2] mm: Extract SLAB_QUARANTINE from KASAN
To: Kees Cook <keescook@chromium.org>, Alexander Popov <alex.popov@linux.com>
Cc: Jann Horn <jannh@google.com>, Will Deacon <will@kernel.org>, 
	Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
	David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Peter Zijlstra <peterz@infradead.org>, Krzysztof Kozlowski <krzk@kernel.org>, 
	Patrick Bellasi <patrick.bellasi@arm.com>, David Howells <dhowells@redhat.com>, 
	Eric Biederman <ebiederm@xmission.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Laura Abbott <labbott@redhat.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kasan-dev <kasan-dev@googlegroups.com>, 
	Linux Memory Management List <linux-mm@kvack.org>, kernel-hardening@lists.openwall.com, 
	LKML <linux-kernel@vger.kernel.org>, notify@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, Aug 15, 2020 at 6:52 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Aug 13, 2020 at 06:19:21PM +0300, Alexander Popov wrote:
> > Heap spraying is an exploitation technique that aims to put controlled
> > bytes at a predetermined memory location on the heap. Heap spraying for
> > exploiting use-after-free in the Linux kernel relies on the fact that on
> > kmalloc(), the slab allocator returns the address of the memory that was
> > recently freed. Allocating a kernel object with the same size and
> > controlled contents allows overwriting the vulnerable freed object.
> >
> > Let's extract slab freelist quarantine from KASAN functionality and
> > call it CONFIG_SLAB_QUARANTINE. This feature breaks widespread heap
> > spraying technique used for exploiting use-after-free vulnerabilities
> > in the kernel code.
> >
> > If this feature is enabled, freed allocations are stored in the quarantine
> > and can't be instantly reallocated and overwritten by the exploit
> > performing heap spraying.

[...]

> In doing this extraction, I wonder if function naming should be changed?
> If it's going to live a new life outside of KASAN proper, maybe call
> these functions quarantine_cache_*()? But perhaps that's too much
> churn...

If quarantine is to be used without the rest of KASAN, I'd prefer for
it to be separated from KASAN completely: move to e.g. mm/quarantine.c
and don't mention KASAN in function/config names.
