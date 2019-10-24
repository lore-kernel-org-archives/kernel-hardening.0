Return-Path: <SRS0=jEfg=YR=lists.openwall.com=kernel-hardening-return-17101-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 163E0CA9EBB
	for <kernel-hardening@archiver.kernel.org>; Thu, 24 Oct 2019 22:17:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5D81820663
	for <kernel-hardening@archiver.kernel.org>; Thu, 24 Oct 2019 22:17:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u1/fHDmx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D81820663
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17101-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10026 invoked by uid 550); 24 Oct 2019 22:17:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10006 invoked from network); 24 Oct 2019 22:17:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qHNXsthwregcyrL2BKVfLqYllW87y6QVnA+Lbr5Rgec=;
        b=u1/fHDmx2F03gUdsJoRaJfl7aP6BcoOTQj7WuOKplTSdf6uXX1E0Rf1hGTjZ93euSU
         NJGI0hMli675V4W1F5aGYPIB6vXEndENuc9l4uQvSvWlXKnpA/Q0fOf41lKCkzVymcMj
         vSAvJbnieQzBs39rOqmCk2ja2JZ+n2tLqqkQvWScrAsxpi7g4yEkQAJHTgbS1XIOEKGc
         ZIEUfghKoKXuOS8kPtcMk4jtp/voE4nzOI5nX/zgK6dajQqfV49v6nb1hfQWLq1Yey8y
         KbnrEILxVOYi9Z6E2nmjX/uSwH9bskxev0otzP5fbZ4T6AZwWHNu+W94Q+UntLXVb7q4
         mXtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qHNXsthwregcyrL2BKVfLqYllW87y6QVnA+Lbr5Rgec=;
        b=XeMYmySnQDZPjqWuKy35JzO3ZHJabL8KUaMx/X6adaKMzy77pQpB91vubG/ubXrSQd
         GTavMRm76GUINLkuiMWB6mSoQlq9+ECe59F0Q4eKUGRFlGa5EeJQdd9DEDHK5zgBGkIP
         nLyfAIIVROfDzljv52wrSjwk/K/bnvibPyBWdu4f9xVKjAL5IVHNkakNH9vJhJ34mN8+
         no9PVZGwribYBRTypk+gcwiou7n1aK6EbuJCTY03Rxd0kcIUTMaouu5NbXuzROQj5jVm
         +8oa31h78Z5j8fRzOm62uI1Yp2FLr97rVb3Icg1UmLnjW87MlvXmymWxt9wQD6I7N9BZ
         eKDA==
X-Gm-Message-State: APjAAAXj4lfzhL7iVrHIONB/bryAkAQxVBZatEYXLWSHHB1q2WGiW2VZ
	YibcV+obowuuciB8RwwfxIcol1r9RZF+1AEAFTy81g==
X-Google-Smtp-Source: APXvYqyC5R+J94HY0QZwShcMklCS8zj2eZiTO4Hh3KIgdjFp8g8gOvA8xc0s1anKvCDkBcvEQB2MlCQ7jEx4vRyMG+k=
X-Received: by 2002:a05:6102:36a:: with SMTP id f10mr324969vsa.44.1571955439473;
 Thu, 24 Oct 2019 15:17:19 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-7-samitolvanen@google.com> <20191022162826.GC699@lakrids.cambridge.arm.com>
 <CABCJKudsD6jghk4i8Tp4aJg0d7skt6sU=gQ3JXqW8sjkUuX7vA@mail.gmail.com> <20191024080418.35423b36@gandalf.local.home>
In-Reply-To: <20191024080418.35423b36@gandalf.local.home>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Thu, 24 Oct 2019 15:17:08 -0700
Message-ID: <CABCJKueb=xZzXBegc58aWRqPq6eCOpBf7uyyzVyNMujDSHhm1g@mail.gmail.com>
Subject: Re: [PATCH 06/18] add support for Clang's Shadow Call Stack (SCS)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, 
	Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 24, 2019 at 5:04 AM Steven Rostedt <rostedt@goodmis.org> wrote:
> You can remove a CFLAGS for a whole directory. lib, kernel/trace and
> others do this. Look at kernel/trace/Makefile, we have:
>
> ORIG_CFLAGS := $(KBUILD_CFLAGS)
> KBUILD_CFLAGS = $(subst $(CC_FLAGS_FTRACE),,$(ORIG_CFLAGS))

That definitely looks less invasive in this case than adding
ccflags-remove-y, since we only really need this for one directory.
I'll use this in v2. Thanks, Steven.

Sami
