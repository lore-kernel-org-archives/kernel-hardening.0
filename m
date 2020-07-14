Return-Path: <SRS0=8dsh=AZ=lists.openwall.com=kernel-hardening-return-19304-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B09C4C433E4
	for <kernel-hardening@archiver.kernel.org>; Tue, 14 Jul 2020 12:28:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1462E22453
	for <kernel-hardening@archiver.kernel.org>; Tue, 14 Jul 2020 12:28:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1462E22453
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19304-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13833 invoked by uid 550); 14 Jul 2020 12:27:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9831 invoked from network); 14 Jul 2020 12:16:56 -0000
Subject: Re: [PATCH 00/22] add support for Clang LTO
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>,
 Nick Desaulniers <ndesaulniers@google.com>,
 clang-built-linux@googlegroups.com,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kbuild <linux-kbuild@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
 x86@kernel.org
References: <20200624203200.78870-1-samitolvanen@google.com>
 <671d8923-ed43-4600-2628-33ae7cb82ccb@molgen.mpg.de>
 <CABCJKuedpxAqndgL=jHT22KtjnLkb1dsYaM6hQYyhqrWjkEe6A@mail.gmail.com>
From: Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <2ac9e722-949b-aa92-3553-df1bf69bf9e5@molgen.mpg.de>
Date: Tue, 14 Jul 2020 14:16:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CABCJKuedpxAqndgL=jHT22KtjnLkb1dsYaM6hQYyhqrWjkEe6A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

Dear Sami,


Am 13.07.20 um 01:34 schrieb Sami Tolvanen:
> On Sat, Jul 11, 2020 at 9:32 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>> Thank you very much for sending these changes.
>>
>> Do you have a branch, where your current work can be pulled from? Your
>> branch on GitHub [1] seems 15 months old.
> 
> The clang-lto branch is rebased regularly on top of Linus' tree.
> GitHub just looks at the commit date of the last commit in the tree,
> which isn't all that informative.

Thank you for clearing this up, and sorry for not checking myself.

>> Out of curiosity, I applied the changes, allowed the selection for i386
>> (x86), and with Clang 1:11~++20200701093119+ffee8040534-1~exp1 from
>> Debian experimental, it failed with `Invalid absolute R_386_32
>> relocation: KERNEL_PAGES`:
> 
> I haven't looked at getting this to work on i386, which is why we only
> select ARCH_SUPPORTS_LTO for x86_64. I would expect there to be a few
> issues to address.
> 
>>>    arch/x86/tools/relocs vmlinux > arch/x86/boot/compressed/vmlinux.relocs;arch/x86/tools/relocs --abs-relocs vmlinux
>>> Invalid absolute R_386_32 relocation: KERNEL_PAGES
> 
> KERNEL_PAGES looks like a constant, so it's probably safe to ignore
> the absolute relocation in tools/relocs.c.

Thank you for pointing me to the right direction. I am happy to report, 
that with the diff below (no idea to what list to add the string), Linux 
5.8-rc5 with the LLVM/Clang/LTO patches on top, builds and boots on the 
ASRock E350M1.

```
diff --git a/arch/x86/tools/relocs.c b/arch/x86/tools/relocs.c
index 8f3bf34840cef..e91af127ed3c0 100644
--- a/arch/x86/tools/relocs.c
+++ b/arch/x86/tools/relocs.c
@@ -79,6 +79,7 @@ static const char * const 
sym_regex_kernel[S_NSYMTYPES] = {
         "__end_rodata_hpage_align|"
  #endif
         "__vvar_page|"
+       "KERNEL_PAGES|"
         "_end)$"
  };
```


Kind regards,

Paul
