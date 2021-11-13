Return-Path: <SRS0=8SVo=QA=lists.openwall.com=kernel-hardening-return-21470-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A389C433EF
	for <kernel-hardening@archiver.kernel.org>; Sat, 13 Nov 2021 23:26:55 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AAF3D60EBC
	for <kernel-hardening@archiver.kernel.org>; Sat, 13 Nov 2021 23:26:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AAF3D60EBC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 3725 invoked by uid 550); 13 Nov 2021 23:26:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10232 invoked from network); 13 Nov 2021 19:56:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=va+QXChIb6mUqaS7Hvl+13iHU9HTHiGu0D2Aym2Vkj8=;
        b=ESVoVEtpkOjqVDc3AC7Th7BTC//byih1n09Za+kFJaxGOPNts1YOaSas39PmKfmfO4
         eVbIzS9Cqz82jWnVdGpWFRgOehqG3e3gL8PtbedmO8D69mBAuVR4cZyspVuUvIVZW2fH
         4z0CRba7kIglqkdye73s0jJhg9Qi+lP9UdvG4P4J+qz8e0sEfttBgogM5hX4oRhPktY0
         1UGIswE/8/+HHXIlrw2Vk9zOWPyu7rQ4TOhKEKYXS2YWHhwoZwfqqWeZzTAYoyDoR3NJ
         BWvVFNaoj+x74+Ep0tL4ou+y0dFhTjENd9dN30DVQRoUvxXqjXXmb7GHQ/xy5fpbMivc
         YEUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=va+QXChIb6mUqaS7Hvl+13iHU9HTHiGu0D2Aym2Vkj8=;
        b=nMsC0Tud2F2FwT6+shLTCZQvkFiDKAOG2kubIKlI8QiodVP3JoV4KO+iPzKdnGKCIv
         jqKSN0ekSFWuPrT0wY4xGz5ajvt0FtI16R2RobsHHBzV8zab6t3p3AT9q/34RUK7UGvS
         Ye/wTtxGcyb1Wg/UmfTd1MZyOQthws+gZi+j4GPJF6pERabQ4n5WMb+7kdyi2lUVUkBu
         PLLKhDVKERGqM+LIeXvWuzrIpE4EmPUZW/DmPcG69UqKkQEMtAMEn/5/MmvII0brJyNa
         KI6aK8atpUT0Sh22JdlWyF50OdstOIcwUYCjnfbkDrASfMS6XjUJg3iZWWUnE/w6AUjp
         Y8aw==
X-Gm-Message-State: AOAM531KwaAJIgVmcLz6VdxU8OOwkKmmrQzqmMg5+2JomQbZ9XiSDCLl
	7wdk5Ape7AWQsqwpsvmELIQ=
X-Google-Smtp-Source: ABdhPJyrBCFSZIvE6ESCe8fzt5Ofuhbfmh9PY2vocqyNsRvUvnN2UIdr5lyr75/R2K3Cs0qqD9GUAQ==
X-Received: by 2002:a1c:488:: with SMTP id 130mr28638161wme.157.1636833372652;
        Sat, 13 Nov 2021 11:56:12 -0800 (PST)
Message-ID: <34779736-e875-c3e0-75d5-0f0a55d729aa@gmail.com>
Date: Sat, 13 Nov 2021 20:56:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v16 1/3] fs: Add trusted_for(2) syscall implementation and
 related sysctl
Content-Language: en-US
To: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
 Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Andy Lutomirski <luto@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Christian Heimes <christian@python.org>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>,
 Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>, James Morris <jmorris@namei.org>,
 Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>,
 Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>,
 Paul Moore <paul@paul-moore.com>,
 =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>,
 Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>,
 Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 Yin Fengwei <fengwei.yin@intel.com>, kernel-hardening@lists.openwall.com,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>
References: <20211110190626.257017-1-mic@digikod.net>
 <20211110190626.257017-2-mic@digikod.net>
 <8a22a3c2-468c-e96c-6516-22a0f029aa34@gmail.com>
 <5312f022-96ea-5555-8d17-4e60a33cf8f8@digikod.net>
From: "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
In-Reply-To: <5312f022-96ea-5555-8d17-4e60a33cf8f8@digikod.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Mickaël,

On 11/13/21 14:02, Mickaël Salaün wrote:
>> TL;DR:
>>
>> ISO C specifies that for the following code:
>>
>>      enum foo {BAR};
>>
>>      enum foo foobar;
>>
>> typeof(foo)    shall be int
>> typeof(foobar) is implementation-defined
> 
> I tested with some version of GCC (from 4.9 to 11) and clang (10 and 11)
> with different optimizations and the related sizes are at least the same
> as for the int type.

GCC has -fshort-enums to make enum types be as short as possible.  I 
expected -Os to turn this on, since it saves space, but it doesn't.

Still, not relying on enum == int is better, IMO.

> 
>>
>> Since foobar = BAR; assigns an int, the best thing to do to avoid
>> implementation-defined behavior, is to declare foobar as int too.
> 
> OK, so it should be enough to change the syscall argument type from enum
> trusted_for_usage to int, but we can keep the UAPI with the enum (i.e.
> we don't need to change the value to #define TRUSTED_FOR_EXECUTION 1) right?

Correct.  The enumerations are guaranteed to be int (except in case of 
UB, see below), so they'll be (almost) the same as a #define after the 
preprocessor.


If you do

enum foo {
	FOO = 1L << INT_WIDTH
};

since that doesn't fit in either int or unsigned int,
it is Undefined Behavior,
and here GCC decides to use long for FOO.

+++++++++ UB example ++++++++++++++

$ cat foo.c
	#include <limits.h>
	#include <stdio.h>


	enum foo {
		FOO = 1L << UINT_WIDTH
	};

	int main(void)
	{
		printf("\tsizeof(enum foo) = %zu\n", sizeof(enum foo));
		printf("\tsizeof(FOO)      = %zu\n", sizeof(FOO));
	}

$ cc foo.c -Wall -Wextra -Werror -Wpedantic -pedantic-errors -std=c2x
foo.c:6:23: error: ISO C restricts enumerator values to range of 'int' 
[-Wpedantic]
     6 |                 FOO = 1L << UINT_WIDTH
       |                       ^~
$ cc foo.c -Wall -Wextra -Werror -std=c2x
$ ./a.out
	sizeof(enum foo) = 8
	sizeof(FOO)      = 8

+++++++++++++ -fshort-enums example +++++++++++++++

$ cat foo.c
	#include <stdio.h>


	enum foo {
		FOO = 1
	};

	int main(void)
	{
		printf("\tsizeof(enum foo) = %zu\n", sizeof(enum foo));
		printf("\tsizeof(FOO)      = %zu\n", sizeof(FOO));
	}

$ cc foo.c -Wall -Wextra -Werror -Wpedantic -pedantic-errors -fshort-enums
$ ./a.out
	sizeof(enum foo) = 1
	sizeof(FOO)      = 4

++++++++++++++++++++++++++++++++++++++++++++++++++++++

Cheers,
Alex


> 
>>
>>
>>> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
>>> index 528a478dbda8..c535e0e43cc8 100644
>>> --- a/include/linux/syscalls.h
>>> +++ b/include/linux/syscalls.h
>>> @@ -462,6 +463,7 @@ asmlinkage long sys_fallocate(int fd, int mode,
>>> loff_t offset, loff_t len);
>>>    asmlinkage long sys_faccessat(int dfd, const char __user *filename,
>>> int mode);
>>>    asmlinkage long sys_faccessat2(int dfd, const char __user *filename,
>>> int mode,
>>>                       int flags);
>>> +asmlinkage long sys_trusted_for(int fd, enum trusted_for_usage usage,
>>> u32 flags);
>>
>> Same here.
>>
>>>    asmlinkage long sys_chdir(const char __user *filename);
>>>    asmlinkage long sys_fchdir(unsigned int fd);
>>>    asmlinkage long sys_chroot(const char __user *filename);
>>
>> Thanks,
>> Alex
>>
>>

-- 
Alejandro Colomar
Linux man-pages comaintainer; http://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
