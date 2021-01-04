Return-Path: <SRS0=/0Fb=GH=lists.openwall.com=kernel-hardening-return-20611-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D71DC433DB
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 Jan 2021 23:08:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7810E207BC
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 Jan 2021 23:08:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7810E207BC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20611-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22285 invoked by uid 550); 4 Jan 2021 23:07:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22262 invoked from network); 4 Jan 2021 23:07:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1609801665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5yhsPzKCS64Ym9MievqPZFkfrX4PHb4luBL7gT8eRhE=;
	b=afqHGjrb6kqdLWNsRSYSsd85+KNZsTppvSAnKaQ6kBYSAFUORurf0+kT11bXQk4xEjpZ8v
	FaM35WjUGznhvephA5xDuITgkQ43FKSI4YU9MG2q84d7gwuLu1hkUMLQrk1TgeKJG0aG6v
	u1CuNVx0aAoZ8Afp75ZesWEP2oOsx7w=
X-MC-Unique: rtRqDYBVNau_mGlI3AI-kg-1
Date: Mon, 4 Jan 2021 17:07:32 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jakub Kicinski <jakub.kicinski@netronome.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Olof Johansson <olof@lixom.net>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Windsor <dwindsor@gmail.com>, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Rik van Riel <riel@surriel.com>, George Spelvin <lkml@sdf.org>
Subject: Re: [PATCH v2] bug: further enhance use of CHECK_DATA_CORRUPTION
Message-ID: <20210104230426.ygzkhnonys4mtc7z@treble>
References: <1491343938-75336-1-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1491343938-75336-1-git-send-email-keescook@chromium.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14

On Tue, Apr 04, 2017 at 03:12:11PM -0700, Kees Cook wrote:
> This continues in applying the CHECK_DATA_CORRUPTION tests where
> appropriate, and pulling similar CONFIGs under the same check. Most
> notably, this adds the checks to refcount_t so that system builders can
> Oops their kernels when encountering a potential refcounter attack. (And
> so now the LKDTM tests for refcount issues pass correctly.)
> 
> The series depends on the changes in -next made to lib/refcount.c,
> so it might be easiest if this goes through the locking tree...
> 
> v2 is a rebase to -next and adjusts to using WARN_ONCE() instead of WARN().
> 
> -Kees
> 
> v1 was here: https://lkml.org/lkml/2017/3/6/720

Ping?  Just wondering what ever happened to this 3+ year old series...

-- 
Josh

