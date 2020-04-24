Return-Path: <SRS0=4AT2=6I=lists.openwall.com=kernel-hardening-return-18630-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61591C2BA1A
	for <kernel-hardening@archiver.kernel.org>; Fri, 24 Apr 2020 10:53:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AF97220776
	for <kernel-hardening@archiver.kernel.org>; Fri, 24 Apr 2020 10:53:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qcq/8rBl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AF97220776
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18630-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 6052 invoked by uid 550); 24 Apr 2020 10:53:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 6020 invoked from network); 24 Apr 2020 10:53:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R8t+7888K7kzJGE2cpI0Gewrm7h/D6gEhogwIFx31Lk=;
        b=Qcq/8rBl9g732jhNkxk/yLJfMtvESceHcAhNq8mjG1GxTvJ8IX7OsX4ULyv5aXcf6A
         XZK65r0qm0zbgUZaDhunfmvAaUraaq1Y6pUQlG4QNpejre+aIew2/3nYeZhhxpLmaImq
         Qh00PpyAIBtDR0WZAoXZWMVSkicj+a+lzCswFroD6uPU8b9ctuKg4IKn/3d9UQcjA01j
         ENSqq8/hZkrORRlXWjzHqqqvZ9p2m5rZkD6K4IF7Uh3fCXN9H36cjfmcn1gmPrrCc4n8
         Juui253ahHG/SHnntUm/R4FJExyknpHv9GAo8z7R68twYuW74qB9ihE/KeE27+xXQtbc
         yRbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:cc:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R8t+7888K7kzJGE2cpI0Gewrm7h/D6gEhogwIFx31Lk=;
        b=izBZlBHwtlnHGfj+m8LK/xD8SzDADjYLy0+G4XqQhbCxhSQguKkthwKzd+TQRjtlSF
         cs4u84tnYXg5neJ04sYcofQmsvb7F0Hdjty6+1UIRnQj/T9A/odW2gQ9aK9h10ekluvh
         /2AI4dUoq2pAfj8ImA+kTGTbf/XNtLXTpeOGjaEv3/2iX1Kr3gHpb1YCgGrzJbx3J4pS
         X5IRo2C8Fm+vGgEaqIdqrclkWnduthLcKzvhyFObgo5y3DD8D96FX3zlmlifqtUCmSjV
         zrPej9SFWdEqfUTHErG0udX2ugsCraSeTgGk/HuDW6F/8eJrlxkTs2f1S9KHaTgrscxt
         v+ew==
X-Gm-Message-State: AGi0PuZfv20VVMqDhgkjZUO1gTETvxnIrSHeL/e+q/nQVfl8v6TpsGRl
	7GCHpNXMDhcltsRfKnyd8Ww=
X-Google-Smtp-Source: APiQypK5+esVN5CdbnzPWeW2IhtsX++39F6f0uikR/CRyclafcDhXyyY7JjiOPtD6LG9xwD0kd49Ew==
X-Received: by 2002:a17:90a:328f:: with SMTP id l15mr5666046pjb.77.1587725599462;
        Fri, 24 Apr 2020 03:53:19 -0700 (PDT)
Cc: tranmanphong@gmail.com, steve.capper@arm.com, steven.price@arm.com,
 keescook@chromium.org, greg@kroah.com, akpm@linux-foundation.org,
 alexios.zavras@intel.com, broonie@kernel.org,
 kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: Re: [PATCH v2] arm64: add check_wx_pages debugfs for CHECK_WX
To: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 ruscur@russell.cc
References: <20200307093926.27145-1-tranmanphong@gmail.com>
 <20200421173557.10817-1-tranmanphong@gmail.com>
 <20200422143526.GD54796@lakrids.cambridge.arm.com>
 <20200422152656.GF676@willie-the-truck>
From: Phong Tran <tranmanphong@gmail.com>
Message-ID: <e06b1ad1-08ca-ec50-7ca1-7d08bbea81b3@gmail.com>
Date: Fri, 24 Apr 2020 17:52:41 +0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422152656.GF676@willie-the-truck>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 4/22/20 10:26 PM, Will Deacon wrote:
> On Wed, Apr 22, 2020 at 03:35:27PM +0100, Mark Rutland wrote:
>> On Wed, Apr 22, 2020 at 12:35:58AM +0700, Phong Tran wrote:
>>> follow the suggestion from
>>> https://github.com/KSPP/linux/issues/35
>>>
>>> Signed-off-by: Phong Tran <tranmanphong@gmail.com>
>>> ---
>>> Change since v1:
>>> - Update the Kconfig help text
>>> - Don't check the return value of debugfs_create_file()
>>> - Tested on QEMU aarch64
>>
>> As on v1, I think that this should be generic across all architectures
>> with CONFIG_DEBUG_WX. Adding this only on arm64 under
>> CONFIG_PTDUMP_DEBUGFS (which does not generally imply a WX check)
>> doesn't seem right.
>>
>> Maybe we need a new ARCH_HAS_CHECK_WX config to make that simpler, but
>> that seems simple to me.
> 
> Agreed. When I asked about respinning, I assumed this would be done in
> generic code as you requested on the first version. Phong -- do you think
> you can take a look at that, please?
> 

sure, plan to make change in mm/ptdump.c with KConfig 
"ARCH_HAS_CHECK_WX" as suggestion.

Then need align with this patch in PowerPC arch also

https://lore.kernel.org/kernel-hardening/20200402084053.188537-3-ruscur@russell.cc/

diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index a1efa246c9ed..50f18e7ff2ae 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -25,6 +25,7 @@ config ARM64_RANDOMIZE_TEXT_OFFSET

  config DEBUG_WX
         bool "Warn on W+X mappings at boot"
+       select ARCH_HAS_CHECK_WX
         select PTDUMP_CORE
         ---help---
           Generate a warning if any W+X mappings are found at boot.
diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 0271b22e063f..40c9ac5a4db2 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -138,3 +138,6 @@ config PTDUMP_DEBUGFS
           kernel.

           If in doubt, say N.
+
+config ARCH_HAS_CHECK_WX
+       bool
diff --git a/mm/ptdump.c b/mm/ptdump.c
index 26208d0d03b7..8f54db007aaa 100644
--- a/mm/ptdump.c
+++ b/mm/ptdump.c
@@ -137,3 +137,29 @@ void ptdump_walk_pgd(struct ptdump_state *st, 
struct mm_struct *mm, pgd_t *pgd)
         /* Flush out the last page */
         st->note_page(st, 0, -1, 0);
  }
+
+#ifdef CONFIG_ARCH_HAS_CHECK_WX
+#include <linux/debugfs.h>
+#include <asm/ptdump.h>
+
+static int check_wx_debugfs_set(void *data, u64 val)
+{
+       if (val != 1ULL)
+               return -EINVAL;
+
+       ptdump_check_wx();
+
+       return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(check_wx_fops, NULL, check_wx_debugfs_set, 
"%llu\n");
+
+static int ptdump_debugfs_check_wx_init(void)
+{
+       debugfs_create_file("check_wx_pages", 0200, NULL,
+                       NULL, &check_wx_fops) ? 0 : -ENOMEM;
+       return 0;
+}
+
+device_initcall(ptdump_debugfs_check_wx_init);
+#endif


Regards,
Phong.
