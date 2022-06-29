Return-Path: <kernel-hardening-return-21568-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 2E206C433EF
	for <kernel-hardening@archiver.kernel.org>; Wed, 29 Jun 2022 11:41:50 +0000 (UTC)
Received: (qmail 6099 invoked by uid 550); 29 Jun 2022 11:41:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14065 invoked from network); 29 Jun 2022 05:51:56 -0000
Message-ID: <6c274345-3370-16c8-f5f1-68521de0f51a@huawei.com>
Date: Wed, 29 Jun 2022 13:51:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] stack: Declare {randomize_,}kstack_offset to fix Sparse
 warnings
Content-Language: en-US
To: Christophe Leroy <christophe.leroy@csgroup.eu>, Kees Cook
	<keescook@chromium.org>, Marco Elver <elver@google.com>
CC: Xiu Jianfeng <xiujianfeng@huawei.com>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220629032939.2506773-1-gongruiqi1@huawei.com>
 <ca0fa9d2-64dd-0e77-71b6-3673e353c316@csgroup.eu>
From: Gong Ruiqi <gongruiqi1@huawei.com>
In-Reply-To: <ca0fa9d2-64dd-0e77-71b6-3673e353c316@csgroup.eu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.108.157]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500016.china.huawei.com (7.185.36.25)
X-CFilter-Loop: Reflected



On 2022/06/29 13:10, Christophe Leroy wrote:
> 
> 
> Le 29/06/2022 à 05:29, GONG, Ruiqi a écrit :
>> Fix the following Sparse warnings that got noticed when the PPC-dev
>> patchwork was checking another patch (see the link below):
>>
>> init/main.c:862:1: warning: symbol 'randomize_kstack_offset' was not declared. Should it be static?
>> init/main.c:864:1: warning: symbol 'kstack_offset' was not declared. Should it be static?
>>
>> Which in fact are triggered on all architectures that have
>> HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET support (for instances x86, arm64
>> etc).
>>
>> Link: https://lore.kernel.org/lkml/e7b0d68b-914d-7283-827c-101988923929@huawei.com/T/#m49b2d4490121445ce4bf7653500aba59eefcb67f
>> Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
>> Cc: Xiu Jianfeng <xiujianfeng@huawei.com>
>> Signed-off-by: GONG, Ruiqi <gongruiqi1@huawei.com>
>> ---
>>   init/main.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/init/main.c b/init/main.c
>> index e2490387db2b..6aa0fb2340cc 100644
>> --- a/init/main.c
>> +++ b/init/main.c
>> @@ -101,6 +101,10 @@
>>   #include <linux/stackdepot.h>
>>   #include <net/net_namespace.h>
>>
>> +#ifdef CONFIG_RANDOMIZE_KSTACK_OFFSET
> 
> You don't need this #ifdef, there is already one inside 
> linux/randomize_kstack.h
> 

Ah yes, I didn't notice the config was there already. I will send a new
version. Thanks for your reminder!

>> +#include <linux/randomize_kstack.h>
>> +#endif
>> +
>>   #include <asm/io.h>
>>   #include <asm/bugs.h>
>>   #include <asm/setup.h>
>> --
>> 2.25.1
