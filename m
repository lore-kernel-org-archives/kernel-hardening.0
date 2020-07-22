Return-Path: <SRS0=5sZb=BB=lists.openwall.com=kernel-hardening-return-19407-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C9F3C433E2
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 15:06:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AD16C20658
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 15:06:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bU8EdgRf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD16C20658
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19407-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1882 invoked by uid 550); 22 Jul 2020 15:06:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30598 invoked from network); 22 Jul 2020 14:51:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1595429499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T+UMFueXPyO+OYg0tEXFd38585DEj4VDz/fSAnWATcs=;
	b=bU8EdgRfAVZ38ZOIJfFIEIIebHB+/cFgS7bdmPBAfnpJ9bdA9kxB84ge7FiPw6Xs8gK1db
	DIUEvWTgt+N+HBSQ5uynDVP0S7qXTzJlAp8qRLCY73YbedmNQJ1QAbbeu0vXreV1TuopFA
	Rb9On0JZSSInfKZiotLz2m4vamjrXa8=
X-MC-Unique: k2Ojwp5FNQqfZxCKnHF9nQ-1
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
To: Kees Cook <keescook@chromium.org>, Miroslav Benes <mbenes@suse.cz>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>, tglx@linutronix.de,
 mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com, x86@kernel.org,
 linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
 rick.p.edgecombe@intel.com, live-patching@vger.kernel.org
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <202007220738.72F26D2480@keescook>
From: Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <aa51eb26-e2a9-c448-a3b8-e9e68deeb468@redhat.com>
Date: Wed, 22 Jul 2020 10:51:32 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <202007220738.72F26D2480@keescook>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16

On 7/22/20 10:39 AM, Kees Cook wrote:
> On Wed, Jul 22, 2020 at 11:27:30AM +0200, Miroslav Benes wrote:
>> Let me CC live-patching ML, because from a quick glance this is something
>> which could impact live patching code. At least it invalidates assumptions
>> which "sympos" is based on.
> 
> In a quick skim, it looks like the symbol resolution is using
> kallsyms_on_each_symbol(), so I think this is safe? What's a good
> selftest for live-patching?
> 

Hi Kees,

I don't think any of the in-tree tests currently exercise the 
kallsyms/sympos end of livepatching.

I do have a local branch that does facilitate creating klp-relocations 
that do rely upon this feature -- I'll try to see if I can get those 
working with this patchset and report back later this week.

-- Joe

