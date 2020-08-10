Return-Path: <SRS0=E21y=BU=lists.openwall.com=kernel-hardening-return-19575-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97CEEC433E1
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Aug 2020 16:11:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E93122073E
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Aug 2020 16:11:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E93122073E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19575-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13706 invoked by uid 550); 10 Aug 2020 16:11:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13683 invoked from network); 10 Aug 2020 16:11:01 -0000
IronPort-SDR: ZC+455sg6W9cVf7vJihrYf/YnbU0MJahBfhEkygfnO3TnqxcYlESHUGOPlwy+QuvhSf0i04oDt
 J3Fjxrjugvvw==
X-IronPort-AV: E=McAfee;i="6000,8403,9709"; a="238393760"
X-IronPort-AV: E=Sophos;i="5.75,458,1589266800"; 
   d="scan'208";a="238393760"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: L0fGK7Oc41XXt/uCpVijKONSkPdWYSy53uICatG+sIVZajt8GK0hK7Me29p68sdmSoSBzhgOHo
 z8ekofBUjVhg==
X-IronPort-AV: E=Sophos;i="5.75,458,1589266800"; 
   d="scan'208";a="494847826"
Message-ID: <6b96dcb30b9e1ab1638979c09462614aa2976721.camel@linux.intel.com>
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com, x86@kernel.org, 
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, 
	rick.p.edgecombe@intel.com, live-patching@vger.kernel.org
Date: Mon, 10 Aug 2020 09:10:41 -0700
In-Reply-To: <202008071019.BF206AE8BD@keescook>
References: <20200717170008.5949-1-kristen@linux.intel.com>
	 <20200804182359.GA23533@redhat.com>
	 <f8963aab93243bc046791dba6af5d006e15c91ff.camel@linux.intel.com>
	 <202008071019.BF206AE8BD@keescook>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Fri, 2020-08-07 at 10:20 -0700, Kees Cook wrote:
> On Fri, Aug 07, 2020 at 09:38:11AM -0700, Kristen Carlson Accardi
> wrote:
> > Thanks for testing. Yes, Josh and I have been discussing the
> > orc_unwind
> > issues. I've root caused one issue already, in that objtool places
> > an
> > orc_unwind_ip address just outside the section, so my algorithm
> > fails
> > to relocate this address. There are other issues as well that I
> > still
> > haven't root caused. I'll be addressing this in v5 and plan to have
> > something that passes livepatch testing with that version.
> 
> FWIW, I'm okay with seeing fgkaslr be developed progressively.
> Getting
> it working with !livepatching would be fine as a first step. There's
> value in getting the general behavior landed, and then continuing to
> improve it.
> 

In this case, part of the issue with livepatching appears to be a more
general issue with objtool and how it creates the orc unwind entries
when you have >64K sections. So livepatching is a good test case for
making sure that the orc tables are actually correct. However, the
other issue with livepatching (the duplicate symbols), might be worth
deferring if the solution is complex - I will keep that in mind as I
look at it more closely.


