Return-Path: <SRS0=lsRq=FF=lists.openwall.com=kernel-hardening-return-20473-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B97DC64E7B
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Dec 2020 17:31:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 35E9F20870
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Dec 2020 17:31:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="COBsdbub"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35E9F20870
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20473-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11523 invoked by uid 550); 1 Dec 2020 17:31:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11503 invoked from network); 1 Dec 2020 17:31:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fIhrXegmFXx4Y1S8YgnbVoZcP9r/eMN50vMQw7Htjj0=;
        b=COBsdbubf4U1NB4bryhE6zpFJFlxC6tnZcSZU41etUauCccqXZsiquU+7Pg3YtVZk6
         FaJj4o1AIWN+/OM9H6u8TAIFxZgoJVNQ/2jTBB5a/m2hHYR3qjgThVUzKnMTBTgmN/d+
         qjZ/Lpe9hl7c2js/gywR+ayaeczGzpkDoU8ik=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fIhrXegmFXx4Y1S8YgnbVoZcP9r/eMN50vMQw7Htjj0=;
        b=Ty1uullvzXN18/aJmcBH4jStC21CjclFYReUTBpkTNCT/PteW7jslrLn/X9Xd/nRi0
         s2yICgQmWOHWI661jXYyX2v53zvDFNcMCiRUTPxLLHFjAcWqN5uNO0qdrxw8hKwL2dXd
         iY/vV6PrtSTz7X2a9KX/HbU+mMhrgJy3nqj9iueJ8PKVu1qCy8InSfA254H5Ohc7RJkm
         4MMXU7HvQ6Bjsar77nFt4ep1Wqjlb4u1LjysCeVlv6VscTkMJXUJ6hZkqiDX+/p+olgN
         yQF08vcSlpVePQseFfneEbC4TKQyIedhGXpM+l9ebIgNE8MLUa1ILEA7nDg45/+g3uCc
         o/VA==
X-Gm-Message-State: AOAM532p5aftaPfZEgh/7dpdGynEuQnWwy43dRgIPwyYGKdu+YOKVejD
	UB5nzXqGUECiesFZkXgN70OnIA==
X-Google-Smtp-Source: ABdhPJxNXrz8lyJzMPvVj7dGfW+IUsSemW9FmHsAZMwUW4pvNI4+h4MvkJF21vQXTZU3MgV3CsB+ag==
X-Received: by 2002:a17:90b:224a:: with SMTP id hk10mr3671202pjb.81.1606843863156;
        Tue, 01 Dec 2020 09:31:03 -0800 (PST)
Date: Tue, 1 Dec 2020 09:31:00 -0800
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v7 00/17] Add support for Clang LTO
Message-ID: <202012010929.3788AF5@keescook>
References: <20201118220731.925424-1-samitolvanen@google.com>
 <20201130120130.GF24563@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130120130.GF24563@willie-the-truck>

On Mon, Nov 30, 2020 at 12:01:31PM +0000, Will Deacon wrote:
> Hi Sami,
> 
> On Wed, Nov 18, 2020 at 02:07:14PM -0800, Sami Tolvanen wrote:
> > This patch series adds support for building the kernel with Clang's
> > Link Time Optimization (LTO). In addition to performance, the primary
> > motivation for LTO is to allow Clang's Control-Flow Integrity (CFI) to
> > be used in the kernel. Google has shipped millions of Pixel devices
> > running three major kernel versions with LTO+CFI since 2018.
> > 
> > Most of the patches are build system changes for handling LLVM bitcode,
> > which Clang produces with LTO instead of ELF object files, postponing
> > ELF processing until a later stage, and ensuring initcall ordering.
> > 
> > Note that v7 brings back arm64 support as Will has now staged the
> > prerequisite memory ordering patches [1], and drops x86_64 while we work
> > on fixing the remaining objtool warnings [2].
> 
> Sounds like you're going to post a v8, but that's the plan for merging
> that? The arm64 parts look pretty good to me now.

I haven't seen Masahiro comment on this in a while, so given the review
history and its use (for years now) in Android, I will carry v8 (assuming
all is fine with it) it in -next unless there are objections.

-- 
Kees Cook
