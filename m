Return-Path: <SRS0=BlEs=YV=lists.openwall.com=kernel-hardening-return-17140-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B87BCA9EC0
	for <kernel-hardening@archiver.kernel.org>; Mon, 28 Oct 2019 19:58:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9720F214B2
	for <kernel-hardening@archiver.kernel.org>; Mon, 28 Oct 2019 19:58:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="O0yZqC1v"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9720F214B2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17140-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1211 invoked by uid 550); 28 Oct 2019 19:57:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1190 invoked from network); 28 Oct 2019 19:57:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+wOJCmH0g8vAxxe+FcShlh+2/nEo9CAjIamY0wkPKUQ=;
        b=O0yZqC1vKJdTDSM5n1ypj42P6mUYqFnfIcgablhmOvhVLjS1Ybl9gj4HXCMp/vZ/Jg
         IlXkNeniJ714HLUGdQmrikkPN3FAzyra+IIBoiYFS+hSOqqXECKH+9kL8TmBRqTz+il7
         BXn0qi51LmPYcG+sXB1pj3nora5+8WYXfasYo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+wOJCmH0g8vAxxe+FcShlh+2/nEo9CAjIamY0wkPKUQ=;
        b=iF91rQash8zz8551WFR6at3VM9dQBjjDVlTEiR4NJaEcPNVoUo9kGa50OZiiD2E/vo
         TZsWibppEtf8tlDZhsmVdJ5qYb/yu4BMKKXAswhI+e8qlDOC8oo3gu0Ywa2tS4M2lj0C
         B0Wo3uscVEtXRXFPTTGs3+ismcuBiw8036SuQ20tAGs8v0DNAVL+IpX4mh2sgRqaZpyu
         EADvd83L3lAyA1I78OtSTy71AvRRUZ3KIXv/GdlqXO9wn1e9JrDgJ4CGvbxKwjeJTIeh
         r8wLdqLSZAvofU18ncIbWU4CYd2/ip5UW+734uMhZ/NHOErnkjM3iOBUO6FAde6Vckrt
         3Ajw==
X-Gm-Message-State: APjAAAW2cdjg6LDz3yKF1rcXRiJf0i/QQ2xCdReTQy85YaLchYBMf8OK
	jGXJL+rnkh9sINvgW50mVrHaPg==
X-Google-Smtp-Source: APXvYqyKAiln1b5mOZI7AcApDWWXQnpclGuce0+3km3MXnlFB0MT9wWVjjgen/Fg+kiLaMYGZZoRxg==
X-Received: by 2002:a62:e10c:: with SMTP id q12mr13396875pfh.248.1572292664956;
        Mon, 28 Oct 2019 12:57:44 -0700 (PDT)
Date: Mon, 28 Oct 2019 12:57:42 -0700
From: Kees Cook <keescook@chromium.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Laura Abbott <labbott@redhat.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 05/17] add support for Clang's Shadow Call Stack (SCS)
Message-ID: <201910281250.25FBA8533@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191024225132.13410-1-samitolvanen@google.com>
 <20191024225132.13410-6-samitolvanen@google.com>
 <20191025105643.GD40270@lakrids.cambridge.arm.com>
 <CABCJKuc+XiDRdqfvjwCF7y=1wX3QO0MCUpeu4Gdcz91+nmnEAQ@mail.gmail.com>
 <20191028163532.GA52213@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028163532.GA52213@lakrids.cambridge.arm.com>

On Mon, Oct 28, 2019 at 04:35:33PM +0000, Mark Rutland wrote:
> On Fri, Oct 25, 2019 at 01:49:21PM -0700, Sami Tolvanen wrote:
> > To keep the address of the currently active shadow stack out of
> > memory, the arm64 implementation clears this field when it loads x18
> > and saves the current value before a context switch. The generic code
> > doesn't expect the arch code to necessarily do so, but does allow it.
> > This requires us to use __scs_base() when accessing the base pointer
> > and to reset it in idle tasks before they're reused, hence
> > scs_task_reset().
> 
> Ok. That'd be worth a comment somewhere, since it adds a number of
> things which would otherwise be unnecessary.
> 
> IIUC this assumes an adversary who knows the address of a task's
> thread_info, and has an arbitrary-read (to extract the SCS base from
> thead_info) and an arbitrary-write (to modify the SCS area).
> 
> Assuming that's the case, I don't think this buys much. If said
> adversary controls two userspace threads A and B, they only need to wait
> until A is context-switched out or in userspace, and read A's SCS base
> using B.
> 
> Given that, I'd rather always store the SCS base in the thread_info, and
> simplify the rest of the code manipulating it.

I'd like to keep this as-is since it provides a temporal protection.
Having arbitrary kernel read and write at arbitrary time is a very
powerful attack primitive, and is, IMO, not very common. Many attacks
tend to be chains of bugs that give attackers narrow visibility in to the
kernel at specific moments. I would say this design is more about stopping
"current" from dumping thread_info (as there are many more opportunities
for current to see its own thread_info compared to arbitrary addresses
or another task's thread_info). As such, I think it's a reasonable
precaution to take.

-- 
Kees Cook
