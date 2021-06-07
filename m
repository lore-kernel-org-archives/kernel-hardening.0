Return-Path: <SRS0=W7bN=LB=lists.openwall.com=kernel-hardening-return-21285-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA33C47082
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Jun 2021 07:39:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E5B776121F
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Jun 2021 07:39:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5B776121F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21285-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19867 invoked by uid 550); 7 Jun 2021 07:39:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19829 invoked from network); 7 Jun 2021 07:39:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FkDnZkLm7S26Fub+7GJQrbQgH8zlz9fkqHVVt8EUVII=;
        b=nHm4WK6cYXy60WGLih3X49PfQoCmkrbdxEffYKfbL3/RwZaUJn+ZpFlw1f4qhBKOsh
         ahRqwNfz/pELzJOgvhEH7fSmrENCdPGqiDPPnxASXGD5q9sd6Dk5WUdbdBbPUArWSpgz
         YhjtWV0vG8EhX7zQlQ+lNbW/aFKCucpeFKWsmDvBb4gvT3urI0A7KLePEk+N9605Vxec
         pkm2nZH26PbCFEe3Rt8MWK2GYZWEhX1zJkTawVJymWS9/t+exzEZtixnPBaQ3CKp7qxO
         KJPc74KVXSeqk4iHCZH7tGPVflFVx/UFdpy6RZ1xAkh+rjGRzUNDiP+yZ5nLQUld/tUh
         Nh2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FkDnZkLm7S26Fub+7GJQrbQgH8zlz9fkqHVVt8EUVII=;
        b=fBAKqfgsykVGZwT8nZ/pprGPPTEP4q25bBzP4NC3FRxLLK2AqUDqf1O3biPHs7ZOlW
         /YE50w3DVUHZBuiSVEw2HWfXEQsZAsymRXyKxmFDvAhvnZFKa5VCmyb1JEgyDpk2mXc2
         NT61cHP1UMyyc2lxaPaXNErFXRXUV8yDabaWA99B48Wn7+tta6E6f77217OGonSQsvF3
         m8v5yvLzSwacXT2S3vfc3AYydrC7mZAPziCUppiNl4VahVfxM/XMJcKGa0yrenHqoeqW
         EAzobQvlXtmXhxfRhGHRGdqVAAhGBtto2MgNOmtWUbfF0TnE/y1lguUAh50lggR/oe5A
         DiJA==
X-Gm-Message-State: AOAM533nB8niOIUkg3HqbKt9jT6Kj7NgCD/lxhhMiAeXPqdwvV+15ern
	4UQV+aK2FFr6JLa8y3OfcmnU+iFVHKOoS/yJqwtzcw==
X-Google-Smtp-Source: ABdhPJw+kgwDX9eCqL8hOPDdudAvKTGNSsQ1Stvnfjs7IZaa/qdT3iEe5T8MNwE87hz52U2sn3g3U6qP7w8/LoXc35w=
X-Received: by 2002:ac8:7c4e:: with SMTP id o14mr14825948qtv.290.1623051534847;
 Mon, 07 Jun 2021 00:38:54 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000c2987605be907e41@google.com> <20210602212726.7-1-fuzzybritches0@gmail.com>
 <YLhd8BL3HGItbXmx@kroah.com> <87609-531187-curtm@phaethon>
 <6a392b66-6f26-4532-d25f-6b09770ce366@fb.com> <CAADnVQKexxZQw0yK_7rmFOdaYabaFpi2EmF6RGs5bXvFHtUQaA@mail.gmail.com>
In-Reply-To: <CAADnVQKexxZQw0yK_7rmFOdaYabaFpi2EmF6RGs5bXvFHtUQaA@mail.gmail.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 7 Jun 2021 09:38:43 +0200
Message-ID: <CACT4Y+b=si6NCx=nRHKm_pziXnVMmLo-eSuRajsxmx5+Hy_ycg@mail.gmail.com>
Subject: Re: [PATCH v4] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Yonghong Song <yhs@fb.com>, Kurt Manucredo <fuzzybritches0@gmail.com>, 
	syzbot+bed360704c521841c85d@syzkaller.appspotmail.com, 
	Andrii Nakryiko <andrii@kernel.org>, Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, "David S. Miller" <davem@davemloft.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, John Fastabend <john.fastabend@gmail.com>, 
	Martin KaFai Lau <kafai@fb.com>, KP Singh <kpsingh@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, 
	Song Liu <songliubraving@fb.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, 
	nathan@kernel.org, Nick Desaulniers <ndesaulniers@google.com>, 
	Clang-Built-Linux ML <clang-built-linux@googlegroups.com>, 
	linux-kernel-mentees@lists.linuxfoundation.org, 
	Shuah Khan <skhan@linuxfoundation.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, Jun 5, 2021 at 9:10 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> On Sat, Jun 5, 2021 at 10:55 AM Yonghong Song <yhs@fb.com> wrote:
> > On 6/5/21 8:01 AM, Kurt Manucredo wrote:
> > > Syzbot detects a shift-out-of-bounds in ___bpf_prog_run()
> > > kernel/bpf/core.c:1414:2.
> >
> > This is not enough. We need more information on why this happens
> > so we can judge whether the patch indeed fixed the issue.
> >
> > >
> > > I propose: In adjust_scalar_min_max_vals() move boundary check up to avoid
> > > missing them and return with error when detected.
> > >
> > > Reported-and-tested-by: syzbot+bed360704c521841c85d@syzkaller.appspotmail.com
> > > Signed-off-by: Kurt Manucredo <fuzzybritches0@gmail.com>
> > > ---
> > >
> > > https://syzkaller.appspot.com/bug?id=edb51be4c9a320186328893287bb30d5eed09231
> > >
> > > Changelog:
> > > ----------
> > > v4 - Fix shift-out-of-bounds in adjust_scalar_min_max_vals.
> > >       Fix commit message.
> > > v3 - Make it clearer what the fix is for.
> > > v2 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
> > >       check in check_alu_op() in verifier.c.
> > > v1 - Fix shift-out-of-bounds in ___bpf_prog_run() by adding boundary
> > >       check in ___bpf_prog_run().
> > >
> > > thanks
> > >
> > > kind regards
> > >
> > > Kurt
> > >
> > >   kernel/bpf/verifier.c | 30 +++++++++---------------------
> > >   1 file changed, 9 insertions(+), 21 deletions(-)
> > >
> > > diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> > > index 94ba5163d4c5..ed0eecf20de5 100644
> > > --- a/kernel/bpf/verifier.c
> > > +++ b/kernel/bpf/verifier.c
> > > @@ -7510,6 +7510,15 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
> > >       u32_min_val = src_reg.u32_min_value;
> > >       u32_max_val = src_reg.u32_max_value;
> > >
> > > +     if ((opcode == BPF_LSH || opcode == BPF_RSH || opcode == BPF_ARSH) &&
> > > +                     umax_val >= insn_bitness) {
> > > +             /* Shifts greater than 31 or 63 are undefined.
> > > +              * This includes shifts by a negative number.
> > > +              */
> > > +             verbose(env, "invalid shift %lld\n", umax_val);
> > > +             return -EINVAL;
> > > +     }
> >
> > I think your fix is good. I would like to move after
>
> I suspect such change will break valid programs that do shift by register.
>
> > the following code though:
> >
> >          if (!src_known &&
> >              opcode != BPF_ADD && opcode != BPF_SUB && opcode != BPF_AND) {
> >                  __mark_reg_unknown(env, dst_reg);
> >                  return 0;
> >          }
> >
> > > +
> > >       if (alu32) {
> > >               src_known = tnum_subreg_is_const(src_reg.var_off);
> > >               if ((src_known &&
> > > @@ -7592,39 +7601,18 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
> > >               scalar_min_max_xor(dst_reg, &src_reg);
> > >               break;
> > >       case BPF_LSH:
> > > -             if (umax_val >= insn_bitness) {
> > > -                     /* Shifts greater than 31 or 63 are undefined.
> > > -                      * This includes shifts by a negative number.
> > > -                      */
> > > -                     mark_reg_unknown(env, regs, insn->dst_reg);
> > > -                     break;
> > > -             }
> >
> > I think this is what happens. For the above case, we simply
> > marks the dst reg as unknown and didn't fail verification.
> > So later on at runtime, the shift optimization will have wrong
> > shift value (> 31/64). Please correct me if this is not right
> > analysis. As I mentioned in the early please write detailed
> > analysis in commit log.
>
> The large shift is not wrong. It's just undefined.
> syzbot has to ignore such cases.

Hi Alexei,

The report is produced by KUBSAN. I thought there was an agreement on
cleaning up KUBSAN reports from the kernel (the subset enabled on
syzbot at least).
What exactly cases should KUBSAN ignore?
+linux-hardening/kasan-dev for KUBSAN false positive
