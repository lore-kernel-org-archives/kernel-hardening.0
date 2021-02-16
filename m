Return-Path: <SRS0=BId4=HT=lists.openwall.com=kernel-hardening-return-20764-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1060C433DB
	for <kernel-hardening@archiver.kernel.org>; Wed, 17 Feb 2021 10:08:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5095E64DA8
	for <kernel-hardening@archiver.kernel.org>; Wed, 17 Feb 2021 10:08:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5095E64DA8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20764-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26582 invoked by uid 550); 17 Feb 2021 10:08:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1901 invoked from network); 16 Feb 2021 21:37:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:content-transfer-encoding:in-reply-to:references
         :subject:from:cc:to:date:message-id:user-agent;
        bh=5c13cGmUbt4hYOZvHMgppB/+Rio5HpP/68H4KQeLHN0=;
        b=ReRhDxqhbkSunXoNFKs68QXeXQQe29qls3Rawassd5TnOS0ra/BVaRti5N4JCpku9i
         WFvN0eptTroG6ILFk0aJk+7U0Cpwpv7GZABusU3ks2UHd2cYY0SRNO1clV8mveQsZY6v
         4SPhZlK3ZoeBDaWYjTe0m41r/urlACLvjZVus=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:content-transfer-encoding
         :in-reply-to:references:subject:from:cc:to:date:message-id
         :user-agent;
        bh=5c13cGmUbt4hYOZvHMgppB/+Rio5HpP/68H4KQeLHN0=;
        b=LruKYJgmxJTzK0NH9zEv5f6at82Zk4ZnQTS8vZX7Yg1wr2a96qy+Jgn0wFiC58gpz0
         2Hkt0X6HyQS1PQZRwk4o53LPB/wzSXD4UbHjLQX+TKkRKsrkSLHJElo3VpYcUdRfATd5
         dJcJhxRjmjfWJ/A5Mr1LaSUTzbenOFb8hOO3U6LX8kKksviluBVZlsDnCplo3Mn7qtxJ
         uqKRpHcDanrOF+bvAlsCYuysThOGSLKszHRzo7Bt4kKzhK0bUZA1zL9EBLgXeghMIxLv
         Nv/Cc+IO3p8dgZkmB8NpJwXqQLOtAgFK77kWTUwr0PUqg7Am+a+WDxdBSDwHrhmG8DFl
         GfFA==
X-Gm-Message-State: AOAM532VhOREmGjHPJ9z1bmMY7S/SutKs7oMhxoKbb/mYtkxp1xKqEAc
	QEjbAs3tpj6AviCtXpURK7jPpA==
X-Google-Smtp-Source: ABdhPJwng0YRoOB0lMJEAUYvnaPmhEg25ysj4ilBC6cgdOuDyH/JoytyrQ43BqTv7IY+NAg5Fqljeg==
X-Received: by 2002:a17:90a:1485:: with SMTP id k5mr1833899pja.103.1613511466714;
        Tue, 16 Feb 2021 13:37:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20201211184633.3213045-6-samitolvanen@google.com>
References: <20201211184633.3213045-1-samitolvanen@google.com> <20201211184633.3213045-6-samitolvanen@google.com>
Subject: Re: [PATCH v9 05/16] kbuild: lto: merge module sections
From: Stephen Boyd <swboyd@chromium.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Paul E. McKenney <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>, <stable@vger.kernel.org>
Date: Tue, 16 Feb 2021 13:37:44 -0800
Message-ID: <161351146485.1254594.3592715065187730966@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1

Quoting Sami Tolvanen (2020-12-11 10:46:22)
> LLD always splits sections with LTO, which increases module sizes. This
> change adds linker script rules to merge the split sections in the final
> module.
>=20
> Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---

This patch fixes a warning I see on arm64 devices running the 5.10 LTS kern=
el.
Can we queue this to the stable tree once it lands in Linus' tree?

 sysfs: cannot create duplicate filename '/module/configs/sections/__patcha=
ble_function_entries'
 CPU: 3 PID: 4173 Comm: modprobe Not tainted 5.10.13 #10
 Hardware name: Google Lazor (rev3+) with KB Backlight (DT)
 Call trace:
  dump_backtrace+0x0/0x1c0
  show_stack+0x24/0x30
  dump_stack+0xc0/0x120
  sysfs_warn_dup+0x74/0x90
  sysfs_add_file_mode_ns+0x12c/0x178
  internal_create_group+0x264/0x36c
  sysfs_create_group+0x24/0x30
  add_sect_attrs+0x154/0x188
  mod_sysfs_setup+0x208/0x284
  load_module+0xff8/0x1158
  __arm64_sys_finit_module+0xb4/0xf0
  el0_svc_common+0xf4/0x1c0
  do_el0_svc_compat+0x2c/0x40
  el0_svc_compat+0x10/0x1c
  el0_sync_compat_handler+0xc0/0xf0
  el0_sync_compat+0x178/0x180

The problem is that the section __patchable_function_entries is present
twice in the kernel module I've compiled. I see that
__patchable_function_entries is used on arm64 now that we have commit
a1326b17ac03 ("module/ftrace: handle patchable-function-entry") combined
with commit 3b23e4991fb6 ("arm64: implement ftrace with regs").

This linker script change nicely combines the section into one instead
of two.

Before:

$ readelf -WS configs.ko=20
There are 29 section headers, starting at offset 0xad78:

Section Headers:
  [Nr] Name              Type            Address          Off    Size   ES =
Flg Lk Inf Al
  [ 0]                   NULL            0000000000000000 000000 000000 00 =
     0   0  0
  [ 1] .plt              NOBITS          0000000000000000 000040 000001 00 =
 AX  0   0 16
  [ 2] .init.plt         NOBITS          0000000000000000 000040 000001 00 =
 AX  0   0  1
  [ 3] .text.ftrace_trampoline NOBITS          0000000000000000 000040 0000=
01 00  AX  0   0  1
  [ 4] .text             PROGBITS        0000000000000000 000040 00004c 00 =
 AX  0   0  4
  [ 5] .rela.text        RELA            0000000000000000 00aa10 000078 18 =
  I 26   4  8
  [ 6] __patchable_function_entries PROGBITS        0000000000000000 000090=
 000008 00 WAL  4   0  8
  [ 7] .rela__patchable_function_entries RELA            0000000000000000 0=
0aa88 000018 18   I 26   6  8
  [ 8] .rodata           PROGBITS        0000000000000000 000098 009c98 00 =
  A  0   0  8
  [ 9] .rela.rodata      RELA            0000000000000000 00aaa0 000030 18 =
  I 26   8  8
  [10] .init.text        PROGBITS        0000000000000000 009d30 000068 00 =
 AX  0   0  4
  [11] .rela.init.text   RELA            0000000000000000 00aad0 0000f0 18 =
  I 26  10  8
  [12] __patchable_function_entries PROGBITS        0000000000000000 009d98=
 000008 00 WAL 10   0  8
  [13] .rela__patchable_function_entries RELA            0000000000000000 0=
0abc0 000018 18   I 26  12  8
  [14] .exit.text        PROGBITS        0000000000000000 009da0 000028 00 =
 AX  0   0  4
  [15] .rela.exit.text   RELA            0000000000000000 00abd8 000048 18 =
  I 26  14  8
  [16] .modinfo          PROGBITS        0000000000000000 009dc8 0000b1 00 =
  A  0   0  1
  [17] .rodata.str1.1    PROGBITS        0000000000000000 009e79 00000a 01 =
AMS  0   0  1
  [18] .comment          PROGBITS        0000000000000000 009e83 0000ce 01 =
 MS  0   0  1
  [19] .note.Linux       NOTE            0000000000000000 009f54 000018 00 =
  A  0   0  4
  [20] .gnu.linkonce.this_module PROGBITS        0000000000000000 009f80 00=
0380 00  WA  0   0 64
  [21] .rela.gnu.linkonce.this_module RELA            0000000000000000 00ac=
20 000030 18   I 26  20  8
  [22] .note.gnu.build-id NOTE            0000000000000000 00a300 000024 00=
   A  0   0  4
  [23] .note.gnu.property NOTE            0000000000000000 00a328 000020 00=
   A  0   0  8
  [24] .note.GNU-stack   PROGBITS        0000000000000000 00a348 000000 00 =
     0   0  1
  [25] .gnu_debuglink    PROGBITS        0000000000000000 00a348 000018 00 =
     0   0  4
  [26] .symtab           SYMTAB          0000000000000000 00a360 0004f8 18 =
    27  43  8
  [27] .strtab           STRTAB          0000000000000000 00a858 0001b1 00 =
     0   0  1
  [28] .shstrtab         STRTAB          0000000000000000 00ac50 000128 00 =
     0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  p (processor specific)

After:

$ readelf -WS configs.ko=20
There are 26 section headers, starting at offset 0xad40:
=20
Section Headers:
  [Nr] Name              Type            Address          Off    Size   ES =
Flg Lk Inf Al
  [ 0]                   NULL            0000000000000000 000000 000000 00 =
     0   0  0
  [ 1] __patchable_function_entries PROGBITS        0000000000000000 000040=
 000010 00 WAL  5   0  8
  [ 2] .rela__patchable_function_entries RELA            0000000000000000 0=
0a9e0 000030 18   I 23   1  8
  [ 3] .rodata           PROGBITS        0000000000000000 000050 009ca2 00 =
AMS  0   0  8
  [ 4] .rela.rodata      RELA            0000000000000000 00aa10 000030 18 =
  I 23   3  8
  [ 5] .text             PROGBITS        0000000000000000 009cf4 00004c 00 =
 AX  0   0  4
  [ 6] .rela.text        RELA            0000000000000000 00aa40 000078 18 =
  I 23   5  8
  [ 7] .plt              NOBITS          0000000000000000 009d40 000001 00 =
 AX  0   0 16
  [ 8] .init.plt         NOBITS          0000000000000000 009d40 000001 00 =
 AX  0   0  1
  [ 9] .text.ftrace_trampoline NOBITS          0000000000000000 009d40 0000=
01 00  AX  0   0  1
  [10] .init.text        PROGBITS        0000000000000000 009d40 000068 00 =
 AX  0   0  4
  [11] .rela.init.text   RELA            0000000000000000 00aab8 0000f0 18 =
  I 23  10  8
  [12] .exit.text        PROGBITS        0000000000000000 009da8 000028 00 =
 AX  0   0  4
  [13] .rela.exit.text   RELA            0000000000000000 00aba8 000048 18 =
  I 23  12  8
  [14] .modinfo          PROGBITS        0000000000000000 009dd0 0000b1 00 =
  A  0   0  1
  [15] .comment          PROGBITS        0000000000000000 009e81 0000ce 01 =
 MS  0   0  1
  [16] .note.Linux       NOTE            0000000000000000 009f50 000018 00 =
  A  0   0  4
  [17] .gnu.linkonce.this_module PROGBITS        0000000000000000 009f80 00=
0380 00  WA  0   0 64
  [18] .rela.gnu.linkonce.this_module RELA            0000000000000000 00ab=
f0 000030 18   I 23  17  8
  [19] .note.gnu.build-id NOTE            0000000000000000 00a300 000024 00=
   A  0   0  4
  [20] .note.gnu.property NOTE            0000000000000000 00a328 000020 00=
   A  0   0  8
  [21] .note.GNU-stack   PROGBITS        0000000000000000 00a348 000000 00 =
     0   0  1
  [22] .gnu_debuglink    PROGBITS        0000000000000000 00a348 000018 00 =
     0   0  4
  [23] .symtab           SYMTAB          0000000000000000 00a360 0004c8 18 =
    24  41  8
  [24] .strtab           STRTAB          0000000000000000 00a828 0001b1 00 =
     0   0  1
  [25] .shstrtab         STRTAB          0000000000000000 00ac20 000119 00 =
     0   0  1
Key to Flags:
  W (write), A (alloc), X (execute), M (merge), S (strings), I (info),
  L (link order), O (extra OS processing required), G (group), T (TLS),
  C (compressed), x (unknown), o (OS specific), E (exclude),
  p (processor specific)

>  scripts/module.lds.S | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>=20
> diff --git a/scripts/module.lds.S b/scripts/module.lds.S
> index 69b9b71a6a47..18d5b8423635 100644
> --- a/scripts/module.lds.S
> +++ b/scripts/module.lds.S
> @@ -23,6 +23,30 @@ SECTIONS {
>         .init_array             0 : ALIGN(8) { *(SORT(.init_array.*)) *(.=
init_array) }
> =20
>         __jump_table            0 : ALIGN(8) { KEEP(*(__jump_table)) }
> +
> +       __patchable_function_entries : { *(__patchable_function_entries) }
> +
> +       /*
> +        * With CONFIG_LTO_CLANG, LLD always enables -fdata-sections and
> +        * -ffunction-sections, which increases the size of the final mod=
ule.
> +        * Merge the split sections in the final binary.
> +        */
> +       .bss : {
> +               *(.bss .bss.[0-9a-zA-Z_]*)
> +               *(.bss..L*)
> +       }
> +
> +       .data : {
> +               *(.data .data.[0-9a-zA-Z_]*)
> +               *(.data..L*)
> +       }
> +
> +       .rodata : {
> +               *(.rodata .rodata.[0-9a-zA-Z_]*)
> +               *(.rodata..L*)
> +       }
> +
> +       .text : { *(.text .text.[0-9a-zA-Z_]*) }
>  }
>
