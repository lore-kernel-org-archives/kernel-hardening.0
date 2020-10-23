Return-Path: <SRS0=Lr2I=D6=lists.openwall.com=kernel-hardening-return-20256-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A436C55179
	for <kernel-hardening@archiver.kernel.org>; Fri, 23 Oct 2020 17:36:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 14A4D21527
	for <kernel-hardening@archiver.kernel.org>; Fri, 23 Oct 2020 17:36:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z3Q8f+9R"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 14A4D21527
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20256-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20258 invoked by uid 550); 23 Oct 2020 17:36:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20235 invoked from network); 23 Oct 2020 17:36:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v3oHNxup2Z/X3RcAQV9SdzT2AuZvE2TJPMlTRy4UVdg=;
        b=Z3Q8f+9RLq4ubmLePTMZVaggismFpKyU9D+I+6AiCOk4KvSVUOSNNZHXKxoPBh7GWY
         RClqHZm+Nfyudz9TEQyjxZMXOurxVJZX4mhjPfYxWkNyr/cAAEGYBbDAp5v2k6CMHKfq
         MxenOHLvWzjF6pubORCn8kVCK413lsXyOSsLbJ1trk61ipxsduiT0ok47wFrcNPbCcVG
         iiwP2bcnvlcv3dbrI1o9h1196320FtFTcf/aywJkmezF05US8O7ooXg0u/bJ/hMpDIr5
         +3GbzQLq4yHFL0EImfjvXUY3X7MZpkijg/UDpo6v1eWZb+7VchisG+G2qcBvKiNl6iKu
         Zb3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v3oHNxup2Z/X3RcAQV9SdzT2AuZvE2TJPMlTRy4UVdg=;
        b=DbL4cKswpV7v6wZijwQK0H03ochsU1GxyePx+Cie3P2F1ExRq9b7dMpcuqOEN+7HEu
         UjNXBR1HlpEjQdjmQkfQZBOUSOiF/1WVPdZ7gND/YL6swSEGYOG89VD8miHy9W0LiCSa
         SqN474ptVVtz/FeWKZlFr8htgxaSc3vOeE7/CaxVS8n4JV9eFSe/G3AcLA/TZ4ZVCKwg
         VdlYcngE8RCS69rhX0KiDza2KMYsf/lUfDS7mrVj8756RIERxoTH/7OU8Afg2M097Kp9
         fRq2Nf5RJ8Xy1mhDVr+nvEuIxJU2YEMB3iZMbMwAG7wQfycZpQv0gkU2w7YNi6NPOPTS
         S9Nw==
X-Gm-Message-State: AOAM533WZJfXOewM1ZeWF9+TpdpArKheCgYy7XtmVhd2YiANeF7t1W7/
	YjUCfjjPIaM3ytB56oYGJNexxw==
X-Google-Smtp-Source: ABdhPJy9hwXaRUl3z4AovIgAs9ZJu1Si99KmTZKm04vtb887MHqVl15EEMpST1nCdQo3PBn3pgvq6Q==
X-Received: by 2002:a63:370f:: with SMTP id e15mr3039898pga.124.1603474584438;
        Fri, 23 Oct 2020 10:36:24 -0700 (PDT)
Date: Fri, 23 Oct 2020 10:36:17 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jannh@google.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-pci@vger.kernel.org
Subject: Re: [PATCH v6 22/25] x86/asm: annotate indirect jumps
Message-ID: <20201023173617.GA3021099@google.com>
References: <20201013003203.4168817-1-samitolvanen@google.com>
 <20201013003203.4168817-23-samitolvanen@google.com>
 <CAG48ez2baAvKDA0wfYLKy-KnM_1CdOwjU873VJGDM=CErjsv_A@mail.gmail.com>
 <20201015102216.GB2611@hirez.programming.kicks-ass.net>
 <20201015203942.f3kwcohcwwa6lagd@treble>
 <CABCJKufDLmBCwmgGnfLcBw_B_4U8VY-R-dSNNp86TFfuMobPMw@mail.gmail.com>
 <20201020185217.ilg6w5l7ujau2246@treble>
 <CABCJKucVjFtrOsw58kn4OnW5kdkUh8G7Zs4s6QU9s6O7soRiAA@mail.gmail.com>
 <20201021085606.GZ2628@hirez.programming.kicks-ass.net>
 <CABCJKufL6=FiaeD8T0P+mK4JeR9J80hhjvJ6Z9S-m9UnCESxVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKufL6=FiaeD8T0P+mK4JeR9J80hhjvJ6Z9S-m9UnCESxVA@mail.gmail.com>

On Wed, Oct 21, 2020 at 05:22:59PM -0700, Sami Tolvanen wrote:
> There are a couple of differences, like the first "undefined stack
> state" warning pointing to set_bringup_idt_handler.constprop.0()
> instead of __switch_to_asm(). I tried running this with --backtrace,
> but objtool segfaults at the first .entry.text warning:

Looks like it segfaults when calling BT_FUNC() for an instruction that
doesn't have a section (?). Applying this patch allows objtool to finish
with --backtrace:

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index c216dd4d662c..618b0c4f2890 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -2604,7 +2604,7 @@ static int validate_branch(struct objtool_file *file, struct symbol *func,
 				ret = validate_branch(file, func,
 						      insn->jump_dest, state);
 				if (ret) {
-					if (backtrace)
+					if (backtrace && insn->sec)
 						BT_FUNC("(branch)", insn);
 					return ret;
 				}


Running objtool -barfld on an allyesconfig+LTO vmlinux.o prints out the
following, ignoring the crypto warnings for now:

__switch_to_asm()+0x0: undefined stack state
  xen_hypercall_set_trap_table()+0x0: <=== (sym)
.entry.text+0xffd: sibling call from callable instruction with modified stack frame
  .entry.text+0xfcb: (branch)
  .entry.text+0xfb5: (alt)
  .entry.text+0xfb0: (alt)
  .entry.text+0xf78: (branch)
  .entry.text+0x9c: (branch)
  xen_syscall_target()+0x15: (branch)
  xen_syscall_target()+0x0: <=== (sym)
.entry.text+0x1754: unsupported instruction in callable function
  .entry.text+0x171d: (branch)
  .entry.text+0x1707: (alt)
  .entry.text+0x1701: (alt)
  xen_syscall32_target()+0x15: (branch)
  xen_syscall32_target()+0x0: <=== (sym)
.entry.text+0x1634: redundant CLD
do_suspend_lowlevel()+0x116: sibling call from callable instruction with modified stack frame
  do_suspend_lowlevel()+0x9a: (branch)
  do_suspend_lowlevel()+0x0: <=== (sym)
... [skipping crypto stack pointer alignment warnings] ...
__x86_retpoline_rdi()+0x10: return with modified stack frame
  __x86_retpoline_rdi()+0x0: (branch)
  .altinstr_replacement+0x13d: (branch)
  .text+0xaf4c7: (alt)
  .text+0xb03b0: (branch)
  .text+0xaf482: (branch)
  crc_pcl()+0x10: (branch)
  crc_pcl()+0x0: <=== (sym)
__x86_retpoline_rdi()+0x0: stack state mismatch: cfa1=7+32 cfa2=7+8
  .altinstr_replacement+0x20b: (branch)
  __x86_indirect_thunk_rdi()+0x0: (alt)
  __x86_indirect_thunk_rdi()+0x0: <=== (sym)
.head.text+0xfb: unsupported instruction in callable function
  .head.text+0x207: (branch)
  sev_es_play_dead()+0xff: (branch)
  sev_es_play_dead()+0xd2: (branch)
  sev_es_play_dead()+0xa8: (alt)
  sev_es_play_dead()+0x144: (branch)
  sev_es_play_dead()+0x10b: (branch)
  sev_es_play_dead()+0x1f: (branch)
  sev_es_play_dead()+0x0: <=== (sym)
__x86_retpoline_rdi()+0x0: stack state mismatch: cfa1=7+32 cfa2=-1+0
  .altinstr_replacement+0x107: (branch)
  .text+0x2885: (alt)
  .text+0x2860: <=== (hint)
.entry.text+0x48: stack state mismatch: cfa1=7-8 cfa2=-1+0
  .altinstr_replacement+0xffffffffffffffff: (branch)
  .entry.text+0x21: (alt)
  .entry.text+0x1c: (alt)
  .entry.text+0x10: <=== (hint)
.entry.text+0x15fd: stack state mismatch: cfa1=7-8 cfa2=-1+0
  .altinstr_replacement+0xffffffffffffffff: (branch)
  .entry.text+0x15dc: (alt)
  .entry.text+0x15d7: (alt)
  .entry.text+0x15d0: <=== (hint)
.entry.text+0x168c: stack state mismatch: cfa1=7-8 cfa2=-1+0
  .altinstr_replacement+0xffffffffffffffff: (branch)
  .entry.text+0x166b: (alt)
  .entry.text+0x1666: (alt)
  .entry.text+0x1660: <=== (hint)

Sami
