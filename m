Return-Path: <SRS0=vvQS=P7=lists.openwall.com=kernel-hardening-return-21464-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C40DC433EF
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Nov 2021 19:19:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 253816102A
	for <kernel-hardening@archiver.kernel.org>; Fri, 12 Nov 2021 19:19:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 253816102A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 22003 invoked by uid 550); 12 Nov 2021 19:19:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19690 invoked from network); 12 Nov 2021 19:16:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=R4ezy0Y4KPXp1tXNQDpaUBacCpK19eND/tfIECpPASc=;
        b=YBAsL5+dMv+AtdCI71meU1aglw9me3H8v1QOrePgPB15Qdk6rfgsmCdUa3yRRslChm
         ZvwFGybUYmH0pUsRB4iG1vgM5KuZsjKJedZTGh9aqBW5D7uE8Zhq4sadE0/TJznNFJJv
         vkafBQ6sMgd0Iu2yRmQLoXMAQCuTVFhemjROjYpBjO77jx+BxZ9HyKBbFAhPT9Y91Mqw
         6ZDocCpHjmTV53A+K8h4+cTq7LsnGH7HYUqNUxGkRDidrKfR/dMZFR3ZbllKD7NW/SJ8
         xHA3zhUcjwK7nluuLxnneD0QK9CXYo2T8596s7qhzcqLGGplshe7hfyK18Y+2/guOa18
         wvMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=R4ezy0Y4KPXp1tXNQDpaUBacCpK19eND/tfIECpPASc=;
        b=axFCIZZfRCPL5oxEQmem2lVUUrpaeoTkYMHPQ6mTA0zCKFX9pdGHQvR0AfDJuEZkaJ
         GD8NBSGHibj0nNsqk98pM6nF9bPd4DKHkIhM/0kL05m6qdpl/7btsmXswSN9awKgW5Sm
         JNRVfJEOZXPKWZYDLX5c1YcTj07sJxsguYyqAluPUGgxhOUwW1eBcgZ91zDLbnCZWUxD
         VZpeB8QK+/kvhSu1gdMgQ9y7FS8rl5FRdVT4vCauMKqUGyZiyIURpXFpFvTn455AAAtX
         i28SjxFabeDdAvu7fHN1RMuXStb3HNkTGmmoW6X+ATcxW6uisiK4r0nYfNFErO4s6bUf
         x31g==
X-Gm-Message-State: AOAM5333LqPzXPPeZT8XKxpKeDrWmQR7+w3hqwhpNCYREhsHqqI0iXeZ
	v8FJ2LYYLhPJClv9+fx07eM=
X-Google-Smtp-Source: ABdhPJztY+FW6YVXoupcUTvo6LglloVd3KdIeP82Ahk9x8OJslbogmifLiXmtGgsz7nnMioMPxUcgQ==
X-Received: by 2002:a05:600c:a05:: with SMTP id z5mr19436348wmp.73.1636744565070;
        Fri, 12 Nov 2021 11:16:05 -0800 (PST)
Message-ID: <8a22a3c2-468c-e96c-6516-22a0f029aa34@gmail.com>
Date: Fri, 12 Nov 2021 20:16:01 +0100
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
From: "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
In-Reply-To: <20211110190626.257017-2-mic@digikod.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Mickaël,

On 11/10/21 20:06, Mickaël Salaün wrote:
> diff --git a/fs/open.c b/fs/open.c
> index f732fb94600c..96a80abec41b 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -480,6 +482,114 @@ SYSCALL_DEFINE2(access, const char __user *, filename, int, mode)
>   	return do_faccessat(AT_FDCWD, filename, mode, 0);
>   }
>   
> +#define TRUST_POLICY_EXEC_MOUNT			BIT(0)
> +#define TRUST_POLICY_EXEC_FILE			BIT(1)
> +
> +int sysctl_trusted_for_policy __read_mostly;
> +
> +/**
...
> + */
> +SYSCALL_DEFINE3(trusted_for, const int, fd, const enum trusted_for_usage, usage,

Please, don't use enums for interfaces.  They are implementation defined 
types, and vary between compilers and within the same compiler also 
depending on optimization flags.

C17::6.7.2.2.4:
[
Each enumerated type shall be compatible with char,
a signed integer type, or an unsigned integer type.
The choice of type is implementation-defined,130)
but shall be capable of representing the values of
all the members of the enumeration.
]

See also:
<https://stackoverflow.com/questions/366017/what-is-the-size-of-an-enum-in-c>

So, please use only standard integer types for interfaces.

And in the case of enums, since the language specifies that enumeration 
constants (the macro-like identifiers) are of type int, it makes sense 
for functions to use int.

C17::6.7.2.2.3:
[
The identifiers in an enumerator list are declared as constants
that have type int and may appear wherever such are permitted.
]

I'd use an int for the API/ABI, even if it's expected to be assigned 
values of 'enum trusted_for_usage' (that should be specified in the 
manual page in DESCRIPTION, but not in SYNOPSIS, which should specify int).



TL;DR:

ISO C specifies that for the following code:

	enum foo {BAR};

	enum foo foobar;

typeof(foo)    shall be int
typeof(foobar) is implementation-defined

Since foobar = BAR; assigns an int, the best thing to do to avoid 
implementation-defined behavior, is to declare foobar as int too.


> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 528a478dbda8..c535e0e43cc8 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -462,6 +463,7 @@ asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);
>   asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode);
>   asmlinkage long sys_faccessat2(int dfd, const char __user *filename, int mode,
>   			       int flags);
> +asmlinkage long sys_trusted_for(int fd, enum trusted_for_usage usage, u32 flags);

Same here.

>   asmlinkage long sys_chdir(const char __user *filename);
>   asmlinkage long sys_fchdir(unsigned int fd);
>   asmlinkage long sys_chroot(const char __user *filename);

Thanks,
Alex


-- 
Alejandro Colomar
Linux man-pages comaintainer; http://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/

-- 
Alejandro Colomar
Linux man-pages comaintainer; http://www.kernel.org/doc/man-pages/
http://www.alejandro-colomar.es/
