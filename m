Return-Path: <SRS0=HESx=D5=lists.openwall.com=kernel-hardening-return-20250-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A58C388F7
	for <kernel-hardening@archiver.kernel.org>; Thu, 22 Oct 2020 08:56:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E760F2417D
	for <kernel-hardening@archiver.kernel.org>; Thu, 22 Oct 2020 08:56:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Z4BFwptn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E760F2417D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20250-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24554 invoked by uid 550); 22 Oct 2020 08:56:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24532 invoked from network); 22 Oct 2020 08:56:10 -0000
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1603356958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ojGGOmyqZOn9deo18ZQqA8PIsqfWBeKBx2jzeHyxdLY=;
	b=Z4BFwptnmLknuUyFcGlTKXOD17CwxaSDci8EpCxD/QzsyWwGgNeDGdYAPxqoVuvOCrdLGw
	icQR860n//NL5qAz06UzZf/8y8Ikjr2u7/Tz+JeNXxJNG3WFT8x40pYX1wYGwK2hs1q4c3
	5b5oUEgz+C+eYglBXQDarIvSK/TDlzY=
Date: Thu, 22 Oct 2020 10:55:57 +0200
From: Michal Hocko <mhocko@suse.com>
To: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>,
	"Guilherme G. Piccoli" <gpiccoli@canonical.com>, linux-mm@kvack.org,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org,
	linux-security-module@vger.kernel.org, kernel@gpiccoli.net,
	cascardo@canonical.com, Alexander Potapenko <glider@google.com>,
	James Morris <jamorris@linux.microsoft.com>,
	Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] mm, hugetlb: Avoid double clearing for hugetlb pages
Message-ID: <20201022085557.GK23790@dhcp22.suse.cz>
References: <20201019182853.7467-1-gpiccoli@canonical.com>
 <20201020082022.GL27114@dhcp22.suse.cz>
 <9cecd9d9-e25c-4495-50e2-8f7cb7497429@canonical.com>
 <20201021061538.GA23790@dhcp22.suse.cz>
 <0ad2f879-7c72-3eef-5cb6-dee44265eb82@redhat.com>
 <20201021113114.GC23790@dhcp22.suse.cz>
 <7c47c5f1-2d7e-eb7a-b8ce-185d715f5cfe@oracle.com>
 <dc49a38c-7be6-5f32-94f5-0de82ed77b53@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc49a38c-7be6-5f32-94f5-0de82ed77b53@redhat.com>

On Thu 22-10-20 10:04:50, David Hildenbrand wrote:
[...]
> > None of that would address the original point of this thread, the global
> > init_on_alloc parameter.
> 
> Yes, but I guess we're past that: whatever leaves the buddy shall be
> zeroed out. That's the whole point of that security hardening mechanism.

Hugetlb can control its zeroying behavior via mount option (for
MAP_HUGETLB controled by a command line parameter). If the page fault
handler can recognize the pre-initialized pages then both init_on* can
be implemented along with such a hugetlb specific mechanism.
-- 
Michal Hocko
SUSE Labs
