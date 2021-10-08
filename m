Return-Path: <SRS0=ONFi=O4=lists.openwall.com=kernel-hardening-return-21427-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9D00C433F5
	for <kernel-hardening@archiver.kernel.org>; Fri,  8 Oct 2021 10:16:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D5E6560FA0
	for <kernel-hardening@archiver.kernel.org>; Fri,  8 Oct 2021 10:16:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D5E6560FA0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 3489 invoked by uid 550); 8 Oct 2021 10:15:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3469 invoked from network); 8 Oct 2021 10:15:56 -0000
Subject: Re: [PATCH v13 1/3] fs: Add trusted_for(2) syscall implementation and
 related sysctl
To: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>, Aleksa Sarai <cyphar@cyphar.com>,
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Casey Schaufler <casey@schaufler-ca.com>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Christian Heimes <christian@python.org>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>,
 Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>, James Morris <jmorris@namei.org>,
 Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>,
 Jonathan Corbet <corbet@lwn.net>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>,
 Paul Moore <paul@paul-moore.com>,
 =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
 Steve Grubb <sgrubb@redhat.com>,
 Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>
References: <20211007182321.872075-1-mic@digikod.net>
 <20211007182321.872075-2-mic@digikod.net> <202110071217.16C7208F@keescook>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <92b01e4f-2bc3-8ba2-997b-5757058fe184@digikod.net>
Date: Fri, 8 Oct 2021 12:16:17 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <202110071217.16C7208F@keescook>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 07/10/2021 21:25, Kees Cook wrote:
> On Thu, Oct 07, 2021 at 08:23:18PM +0200, Mickaël Salaün wrote:
>> From: Mickaël Salaün <mic@linux.microsoft.com>
>>
>> The trusted_for() syscall enables user space tasks to check that files
>> are trusted to be executed or interpreted by user space.  This may allow
>> script interpreters to check execution permission before reading
>> commands from a file, or dynamic linkers to allow shared object loading.
>> This may be seen as a way for a trusted task (e.g. interpreter) to check
>> the trustworthiness of files (e.g. scripts) before extending its control
>> flow graph with new ones originating from these files.
>> [...]
>>  aio-nr & aio-max-nr
>> @@ -382,3 +383,52 @@ Each "watch" costs roughly 90 bytes on a 32bit kernel, and roughly 160 bytes
>>  on a 64bit one.
>>  The current default value for  max_user_watches  is the 1/25 (4%) of the
>>  available low memory, divided for the "watch" cost in bytes.
>> +
>> +
>> +trust_policy
>> +------------
> 
> bikeshed: can we name this "trusted_for_policy"? Both "trust" and
> "policy" are very general words, but "trusted_for" (after this series)
> will have a distinct meaning, so "trusted_for_policy" becomes more
> specific/searchable.

Ok, I'll rename this sysctl.

> 
> With that renamed, I think it looks good! I'm looking forward to
> interpreters using this. :)
> 
> Acked-by: Kees Cook <keescook@chromium.org>
> 
