Return-Path: <SRS0=fXtl=VU=lists.openwall.com=kernel-hardening-return-16558-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A277C7618B
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 14:54:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D8F67223A0
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 14:54:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qXzwwQuB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8F67223A0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16558-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29851 invoked by uid 550); 23 Jul 2019 14:54:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29827 invoked from network); 23 Jul 2019 14:54:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h4KWYzLiz8Q76GJXEl0Zz0b7uhOVauu+r5qbYmNBT7A=;
        b=qXzwwQuBz/BmI26lbVCqNhkrQrcAoVMmFk29raVO7XCfT+iYt7qIl5aMn+cE0enLiD
         3+xaEvX2sNlGH8nkUL47bNlG38bxXHpFIXUqMIM/39Zba78y5N1D9sev9Ti45+6yKvFo
         fnptNuTBEsfw1q7trWYvR9MRl1i1CmZJ81dZIrb9qrELPtiW892ktHWMpqYVyezzutph
         EzfwjamCsf8fVFG4I08D2wdsCJDH1gV8GIksnHln9mgLPk0eckvQ9VliameBuufWzcy4
         PlTOxHKX/9Vzj1mpMqG7PlDpXbg/JnOaAe+W5cw6SU3DpVodIr8KnfpprqFivQ+asM2D
         WWrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h4KWYzLiz8Q76GJXEl0Zz0b7uhOVauu+r5qbYmNBT7A=;
        b=FpJUL499vt+uFmdXB6yjSZ1gUmgcvtEaSOt17HlhcJBTSsWQ2EPSvMmhrmv1B65sge
         Dd94MO5JZny2Mp00nLPD1Ep7c7N/5r/sROAqQBkp3u4yYgNPOChltdia6UIiRuTRghU0
         +S3MabTTEZG1JiUUlutaZDkXnWk0nnx7irPmZoNROy1ckUD3+Qu8lvRQurtA9jkyALGU
         sUpxexsmM/kLBXd5+LrXGJFjqiWIbgdUC3h2loKTclCTw4cM8yq+5gUQQiJsdHRx4FpP
         GVSFw4ep+QYOe+x9KmsaWRjPShGRQkZtwXjKciaF7Y2fYNwgRQLrtKa42SfCLQXawDjy
         QdJA==
X-Gm-Message-State: APjAAAUFcu1vVYTpBeQtUPgvBwFAMwtkvofn/vRBcQRx7e4kkQvsd/wP
	DYrLXpQ0lu9BmW5L62nQ6fcl42vGPOjlmKsuSL/dEw==
X-Google-Smtp-Source: APXvYqz6MT1sE9TYkC+Gt3TnmGvb96tCIp+1WidsrIqgtwnzoYqgfblBqQU7t6GJZutpN2xUNv4oxyMInzb5C00uRSI=
X-Received: by 2002:a9d:812:: with SMTP id 18mr48441341oty.180.1563893653534;
 Tue, 23 Jul 2019 07:54:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190722113151.1584-1-nitin.r.gote@intel.com> <CAFqZXNs5vdQwoy2k=_XLiGRdyZCL=n8as6aL01Dw-U62amFREA@mail.gmail.com>
In-Reply-To: <CAFqZXNs5vdQwoy2k=_XLiGRdyZCL=n8as6aL01Dw-U62amFREA@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 23 Jul 2019 16:53:47 +0200
Message-ID: <CAG48ez3zRoB7awMdb-koKYJyfP9WifTLevxLxLHioLhH=itZ-A@mail.gmail.com>
Subject: Re: [PATCH] selinux: convert struct sidtab count to refcount_t
To: Ondrej Mosnacek <omosnace@redhat.com>
Cc: NitinGote <nitin.r.gote@intel.com>, Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, 
	SElinux list <selinux@vger.kernel.org>, 
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jul 22, 2019 at 3:44 PM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> On Mon, Jul 22, 2019 at 1:35 PM NitinGote <nitin.r.gote@intel.com> wrote:
> > refcount_t type and corresponding API should be
> > used instead of atomic_t when the variable is used as
> > a reference counter. This allows to avoid accidental
> > refcounter overflows that might lead to use-after-free
> > situations.
> >
> > Signed-off-by: NitinGote <nitin.r.gote@intel.com>
>
> Nack.
>
> The 'count' variable is not used as a reference counter here. It
> tracks the number of entries in sidtab, which is a very specific
> lookup table that can only grow (the count never decreases). I only
> made it atomic because the variable is read outside of the sidtab's
> spin lock and thus the reads and writes to it need to be guaranteed to
> be atomic. The counter is only updated under the spin lock, so
> insertions do not race with each other.

Probably shouldn't even be atomic_t... quoting Documentation/atomic_t.txt:

| SEMANTICS
| ---------
|
| Non-RMW ops:
|
| The non-RMW ops are (typically) regular LOADs and STOREs and are canonically
| implemented using READ_ONCE(), WRITE_ONCE(), smp_load_acquire() and
| smp_store_release() respectively. Therefore, if you find yourself only using
| the Non-RMW operations of atomic_t, you do not in fact need atomic_t at all
| and are doing it wrong.

So I think what you actually want here is a plain "int count", and then:
 - for unlocked reads, either READ_ONCE()+smp_rmb() or smp_load_acquire()
 - for writes, either smp_wmb()+WRITE_ONCE() or smp_store_release()

smp_load_acquire() and smp_store_release() are probably the nicest
here, since they are semantically clearer than smp_rmb()/smp_wmb().
