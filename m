Return-Path: <SRS0=Nl43=5M=lists.openwall.com=kernel-hardening-return-18255-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4581BC43331
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Mar 2020 14:59:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A0110206F6
	for <kernel-hardening@archiver.kernel.org>; Fri, 27 Mar 2020 14:59:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A0110206F6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18255-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27997 invoked by uid 550); 27 Mar 2020 14:59:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27962 invoked from network); 27 Mar 2020 14:59:27 -0000
Subject: Re: [PATCH v15 09/10] samples/landlock: Add a sandbox manager example
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>,
 Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
 Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
 "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-security-module@vger.kernel.org, x86@kernel.org
References: <20200326202731.693608-1-mic@digikod.net>
 <20200326202731.693608-10-mic@digikod.net>
 <11634607-2fdb-1868-03d0-94096763766f@infradead.org>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <4285db52-e7ce-6a0f-3791-fd39c892489e@digikod.net>
Date: Fri, 27 Mar 2020 15:59:00 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <11634607-2fdb-1868-03d0-94096763766f@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 27/03/2020 00:54, Randy Dunlap wrote:
> Hi,
> 
> On 3/26/20 1:27 PM, Mickaël Salaün wrote:
>> diff --git a/samples/Kconfig b/samples/Kconfig
>> index 9d236c346de5..b54408c5bd86 100644
>> --- a/samples/Kconfig
>> +++ b/samples/Kconfig
>> @@ -120,6 +120,13 @@ config SAMPLE_HIDRAW
>>  	bool "hidraw sample"
>>  	depends on HEADERS_INSTALL
>>  
>> +config SAMPLE_LANDLOCK
>> +	bool "Build Landlock sample code"
>> +	select HEADERS_INSTALL
> 
> I think that this should be like all of the other users of HEADERS_INSTALL
> and depend on that instead of select-ing it.

Ok, I though it made sense to select it automatically, but I'll get back
the "depends on".

Thanks.

> 
>> +	help
>> +	  Build a simple Landlock sandbox manager able to launch a process
>> +	  restricted by a user-defined filesystem access-control security policy.
>> +
>>  config SAMPLE_PIDFD
>>  	bool "pidfd sample"
>>  	depends on HEADERS_INSTALL
> 
> thanks.
> 
