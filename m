Return-Path: <SRS0=RwFA=GM=lists.openwall.com=kernel-hardening-return-20624-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F9B9C433E0
	for <kernel-hardening@archiver.kernel.org>; Sat,  9 Jan 2021 23:45:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A4A2822CAF
	for <kernel-hardening@archiver.kernel.org>; Sat,  9 Jan 2021 23:45:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4A2822CAF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20624-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30356 invoked by uid 550); 9 Jan 2021 23:45:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30334 invoked from network); 9 Jan 2021 23:45:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=+RrrtQj8SC/rvlP5LlORUe5YEU0RLqpKs9/GxE+Y/3s=;
        b=UOX+83msyY0c9zbWi3lYQYT+DWm3pxfGQCmxDKZPWRz9aNa0fJmFuyJAoTAa/G4p7p
         SfNMBUVFInFsSss6Hai+8E7R2dRPkeMJSuuqPKYrSgxVvPznCQuX0c2x7pK0ziYUnGZu
         C/dqYRW3yn3mK0faEKPwVBExadp8Kgslh3Ifx3qEtRAOxZYLp3wJrsmwNVogv2Xvn8YT
         DVM8yO3ktn4mQBz3CJwUaGYDKRVh9+pk89SZhcMQUvemteqhM0YjjcAszrwEuZ3YQsOL
         +z0ZOj3P4MtB6Y0w3VDW2nsmUA/2XYGMxtK5IxtSgUVZaBmlLr3bxkan/kkyZN9N4cu3
         RmgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=+RrrtQj8SC/rvlP5LlORUe5YEU0RLqpKs9/GxE+Y/3s=;
        b=dN4ZJWdUCLbBIkWwNIrL72Tg0cSpgfDah+40QAfn+vMLQQlNfhCP4UnlLBu/hc4okj
         G5bfh+QR1GHMClN+iZ0p2SyQvyXIT44/eG5aHhsWVrPyP2/ce30kLapBlCF5zkHy86l/
         NA6Y8yuF6li2gznAnbwwAKONOtyujeImwMWQYZjShrLejXNs7t16HkKEPoeKi60m8p/q
         qQl/G6Tuu3bNry3fgdKB2Al0PYX8gp5MFjmU6gasjAKoxkGHX4Rdf9NoHrdHMq+N8iA1
         Q2DMe+AlH6bc+8pGOdndhLg0TxV4ZOMT0OnIg0DFSBx4AQtj+cGsWjqE6Bvr+JbL3O7R
         VVSA==
X-Gm-Message-State: AOAM533a9XjmltaEZRcIlK1qiJz83wqQtUQZwv7CzjzBoMaau1OOrDHu
	ZS4C2ykYduot8ierRnMb6SRhLXS4t9XDiuWC7DE=
X-Google-Smtp-Source: ABdhPJzWsen+1bFKw+cuUM+1jT3nRAdUJAbnO8/1z/3RJ3vKQKxWxm92cFnz6xMw+Un/kDcSMfb/nu/s13W2lsXa7/g=
X-Received: by 2002:a92:c002:: with SMTP id q2mr10229657ild.186.1610235907552;
 Sat, 09 Jan 2021 15:45:07 -0800 (PST)
MIME-Version: 1.0
References: <20201211184633.3213045-1-samitolvanen@google.com>
 <CA+icZUWYxO1hHW-_vrJid7EstqQRYQphjO3Xn6pj6qfEYEONbA@mail.gmail.com>
 <20210109153646.zrmglpvr27f5zd7m@treble> <CA+icZUUiucbsQZtJKYdD7Y7Cq8hJZdBwsF0U0BFbaBtnLY3Nsw@mail.gmail.com>
 <20210109160709.kqqpf64klflajarl@treble> <CA+icZUU=sS2xfzo9qTUTPQ0prbbQcj29tpDt1qK5cYZxarXuxg@mail.gmail.com>
 <20210109163256.3sv3wbgrshbj72ik@treble> <CA+icZUUszOHkJ8Acx2mDowg3StZw9EureDQ7YYkJkcAnpLBA+g@mail.gmail.com>
 <20210109170353.litivfvc4zotnimv@treble> <20210109170558.meufvgwrjtqo5v3i@treble>
In-Reply-To: <20210109170558.meufvgwrjtqo5v3i@treble>
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Sun, 10 Jan 2021 00:44:54 +0100
Message-ID: <CA+icZUVS_CbbxG-V0RZxqxcY7E__QUrVxgC1VRmTLN4wrz=E5w@mail.gmail.com>
Subject: Re: [PATCH v9 00/16] Add support for Clang LTO
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	Clang-Built-Linux ML <clang-built-linux@googlegroups.com>, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, Jan 9, 2021 at 6:06 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Sat, Jan 09, 2021 at 11:03:57AM -0600, Josh Poimboeuf wrote:
> > On Sat, Jan 09, 2021 at 05:45:47PM +0100, Sedat Dilek wrote:
> > > I tried merging with clang-cfi Git which is based on Linux v5.11-rc2+
> > > with a lot of merge conflicts.
> > >
> > > Did you try on top of cfi-10 Git tag which is based on Linux v5.10?
> > >
> > > Whatever you successfully did... Can you give me a step-by-step instruction?
> >
> > Oops, my bad.  My last three commits (which I just added) do conflict.
> > Sorry for the confusion.
> >
> > Just drop my last three commits:
> >
> > git fetch https://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git objtool-vmlinux
> > git checkout -B tmp FETCH_HEAD
> > git reset --hard HEAD~~~
> > git fetch https://github.com/samitolvanen/linux clang-lto
> > git rebase --onto FETCH_HEAD 79881bfc57be
>
> Last one should be:
>
> git rebase --onto FETCH_HEAD 2c85ebc57b3e
>

Hi Josh,

as said I tried your latest changes on top of Linux v5.10.6 + cfi-5.10.
This reduces the objtool-warnings in vmlinux.o from 15 down to 2.

Without your latest changes:

$ grep 'vmlinux.o: warning: objtool:'
build-log_5.10.4-3-amd64-clang11-cfi.txt | wc -l
15

$ grep 'vmlinux.o: warning: objtool:'
build-log_5.10.4-3-amd64-clang11-cfi.txt
vmlinux.o: warning: objtool: wakeup_long64()+0x61: indirect jump found
in RETPOLINE build
vmlinux.o: warning: objtool: .text+0x408a: indirect jump found in
RETPOLINE build
vmlinux.o: warning: objtool: .text+0x40c5: indirect jump found in
RETPOLINE build
vmlinux.o: warning: objtool: .head.text+0x298: indirect jump found in
RETPOLINE build
vmlinux.o: warning: objtool: __switch_to_asm()+0x0: undefined stack state
vmlinux.o: warning: objtool: .entry.text+0xf91: sibling call from
callable instruction with modified stack frame
vmlinux.o: warning: objtool: .entry.text+0x16c4: unsupported
instruction in callable function
vmlinux.o: warning: objtool: .entry.text+0x15a4: redundant CLD
vmlinux.o: warning: objtool: do_suspend_lowlevel()+0x116: sibling call
from callable instruction with modified stack frame
vmlinux.o: warning: objtool: kretprobe_trampoline()+0x49: return with
modified stack frame
vmlinux.o: warning: objtool: machine_real_restart()+0x85: unsupported
instruction in callable function
vmlinux.o: warning: objtool: __x86_retpoline_rdi()+0x0: stack state
mismatch: cfa1=7+8 cfa2=-1+0
vmlinux.o: warning: objtool: .entry.text+0x48: stack state mismatch:
cfa1=7-8 cfa2=-1+0
vmlinux.o: warning: objtool: .entry.text+0x156d: stack state mismatch:
cfa1=7-8 cfa2=-1+0
vmlinux.o: warning: objtool: .entry.text+0x15fc: stack state mismatch:
cfa1=7-8 cfa2=-1+0

With your latest changes in <jpoimboe.git#objtool-vmlinux>:

$ grep 'vmlinux.o: warning: objtool:'
build-log_5.10.6-1-amd64-clang11-cfi.txt | wc -l
2

$ grep 'vmlinux.o: warning: objtool:' build-log_5.10.6-1-amd64-clang11-cfi.txt
vmlinux.o: warning: objtool: kretprobe_trampoline()+0x49: return with
modified stack frame
vmlinux.o: warning: objtool: machine_real_restart()+0x85: unsupported
instruction in callable function

Awesome.

If you need further information, please let me know.

Regards,
- Sedat -
