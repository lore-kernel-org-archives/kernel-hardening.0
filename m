Return-Path: <SRS0=+mQD=AT=lists.openwall.com=kernel-hardening-return-19249-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26726C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jul 2020 07:31:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7CD592067D
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jul 2020 07:31:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7CD592067D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19249-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32104 invoked by uid 550); 8 Jul 2020 07:31:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32070 invoked from network); 8 Jul 2020 07:31:44 -0000
Subject: Re: [PATCH v19 09/12] arch: Wire up landlock() syscall
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Casey Schaufler <casey@schaufler-ca.com>, James Morris <jmorris@namei.org>,
 Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>,
 Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
 Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>,
 Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Linux API <linux-api@vger.kernel.org>,
 linux-arch <linux-arch@vger.kernel.org>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
 "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
 LSM List <linux-security-module@vger.kernel.org>,
 the arch/x86 maintainers <x86@kernel.org>
References: <20200707180955.53024-1-mic@digikod.net>
 <20200707180955.53024-10-mic@digikod.net>
 <CAK8P3a0docCqHkEn9C7=e0GC_ieN1dsYgKQ9PbUmSZYxh9MRnw@mail.gmail.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <8d2dab03-289e-2872-db66-ce80ce5c189f@digikod.net>
Date: Wed, 8 Jul 2020 09:31:26 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <CAK8P3a0docCqHkEn9C7=e0GC_ieN1dsYgKQ9PbUmSZYxh9MRnw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 08/07/2020 09:22, Arnd Bergmann wrote:
> On Tue, Jul 7, 2020 at 8:10 PM Mickaël Salaün <mic@digikod.net> wrote:
> 
>> index f4a01305d9a6..a63a411a74d5 100644
>> --- a/include/uapi/asm-generic/unistd.h
>> +++ b/include/uapi/asm-generic/unistd.h
>> @@ -857,9 +857,11 @@ __SYSCALL(__NR_openat2, sys_openat2)
>>  __SYSCALL(__NR_pidfd_getfd, sys_pidfd_getfd)
>>  #define __NR_faccessat2 439
>>  __SYSCALL(__NR_faccessat2, sys_faccessat2)
>> +#define __NR_landlock 440
>> +__SYSCALL(__NR_landlock, sys_landlock)
>>
>>  #undef __NR_syscalls
>> -#define __NR_syscalls 440
>> +#define __NR_syscalls 441
> 
> In linux-next, we already have:
> 
> +#define __NR_watch_mount 440
> +#define __NR_watch_sb 441
> +#define __NR_fsinfo 442
> +#define __NR_process_madvise 443
> 
> You may want to increase the number again.
> 
>       Arnd
> 

OK, I'll rebase the next series on linux-next. Do you know if there is
other syscalls on their way to linux-next?

Are the other parts of arch/syscall OK for you?
