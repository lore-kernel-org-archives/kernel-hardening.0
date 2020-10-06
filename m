Return-Path: <SRS0=H+KR=DN=lists.openwall.com=kernel-hardening-return-20107-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB10C4363A
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Oct 2020 02:20:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2E04920870
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Oct 2020 02:20:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XhNVw1+T"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E04920870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20107-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13483 invoked by uid 550); 6 Oct 2020 02:19:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13462 invoked from network); 6 Oct 2020 02:19:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5RQGQQnzUDnv0mOraeBJTeR9VvHirvaV4JaPm4c+FnM=;
        b=XhNVw1+TBfKHXDS9ILNRhsKTwQkADm6bKZt0zmGoCf9RgtxlAMSHmVejVLnM+hlQ92
         9h1bZRhd7XNx+Pyw4umW8tO3rsbDSYAT7TFN/BzcPFURPd/PbJaqRc0mm9uvXokDH8UD
         twLL6dA+UDImJ+xLxiFncIkwWOcVKLiIe+8/9fcDubmIl8YA6uqSmPA/Wop8j+DGiOzn
         fGXMDXhS5LJFaU/q4N03ythlCP8rgQPXyZn2wsuvvHKD6yWdvHdfCyoIUA5mgHl+16us
         9bIcRZ+VPstpHqmqgrQIz0bq7JqtPJa7d80mrw+1cbzqCm/yjj5Nqh6LXLQdB0eZfSqU
         kSxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5RQGQQnzUDnv0mOraeBJTeR9VvHirvaV4JaPm4c+FnM=;
        b=XM3sFUflnDptgft699mpCIAL6EPyiQ1oUpIPfj72liayr9WKDRGrUAxpHgsZCVg7IO
         ej2gp5vdDTxZQ9JrbGfABruVg3NJiHekcin7Cbqt8kySv2YimxZKgOQ/YpnhPVeOIeLr
         yuxFuxrLadlDsrSbhNPIsDEMtzhhQeiGOv5Viwx7rHCC1lfv7ODXfM+NH9hCgQKaI1mS
         uTFeRUx97dYYrz5uS+YjGhuuzqTxtNqWPBxBwyOxiMqJqE5czOLXMIqD3MkhxPeYWSCn
         nL4AIwXNHu5EV9q1Z/oCJQ/n6eEqKRUGTOOV7oU6Fx+UvbnGG7tgHh9IO6EyJo4uTsdQ
         7IdA==
X-Gm-Message-State: AOAM5314OTZ+gSHAOJBS+bj8xGwPEQjPUmGUyFVvVKaSMnyeTXaMvMiN
	p2+Jhro9VWc5jhg7nO47G2r6AGHjzzdWIJSLvHE=
X-Google-Smtp-Source: ABdhPJxdtW1KHo9nm8XsftaIlbJ6Jt+UypzA4SMemizIx7+yhJ4RSe/qGU0OzOwdpL5vrNU/i9b2ut1DDWsxfYGMJEE=
X-Received: by 2002:a17:906:7d52:: with SMTP id l18mr2771101ejp.220.1601950787443;
 Mon, 05 Oct 2020 19:19:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200929183513.380760-1-alex.popov@linux.com> <91d564a6-9000-b4c5-15fd-8774b06f5ab0@linux.com>
 <CAG48ez1tNU_7n8qtnxTYZ5qt-upJ81Fcb0P2rZe38ARK=iyBkA@mail.gmail.com>
 <20201006004414.GP20115@casper.infradead.org> <202010051905.62D79560@keescook>
In-Reply-To: <202010051905.62D79560@keescook>
From: Daniel Micay <danielmicay@gmail.com>
Date: Mon, 5 Oct 2020 22:19:10 -0400
Message-ID: <CA+DvKQ+-k9pk1mUrEiTRKzSsz1ugCiv1A3Owd97dop0HPXa6MA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 0/6] Break heap spraying needed for exploiting use-after-free
To: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <willy@infradead.org>, Jann Horn <jannh@google.com>, 
	Alexander Popov <alex.popov@linux.com>, Will Deacon <will@kernel.org>, 
	Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, 
	David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Peter Zijlstra <peterz@infradead.org>, Krzysztof Kozlowski <krzk@kernel.org>, 
	Patrick Bellasi <patrick.bellasi@arm.com>, David Howells <dhowells@redhat.com>, 
	Eric Biederman <ebiederm@xmission.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Laura Abbott <labbott@redhat.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrey Konovalov <andreyknvl@google.com>, 
	Pavel Machek <pavel@denx.de>, Valentin Schneider <valentin.schneider@arm.com>, 
	kasan-dev <kasan-dev@googlegroups.com>, Linux-MM <linux-mm@kvack.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	kernel list <linux-kernel@vger.kernel.org>, notify@kernel.org
Content-Type: text/plain; charset="UTF-8"

It will reuse the memory for other things when the whole slab is freed
though. Not really realistic to change that without it being backed by
virtual memory along with higher-level management of regions to avoid
intense fragmentation and metadata waste. It would depend a lot on
having much finer-grained slab caches, otherwise it's not going to be
much of an alternative to a quarantine feature. Even then, a
quarantine feature is still useful, but is less suitable for a
mainstream feature due to performance cost. Even a small quarantine
has a fairly high performance cost.
