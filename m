Return-Path: <SRS0=wrf1=CU=lists.openwall.com=kernel-hardening-return-19879-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65AB0C433E2
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Sep 2020 12:16:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 56CB421D40
	for <kernel-hardening@archiver.kernel.org>; Fri, 11 Sep 2020 12:16:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56CB421D40
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19879-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3199 invoked by uid 550); 11 Sep 2020 12:16:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3177 invoked from network); 11 Sep 2020 12:16:38 -0000
Subject: Re: [RFC PATCH v9 0/3] Add introspect_access(2) (was O_MAYEXEC)
To: Matthew Wilcox <willy@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Mimi Zohar <zohar@linux.ibm.com>, linux-kernel@vger.kernel.org,
 Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski
 <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Casey Schaufler <casey@schaufler-ca.com>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Christian Heimes <christian@python.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>,
 Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>,
 James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
 Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
 Kees Cook <keescook@chromium.org>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 Matthew Garrett <mjg59@google.com>, Michael Kerrisk
 <mtk.manpages@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>,
 =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
 Steve Grubb <sgrubb@redhat.com>,
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20200910164612.114215-1-mic@digikod.net>
 <20200910170424.GU6583@casper.infradead.org>
 <f6e2358c-8e5e-e688-3e66-2cdd943e360e@digikod.net>
 <a48145770780d36e90f28f1526805a7292eb74f6.camel@linux.ibm.com>
 <880bb4ee-89a2-b9b0-747b-0f779ceda995@digikod.net>
 <20200910184033.GX6583@casper.infradead.org>
 <20200910200010.GF1236603@ZenIV.linux.org.uk>
 <20200910200543.GY6583@casper.infradead.org>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <3dd9b2b3-6304-03df-bfba-13864169453e@digikod.net>
Date: Fri, 11 Sep 2020 14:16:23 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <20200910200543.GY6583@casper.infradead.org>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 10/09/2020 22:05, Matthew Wilcox wrote:
> On Thu, Sep 10, 2020 at 09:00:10PM +0100, Al Viro wrote:
>> On Thu, Sep 10, 2020 at 07:40:33PM +0100, Matthew Wilcox wrote:
>>> On Thu, Sep 10, 2020 at 08:38:21PM +0200, Mickaël Salaün wrote:
>>>> There is also the use case of noexec mounts and file permissions. From
>>>> user space point of view, it doesn't matter which kernel component is in
>>>> charge of defining the policy. The syscall should then not be tied with
>>>> a verification/integrity/signature/appraisal vocabulary, but simply an
>>>> access control one.
>>>
>>> permission()?
>>
>> int lsm(int fd, const char *how, char *error, int size);
>>
>> Seriously, this is "ask LSM to apply special policy to file"; let's
>> _not_ mess with flags, etc. for that; give it decent bandwidth
>> and since it's completely opaque for the rest of the kernel,
>> just a pass a string to be parsed by LSM as it sees fit.

Well, I don't know why you're so angry against LSM, but as noticed by
Matthew, the main focus of this patch series is not about LSM (no hook,
no security/* code, only file permission and mount option checks,
nothing fancy). Moreover, the syscall you're proposing doesn't make
sense, but I guess it's yet another sarcastic reply. Please, cool down.
We asked for constructive comments and already followed your previous
requests (even if we didn't get answers for some questions), but
seriously, this one is nonsense.

> 
> Hang on, it does have some things which aren't BD^W^WLSM.  It lets
> the interpreter honour the mount -o noexec option.  I presume it's
> not easily defeated by
> 	cat /home/salaun/bin/bad.pl | perl -
> 

Funny. I know there is a lot of text and links but please read the
commit messages before further comments.
