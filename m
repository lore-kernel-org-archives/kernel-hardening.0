Return-Path: <SRS0=AZum=6G=lists.openwall.com=kernel-hardening-return-18611-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73362C55185
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Apr 2020 22:18:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C38BD2077D
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Apr 2020 22:18:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LSTEpZBe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C38BD2077D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18611-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1550 invoked by uid 550); 22 Apr 2020 22:17:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1521 invoked from network); 22 Apr 2020 22:17:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1587593862;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/cWGqNrwRUi86LXOam7nhjqgeV8uCuXewweugzrbGz8=;
	b=LSTEpZBeAIadbFWzI9rNJbDHLn0btciauA5oreAFIPc/Zekg11BqTnd7TbQ225RaoA1122
	XiEOqECpsi/PUAAEJxYBTcMHxtrtHGvsEbLvzOAlJhqrdNYFcMgL3MKtjWBvUf4zGOm+Jn
	OT4Q4iX5gWmkx6HwxDA/UH+O4KZ/zZQ=
X-MC-Unique: etYuuQxEORWvQuObNkoVTA-1
Date: Wed, 22 Apr 2020 17:17:32 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: keescook@chromium.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, hpa@zytor.com, Peter Zijlstra <peterz@infradead.org>,
	arjan@linux.intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecomb@intel.com
Subject: Re: [PATCH 1/9] objtool: do not assume order of parent/child
 functions
Message-ID: <20200422221732.wmih73qrdh4fksog@treble>
References: <20200415210452.27436-1-kristen@linux.intel.com>
 <20200415210452.27436-2-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200415210452.27436-2-kristen@linux.intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12

On Wed, Apr 15, 2020 at 02:04:43PM -0700, Kristen Carlson Accardi wrote:
> If a .cold function is examined prior to it's parent, the link
> to the parent/child function can be overwritten when the parent
> is examined. Only update pfunc and cfunc if they were previously
> nil to prevent this from happening.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

Hi Kristen,

I grabbed this one and it will be merged into the -tip tree soon.
Thanks!

-- 
Josh

