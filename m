Return-Path: <SRS0=l+lY=GM=lists.openwall.com=kernel-hardening-return-20620-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5166C433DB
	for <kernel-hardening@archiver.kernel.org>; Sat,  9 Jan 2021 16:46:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8C2C02343F
	for <kernel-hardening@archiver.kernel.org>; Sat,  9 Jan 2021 16:46:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C2C02343F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20620-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25782 invoked by uid 550); 9 Jan 2021 16:46:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25756 invoked from network); 9 Jan 2021 16:46:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=rDWdOZV033PbHRIoz9gFCdCCPtDWdrf2QpLHI3qC4Ks=;
        b=lKYcZ/pDNyBpVRy/AIFMoAbc4kprZN1qFvAjZkMTlSPZ5aYun28E09bjuogCaNUv7+
         Jk00ybCpOX3sRiY1yW7DtbR1t5e0mTTTipytCO1wRUEXHBZlQRRsJKvAw3XkePn6yfiV
         UFNx1upTAd3QSESauWaa2JAU/2cdQxOzkt5Ztgw/fJYIwXoUFzmkQRpOqFsPrfUNYW9c
         EFSdjIuirPdJ+egYTzlBHVJ7Rr2et1jlwL7eG1TSMJjCDRIrWqamwd5W4oCOtNuRZded
         QQ8dIwDS4wHOnvl7ZFgLKeJW/GUG/iAAMiIFzyTyTueJxHEPLZYCOOH5OpE4A9esijMR
         ph1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=rDWdOZV033PbHRIoz9gFCdCCPtDWdrf2QpLHI3qC4Ks=;
        b=GOKbw7uZll3bQjd1LJ5ZhNHyn++JmY51BSodmkJjp2YTc4TQv2OCAqCSHouOVUTXgY
         xFrcyyTFRlzWnbgFsS4h80VN9PQL7wQwzhQBsMSDlXRD3Xu5A2ow3F4SkzC3nR+sgNgK
         /hzsyuaHpo7U8MT6j58aUAHLZrO3yxKyFCFgcIA3o24LJN9tQhBZAkHmhxkEwidzxuj2
         zwxAHxbk7A1t0Vcar+WoU0Ae2wqge2aZrvkIjiGc7ueup3kV+2cSXOtWwrCO0qsB8l1B
         ZAxt5uSPvq5Sv2LAAVlK/1/2/DbMMbFKsfcrW1p93iijG7YscNM5ITliQ+p6nf+/Nrqt
         P3Iw==
X-Gm-Message-State: AOAM531e5Vw4r6gFJ45nGmIPL8vlkmo+kRiy0a1nIIHfde3nMoEhVVzd
	PHU4aqFjrhnZnRNUmB5hj9J5eUFM6sJBCgFHWZk=
X-Google-Smtp-Source: ABdhPJyotcpCJj00XIwZxbBrRJwxOADUXFaeLowTjCUgN91QtyNu5IEBjFHQ+MWTW5HHUGdfbSGUxbCNMTehHWc8gzM=
X-Received: by 2002:a92:c692:: with SMTP id o18mr9393270ilg.215.1610210757859;
 Sat, 09 Jan 2021 08:45:57 -0800 (PST)
MIME-Version: 1.0
References: <20201211184633.3213045-1-samitolvanen@google.com>
 <CA+icZUWYxO1hHW-_vrJid7EstqQRYQphjO3Xn6pj6qfEYEONbA@mail.gmail.com>
 <20210109153646.zrmglpvr27f5zd7m@treble> <CA+icZUUiucbsQZtJKYdD7Y7Cq8hJZdBwsF0U0BFbaBtnLY3Nsw@mail.gmail.com>
 <20210109160709.kqqpf64klflajarl@treble> <CA+icZUU=sS2xfzo9qTUTPQ0prbbQcj29tpDt1qK5cYZxarXuxg@mail.gmail.com>
 <20210109163256.3sv3wbgrshbj72ik@treble>
In-Reply-To: <20210109163256.3sv3wbgrshbj72ik@treble>
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Sat, 9 Jan 2021 17:45:47 +0100
Message-ID: <CA+icZUUszOHkJ8Acx2mDowg3StZw9EureDQ7YYkJkcAnpLBA+g@mail.gmail.com>
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
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 9, 2021 at 5:33 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> > > > Did you push it (oh ah push it push it really really really good...=
)
> > > > to your remote Git please :-).
> > >
> > > I thought I already pushed it pretty good ;-) do you not see it?
> > >
> > > git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git objt=
ool-vmlinux
> > >
> > > d6baee244f2d =E2=80=94 objtool: Alphabetize usage option list (3 week=
s ago)
> > > c0b2a6a625ac =E2=80=94 objtool: Separate vmlinux/noinstr validation c=
onfig options (3 weeks ago)
> > > 84c53551ad17 =E2=80=94 objtool: Enable full vmlinux validation (3 wee=
ks ago)
> > > e518ac0801cd =E2=80=94 x86/power: Support objtool validation in hiber=
nate_asm_64.S (3 weeks ago)
> > > d0ac4c7301c1 =E2=80=94 x86/power: Move restore_registers() to top of =
the file (3 weeks ago)
> > > d3389bc83538 =E2=80=94 x86/power: Convert indirect jumps to retpoline=
s (3 weeks ago)
> > > 7a974d90aa40 =E2=80=94 x86/acpi: Support objtool validation in wakeup=
_64.S (3 weeks ago)
> > > 6693e26cd6cc =E2=80=94 x86/acpi: Convert indirect jump to retpoline (=
3 weeks ago)
> > > 0dfb760c74d1 =E2=80=94 x86/ftrace: Support objtool vmlinux.o validati=
on in ftrace_64.S (3 weeks ago)
> > > 89a4febfd7bf =E2=80=94 x86/xen/pvh: Convert indirect jump to retpolin=
e (3 weeks ago)
> > > b62837092140 =E2=80=94 x86/xen: Support objtool vmlinux.o validation =
in xen-head.S (3 weeks ago)
> > > 705e18481ed9 =E2=80=94 x86/xen: Support objtool validation in xen-asm=
.S (3 weeks ago)
> > > 3548319e21b9 =E2=80=94 objtool: Add xen_start_kernel() to noreturn li=
st (3 weeks ago)
> > > 6016e8da8c3d =E2=80=94 objtool: Combine UNWIND_HINT_RET_OFFSET and UN=
WIND_HINT_FUNC (3 weeks ago)
> > > 56d6a7aee8b1 =E2=80=94 objtool: Add asm version of STACK_FRAME_NON_ST=
ANDARD (3 weeks ago)
> > > 68259d951f1a =E2=80=94 objtool: Assume only ELF functions do sibling =
calls (3 weeks ago)
> > > 0d6c8816cf91 =E2=80=94 x86/ftrace: Add UNWIND_HINT_FUNC annotation fo=
r ftrace_stub (3 weeks ago)
> > > 24d6ce8cd8f6 =E2=80=94 objtool: Support retpoline jump detection for =
vmlinux.o (3 weeks ago)
> > > 8145ea268f16 =E2=80=94 objtool: Fix ".cold" section suffix check for =
newer versions of GCC (3 weeks ago)
> > > b3dfca472514 =E2=80=94 objtool: Fix retpoline detection in asm code (=
3 weeks ago)
> > > b82402fa5211 =E2=80=94 objtool: Fix error handling for STD/CLD warnin=
gs (3 weeks ago)
> > > 1f02defb4b79 =E2=80=94 objtool: Fix seg fault in BT_FUNC() with fake =
jump (3 weeks ago)
> > > 2c85ebc57b3e =E2=80=94 Linux 5.10 (4 weeks ago)
> > >
> >
> > I already have this one in my patch-series - I hoped you pushed
> > something new to your objtool-vmlinux Git branch.
> > That is what I mean by shortened... <jpoimboe.git#objtool-vmlinux>.
> >
> > Hey, it's based on Linux v5.10 - I can test this with Linux v5.10.6 :-)=
.
>
> This is the most recent version of the patches.  I only pushed them this
> morning since you said the prior version wasn't applying on Sami's
> clang-cfi branch.  This version rebases fine on 'clang-cfi'.
>

I tried merging with clang-cfi Git which is based on Linux v5.11-rc2+
with a lot of merge conflicts.

Did you try on top of cfi-10 Git tag which is based on Linux v5.10?

Whatever you successfully did... Can you give me a step-by-step instruction=
?

- Sedat -
