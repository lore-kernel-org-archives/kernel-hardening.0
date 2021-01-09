Return-Path: <SRS0=WHdu=GM=lists.openwall.com=kernel-hardening-return-20618-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07026C433DB
	for <kernel-hardening@archiver.kernel.org>; Sat,  9 Jan 2021 16:22:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6A21823A23
	for <kernel-hardening@archiver.kernel.org>; Sat,  9 Jan 2021 16:22:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A21823A23
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20618-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14147 invoked by uid 550); 9 Jan 2021 16:22:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14121 invoked from network); 9 Jan 2021 16:22:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=SBw9x5RzF6S1E0bgP/dBM7DvvjaOtCClJyn1xuwfGAM=;
        b=ivZm2CZr3az3alRQ5FuDxSzTbBb3ILvI9WHM5seIOXxjHBiEx2ZIeqgJm+JV9tl7RO
         ZhQ77eHFQkMR1oTs1Qa0QNO81vv9qAg5XJr58smMNRbYuVLxsN+dz+a7HNocanIfCQgN
         P9upEioOrTeQwHgFwE0EhjoMHB/imztKDSo/sq4HgjSnzgGq2XVNdSFfY41ItwXhiGX9
         vunF4HVM6wF+4jjG/zD0qVBK6qwhBLI95WVy0jw5vvDk53PfFI4umqGvFPEPveT/fzLo
         +YH6U7Xn1H/MCvNNeGs6AzjNHzSE1lglIGxOWPjush8c+fdZ/UcGEA/lfs79BYGrNrb2
         H+tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=SBw9x5RzF6S1E0bgP/dBM7DvvjaOtCClJyn1xuwfGAM=;
        b=AxRZsWwCib3xA2yk1SG8L1KBAj0eQbAAZnFN9qqyWE4eKpNsO8NWE0qCRn8QPvh5g4
         2qVHRZPhja4RX+dOVbrfJQNh48DN2/Lbu3l++84ZblEDmHQtzrV+/rnotO11wzMwlyQp
         CvzeQAW9oZbeUVpKh+/gwearJBh6O9eoTJ7SawTcq74FXWE+8KHUWhm4+JVmGono0ten
         gu+h78WBcOBttKftXeWnXmeLz5fqWnwfVpbCB3KPGoDyGyIbdCMfEOTvY9z5pAdDwESa
         GhLKlhaA11Xi5HAypB/+UBRTCZQ2Q76IsoBU4tPT+qS4LS8fE2STamVDX78fpbvtIaMT
         iOWw==
X-Gm-Message-State: AOAM532xDdk3fhTig+p5AT4jGdKKq8y92/NeR90qGluv7VFgj6btxSuS
	46BnWyX95UxaLCfhNwgDV8O+t7sd4SlDlgihBvo=
X-Google-Smtp-Source: ABdhPJxOLHtBfV8AOPpXrXXuxrdgkS2WGzZDrDNCogUWxjHgMgHHItj2+IYeGbJgMqzyqqPipfKWi3S0CcurZMGsrh0=
X-Received: by 2002:a02:9f19:: with SMTP id z25mr8124040jal.30.1610209324708;
 Sat, 09 Jan 2021 08:22:04 -0800 (PST)
MIME-Version: 1.0
References: <20201211184633.3213045-1-samitolvanen@google.com>
 <CA+icZUWYxO1hHW-_vrJid7EstqQRYQphjO3Xn6pj6qfEYEONbA@mail.gmail.com>
 <20210109153646.zrmglpvr27f5zd7m@treble> <CA+icZUUiucbsQZtJKYdD7Y7Cq8hJZdBwsF0U0BFbaBtnLY3Nsw@mail.gmail.com>
 <20210109160709.kqqpf64klflajarl@treble>
In-Reply-To: <20210109160709.kqqpf64klflajarl@treble>
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Sat, 9 Jan 2021 17:21:51 +0100
Message-ID: <CA+icZUU=sS2xfzo9qTUTPQ0prbbQcj29tpDt1qK5cYZxarXuxg@mail.gmail.com>
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

On Sat, Jan 9, 2021 at 5:07 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Sat, Jan 09, 2021 at 04:46:21PM +0100, Sedat Dilek wrote:
> > On Sat, Jan 9, 2021 at 4:36 PM Josh Poimboeuf <jpoimboe@redhat.com> wro=
te:
> > >
> > > On Sat, Jan 09, 2021 at 03:54:20PM +0100, Sedat Dilek wrote:
> > > > I am interested in having Clang LTO (Clang-CFI) for x86-64 working =
and
> > > > help with testing.
> > > >
> > > > I tried the Git tree mentioned in [3] <jpoimboe.git#objtool-vmlinux=
>
> > > > (together with changes from <peterz.git#x86/urgent>).
> > > >
> > > > I only see in my build-log...
> > > >
> > > > drivers/gpu/drm/i915/gem/i915_gem_execbuffer.o: warning: objtool:
> > > > eb_relocate_parse_slow()+0x3d0: stack state mismatch: cfa1=3D7+120
> > > > cfa2=3D-1+0
> > > > drivers/gpu/drm/i915/gem/i915_gem_execbuffer.o: warning: objtool:
> > > > eb_copy_relocations()+0x229: stack state mismatch: cfa1=3D7+120
> > > > cfa2=3D-1+0
> > > >
> > > > ...which was reported and worked on in [1].
> > > >
> > > > This is with Clang-IAS version 11.0.1.
> > > >
> > > > Unfortunately, the recent changes in <samitolvanen.github#clang-cfi=
>
> > > > do not cleanly apply with Josh stuff.
> > > > My intention/wish was to report this combination of patchsets "heal=
s"
> > > > a lot of objtool-warnings for vmlinux.o I observed with Clang-CFI.
> > > >
> > > > Is it possible to have a Git branch where Josh's objtool-vmlinux is
> > > > working together with Clang-LTO?
> > > > For testing purposes.
> > >
> > > I updated my branch with my most recent work from before the holidays=
,
> > > can you try it now?  It still doesn't fix any of the crypto warnings,
> > > but I'll do that in a separate set after posting these next week.
> > >
> >
> > Thanks, Josh.
> >
> > Did you push it (oh ah push it push it really really really good...)
> > to your remote Git please :-).
>
> I thought I already pushed it pretty good ;-) do you not see it?
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git objtool-=
vmlinux
>
> d6baee244f2d =E2=80=94 objtool: Alphabetize usage option list (3 weeks ag=
o)
> c0b2a6a625ac =E2=80=94 objtool: Separate vmlinux/noinstr validation confi=
g options (3 weeks ago)
> 84c53551ad17 =E2=80=94 objtool: Enable full vmlinux validation (3 weeks a=
go)
> e518ac0801cd =E2=80=94 x86/power: Support objtool validation in hibernate=
_asm_64.S (3 weeks ago)
> d0ac4c7301c1 =E2=80=94 x86/power: Move restore_registers() to top of the =
file (3 weeks ago)
> d3389bc83538 =E2=80=94 x86/power: Convert indirect jumps to retpolines (3=
 weeks ago)
> 7a974d90aa40 =E2=80=94 x86/acpi: Support objtool validation in wakeup_64.=
S (3 weeks ago)
> 6693e26cd6cc =E2=80=94 x86/acpi: Convert indirect jump to retpoline (3 we=
eks ago)
> 0dfb760c74d1 =E2=80=94 x86/ftrace: Support objtool vmlinux.o validation i=
n ftrace_64.S (3 weeks ago)
> 89a4febfd7bf =E2=80=94 x86/xen/pvh: Convert indirect jump to retpoline (3=
 weeks ago)
> b62837092140 =E2=80=94 x86/xen: Support objtool vmlinux.o validation in x=
en-head.S (3 weeks ago)
> 705e18481ed9 =E2=80=94 x86/xen: Support objtool validation in xen-asm.S (=
3 weeks ago)
> 3548319e21b9 =E2=80=94 objtool: Add xen_start_kernel() to noreturn list (=
3 weeks ago)
> 6016e8da8c3d =E2=80=94 objtool: Combine UNWIND_HINT_RET_OFFSET and UNWIND=
_HINT_FUNC (3 weeks ago)
> 56d6a7aee8b1 =E2=80=94 objtool: Add asm version of STACK_FRAME_NON_STANDA=
RD (3 weeks ago)
> 68259d951f1a =E2=80=94 objtool: Assume only ELF functions do sibling call=
s (3 weeks ago)
> 0d6c8816cf91 =E2=80=94 x86/ftrace: Add UNWIND_HINT_FUNC annotation for ft=
race_stub (3 weeks ago)
> 24d6ce8cd8f6 =E2=80=94 objtool: Support retpoline jump detection for vmli=
nux.o (3 weeks ago)
> 8145ea268f16 =E2=80=94 objtool: Fix ".cold" section suffix check for newe=
r versions of GCC (3 weeks ago)
> b3dfca472514 =E2=80=94 objtool: Fix retpoline detection in asm code (3 we=
eks ago)
> b82402fa5211 =E2=80=94 objtool: Fix error handling for STD/CLD warnings (=
3 weeks ago)
> 1f02defb4b79 =E2=80=94 objtool: Fix seg fault in BT_FUNC() with fake jump=
 (3 weeks ago)
> 2c85ebc57b3e =E2=80=94 Linux 5.10 (4 weeks ago)
>

I already have this one in my patch-series - I hoped you pushed
something new to your objtool-vmlinux Git branch.
That is what I mean by shortened... <jpoimboe.git#objtool-vmlinux>.

Hey, it's based on Linux v5.10 - I can test this with Linux v5.10.6 :-).

- Sedat -
