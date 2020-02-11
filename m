Return-Path: <SRS0=j4gB=37=lists.openwall.com=kernel-hardening-return-17779-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B62BC3B187
	for <kernel-hardening@archiver.kernel.org>; Tue, 11 Feb 2020 18:11:43 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EC4B320714
	for <kernel-hardening@archiver.kernel.org>; Tue, 11 Feb 2020 18:11:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="sqJ97A8Q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EC4B320714
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17779-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10202 invoked by uid 550); 11 Feb 2020 18:11:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10162 invoked from network); 11 Feb 2020 18:11:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581444682;
	bh=fCi7iGEzUFz55yqEcvf2QdYxh8pGHQFjh2eIogW1O7U=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=sqJ97A8QIcyNMreWkO51N9AJETetiBfBcRXN9gx5CKrvprmwfwo8YMHxgwMDzkQDM
	 zdgThFTGIS6YitPfMwAGXptjc1IhDOR0zQwqp6O1ewNLHX6botCS733PBTZfglTpTN
	 E5LnjKkXHdOxsui31xVKNIPr9HhvWhP8PkYuuT0U=
Subject: Re: [PATCH v3 7/7] selftests/exec: Add READ_IMPLIES_EXEC tests
To: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>
Cc: Hector Marco-Gisbert <hecmargi@upv.es>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon
 <will.deacon@arm.com>, Jason Gunthorpe <jgg@mellanox.com>,
 Jann Horn <jannh@google.com>, Russell King <linux@armlinux.org.uk>,
 x86@kernel.org, kernel-hardening@lists.openwall.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200210193049.64362-1-keescook@chromium.org>
 <20200210193049.64362-8-keescook@chromium.org>
From: shuah <shuah@kernel.org>
Message-ID: <4f8a5036-dc2a-90ad-5fc8-69560a5dd78e@kernel.org>
Date: Tue, 11 Feb 2020 11:11:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200210193049.64362-8-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 2/10/20 12:30 PM, Kees Cook wrote:
> In order to check the matrix of possible states for handling
> READ_IMPLIES_EXEC across native, compat, and the state of PT_GNU_STACK,
> add tests for these execution conditions.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

No issues for this to go through tip.

A few problems to fix first. This fails to compile when 32-bit libraries
aren't installed. It should fail the 32-bit part and run other checks.

make kselftest TARGETS=exec
make --no-builtin-rules ARCH=x86 -C ../../.. headers_install
make[2]: Entering directory '/lkml/linux_5.6'
   INSTALL ./usr/include
make[2]: Leaving directory '/lkml/linux_5.6'
make[2]: Entering directory '/lkml/linux_5.6/tools/testing/selftests/exec'
gcc -m32 -Wall -Wno-nonnull -D_GNU_SOURCE -Wl,-z,noexecstack -o 
/lkml/linux_5.6/tools/testing/selftests/exec/rie-compat-nx-gnu-stack.new 
read_implies_exec.c
readelf -Wl 
/lkml/linux_5.6/tools/testing/selftests/exec/rie-compat-nx-gnu-stack.new 
| grep GNU_STACK | grep -q 'RW ' && \
mv 
/lkml/linux_5.6/tools/testing/selftests/exec/rie-compat-nx-gnu-stack.new 
/lkml/linux_5.6/tools/testing/selftests/exec/rie-compat-nx-gnu-stack
In file included from /usr/lib/gcc/x86_64-linux-gnu/9/include/stdint.h:9,
                  from read_implies_exec.c:6:
/usr/include/stdint.h:26:10: fatal error: bits/libc-header-start.h: No 
such file or directory
    26 | #include <bits/libc-header-start.h>
       |          ^~~~~~~~~~~~~~~~~~~~~~~~~~
compilation terminated.
readelf: Error: 
'/lkml/linux_5.6/tools/testing/selftests/exec/rie-compat-nx-gnu-stack.new': 
No such file
make[2]: *** [Makefile:58: 
/lkml/linux_5.6/tools/testing/selftests/exec/rie-compat-nx-gnu-stack] 
Error 1
make[2]: Leaving directory '/lkml/linux_5.6/tools/testing/selftests/exec'
make[1]: *** [Makefile:150: all] Error 2
make: *** [Makefile:1217: kselftest] Error 2

thanks,
-- Shuah
