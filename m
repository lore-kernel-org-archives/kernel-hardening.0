Return-Path: <SRS0=w4/Z=AG=lists.openwall.com=kernel-hardening-return-19170-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 737B8C433E1
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jun 2020 19:32:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C54C120767
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Jun 2020 19:32:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mDZm0gGa"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C54C120767
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19170-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19771 invoked by uid 550); 25 Jun 2020 19:32:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19735 invoked from network); 25 Jun 2020 19:32:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aiCyaSfPElHdBJ1rU4jQnvBfG3hDID3mTTJS9XuQz+Q=;
        b=mDZm0gGa4yZbKDGF9rgasIeYxWV9KiHwNiMw4ndiNsCn3uE7R//SGEQLJE3mdDSI9/
         HpYkrdPyVuwor8peEnUfcbBGXiofFnd9veTD7NWibiAP8Ve8E8gCOzG31rjOvREFV1Bf
         JgsOujSu3baR0YmlQhh5NEYw2pxgOkuVQSleeQxner2eUY5rh1bZK2fJ9oTRt0snh+M+
         w5fHbf1pXC29S4Vdgqgal1yygHmQF+xISjlsoEB9iBq9A7j/gBZC02UXmgSOGcV/V0l2
         EEwNoJRyrtCrwRdjdM5UwbSh/doG0vV/wAS2jKyrjWA8airu6HPV73/rpljmn2VIho8e
         Lz0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aiCyaSfPElHdBJ1rU4jQnvBfG3hDID3mTTJS9XuQz+Q=;
        b=C+tI/bnLBgYnm2Bi5i9nwH+uyHL5XuSNdcMMG4dpPVGdjRyvPsAkyOirxzwiaiLwOR
         4yUK0ujTcRec4NvTKXFKP7mI9yR7nNq/xB7+1sG6Fgzu3mkiPI5PGCSUY0dv/4qRMphY
         g3Ve51SR6ULmHTUdxd4fa8XdYN8QmUm8/UoIAwDWrdgdbWHeSEdrVnYowkKuCnial851
         Tw5pLvm6quAR7I+gs1pEq4yENOXKQCTdJ39Qev1ye2XN+JDUjv1x4jXc7DPLwOoFdkVb
         a7opbV6RoO26343/OfZjkZIqnrVl7se192JMuOs3FAgzHjGXvesjz3aaP1Xd+I6x3RJ4
         ts8w==
X-Gm-Message-State: AOAM531lQsrD4O++PdnAGQxT8Qy6ggCNJ9zXREWU2DQ9z5WwpTQzpiOu
	/PhdebRj8TDDTqIjfZ+eIFc6Hw==
X-Google-Smtp-Source: ABdhPJzHjBuSoIFTZJ1sk5l9LqVn8mN4nFIUCyUrTGu3HSZs8Ut1ULHUwpBV+FgkM8L4HnNscu3bNQ==
X-Received: by 2002:a17:90b:88b:: with SMTP id bj11mr5103958pjb.51.1593113544026;
        Thu, 25 Jun 2020 12:32:24 -0700 (PDT)
Date: Thu, 25 Jun 2020 12:32:17 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH 05/22] kbuild: lto: postpone objtool
Message-ID: <20200625193217.GA59566@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-6-samitolvanen@google.com>
 <20200624211908.GT4817@hirez.programming.kicks-ass.net>
 <20200624214925.GB120457@google.com>
 <20200625074716.GX4817@hirez.programming.kicks-ass.net>
 <20200625162226.GC173089@google.com>
 <20200625183351.GH4800@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625183351.GH4800@hirez.programming.kicks-ass.net>

On Thu, Jun 25, 2020 at 08:33:51PM +0200, Peter Zijlstra wrote:
> On Thu, Jun 25, 2020 at 09:22:26AM -0700, Sami Tolvanen wrote:
> > On Thu, Jun 25, 2020 at 09:47:16AM +0200, Peter Zijlstra wrote:
> 
> > > Right, then we need to make --no-vmlinux work properly when
> > > !DEBUG_ENTRY, which I think might be buggered due to us overriding the
> > > argument when the objname ends with "vmlinux.o".
> > 
> > Right. Can we just remove that and  pass --vmlinux to objtool in
> > link-vmlinux.sh, or is the override necessary somewhere else?
> 
> Think we can remove it; it was just convenient when running manually.

Great, I'll change this in v2.

> > > > > > +ifdef CONFIG_STACK_VALIDATION
> > > > > > +ifneq ($(SKIP_STACK_VALIDATION),1)
> > > > > > +cmd_ld_ko_o +=								\
> > > > > > +	$(objtree)/tools/objtool/objtool				\
> > > > > > +		$(if $(CONFIG_UNWINDER_ORC),orc generate,check)		\
> > > > > > +		--module						\
> > > > > > +		$(if $(CONFIG_FRAME_POINTER),,--no-fp)			\
> > > > > > +		$(if $(CONFIG_GCOV_KERNEL),--no-unreachable,)		\
> > > > > > +		$(if $(CONFIG_RETPOLINE),--retpoline,)			\
> > > > > > +		$(if $(CONFIG_X86_SMAP),--uaccess,)			\
> > > > > > +		$(@:.ko=$(prelink-ext).o);
> > > > > > +
> > > > > > +endif # SKIP_STACK_VALIDATION
> > > > > > +endif # CONFIG_STACK_VALIDATION
> > > > > 
> > > > > What about the objtool invocation from link-vmlinux.sh ?
> > > > 
> > > > What about it? The existing objtool_link invocation in link-vmlinux.sh
> > > > works fine for our purposes as well.
> > > 
> > > Well, I was wondering why you're adding yet another objtool invocation
> > > while we already have one.
> > 
> > Because we can't run objtool until we have compiled bitcode to native
> > code, so for modules, we're need another invocation after everything has
> > been compiled.
> 
> Well, that I understand, my question was why we need one in
> scripts/link-vmlinux.sh and an additional one. I think we're just
> talking past one another and agree we only need one.

We need just one for vmlinux.o, but this rule adds an objtool invocation
for kernel modules, which we also couldn't check earlier. We link all
the bitcode for modules into <module>.lto.o and run modpost and objtool
on that before building the final .ko.

Sami
