Return-Path: <SRS0=bvAI=CR=lists.openwall.com=kernel-hardening-return-19827-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23825C43461
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 21:17:06 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3225B2080C
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 21:17:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sITCjv2G"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3225B2080C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19827-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13904 invoked by uid 550); 8 Sep 2020 21:16:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13872 invoked from network); 8 Sep 2020 21:16:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2efFs7I/aVceVr/UA1FiVN+0BylwZxjeaszZFFD+TI8=;
        b=sITCjv2Gw9n5L/AbRCZ60B2tM96FOIAmZJP0xe2pWojsuA5XzhXqrZIsezZXCVNKFJ
         oTkLfrCwO3b29MBCWYBtrLpvexnpWu8O5O9PQPbfZcg2StDIQ5hvVUVYZF2KMkZQM3jA
         Y0n9t1cvTsIau5HLXC3w1BW386YBX5etGcBDupIed7NhVvmW3Sze/9BeRrY+3eebmC54
         A3rg+0Q2or5ANiemPjDYOHk9RJ87YkzEsypOP9ODMDA2xV0LR5EzXHAisx/02MWDtifr
         c59B02GuTqOPM7NTMhmOA+z/kS+V8qF7KI7GgYITYiOU1zTcJV35HGMVQ8GGwXhyPLWc
         L4uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2efFs7I/aVceVr/UA1FiVN+0BylwZxjeaszZFFD+TI8=;
        b=USOo34gCRPelU0hMr9rNm0342ow0Hu/BySxkrFyPt4cIYwsZaCgBm2+hNxXr3aX4+R
         /CjW+wf20FfQ+KXQTCUWsV8lhuVkqeeNui5IAaVyRfdRGiOmYHFVkNLwxiDaVNBwJ0nq
         MYJdfNOo0Yj8+7Jd5PJjmaAY9AvEmHXpfvYlHFbfsja5KuKsVpK6p7DvR8lsHv4/vYOS
         UDs7qra7av99+4zilDjilWdqV3Qljab6cuI15z040r7kc5JBmo5kguqMy7nDuVjcMXdp
         MBdlngDqpV66M8iiOizTgvCSjSeffaWo57j/Vkut1rB90pf+kaBag0oTAOVA/XrR1U2w
         rukw==
X-Gm-Message-State: AOAM530fku+3VC0I9qVio49mKbtnjvkozg81CGcH4oSNeCYtkrA5oAdf
	6bpFLaVq9fGV1OrZulqpNq3jCw==
X-Google-Smtp-Source: ABdhPJyWG8mI3H/BsY+oT/o/ksZJ0zCieLkhk5hIgmn2bkbuRWqCNofmO6IoZa9/Ax5C5W1FdW8cWQ==
X-Received: by 2002:a17:90a:f486:: with SMTP id bx6mr641742pjb.130.1599599806032;
        Tue, 08 Sep 2020 14:16:46 -0700 (PDT)
Date: Tue, 8 Sep 2020 14:16:38 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v2 15/28] init: lto: ensure initcall ordering
Message-ID: <20200908211638.GC1060586@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-16-samitolvanen@google.com>
 <202009031532.CD2A5F372D@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202009031532.CD2A5F372D@keescook>

On Thu, Sep 03, 2020 at 03:40:31PM -0700, Kees Cook wrote:
> On Thu, Sep 03, 2020 at 01:30:40PM -0700, Sami Tolvanen wrote:
> > With LTO, the compiler doesn't necessarily obey the link order for
> > initcalls, and initcall variables need globally unique names to avoid
> > collisions at link time.
> > 
> > This change exports __KBUILD_MODNAME and adds the initcall_id() macro,
> > which uses it together with __COUNTER__ and __LINE__ to help ensure
> > these variables have unique names, and moves each variable to its own
> > section when LTO is enabled, so the correct order can be specified using
> > a linker script.
> > 
> > The generate_initcall_ordering.pl script uses nm to find initcalls from
> > the object files passed to the linker, and generates a linker script
> > that specifies the intended order. With LTO, the script is called in
> > link-vmlinux.sh.
> 
> I think I asked before about this being made unconditional, but the hit
> on final link time was noticeable. Am I remembering that right? If so,
> sure, let's keep it separate.

Yes, it was noticeable when compiling on systems with fewer CPU cores,
so I would prefer to keep it separate.

> > +## forks a child to process each file passed in the command line and collects
> > +## the results
> > +sub process_files {
> > +	my $index = 0;
> > +	my $njobs = get_online_processors();
> > +	my $select = IO::Select->new();
> > +
> > +	while (my $file = shift(@ARGV)) {
> > +		# fork a child process and read it's stdout
> > +		my $pid = open(my $fh, '-|');
> 
> /me makes noises about make -jN and the jobserver and not using all
> processors on a machine if we were asked nicely not to.
> 
> I wrote a jobserver aware tool for the documentation builds, but it's in
> python (scripts/jobserver-exec). Instead of reinventing that wheel (and
> in Perl), we could:
> 
> 1) ignore this problem and assume anyone using LTO is fine with using all CPUs
> 
> 2) implement a jobserver-aware Perl script to do this
> 
> 3) make Python a build dependency of CONFIG_LTO and re-use scripts/jobserver-exec

I'm fine with any of these options, although I'm not sure why anyone
would want to compile an LTO kernel without using all the available
cores... :)

Using jobserver-exec seems like the easiest option if we want to limit
the number of cores used here. Any preferences?

> >  # If CONFIG_LTO_CLANG is selected, collect generated symbol versions into
> >  # .tmp_symversions.lds
> >  gen_symversions()
> > @@ -74,6 +84,9 @@ modpost_link()
> >  		--end-group"
> >  
> >  	if [ -n "${CONFIG_LTO_CLANG}" ]; then
> > +		gen_initcalls
> > +		lds="-T .tmp_initcalls.lds"
> 
> Oh, I think lds should be explicitly a "local" at the start of this
> function, perhaps back in the symversions patch that touches this?

It's already local, that part is just not visible in this patch.

Sami
