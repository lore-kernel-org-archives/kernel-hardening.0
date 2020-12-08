Return-Path: <SRS0=MPbh=FM=lists.openwall.com=kernel-hardening-return-20539-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61114C4361B
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Dec 2020 00:47:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6E2A323A04
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Dec 2020 00:47:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6E2A323A04
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20539-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16293 invoked by uid 550); 8 Dec 2020 00:47:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16272 invoked from network); 8 Dec 2020 00:47:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VZHUufd0g6UdJFDVTYdblkgbgMRwbf0Y/fHI7mLRtWU=;
        b=l8tTsbTg21o1/hkJDil01QyPt1S+hNNQArxmXVMWZl+14KG3cwUPD9yhA9zz5er/OS
         WYmStLyhnHG81FxqOu7c5y430buEHIvhm1Kow/NQKRBzNLmEZELihteVRg5vdXuLfAHG
         rCoL22aDgnYFYdg61Z5cuWrNOH2SbjzbnuSM9xLI1c/BWw55NcLnaGoD4ziICgb+XXXK
         ZeF6QVt5WjFDXfuParnupBwgMVJIt4Nk49/ME1JGFmKbptXtgpSroyIdGE0tbGMqLfhi
         B0JM0p8wI/gGSE0p8C1IQpscG2TL91p7V58n7vS9habhu8GuNnQ8wlQktv+vR8fmUA6f
         4RyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VZHUufd0g6UdJFDVTYdblkgbgMRwbf0Y/fHI7mLRtWU=;
        b=O+0c7H3q96SDBncSNOCIqczt9AqY8pvsGmPGyhknConxtiKoWUywEDQKhMsTcdeGXZ
         Ue8OZBB9Is1pPgKkP8myXAEaAPXdLsA6BfSrGdSNIzhxRcl62O3dM9lJDYwxO5JmUKW8
         fPthhm7csk95zyt1xkH6AOZ9cWttJuZsIkf1rDRi2ip4JiUCYc0l88Le3/LEPL3clme6
         Jy0CF3eyRm4Y5aiTjLbEuS8LKpfXmPSghYUxJcloH8xtIjZ6R/7WHI/EMr0mt84VtT30
         2+ZPgSynwq8qrHZouJOM3e0ro/j4LNJYNifOwqcA18BBVW5IrPJKzoPSjerYrIiT5Glk
         1eQQ==
X-Gm-Message-State: AOAM532YIICVmrtGRr+HzgpdofawU8dbB6eeUlVcG51K9AaAjCL4DMii
	aBWvmhkj1cM1DNMiRSNvQ58=
X-Google-Smtp-Source: ABdhPJxkqh2BZJT/hzS1hsNzGm89wAIBgMDItnp0jBYXVFcXuYuBQBr+FGcdnMvIwDpLuGTDZMUazw==
X-Received: by 2002:ac8:51d8:: with SMTP id d24mr14423965qtn.73.1607388422238;
        Mon, 07 Dec 2020 16:47:02 -0800 (PST)
Date: Mon, 7 Dec 2020 17:46:59 -0700
From: Nathan Chancellor <natechancellor@gmail.com>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
	Will Deacon <will@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	PCI <linux-pci@vger.kernel.org>, Jian Cai <jiancai@google.com>,
	Kristof Beyls <Kristof.Beyls@arm.com>
Subject: Re: [PATCH v8 00/16] Add support for Clang LTO
Message-ID: <20201208004659.GA587492@ubuntu-m3-large-x86>
References: <20201201213707.541432-1-samitolvanen@google.com>
 <20201203112622.GA31188@willie-the-truck>
 <CABCJKueby8pUoN7f5=6RoyLSt4PgWNx8idUej0sNwAi0F3Xqzw@mail.gmail.com>
 <20201203182252.GA32011@willie-the-truck>
 <CAKwvOdnvq=L=gQMv9MHaStmKMOuD5jvffzMedhp3gytYB6R7TQ@mail.gmail.com>
 <CABCJKufgkq+k0DeYaXrzjXniy=T_N4sN1bxoK9=cUxTZN5xSVQ@mail.gmail.com>
 <20201206065028.GA2819096@ubuntu-m3-large-x86>
 <CABCJKue9TJnhge6TVPj9vfZXPGD4RW2JYiN3kNwVKNovTCq8ZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKue9TJnhge6TVPj9vfZXPGD4RW2JYiN3kNwVKNovTCq8ZA@mail.gmail.com>

On Sun, Dec 06, 2020 at 12:09:31PM -0800, Sami Tolvanen wrote:
> Sure, looks good to me. However, I think we should also test for
> LLVM=1 to avoid possible further issues with mismatched toolchains
> instead of only checking for llvm-nm and llvm-ar.

It might still be worth testing for $(AR) and $(NM) because in theory, a
user could say 'make AR=ar LLVM=1'. Highly unlikely I suppose but worth
considering.

Cheers,
Nathan
