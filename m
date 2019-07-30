Return-Path: <SRS0=Xet5=V3=lists.openwall.com=kernel-hardening-return-16642-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2DCBC433FF
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Jul 2019 19:10:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D059B2064A
	for <kernel-hardening@archiver.kernel.org>; Tue, 30 Jul 2019 19:10:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="aJiRP98z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D059B2064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16642-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23798 invoked by uid 550); 30 Jul 2019 19:10:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23753 invoked from network); 30 Jul 2019 19:10:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dsk8ZydsUhALc559Eoh2HiqlRDNFYGUSysH9tXyKuOA=;
        b=aJiRP98zViobaSTaZiXjGOvOTKc8CYMZWMp41PMBiw4wA+jXZVKuk+B2yflzE6trDY
         7hSQYvjfGvZPNIZd1w9dCfUAgpkBhEM/4PfkSuyQJe9LQ/11js0JTCryijJrqk/55a4O
         lrYi0meSGVBbHfSSibcbAgyQhhtSJl1zt1TBA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dsk8ZydsUhALc559Eoh2HiqlRDNFYGUSysH9tXyKuOA=;
        b=peFRa4UR+DxjWoxjr4iz/sYk29sHpCQGZKgRNmjOjma5GCA96P949V37XZEt1/6Srv
         oTunFnmUVcxbHXG9+6oKUwxPAbdYNeOIAH7WBha696mebxjBzg4+4MFbw1/Z8CBx5JLp
         DzLLVESPKtxUEFbIEq+Il5kkb8AVu3mgkYjJXo+A2y4gTux+H9ASYGdR/8aMTTR70Fo4
         5INEg1p+xToBs5B8ilzGmzgSeD+B7+7MnVdi3OERQlrkwbt2yhECFKXMFifcn1ef7KU7
         ih+3edSpn+vim+fKdYTe4kQImu99lW7/MxQRzbN/4mYD7cLzSH1t5GqVWL8xl8zt2MgS
         +Nnw==
X-Gm-Message-State: APjAAAV99iPrWksruTCPrEpU8g6qt6heYCNO2ULUBK5LJyy2nRBbwESG
	oYSXKJMLAA6dfIG6KMPlirAU92vIFuA=
X-Google-Smtp-Source: APXvYqwZs3EtsvAIrB8Vp3q6f42rh1/JYifwoi7wNhEaXtYzsws1hjrqbg9Mn4WBhWx2BkUp0DT+dA==
X-Received: by 2002:a05:6402:28e:: with SMTP id l14mr37779235edv.11.1564513796062;
        Tue, 30 Jul 2019 12:09:56 -0700 (PDT)
X-Received: by 2002:a5d:528d:: with SMTP id c13mr45696619wrv.247.1564513794356;
 Tue, 30 Jul 2019 12:09:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190708174913.123308-1-thgarnie@chromium.org> <201907301100.90BB865078@keescook>
In-Reply-To: <201907301100.90BB865078@keescook>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Tue, 30 Jul 2019 12:09:42 -0700
X-Gmail-Original-Message-ID: <CAJcbSZEZNk-YoE-dH=N1QpAeUdzm9wGpEqU644bO30WmYcnCtQ@mail.gmail.com>
Message-ID: <CAJcbSZEZNk-YoE-dH=N1QpAeUdzm9wGpEqU644bO30WmYcnCtQ@mail.gmail.com>
Subject: Re: [PATCH v8 00/11] x86: PIE support to extend KASLR randomization
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Kristen Carlson Accardi <kristen@linux.intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Juergen Gross <jgross@suse.com>, 
	Alok Kataria <akataria@vmware.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, 
	Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <peterz@infradead.org>, Nadav Amit <namit@vmware.com>, 
	Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Boris Ostrovsky <boris.ostrovsky@oracle.com>, Feng Tang <feng.tang@intel.com>, 
	Maran Wilson <maran.wilson@oracle.com>, Enrico Weigelt <info@metux.net>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexios Zavras <alexios.zavras@intel.com>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	virtualization@lists.linux-foundation.org, 
	Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jul 30, 2019 at 11:01 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Jul 08, 2019 at 10:48:53AM -0700, Thomas Garnier wrote:
> > Splitting the previous series in two. This part contains assembly code
> > changes required for PIE but without any direct dependencies with the
> > rest of the patchset.
> >
> > Changes:
> >  - patch v8 (assembly):
> >    - Fix issues in crypto changes (thanks to Eric Biggers).
> >    - Remove unnecessary jump table change.
> >    - Change author and signoff to chromium email address.
>
> With -rc2 done, is this a good time for this to land in -tip? Are there
> more steps needed for review?

I have a minor feedback and rebase that I am about to send (v9). It
seems like a good one to send to tip if there is no major feedback.

>
> Thanks!
>
> -Kees
>
> >  - patch v7 (assembly):
> >    - Split patchset and reorder changes.
> >  - patch v6:
> >    - Rebase on latest changes in jump tables and crypto.
> >    - Fix wording on couple commits.
> >    - Revisit checkpatch warnings.
> >    - Moving to @chromium.org.
> >  - patch v5:
> >    - Adapt new crypto modules for PIE.
> >    - Improve per-cpu commit message.
> >    - Fix xen 32-bit build error with .quad.
> >    - Remove extra code for ftrace.
> >  - patch v4:
> >    - Simplify early boot by removing global variables.
> >    - Modify the mcount location script for __mcount_loc intead of the address
> >      read in the ftrace implementation.
> >    - Edit commit description to explain better where the kernel can be located.
> >    - Streamlined the testing done on each patch proposal. Always testing
> >      hibernation, suspend, ftrace and kprobe to ensure no regressions.
> >  - patch v3:
> >    - Update on message to describe longer term PIE goal.
> >    - Minor change on ftrace if condition.
> >    - Changed code using xchgq.
> >  - patch v2:
> >    - Adapt patch to work post KPTI and compiler changes
> >    - Redo all performance testing with latest configs and compilers
> >    - Simplify mov macro on PIE (MOVABS now)
> >    - Reduce GOT footprint
> >  - patch v1:
> >    - Simplify ftrace implementation.
> >    - Use gcc mstack-protector-guard-reg=%gs with PIE when possible.
> >  - rfc v3:
> >    - Use --emit-relocs instead of -pie to reduce dynamic relocation space on
> >      mapped memory. It also simplifies the relocation process.
> >    - Move the start the module section next to the kernel. Remove the need for
> >      -mcmodel=large on modules. Extends module space from 1 to 2G maximum.
> >    - Support for XEN PVH as 32-bit relocations can be ignored with
> >      --emit-relocs.
> >    - Support for GOT relocations previously done automatically with -pie.
> >    - Remove need for dynamic PLT in modules.
> >    - Support dymamic GOT for modules.
> >  - rfc v2:
> >    - Add support for global stack cookie while compiler default to fs without
> >      mcmodel=kernel
> >    - Change patch 7 to correctly jump out of the identity mapping on kexec load
> >      preserve.
> >
> > These patches make some of the changes necessary to build the kernel as
> > Position Independent Executable (PIE) on x86_64. Another patchset will
> > add the PIE option and larger architecture changes.
> >
> > The patches:
> >  - 1, 3-11: Change in assembly code to be PIE compliant.
> >  - 2: Add a new _ASM_MOVABS macro to fetch a symbol address generically.
> >
> > diffstat:
> >  crypto/aegis128-aesni-asm.S         |    6 +-
> >  crypto/aegis128l-aesni-asm.S        |    8 +--
> >  crypto/aegis256-aesni-asm.S         |    6 +-
> >  crypto/aes-x86_64-asm_64.S          |   45 ++++++++++------
> >  crypto/aesni-intel_asm.S            |    8 +--
> >  crypto/aesni-intel_avx-x86_64.S     |    3 -
> >  crypto/camellia-aesni-avx-asm_64.S  |   42 +++++++--------
> >  crypto/camellia-aesni-avx2-asm_64.S |   44 ++++++++--------
> >  crypto/camellia-x86_64-asm_64.S     |    8 +--
> >  crypto/cast5-avx-x86_64-asm_64.S    |   50 ++++++++++--------
> >  crypto/cast6-avx-x86_64-asm_64.S    |   44 +++++++++-------
> >  crypto/des3_ede-asm_64.S            |   96 ++++++++++++++++++++++++------------
> >  crypto/ghash-clmulni-intel_asm.S    |    4 -
> >  crypto/glue_helper-asm-avx.S        |    4 -
> >  crypto/glue_helper-asm-avx2.S       |    6 +-
> >  crypto/morus1280-avx2-asm.S         |    4 -
> >  crypto/morus1280-sse2-asm.S         |    8 +--
> >  crypto/morus640-sse2-asm.S          |    6 +-
> >  crypto/sha256-avx2-asm.S            |   18 ++++--
> >  entry/entry_64.S                    |   16 ++++--
> >  include/asm/alternative.h           |    6 +-
> >  include/asm/asm.h                   |    1
> >  include/asm/paravirt_types.h        |   25 +++++++--
> >  include/asm/pm-trace.h              |    2
> >  include/asm/processor.h             |    6 +-
> >  kernel/acpi/wakeup_64.S             |   31 ++++++-----
> >  kernel/head_64.S                    |   16 +++---
> >  kernel/relocate_kernel_64.S         |    2
> >  power/hibernate_asm_64.S            |    4 -
> >  29 files changed, 306 insertions(+), 213 deletions(-)
> >
> > Patchset is based on next-20190708.
> >
> >
>
> --
> Kees Cook
