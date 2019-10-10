Return-Path: <SRS0=WQVM=YD=lists.openwall.com=kernel-hardening-return-17001-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4105CC10F14
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Oct 2019 14:23:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8A1E9206B6
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Oct 2019 14:23:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A1E9206B6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17001-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13781 invoked by uid 550); 10 Oct 2019 14:22:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13749 invoked from network); 10 Oct 2019 14:22:52 -0000
Date: Thu, 10 Oct 2019 14:22:40 +0000 (UTC)
From: Christopher Lameter <cl@linux.com>
X-X-Sender: cl@www.lameter.com
To: Shyam Saini <mayhs11saini@gmail.com>
cc: linux-mm@kvack.org, kernel-hardening@lists.openwall.com, 
    Matthew Wilcox <willy@infradead.org>, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] slab: Redefine ZERO_SIZE_PTR to include ERR_PTR range
In-Reply-To: <20191010103151.7708-1-mayhs11saini@gmail.com>
Message-ID: <alpine.DEB.2.21.1910101418500.27284@www.lameter.com>
References: <20191010103151.7708-1-mayhs11saini@gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Thu, 10 Oct 2019, Shyam Saini wrote:

> This will help error related to ERR_PTR stand out better.

Maybe make ZERO_SIZE_PTR an ERRNO value instead? Then allow ERR_PTRs to be
used instead of ZERO_SIZE_PTRs

ERRNO_ZERO_OBJECT

or something like that?

>   */
> -#define ZERO_SIZE_PTR ((void *)16)

#define ZERO_SIZE_PTR ((void *)-ERRNO_ZERO_OBJECT)

> +
> +#define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) - 1 >= \
> +		(unsigned long)ZERO_SIZE_PTR - 1)

And call this something different?

