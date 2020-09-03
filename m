Return-Path: <SRS0=kmkm=CM=lists.openwall.com=kernel-hardening-return-19758-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 733B4C433E2
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 22:12:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B7F7720716
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Sep 2020 22:12:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="IGPy3Ev8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7F7720716
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19758-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 2024 invoked by uid 550); 3 Sep 2020 22:12:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1989 invoked from network); 3 Sep 2020 22:12:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5FkC7ZydcYZ7OvnDcVYU3cxvw/A+RLXuwzidT1u3ktE=;
        b=IGPy3Ev8EutCuQb4lwsTx1VAvqIeOIRFD7wLuyvXGTSAxwz8hL6v0K8f8IQ9Y+H11S
         fKbqKBL1KVGfL9CLfKWhp972pCQiDMPENIKcZYhRYuBh/NJ5d1xhg8qEzMWhJmjTO78y
         hpDI1nGkw9U2lPKfWpYJ5VKAyDFTBSuj0ip0o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5FkC7ZydcYZ7OvnDcVYU3cxvw/A+RLXuwzidT1u3ktE=;
        b=agbVBh6DKO7JqzIqNiUrNmDzE38GiAY5oHmoq7AxWco8qyoGkYusI+GII7ydqy4vWV
         GUDdxe5VkhlfdRYqH2Hi52hMNABD1KtVE9UXwk1tezv+K4faREts041zCWkjtpeiMQTR
         05qmH9YvajFcPTKD5eNOYrXKnVczph2k8JbZS3TGYhlSVu/h0yGesv2Wv7DqHAY03RuX
         CG5xZEPN2ZNSIjPpKqN8kQ0ZrPl9trtqf7FnKJ8VWyS5c67HF4l85KaqA8c2K4rs3aod
         Yew8oNHqEZCBvDRnWiKnQVYCXDGfFRri8UeGzWbujrG+UvLiEYSR1qXfwUDE2WOqEC0h
         ZhFQ==
X-Gm-Message-State: AOAM531j4mRzEWXzcAyqWbE2iVNZehQld06Dw5/BVuUwmqE6bcEzwVWv
	Fr18zrpNv88UhiF2hOiMsY/qpQ==
X-Google-Smtp-Source: ABdhPJxNUt7QAkJJr6DVIatL2r/ZHjflOqWAAtFiZXIMzyxOBsAVSA+Y4d6vSRQM4txHS5CM9PwpZQ==
X-Received: by 2002:a17:902:d702:: with SMTP id w2mr6057532ply.53.1599171116270;
        Thu, 03 Sep 2020 15:11:56 -0700 (PDT)
Date: Thu, 3 Sep 2020 15:11:54 -0700
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
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
Subject: Re: [PATCH v2 10/28] kbuild: lto: fix module versioning
Message-ID: <202009031510.32523E45EC@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-11-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-11-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:35PM -0700, Sami Tolvanen wrote:
> With CONFIG_MODVERSIONS, version information is linked into each
> compilation unit that exports symbols. With LTO, we cannot use this
> method as all C code is compiled into LLVM bitcode instead. This
> change collects symbol versions into .symversions files and merges
> them in link-vmlinux.sh where they are all linked into vmlinux.o at
> the same time.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

The only thought I have here is I wonder if this change could be made
universally instead of gating on LTO? (i.e. is it noticeably slower to
do it this way under non-LTO?)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
