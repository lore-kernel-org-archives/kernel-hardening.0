Return-Path: <SRS0=oPAr=EP=lists.openwall.com=kernel-hardening-return-20370-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 665C6C4741F
	for <kernel-hardening@archiver.kernel.org>; Mon,  9 Nov 2020 23:12:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1ECE32074F
	for <kernel-hardening@archiver.kernel.org>; Mon,  9 Nov 2020 23:12:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t1l2R3Sn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1ECE32074F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20370-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13905 invoked by uid 550); 9 Nov 2020 23:12:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13883 invoked from network); 9 Nov 2020 23:12:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JZQgZVi3YCvHDQb4j6S1eW+CN0G55HltfL6yQaxCZtw=;
        b=t1l2R3SnFFVdfdQvYDlijrD+UPXk5ZGukiIRHbJTgQvkl7MTRTVczlXt06QVcmacOU
         Vq3BUJUgAZO6+588P8OO1JRTe7UiwB49K2bkoIQ6w9PNfnSXY776+H/z2QNOD9pBtnZr
         i05N8trMnBkez5wbwi+w6kBRSBw8LXuAVWvbCdU88nCrBKLfdQmj3N16FJBIDo9iCBjp
         yFXmba2Ft4il4SYs0wKwBCCmZDmGe7YDt5JC6ZYcyK8Qw6xos9xkUlZyf3ZuAhZkYY+N
         cX7DJc+SmToTO8Tnv/dbcYY1E0OJEJbMR39R6oZeEenW8DovERzm0Y6tVyJoIffqRt1v
         xZzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JZQgZVi3YCvHDQb4j6S1eW+CN0G55HltfL6yQaxCZtw=;
        b=h98ZJa+hXO9PzIpHhlSUS+n7i/1UXTaSTXsfQqzBRSqGR+1dqqgFmsdpwY5gEkgJ8f
         qcSSnuszItFqpN3dwVF7VIz30yKINBi1Ichvn5V16mBedo6q46p+T7kzTKb38Q0qbs3A
         DRoXx68rjyIcwFWuVNvo/cOcp2HgA+tw1R0iyoJrTeAb3xgLsM175SKsGck99KmBcR0+
         ocBMPABBHqAeUgegev9a59pOoYPSnRXSq/Ii3GDeddizdDDh5nbo2BZ7lPDmziijov9j
         TBrHxqAqmhQFag3bgz4W+DkDSpXvW10ObhVFzgg6JbM8e7gE1pYeAHVZw3dTkEgFeDnx
         sO2w==
X-Gm-Message-State: AOAM5329M8QTOplvsYFH0AbisNCkoSiCs3QORHM8lOt04eqXt9+R7Qbn
	+zzMhOMgV/OTGGW1Z3YuOlBv8mjO2erKX2j6aYM0GQ==
X-Google-Smtp-Source: ABdhPJzSnCy7R7CRJtXrWRQ8NOKgeJ6TkQkftDL443Gd1HeH/sey0RLyxXEmQPm/+B7rr2/os6cjJRBBWXYe+xD8OYU=
X-Received: by 2002:ab0:186a:: with SMTP id j42mr8260179uag.52.1604963513337;
 Mon, 09 Nov 2020 15:11:53 -0800 (PST)
MIME-Version: 1.0
References: <20201013003203.4168817-1-samitolvanen@google.com>
 <20201013003203.4168817-23-samitolvanen@google.com> <CAG48ez2baAvKDA0wfYLKy-KnM_1CdOwjU873VJGDM=CErjsv_A@mail.gmail.com>
 <20201015102216.GB2611@hirez.programming.kicks-ass.net> <20201015203942.f3kwcohcwwa6lagd@treble>
 <CABCJKufDLmBCwmgGnfLcBw_B_4U8VY-R-dSNNp86TFfuMobPMw@mail.gmail.com>
 <20201020185217.ilg6w5l7ujau2246@treble> <CABCJKucVjFtrOsw58kn4OnW5kdkUh8G7Zs4s6QU9s6O7soRiAA@mail.gmail.com>
 <20201021085606.GZ2628@hirez.programming.kicks-ass.net> <CABCJKufL6=FiaeD8T0P+mK4JeR9J80hhjvJ6Z9S-m9UnCESxVA@mail.gmail.com>
 <20201023173617.GA3021099@google.com>
In-Reply-To: <20201023173617.GA3021099@google.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Mon, 9 Nov 2020 15:11:41 -0800
Message-ID: <CABCJKuee7hUQSiksdRMYNNx05bW7pWaDm4fQ__znGQ99z9-dEw@mail.gmail.com>
Subject: Re: [PATCH v6 22/25] x86/asm: annotate indirect jumps
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jannh@google.com>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2020 at 10:36 AM Sami Tolvanen <samitolvanen@google.com> wr=
ote:
>
> On Wed, Oct 21, 2020 at 05:22:59PM -0700, Sami Tolvanen wrote:
> > There are a couple of differences, like the first "undefined stack
> > state" warning pointing to set_bringup_idt_handler.constprop.0()
> > instead of __switch_to_asm(). I tried running this with --backtrace,
> > but objtool segfaults at the first .entry.text warning:
>
> Looks like it segfaults when calling BT_FUNC() for an instruction that
> doesn't have a section (?). Applying this patch allows objtool to finish
> with --backtrace:
>
> diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> index c216dd4d662c..618b0c4f2890 100644
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -2604,7 +2604,7 @@ static int validate_branch(struct objtool_file *fil=
e, struct symbol *func,
>                                 ret =3D validate_branch(file, func,
>                                                       insn->jump_dest, st=
ate);
>                                 if (ret) {
> -                                       if (backtrace)
> +                                       if (backtrace && insn->sec)
>                                                 BT_FUNC("(branch)", insn)=
;
>                                         return ret;
>                                 }
>
>
> Running objtool -barfld on an allyesconfig+LTO vmlinux.o prints out the
> following, ignoring the crypto warnings for now:

OK, I spent some time looking at these warnings and the configs needed
to reproduce them without building allyesconfig:

CONFIG_XEN

__switch_to_asm()+0x0: undefined stack state
  xen_hypercall_set_trap_table()+0x0: <=3D=3D=3D (sym)

CONFIG_XEN_PV

.entry.text+0xffd: sibling call from callable instruction with
modified stack frame
  .entry.text+0xfcb: (branch)
  .entry.text+0xfb5: (alt)
  .entry.text+0xfb0: (alt)
  .entry.text+0xf78: (branch)
  .entry.text+0x9c: (branch)
  xen_syscall_target()+0x15: (branch)
  xen_syscall_target()+0x0: <=3D=3D=3D (sym)
.entry.text+0x1754: unsupported instruction in callable function
  .entry.text+0x171d: (branch)
  .entry.text+0x1707: (alt)
  .entry.text+0x1701: (alt)
  xen_syscall32_target()+0x15: (branch)
  xen_syscall32_target()+0x0: <=3D=3D=3D (sym)
.entry.text+0x1634: redundant CLD

Backtrace doesn=E2=80=99t print out anything useful for the =E2=80=9Credund=
ant CLD=E2=80=9D
error, but it occurs when validate_branch is looking at
xen_sysenter_target.

do_suspend_lowlevel()+0x116: sibling call from callable instruction
with modified stack frame
  do_suspend_lowlevel()+0x9a: (branch)
  do_suspend_lowlevel()+0x0: <=3D=3D=3D (sym)

.entry.text+0x48: stack state mismatch: cfa1=3D7-8 cfa2=3D-1+0
  .altinstr_replacement+0xffffffffffffffff: (branch)
  .entry.text+0x21: (alt)
  .entry.text+0x1c: (alt)
  .entry.text+0x10: <=3D=3D=3D (hint)
.entry.text+0x15fd: stack state mismatch: cfa1=3D7-8 cfa2=3D-1+0
  .altinstr_replacement+0xffffffffffffffff: (branch)
  .entry.text+0x15dc: (alt)
  .entry.text+0x15d7: (alt)
  .entry.text+0x15d0: <=3D=3D=3D (hint)
.entry.text+0x168c: stack state mismatch: cfa1=3D7-8 cfa2=3D-1+0
  .altinstr_replacement+0xffffffffffffffff: (branch)
  .entry.text+0x166b: (alt)
  .entry.text+0x1666: (alt)
  .entry.text+0x1660: <=3D=3D=3D (hint)

It looks like the stack state mismatch warnings can be fixed by adding
unwind hints also to entry_SYSCALL_64_after_hwframe,
entry_SYSENTER_compat_after_hwframe, and
entry_SYSCALL_compat_after_hwframe. Does that sound correct?

CONFIG_AMD_MEM_ENCRYPT

.head.text+0xfb: unsupported instruction in callable function
  .head.text+0x207: (branch)
  sev_es_play_dead()+0xff: (branch)
  sev_es_play_dead()+0xd2: (branch)
  sev_es_play_dead()+0xa8: (alt)
  sev_es_play_dead()+0x144: (branch)
  sev_es_play_dead()+0x10b: (branch)
  sev_es_play_dead()+0x1f: (branch)
  sev_es_play_dead()+0x0: <=3D=3D=3D (sym)

This happens because sev_es_play_dead calls start_cpu0. It always has,
but objtool hasn=E2=80=99t been able to follow the call when processing onl=
y
sev-es.o. Any thoughts on the preferred way to fix this one?

CONFIG_CRYPTO_CRC32C_INTEL

__x86_retpoline_rdi()+0x10: return with modified stack frame
  __x86_retpoline_rdi()+0x0: (branch)
  .altinstr_replacement+0x147: (branch)
  .text+0xaf4c7: (alt)
  .text+0xb03b0: (branch)
  .text+0xaf482: (branch)
  crc_pcl()+0x10: (branch)
  crc_pcl()+0x0: <=3D=3D=3D (sym)

__x86_retpoline_rdi()+0x0: stack state mismatch: cfa1=3D7+32 cfa2=3D7+8
  .altinstr_replacement+0x265: (branch)
  __x86_indirect_thunk_rdi()+0x0: (alt)
  __x86_indirect_thunk_rdi()+0x0: <=3D=3D=3D (sym)

This is different from the warnings in the rest of the arch/x86/crypto
code. Do we need some kind of a hint before the JMP_NOSPEC in crc_pcl?

CONFIG_FUNCTION_TRACER

__x86_retpoline_rdi()+0x0: stack state mismatch: cfa1=3D7+32 cfa2=3D-1+0
  .altinstr_replacement+0x111: (branch)
  .text+0x28a5: (alt)
  .text+0x2880: <=3D=3D=3D (hint)

This unwind hint is in return_to_handler. Removing it obviously stops
the warning and doesn=E2=80=99t seem to result in any other complaints from
objtool. Is this hint correct?

The remaining warnings are all =E2=80=9Cunsupported stack pointer realignme=
nt=E2=80=9D
issues in the crypto code and can be reproduced with the following
configs:

CONFIG_CRYPTO_AES_NI_INTEL
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64
CONFIG_CRYPTO_SHA1_SSSE3
CONFIG_CRYPTO_SHA256_SSSE3
CONFIG_CRYPTO_SHA512_SSSE3

Josh, have you had a chance to look at the crypto patches you mentioned ear=
lier?

Sami
