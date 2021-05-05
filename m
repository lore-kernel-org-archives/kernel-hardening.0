Return-Path: <SRS0=3aqd=KA=lists.openwall.com=kernel-hardening-return-21236-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F03A4C433ED
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 06:25:55 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 027B761002
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 May 2021 06:25:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 027B761002
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21236-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11668 invoked by uid 550); 5 May 2021 06:25:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11633 invoked from network); 5 May 2021 06:25:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=R97okrrT1ZR3nAmwWW6z4OxB86R8rXbhMKoQVYu9dd4=;
        b=ns8vvV1Qo1QZc0J0GCqe2q2V5F0oFWwYAmbWDMmx7uVV7+gwRXWIDYJREfCKTuxZs2
         wIqUtWMg6NwDe/gc16gCZL7CPHrQcl845Wr7bS9w0L9Igv5JLk8cXPN/m8SY78GMkIXt
         /G/Zy48px0xpleaxPam7W4wMLM3zxCYEEQd94=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=R97okrrT1ZR3nAmwWW6z4OxB86R8rXbhMKoQVYu9dd4=;
        b=MUHx+MALeQ6clk8F1Or1leuXk34I4g5eNYbiw0q+ng1CH6L/kKG9AHirOJ2le+PJmB
         muYKkGJqL0PXu18S5kTlhc2DB614J4EQzUlKIOxXn50GLBNL4K4WrkHy7QAn3pTKg8J3
         yHSLBHdKYFT1goBMlVTOjIXaMrRl/ezuOb2swFd4l7nr1F3TN3ViR9m9/LATq74F34JD
         xGtCgrm1ttQiYlyliO2H1rkX9S3yPBHCZ3tDaHYOAeW8R2yC5V7hzGfxqzmdgK9rA1dn
         kGhchK7NTk+3l0YxngF9ZRsxg89UDceOFx9e/VcUCdPrIb9jEVUVbbeXQ/eix6VmOobZ
         1MfQ==
X-Gm-Message-State: AOAM533nyqbfNn/wO3gMJnWddWAbAxJYOpk+DtPj3SmEK8ieQ+AaUub/
	t8OFq5H70CDA8tJ9K3qdCH8NAg==
X-Google-Smtp-Source: ABdhPJyyFwabQwvnS1ulWRW160zd3aj383RgdjKZyVc1Alzp4aC2H+g6nFGuTTkCJgHz/TUp24HBww==
X-Received: by 2002:a63:8f15:: with SMTP id n21mr26183891pgd.366.1620195933437;
        Tue, 04 May 2021 23:25:33 -0700 (PDT)
Date: Tue, 4 May 2021 23:25:31 -0700
From: Kees Cook <keescook@chromium.org>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: dave.hansen@intel.com, luto@kernel.org, peterz@infradead.org,
	linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com, ira.weiny@intel.com,
	rppt@kernel.org, dan.j.williams@intel.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 0/9] PKS write protected page tables
Message-ID: <202105042253.ECBBF6B6@keescook>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210505003032.489164-1-rick.p.edgecombe@intel.com>

On Tue, May 04, 2021 at 05:30:23PM -0700, Rick Edgecombe wrote:
> This is a POC for write protecting page tables with PKS (Protection Keys for 
> Supervisor) [1]. The basic idea is to make the page tables read only, except 
> temporarily on a per-cpu basis when they need to be modified. I’m looking for 
> opinions on whether people like the general direction of this in terms of 
> value and implementation.

Yay!

> Why would people want this?
> ===========================
> Page tables are the basis for many types of protections and as such, are a 
> juicy target for attackers. Mapping them read-only will make them harder to 
> use in attacks.
> 
> This protects against an attacker that has acquired the ability to write to 
> the page tables. It's not foolproof because an attacker who can execute 
> arbitrary code can either disable PKS directly, or simply call the same 
> functions that the kernel uses for legitimate page table writes.

I think it absolutely has value. The exploit techniques I'm aware of that
target the page table are usually attempting to upgrade an arbitrary
write into execution (e.g. write to kernel text after setting kernel
text writable in the page table) or similar "data only" attacks (make
sensitive page writable).

It looks like PKS-protected page tables would be much like the
RO-protected text pages in the sense that there is already code in
the kernel to do things to make it writable, change text, and set it
read-only again (alternatives, ftrace, etc). That said, making the PKS
manipulation code be inline to page-writing code would make it less
available for ROP/JOP, if an attack DID want to go that route.

> Why use PKS for this?
> =====================
> PKS is an upcoming CPU feature that allows supervisor virtual memory 
> permissions to be changed without flushing the TLB, like PKU does for user 
> memory. Protecting page tables would normally be really expensive because you 
> would have to do it with paging itself. PKS helps by providing a way to toggle 
> the writability of the page tables with just a per-cpu MSR.

The per-cpu-ness is really important for both performance and for avoiding
temporal attacks where an arbitrary write in one CPU is timed against
a page table write in another CPU.

> Performance impacts
> ===================
> Setting direct map permissions on whatever random page gets allocated for a 
> page table would result in a lot of kernel range shootdowns and direct map 
> large page shattering. So the way the PKS page table memory is created is 
> similar to this module page clustering series[2], where a cache of pages is 
> replenished from 2MB pages such that the direct map permissions and associated 
> breakage is localized on the direct map. In the PKS page tables case, a PKS 
> key is pre-applied to the direct map for pages in the cache.
> 
> There would be some costs of memory overhead in order to protect the direct 
> map page tables. There would also be some extra kernel range shootdowns to 
> replenish the cache on occasion, from setting the PKS key on the direct map of 
> the new pages. I don’t have any actual performance data yet.

What CPU models are expected to have PKS?

> This is based on V6 [1] of the core PKS infrastructure patches. PKS 
> infrastructure follow-on’s are planned to enable keys to be set to the same 
> permissions globally. Since this usage needs a key to be set globally 
> read-only by default, a small temporary solution is hacked up in patch 8. Long 
> term, PKS protected page tables would use a better and more generic solution 
> to achieve this.
> 
> [1] https://lore.kernel.org/lkml/20210401225833.566238-1-ira.weiny@intel.com/

Ah, neat!

> [2] https://lore.kernel.org/lkml/20210405203711.1095940-1-rick.p.edgecombe@intel.com/

Ooh. What does this do for performance? It sounds like less TLB
pressure, IIUC?

-- 
Kees Cook
