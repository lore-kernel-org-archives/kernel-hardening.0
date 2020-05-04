Return-Path: <SRS0=wKb9=6S=lists.openwall.com=kernel-hardening-return-18711-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB77C3A5A9
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 May 2020 17:34:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7D9AF20663
	for <kernel-hardening@archiver.kernel.org>; Mon,  4 May 2020 17:34:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NSx6akBs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7D9AF20663
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18711-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17929 invoked by uid 550); 4 May 2020 17:34:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17906 invoked from network); 4 May 2020 17:34:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PrY9RkQAS2W4bvl/VgQNbnvFW03G7lNRCloDxmlrbTs=;
        b=NSx6akBsnMeQfEHZMVzRywWho3NUk5G1Vo0x9NmA2cdAFkj2Jt+bh+ps+QVmtbKP6P
         Zml20Z7STNcLk6CRZra57o6MZBjJkz/1+fx7yVrRrpKS0u6X7Tiy5VZSn9MegaYT6ZOm
         a4Y9ctFI/tzyT4DFAtGg2FqiJ2zkHVYo53oNdDszflXKgRFIY9gWSJku6qzMvTeTmhJY
         FewTT7B04sS1GWkGafkaO5BjJaa9EIGdXsEtvWPQNoW4vfSk7SKcNZgCtH6TJjNl/rJ1
         EzzEaVpjzUUNwwIoQZfhQiJC05upym6vjJqsM4/7CQCTICTvXtXrgnJ4NFPjTdE1aQkL
         NUfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PrY9RkQAS2W4bvl/VgQNbnvFW03G7lNRCloDxmlrbTs=;
        b=OsMvbRoWF4gwsmipCElT/n866aWSCfoZrQ7bU+AUy9WusXAjQfW1HWnQMp61xPwBoN
         zbRj728Lf2SHtSPcxOv3VM85p5YbLKvkhd9OBz8DnoQfwXljZjFSG8RoZObuYjoZpabm
         ezme9wqgVd2jxbzh6WW+DOsEuZjjlCI6/CJdN0O502Q4P8pr9OdoZfORRwmXEXDxw4hb
         epwRDPjadrjOdPT0u/V868DX+S/EvaJLRbuHu/OStXRtdmTnemxmJpdo4A4QkMeCLwr5
         nUfhIBO28EdwQuyqYTUgzCSM+eHsbXtwzIaFPJJTEJxrAb0Abys6OsUhDyvv3jIiCV62
         15Ww==
X-Gm-Message-State: AGi0Puan+Hv3VgQv8sEeuF7KXMQKg5r8ErHTcy8foLFuicTrkuO/0Ero
	xl+ZTwydMLubnLynDRscKwr8nw==
X-Google-Smtp-Source: APiQypKurnJqa9FCEdm9LaSAgNsP73wdOybQtoVO9KgHsIEow7TzATK6FCFw0kO5pS7r5hlTl3puzA==
X-Received: by 2002:a63:2943:: with SMTP id p64mr91169pgp.36.1588613644620;
        Mon, 04 May 2020 10:34:04 -0700 (PDT)
Date: Mon, 4 May 2020 10:33:56 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>
Cc: Kees Cook <keescook@chromium.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
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
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 01/12] add support for Clang's Shadow Call Stack (SCS)
Message-ID: <20200504173356.GA7200@google.com>
References: <20200416161245.148813-1-samitolvanen@google.com>
 <20200416161245.148813-2-samitolvanen@google.com>
 <20200420171727.GB24386@willie-the-truck>
 <20200420211830.GA5081@google.com>
 <20200422173938.GA3069@willie-the-truck>
 <20200422235134.GA211149@google.com>
 <202004231121.A13FDA100@keescook>
 <20200424112113.GC21141@willie-the-truck>
 <20200427204546.GA80713@google.com>
 <20200504165227.GB1833@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200504165227.GB1833@willie-the-truck>

On Mon, May 04, 2020 at 05:52:28PM +0100, Will Deacon wrote:
> On Mon, Apr 27, 2020 at 01:45:46PM -0700, Sami Tolvanen wrote:
> > I agree that allocating from a kmem_cache isn't ideal for safety. It's a
> > compromise to reduce memory overhead.
> 
> Do you think it would be a problem if we always allocated a page for the
> SCS?

Yes, the memory overhead was deemed too large for Android devices, which
have thousands of threads running.

Sami
