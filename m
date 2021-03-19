Return-Path: <SRS0=fFuB=IR=lists.openwall.com=kernel-hardening-return-21001-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 692E9C433C1
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 19:08:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ABE746197B
	for <kernel-hardening@archiver.kernel.org>; Fri, 19 Mar 2021 19:07:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ABE746197B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21001-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5815 invoked by uid 550); 19 Mar 2021 19:07:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5794 invoked from network); 19 Mar 2021 19:07:52 -0000
Subject: Re: [PATCH v30 03/12] landlock: Set up the security framework and
 manage credentials
To: Kees Cook <keescook@chromium.org>
Cc: James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
 "Serge E . Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann
 <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 David Howells <dhowells@redhat.com>, Jeff Dike <jdike@addtoit.com>,
 Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>,
 Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-security-module@vger.kernel.org,
 x86@kernel.org, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?=
 <mic@linux.microsoft.com>
References: <20210316204252.427806-1-mic@digikod.net>
 <20210316204252.427806-4-mic@digikod.net> <202103191140.7D1F10CBFD@keescook>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <3a8a9744-20fe-a3e7-24bb-aeac2c4b74f8@digikod.net>
Date: Fri, 19 Mar 2021 20:07:55 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <202103191140.7D1F10CBFD@keescook>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 19/03/2021 19:45, Kees Cook wrote:
> On Tue, Mar 16, 2021 at 09:42:43PM +0100, Mickaël Salaün wrote:
>>  config LSM
>>  	string "Ordered list of enabled LSMs"
>> -	default "lockdown,yama,loadpin,safesetid,integrity,smack,selinux,tomoyo,apparmor,bpf" if DEFAULT_SECURITY_SMACK
>> -	default "lockdown,yama,loadpin,safesetid,integrity,apparmor,selinux,smack,tomoyo,bpf" if DEFAULT_SECURITY_APPARMOR
>> -	default "lockdown,yama,loadpin,safesetid,integrity,tomoyo,bpf" if DEFAULT_SECURITY_TOMOYO
>> -	default "lockdown,yama,loadpin,safesetid,integrity,bpf" if DEFAULT_SECURITY_DAC
>> -	default "lockdown,yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor,bpf"
>> +	default "landlock,lockdown,yama,loadpin,safesetid,integrity,smack,selinux,tomoyo,apparmor,bpf" if DEFAULT_SECURITY_SMACK
>> +	default "landlock,lockdown,yama,loadpin,safesetid,integrity,apparmor,selinux,smack,tomoyo,bpf" if DEFAULT_SECURITY_APPARMOR
>> +	default "landlock,lockdown,yama,loadpin,safesetid,integrity,tomoyo,bpf" if DEFAULT_SECURITY_TOMOYO
>> +	default "landlock,lockdown,yama,loadpin,safesetid,integrity,bpf" if DEFAULT_SECURITY_DAC
>> +	default "landlock,lockdown,yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor,bpf"
>>  	help
>>  	  A comma-separated list of LSMs, in initialization order.
>>  	  Any LSMs left off this list will be ignored. This can be
> 
> There was some discussion long ago about landlock needing to be last
> in the list because it was unprivileged. Is that no longer true? (And
> what is the justification for its position in the list?)

Indeed, I wanted to put Landlock last because it was an unprivileged
programmable access-control, which could lead to side-channel attacks
against other access-controls (e.g. to infer enforced policies). This is
not valid anymore because Landlock is not using eBPF, only the BPF LSM
does that (which is not the only reason why it is the last stacked).

> 
>> diff --git a/security/landlock/common.h b/security/landlock/common.h
>> new file mode 100644
>> index 000000000000..5dc0fe15707d
>> --- /dev/null
>> +++ b/security/landlock/common.h
>> @@ -0,0 +1,20 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Landlock LSM - Common constants and helpers
>> + *
>> + * Copyright © 2016-2020 Mickaël Salaün <mic@digikod.net>
>> + * Copyright © 2018-2020 ANSSI
>> + */
>> +
>> +#ifndef _SECURITY_LANDLOCK_COMMON_H
>> +#define _SECURITY_LANDLOCK_COMMON_H
>> +
>> +#define LANDLOCK_NAME "landlock"
>> +
>> +#ifdef pr_fmt
>> +#undef pr_fmt
>> +#endif
> 
> When I see "#undef pr_fmt" I think there is a header ordering problem.

Not is this case, it's a "namespace" definition. :)

> 
>> [...]
> 
> Everything else looks like regular boilerplate for an LSM. :)
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 
