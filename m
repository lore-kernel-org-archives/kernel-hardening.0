Return-Path: <SRS0=3Bm+=AT=lists.openwall.com=kernel-hardening-return-19247-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5D7C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jul 2020 07:04:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6A82220656
	for <kernel-hardening@archiver.kernel.org>; Wed,  8 Jul 2020 07:04:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A82220656
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19247-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11909 invoked by uid 550); 8 Jul 2020 07:04:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11876 invoked from network); 8 Jul 2020 07:04:06 -0000
Subject: Re: [PATCH v19 07/12] landlock: Support filesystem access-control
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann
 <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
 Jeff Dike <jdike@addtoit.com>, Jonathan Corbet <corbet@lwn.net>,
 Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
 Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>,
 Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-security-module@vger.kernel.org, x86@kernel.org
References: <20200707180955.53024-1-mic@digikod.net>
 <20200707180955.53024-8-mic@digikod.net>
 <6a80b712-a7b9-7b47-083a-08b7769016f8@infradead.org>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <b5d5326f-cf37-36f0-7bce-8494c5a65cb5@digikod.net>
Date: Wed, 8 Jul 2020 09:03:46 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <6a80b712-a7b9-7b47-083a-08b7769016f8@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 07/07/2020 22:11, Randy Dunlap wrote:
> Hi--
> 
> On 7/7/20 11:09 AM, Mickaël Salaün wrote:
>> ---
>>  arch/Kconfig                  |   7 +
>>  arch/um/Kconfig               |   1 +
>>  include/uapi/linux/landlock.h |  78 +++++
>>  security/landlock/Kconfig     |   2 +-
>>  security/landlock/Makefile    |   2 +-
>>  security/landlock/fs.c        | 609 ++++++++++++++++++++++++++++++++++
>>  security/landlock/fs.h        |  60 ++++
>>  security/landlock/setup.c     |   7 +
>>  security/landlock/setup.h     |   2 +
>>  9 files changed, 766 insertions(+), 2 deletions(-)
>>  create mode 100644 include/uapi/linux/landlock.h
>>  create mode 100644 security/landlock/fs.c
>>  create mode 100644 security/landlock/fs.h
>>
>> diff --git a/arch/Kconfig b/arch/Kconfig
>> index 8cc35dc556c7..483b7476ac69 100644
>> --- a/arch/Kconfig
>> +++ b/arch/Kconfig
>> @@ -845,6 +845,13 @@ config COMPAT_32BIT_TIME
>>  config ARCH_NO_PREEMPT
>>  	bool
>>  
>> +config ARCH_EPHEMERAL_STATES
>> +	def_bool n
>> +	help
>> +	  An arch should select this symbol if it do not keep an internal kernel
> 
> 	                                       it does not
> 
>> +	  state for kernel objects such as inodes, but instead rely on something
> 
> 	                                               instead relies on
> 
>> +	  else (e.g. the host kernel for an UML kernel).
>> +
>>  config ARCH_SUPPORTS_RT
>>  	bool
>>  
> 
> thanks.
> 

Thanks Randy!
