Return-Path: <SRS0=fI/O=6G=lists.openwall.com=kernel-hardening-return-18604-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9982BC55185
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Apr 2020 17:43:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EF05F20767
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Apr 2020 17:43:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ElNvhNTf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF05F20767
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18604-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21623 invoked by uid 550); 22 Apr 2020 17:43:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21598 invoked from network); 22 Apr 2020 17:43:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587577413;
	bh=GKVeRNovN7Obk0/QIZ5ZrkitdmSCkes/oP/yb8NxlYI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ElNvhNTfCskVw6AaK9v+WlfpKssxKenLa3m1DmDTw4TqDUbQh+iCxY1wYHWhNgrgU
	 Vlx/Xx0LKMTw5ZJdupehMz598ahh2mcR867bVsF5vs6oio7Vyk36GE9ZV2ATk2O5s9
	 567isgI4CNdFQyeLZGcIBhgxm+6d9fUHAXgy6Go0=
Date: Wed, 22 Apr 2020 18:43:26 +0100
From: Will Deacon <will@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 02/12] scs: add accounting
Message-ID: <20200422174326.GA3121@willie-the-truck>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200421021453.198187-1-samitolvanen@google.com>
 <20200421021453.198187-3-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421021453.198187-3-samitolvanen@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Apr 20, 2020 at 07:14:43PM -0700, Sami Tolvanen wrote:
> This change adds accounting for the memory allocated for shadow stacks.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---
>  drivers/base/node.c    |  6 ++++++
>  fs/proc/meminfo.c      |  4 ++++
>  include/linux/mmzone.h |  3 +++
>  kernel/scs.c           | 16 ++++++++++++++++
>  mm/page_alloc.c        |  6 ++++++
>  mm/vmstat.c            |  3 +++
>  6 files changed, 38 insertions(+)

Acked-by: Will Deacon <will@kernel.org>

Thanks!

Will
