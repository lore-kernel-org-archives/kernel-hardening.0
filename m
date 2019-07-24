Return-Path: <SRS0=O6AQ=VV=lists.openwall.com=kernel-hardening-return-16574-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEB01C7618B
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jul 2019 14:29:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3B237217F4
	for <kernel-hardening@archiver.kernel.org>; Wed, 24 Jul 2019 14:29:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hqv8AC23"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B237217F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16574-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17467 invoked by uid 550); 24 Jul 2019 14:29:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17442 invoked from network); 24 Jul 2019 14:29:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=07WBpiUlOYIZ7+P49JY1jjRjsEVdVyLwuxczlg4O6CI=;
        b=Hqv8AC23ggzMBGj+XNz87q/bwhtAZqBW9K01CFg1Ke4/U1wAGhKmppexKCc4EGZOyl
         KrTl6bgaWESUyaEOsfnVY1iFH3FefGe2ETp/hGkkAdl3KKTge7AhOe+NAXu6IwCsvfR6
         beRC9TM/51Cg2MPPRud6dSvT0IKTOFQha/L7UIs1hoB7whP7edTHVyTP6mVie6n/R6Kh
         YA+NmOmL5PyVoli5LE8MRCrmBDkOjgYnZcy5rHDoGoc9grpRKF8HOLj5QGncs2JshFZo
         m9vTH0j8dZ47bJeb/1sn59Q6cmVatCE7m+8hwbuPCkLIyKRIVTtoGquFd4SZtWThYaMF
         223w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=07WBpiUlOYIZ7+P49JY1jjRjsEVdVyLwuxczlg4O6CI=;
        b=M1tMJeOCMuMuW+8/x4ZHH8MmVXd87klMLdvkZ/N+0OEEW9TjUBEQHBAYZX1xyzWiaz
         pgfgylzmvTvc2A5GynYfvJcu5OxxAePFJArCovYlCnM379jKDq4sheVnb4U3a5ruLXL9
         fCDmOfXC/qjBR6hTiLYG6BvfI1KQQbFvmJhTXJviCJBgOa/ZUWzQEQoWDGUoMdEJ7x2Q
         n4WcFm9YgR43MB/hjWCVj9tfEei/Zd7y7NmiSQII7IXrFsaaI96vcve2orTbKVA7CgJp
         fd0rMOeoeMEbknnTLwM+2J8kJg+EEkRYDKzYILOEYQ7WT0xjNJcigKuwNkKfuvsd9R+p
         LCoQ==
X-Gm-Message-State: APjAAAVfBejaiaOHYjr2AHKMXpgqc7WBiPFaWyXK8BKudoOTUt9rlbCI
	6ype0Fz9Iyx9+G6wJsL/MEjhHDTlV90P3X89UOSCig==
X-Google-Smtp-Source: APXvYqzqMTdf8CPoruUPhw4URkBpdrabgibucjn8aLFByJaBJKYxxZjQtyWMUVa0kX6ewYeRZEUPdgw0udWGwYfMCyA=
X-Received: by 2002:aca:3dd7:: with SMTP id k206mr37007062oia.47.1563978537976;
 Wed, 24 Jul 2019 07:28:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190722113151.1584-1-nitin.r.gote@intel.com> <CAFqZXNs5vdQwoy2k=_XLiGRdyZCL=n8as6aL01Dw-U62amFREA@mail.gmail.com>
 <CAG48ez3zRoB7awMdb-koKYJyfP9WifTLevxLxLHioLhH=itZ-A@mail.gmail.com> <201907231516.11DB47AA@keescook>
In-Reply-To: <201907231516.11DB47AA@keescook>
From: Jann Horn <jannh@google.com>
Date: Wed, 24 Jul 2019 16:28:31 +0200
Message-ID: <CAG48ez2eXJwE+vS2_ahR9Vuc3qD8O4CDZ5Lh6DcrrOq+7VKOYQ@mail.gmail.com>
Subject: Re: [PATCH] selinux: convert struct sidtab count to refcount_t
To: Kees Cook <keescook@chromium.org>
Cc: Ondrej Mosnacek <omosnace@redhat.com>, NitinGote <nitin.r.gote@intel.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Paul Moore <paul@paul-moore.com>, 
	Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, 
	SElinux list <selinux@vger.kernel.org>, 
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 24, 2019 at 12:17 AM Kees Cook <keescook@chromium.org> wrote:
> On Tue, Jul 23, 2019 at 04:53:47PM +0200, Jann Horn wrote:
> > On Mon, Jul 22, 2019 at 3:44 PM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> > > On Mon, Jul 22, 2019 at 1:35 PM NitinGote <nitin.r.gote@intel.com> wrote:
> > > > refcount_t type and corresponding API should be
> > > > used instead of atomic_t when the variable is used as
> > > > a reference counter. This allows to avoid accidental
> > > > refcounter overflows that might lead to use-after-free
> > > > situations.
> > > >
> > > > Signed-off-by: NitinGote <nitin.r.gote@intel.com>
> > >
> > > Nack.
> > >
> > > The 'count' variable is not used as a reference counter here. It
> > > tracks the number of entries in sidtab, which is a very specific
> > > lookup table that can only grow (the count never decreases). I only
> > > made it atomic because the variable is read outside of the sidtab's
> > > spin lock and thus the reads and writes to it need to be guaranteed to
> > > be atomic. The counter is only updated under the spin lock, so
> > > insertions do not race with each other.
> >
> > Probably shouldn't even be atomic_t... quoting Documentation/atomic_t.txt:
> >
> > | SEMANTICS
> > | ---------
> > |
> > | Non-RMW ops:
> > |
> > | The non-RMW ops are (typically) regular LOADs and STOREs and are canonically
> > | implemented using READ_ONCE(), WRITE_ONCE(), smp_load_acquire() and
> > | smp_store_release() respectively. Therefore, if you find yourself only using
> > | the Non-RMW operations of atomic_t, you do not in fact need atomic_t at all
> > | and are doing it wrong.
> >
> > So I think what you actually want here is a plain "int count", and then:
> >  - for unlocked reads, either READ_ONCE()+smp_rmb() or smp_load_acquire()
> >  - for writes, either smp_wmb()+WRITE_ONCE() or smp_store_release()
> >
> > smp_load_acquire() and smp_store_release() are probably the nicest
> > here, since they are semantically clearer than smp_rmb()/smp_wmb().
>
> Perhaps we need a "statistics" counter type for these kinds of counters?
> "counter_t"? I bet there are a lot of atomic_t uses that are just trying
> to be counters. (likely most of atomic_t that isn't now refcount_t ...)

This isn't a statistics counter though; this thing needs ordered
memory accesses, which you wouldn't need for statistics.
