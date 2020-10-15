Return-Path: <SRS0=qUOK=DW=lists.openwall.com=kernel-hardening-return-20217-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40C78C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 15 Oct 2020 20:40:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EF8B92074D
	for <kernel-hardening@archiver.kernel.org>; Thu, 15 Oct 2020 20:40:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XQE1vKY1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EF8B92074D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20217-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15673 invoked by uid 550); 15 Oct 2020 20:40:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15651 invoked from network); 15 Oct 2020 20:40:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1602794395;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=drNAM9RnP6kYRtro33MBF8DkJ/VVjdpQLGpKNAKGMr0=;
	b=XQE1vKY169zUJHe8PpMOjjo8nT2H7ZQLtKK61ZasL6GD5Ad29IzcFP73xH9D4gtd49yydv
	94vWPhfqXFGRh6Nt0cX62L4aW5woTAaQ9BzhOY73j2Q3pkMFHQdYtt+aM/evrdr7PHqj46
	aY+XdFzFgaECSAI22RFL2znS0Wf4yVg=
X-MC-Unique: RnX1X4qvPkWYUnhEN4Iw2A-1
Date: Thu, 15 Oct 2020 15:39:42 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jann Horn <jannh@google.com>, Sami Tolvanen <samitolvanen@google.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	linux-kbuild@vger.kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-pci@vger.kernel.org
Subject: Re: [PATCH v6 22/25] x86/asm: annotate indirect jumps
Message-ID: <20201015203942.f3kwcohcwwa6lagd@treble>
References: <20201013003203.4168817-1-samitolvanen@google.com>
 <20201013003203.4168817-23-samitolvanen@google.com>
 <CAG48ez2baAvKDA0wfYLKy-KnM_1CdOwjU873VJGDM=CErjsv_A@mail.gmail.com>
 <20201015102216.GB2611@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201015102216.GB2611@hirez.programming.kicks-ass.net>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13

On Thu, Oct 15, 2020 at 12:22:16PM +0200, Peter Zijlstra wrote:
> On Thu, Oct 15, 2020 at 01:23:41AM +0200, Jann Horn wrote:
> 
> > It would probably be good to keep LTO and non-LTO builds in sync about
> > which files are subjected to objtool checks. So either you should be
> > removing the OBJECT_FILES_NON_STANDARD annotations for anything that
> > is linked into the main kernel (which would be a nice cleanup, if that
> > is possible), 
> 
> This, I've had to do that for a number of files already for the limited
> vmlinux.o passes we needed for noinstr validation.

Getting rid of OBJECT_FILES_NON_STANDARD is indeed the end goal, though
I'm not sure how practical that will be for some of the weirder edge
case.

On a related note, I have some old crypto cleanups which need dusting
off.

-- 
Josh

