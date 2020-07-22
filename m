Return-Path: <SRS0=76wk=BB=lists.openwall.com=kernel-hardening-return-19417-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BF00C433E1
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 19:05:07 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E5E9920714
	for <kernel-hardening@archiver.kernel.org>; Wed, 22 Jul 2020 19:05:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5E9920714
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19417-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28391 invoked by uid 550); 22 Jul 2020 19:05:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28371 invoked from network); 22 Jul 2020 19:04:59 -0000
Subject: Re: [PATCH v6 5/7] fs,doc: Enable to enforce noexec mounts or file
 exec through O_MAYEXEC
To: Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
 Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
 Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski
 <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>,
 Christian Heimes <christian@python.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>,
 Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>,
 James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
 Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
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
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20200714181638.45751-1-mic@digikod.net>
 <20200714181638.45751-6-mic@digikod.net> <202007151312.C28D112013@keescook>
 <35ea0914-7360-43ab-e381-9614d18cceba@digikod.net>
 <20200722161639.GA24129@gandi.net>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <efb88aab-f9f9-4b66-e7ab-3aa054eec96e@digikod.net>
Date: Wed, 22 Jul 2020 21:04:28 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <20200722161639.GA24129@gandi.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 22/07/2020 18:16, Thibaut Sautereau wrote:
> On Thu, Jul 16, 2020 at 04:39:14PM +0200, Mickaël Salaün wrote:
>>
>> On 15/07/2020 22:37, Kees Cook wrote:
>>> On Tue, Jul 14, 2020 at 08:16:36PM +0200, Mickaël Salaün wrote:
>>>> @@ -2849,7 +2855,7 @@ static int may_open(const struct path *path, int acc_mode, int flag)
>>>>  	case S_IFLNK:
>>>>  		return -ELOOP;
>>>>  	case S_IFDIR:
>>>> -		if (acc_mode & (MAY_WRITE | MAY_EXEC))
>>>> +		if (acc_mode & (MAY_WRITE | MAY_EXEC | MAY_OPENEXEC))
>>>>  			return -EISDIR;
>>>>  		break;
>>>
>>> (I need to figure out where "open for reading" rejects S_IFDIR, since
>>> it's clearly not here...)
> 
> Doesn't it come from generic_read_dir() in fs/libfs.c?
> 
>>>
>>>>  	case S_IFBLK:
>>>> @@ -2859,13 +2865,26 @@ static int may_open(const struct path *path, int acc_mode, int flag)
>>>>  		fallthrough;
>>>>  	case S_IFIFO:
>>>>  	case S_IFSOCK:
>>>> -		if (acc_mode & MAY_EXEC)
>>>> +		if (acc_mode & (MAY_EXEC | MAY_OPENEXEC))
>>>>  			return -EACCES;
>>>>  		flag &= ~O_TRUNC;
>>>>  		break;
>>>
>>> This will immediately break a system that runs code with MAY_OPENEXEC
>>> set but reads from a block, char, fifo, or socket, even in the case of
>>> a sysadmin leaving the "file" sysctl disabled.
>>
>> As documented, O_MAYEXEC is for regular files. The only legitimate use
>> case seems to be with pipes, which should probably be allowed when
>> enforcement is disabled.
> 
> By the way Kees, while we fix that for the next series, do you think it
> would be relevant, at least for the sake of clarity, to add a
> WARN_ON_ONCE(acc_mode & MAY_OPENEXEC) for the S_IFSOCK case, since a
> socket cannot be open anyway?
> 

We just did some more tests (for the next patch series) and it turns out
that may_open() can return EACCES before another part returns ENXIO.

As a reminder, the next series will deny access to block devices,
character devices, fifo and socket when opened with O_MAYEXEC *and* if
any policy is enforced (via the sysctl).

The question is then: do we prefer to return EACCES when a policy is
enforced (on a socket), or do we stick to the ENXIO? The EACCES approach
will be more consistent with devices and fifo handling, and seems safer
(belt and suspenders) thought.
