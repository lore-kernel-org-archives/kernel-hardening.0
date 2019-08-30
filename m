Return-Path: <SRS0=RAlZ=W2=lists.openwall.com=kernel-hardening-return-16837-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 351D8C3A5A3
	for <kernel-hardening@archiver.kernel.org>; Fri, 30 Aug 2019 04:30:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6F34B22CE3
	for <kernel-hardening@archiver.kernel.org>; Fri, 30 Aug 2019 04:30:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F34B22CE3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fromorbit.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16837-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23610 invoked by uid 550); 30 Aug 2019 04:30:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23574 invoked from network); 30 Aug 2019 04:30:14 -0000
Date: Fri, 30 Aug 2019 14:29:58 +1000
From: Dave Chinner <david@fromorbit.com>
To: Kees Cook <keescook@chromium.org>
Cc: Jason Yan <yanaijie@huawei.com>, kernel-hardening@lists.openwall.com,
	linux-fsdevel@vger.kernel.org
Subject: Re: CONFIG_HARDENED_USERCOPY
Message-ID: <20190830042958.GC7777@dread.disaster.area>
References: <6e02a518-fea9-19fe-dca7-0323a576750d@huawei.com>
 <201908290914.F0F929EA@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201908290914.F0F929EA@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
	a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
	a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
	a=7-415B0cAAAA:8 a=hzK9nwXln0vweuEjbcYA:9 a=CjuIK1q_8ugA:10
	a=biEYGPWJfzWAr4FL6Ov7:22

On Thu, Aug 29, 2019 at 09:15:36AM -0700, Kees Cook wrote:
> On Thu, Aug 29, 2019 at 08:42:30PM +0800, Jason Yan wrote:
> > We found an issue of kernel bug related to HARDENED_USERCOPY.
> > When copying an IO buffer to userspace, HARDENED_USERCOPY thought it is
> > illegal to copy this buffer. Actually this is because this IO buffer was
> > merged from two bio vectors, and the two bio vectors buffer was allocated
> > with kmalloc() in the filesystem layer.
> 
> Ew. I thought the FS layer was always using page_alloc?

No, they don't. It's perfectly legal to use heap memory for bio
buffers - we've been doing it since, at least, XFS got merged all
those years ago.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
