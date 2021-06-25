Return-Path: <SRS0=hD6I=LT=lists.openwall.com=kernel-hardening-return-21321-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A34CC2B9F4
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Jun 2021 13:27:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DE8D361962
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Jun 2021 13:27:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE8D361962
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21321-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7360 invoked by uid 550); 25 Jun 2021 13:27:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7328 invoked from network); 25 Jun 2021 13:27:48 -0000
Date: Fri, 25 Jun 2021 09:27:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yun Zhou <yun.zhou@windriver.com>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
 ying.xue@windriver.com, "Li, Zhiquan" <Zhiquan.Li@windriver.com>
Subject: Re: [PATCH] seq_buf: let seq_buf_putmem_hex support len larger than
 8
Message-ID: <20210625092733.63bde998@oasis.local.home>
In-Reply-To: <06010fbf-1d46-3313-1545-b75c42f19935@windriver.com>
References: <20210624131646.17878-1-yun.zhou@windriver.com>
	<20210624105422.5c8aaf4d@oasis.local.home>
	<32276a16-b893-bdbb-e552-7f5ecaaec5f1@windriver.com>
	<20210625000854.36ed6f2d@gandalf.local.home>
	<06010fbf-1d46-3313-1545-b75c42f19935@windriver.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 25 Jun 2021 15:28:25 +0800
Yun Zhou <yun.zhou@windriver.com> wrote:

> Hi Mr Steven,
> 
> I found that you had ever wanted to enhance trace_seq_putmem_hex() to
> 
> allow any size input(6d2289f3faa71dcc). Great minds think alike. Your
> 
> enhancement will let the function more robust, I think it is very advisable.
> 
> Now we only need modify two lines to solve a little flaw, and to let it
> 
> more more robust.

You are still solving two bugs with one patch, which is considered a no-no.

One bug fix needs to go back to the beginning. If you want to add the
other update, then it could be labeled a fix to that commit. Either
way, it requires two patches.

-- Steve
