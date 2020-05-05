Return-Path: <SRS0=oej2=6T=lists.openwall.com=kernel-hardening-return-18725-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B044AC47247
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 May 2020 16:56:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 15EAE206CC
	for <kernel-hardening@archiver.kernel.org>; Tue,  5 May 2020 16:56:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 15EAE206CC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18725-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17587 invoked by uid 550); 5 May 2020 16:56:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17567 invoked from network); 5 May 2020 16:56:14 -0000
Subject: Re: [PATCH v5 3/6] fs: Enable to enforce noexec mounts or file exec
 through O_MAYEXEC
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>,
 Christian Heimes <christian@python.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>,
 James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
 Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
 Kees Cook <keescook@chromium.org>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
 Mimi Zohar <zohar@linux.ibm.com>,
 =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
 Steve Grubb <sgrubb@redhat.com>,
 Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20200505153156.925111-1-mic@digikod.net>
 <20200505153156.925111-4-mic@digikod.net>
 <fb6e2d7d-a372-3e79-214d-3ac9a451cd0a@infradead.org>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <3555aab7-f4e0-80eb-0dfc-a87cfcba5e68@digikod.net>
Date: Tue, 5 May 2020 18:55:59 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <fb6e2d7d-a372-3e79-214d-3ac9a451cd0a@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000



On 05/05/2020 17:44, Randy Dunlap wrote:
> On 5/5/20 8:31 AM, Mickaël Salaün wrote:
>> diff --git a/security/Kconfig b/security/Kconfig
>> index cd3cc7da3a55..d8fac9240d14 100644
>> --- a/security/Kconfig
>> +++ b/security/Kconfig
>> @@ -230,6 +230,32 @@ config STATIC_USERMODEHELPER_PATH
>>  	  If you wish for all usermode helper programs to be disabled,
>>  	  specify an empty string here (i.e. "").
>>  
>> +menuconfig OMAYEXEC_STATIC
>> +	tristate "Configure O_MAYEXEC behavior at build time"
>> +	---help---
>> +	  Enable to enforce O_MAYEXEC at build time, and disable the dedicated
>> +	  fs.open_mayexec_enforce sysctl.
> 
> That help message is a bit confusing IMO.  Does setting/enabling OMAYEXEC_STATIC
> both enforce O_MAYEXEC at build time and also disable the dedicated sysctl?

Yes. What about this?
"Define the O_MAYEXEC policy at build time only. As a side effect, this
also disables the fs.open_mayexec_enforce sysctl."

> 
> Or are these meant to be alternatives, one for what Enabling this kconfig symbol
> does and the other for what Disabling this symbol does?  If so, it doesn't
> say that.
> 
>> +
>> +	  See Documentation/admin-guide/sysctl/fs.rst for more details.
>> +
>> +if OMAYEXEC_STATIC
>> +
>> +config OMAYEXEC_ENFORCE_MOUNT
>> +	bool "Mount restriction"
>> +	default y
>> +	---help---
>> +	  Forbid opening files with the O_MAYEXEC option if their underlying VFS is
>> +	  mounted with the noexec option or if their superblock forbids execution
>> +	  of its content (e.g., /proc).
>> +
>> +config OMAYEXEC_ENFORCE_FILE
>> +	bool "File permission restriction"
>> +	---help---
>> +	  Forbid opening files with the O_MAYEXEC option if they are not marked as
>> +	  executable for the current process (e.g., POSIX permissions).
>> +
>> +endif # OMAYEXEC_STATIC
>> +
>>  source "security/selinux/Kconfig"
>>  source "security/smack/Kconfig"
>>  source "security/tomoyo/Kconfig"
> 
> 
