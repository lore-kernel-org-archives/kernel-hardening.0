Return-Path: <SRS0=cvrJ=D6=lists.openwall.com=kernel-hardening-return-20254-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCCF2C388F9
	for <kernel-hardening@archiver.kernel.org>; Fri, 23 Oct 2020 08:23:39 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D724720EDD
	for <kernel-hardening@archiver.kernel.org>; Fri, 23 Oct 2020 08:23:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VXC9zIFb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D724720EDD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20254-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5316 invoked by uid 550); 23 Oct 2020 08:23:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5283 invoked from network); 23 Oct 2020 08:23:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1603441398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vrrCnJClB594lCGc07GMK4Rm/U9anNocYatjSBsoBao=;
	b=VXC9zIFbexGR5qaBATU0YT39IdhKzDD7GixEdsciYM6mzw7CDaR7wkwEXy/hVh4evUWrd9
	3V15tj3CZ3s5gr0SbJmlwJvbrjJWPeTxi4my7Z3yKz15Gt5CqZ6KKcjCnE7TcmIN4A1UYN
	fP3d/Xu66QpwoMV4ULgHneJbJsoKin8=
X-MC-Unique: LvyKSZ3rPSmO7Y_naD5FQQ-1
Subject: Re: [PATCH] mm, hugetlb: Avoid double clearing for hugetlb pages
To: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>,
 "Guilherme G. Piccoli" <gpiccoli@canonical.com>, linux-mm@kvack.org,
 kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org,
 linux-security-module@vger.kernel.org, kernel@gpiccoli.net,
 cascardo@canonical.com, Alexander Potapenko <glider@google.com>,
 James Morris <jamorris@linux.microsoft.com>,
 Kees Cook <keescook@chromium.org>
References: <20201019182853.7467-1-gpiccoli@canonical.com>
 <20201020082022.GL27114@dhcp22.suse.cz>
 <9cecd9d9-e25c-4495-50e2-8f7cb7497429@canonical.com>
 <20201021061538.GA23790@dhcp22.suse.cz>
 <0ad2f879-7c72-3eef-5cb6-dee44265eb82@redhat.com>
 <20201021113114.GC23790@dhcp22.suse.cz>
 <7c47c5f1-2d7e-eb7a-b8ce-185d715f5cfe@oracle.com>
 <dc49a38c-7be6-5f32-94f5-0de82ed77b53@redhat.com>
 <20201022085557.GK23790@dhcp22.suse.cz>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <634a44b5-5947-df02-be63-a68f7b317949@redhat.com>
Date: Fri, 23 Oct 2020 10:23:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201022085557.GK23790@dhcp22.suse.cz>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=david@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 22.10.20 10:55, Michal Hocko wrote:
> On Thu 22-10-20 10:04:50, David Hildenbrand wrote:
> [...]
>>> None of that would address the original point of this thread, the global
>>> init_on_alloc parameter.
>>
>> Yes, but I guess we're past that: whatever leaves the buddy shall be
>> zeroed out. That's the whole point of that security hardening mechanism.
> 
> Hugetlb can control its zeroying behavior via mount option (for
> MAP_HUGETLB controled by a command line parameter). If the page fault
> handler can recognize the pre-initialized pages then both init_on* can

Right, looking at init_on_alloc tells you if you have to zero after
alloc or if it's already been done even though you didn't pass GFP_ZERO.

-- 
Thanks,

David / dhildenb

