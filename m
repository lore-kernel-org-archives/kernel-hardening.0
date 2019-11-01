Return-Path: <SRS0=HrUA=YZ=lists.openwall.com=kernel-hardening-return-17225-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E046CA9ED1
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 14:24:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6D56E21734
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 Nov 2019 14:24:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="pJiWpx1Q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D56E21734
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=axtens.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17225-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27913 invoked by uid 550); 1 Nov 2019 14:24:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27875 invoked from network); 1 Nov 2019 14:24:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=IMfqZTNf1MKqWzQ6EZPjw+OGGIt0HqVhdg1aNy6jKk0=;
        b=pJiWpx1QEvl179v4Uf+NmtLlAgVIYbaD+xGWOlIR2EY6d5BII873FZds3gbkpd5M35
         pCo/CTgZMy0T9znBpC9u36nrbIS4k8CPwAHhRrJU9G8gsR/b9IMya9iBGujrLTssd/kJ
         o22QxXCSwphC0pHYD8zdsjvACwo3BuT4DakM4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=IMfqZTNf1MKqWzQ6EZPjw+OGGIt0HqVhdg1aNy6jKk0=;
        b=TXCrdkQD8v09B1bhfYyLbEm8MHBey2T33W1Njejl37sUNPVNMHZh4Y3MJgGHtC2mmx
         yKdqcba+6Q9+6XG/ciOKUdMQdfCGrgTww/h5hNlpso8rNJzj265FwSQvpIt1QyoYrS9/
         V8qebqtSOjfGsfUR4tSYcHMvu6K71FmYDCQ87FVVx/3YwX20PbKomo1lCNAj7Q4mUIrb
         JdH8Vq0BElvs3OXTUqMuoH9XID0AEh/DBoH9ZuCCLpxYJC7pZcIhOKsjuRfhBftqf8nO
         NoaUZ4IMWULRQ2Eqh7f5jLpW2n07uj0E5s3WHpJFMUnawjX94gAGpSd8F0V+GCDLrb/T
         veKw==
X-Gm-Message-State: APjAAAUGH1gWLn2gLwmrv6lU67iwpYWc1UOZMXBBpOcns21q8noyXnbX
	2AwxueSfFusfgA6oIyBSWrS03g==
X-Google-Smtp-Source: APXvYqwFL0AJDhgZLbiWAevUOF5g87rSxWVhZ6TOxKYVcY5QEsRjFKfI9/sGgolt/ezIpb/xMBmzjQ==
X-Received: by 2002:a63:1b59:: with SMTP id b25mr13671933pgm.267.1572618239018;
        Fri, 01 Nov 2019 07:23:59 -0700 (PDT)
From: Daniel Axtens <dja@axtens.net>
To: Russell Currey <ruscur@russell.cc>, linuxppc-dev@lists.ozlabs.org
Cc: Russell Currey <ruscur@russell.cc>, christophe.leroy@c-s.fr, joel@jms.id.au, mpe@ellerman.id.au, ajd@linux.ibm.com, npiggin@gmail.com, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v5 2/5] powerpc/kprobes: Mark newly allocated probes as RO
In-Reply-To: <20191030073111.140493-3-ruscur@russell.cc>
References: <20191030073111.140493-1-ruscur@russell.cc> <20191030073111.140493-3-ruscur@russell.cc>
Date: Sat, 02 Nov 2019 01:23:54 +1100
Message-ID: <8736f7n091.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain

Russell Currey <ruscur@russell.cc> writes:

> With CONFIG_STRICT_KERNEL_RWX=y and CONFIG_KPROBES=y, there will be one
> W+X page at boot by default.  This can be tested with
> CONFIG_PPC_PTDUMP=y and CONFIG_PPC_DEBUG_WX=y set, and checking the
> kernel log during boot.
>
> powerpc doesn't implement its own alloc() for kprobes like other
> architectures do, but we couldn't immediately mark RO anyway since we do
> a memcpy to the page we allocate later.  After that, nothing should be
> allowed to modify the page, and write permissions are removed well
> before the kprobe is armed.
>
> Thus mark newly allocated probes as read-only once it's safe to do so.

So if I've got the flow right here:

register[_aggr]_kprobe
 -> prepare_kprobe
  -> arch_prepare_kprobe
       perform memcpy
       mark as readonly, after which no-one touches writes to the memory

which all seems right to me.

I have been trying to check if optprobes need special handling: it looks
like the buffer for them lives in kernel text, not dynamically allocated
memory, so it should be protected by the usual Strict RWX protections
without special treatment here.

So lgtm.

Reviewed-by: Daniel Axtens <dja@axtens.net>

Regards,
Daniel

>
> Signed-off-by: Russell Currey <ruscur@russell.cc>
> ---
>  arch/powerpc/kernel/kprobes.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
> index 2d27ec4feee4..2610496de7c7 100644
> --- a/arch/powerpc/kernel/kprobes.c
> +++ b/arch/powerpc/kernel/kprobes.c
> @@ -24,6 +24,7 @@
>  #include <asm/sstep.h>
>  #include <asm/sections.h>
>  #include <linux/uaccess.h>
> +#include <linux/set_memory.h>
>  
>  DEFINE_PER_CPU(struct kprobe *, current_kprobe) = NULL;
>  DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
> @@ -131,6 +132,8 @@ int arch_prepare_kprobe(struct kprobe *p)
>  			(unsigned long)p->ainsn.insn + sizeof(kprobe_opcode_t));
>  	}
>  
> +	set_memory_ro((unsigned long)p->ainsn.insn, 1);
> +
>  	p->ainsn.boostable = 0;
>  	return ret;
>  }
> -- 
> 2.23.0
