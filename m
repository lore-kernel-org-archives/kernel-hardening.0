Return-Path: <SRS0=GUuK=CS=lists.openwall.com=kernel-hardening-return-19835-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 979E3C433E2
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Sep 2020 17:56:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D091521D46
	for <kernel-hardening@archiver.kernel.org>; Wed,  9 Sep 2020 17:56:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D091521D46
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19835-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1924 invoked by uid 550); 9 Sep 2020 17:56:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1904 invoked from network); 9 Sep 2020 17:56:29 -0000
Subject: Re: [RFC PATCH v8 0/3] Add support for AT_INTERPRETED (was O_MAYEXEC)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
 Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski
 <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>,
 Christian Heimes <christian@python.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>,
 Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>,
 James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
 Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
 Kees Cook <keescook@chromium.org>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>,
 Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>,
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
References: <20200908075956.1069018-1-mic@digikod.net>
 <20200908185026.GU1236603@ZenIV.linux.org.uk>
 <e3223b50-0d00-3b64-1e09-cfb1b9648b02@digikod.net>
 <20200909171316.GW1236603@ZenIV.linux.org.uk>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <2ed377c4-3500-3ddc-7181-a5bc114ddf94@digikod.net>
Date: Wed, 9 Sep 2020 19:56:20 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <20200909171316.GW1236603@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 09/09/2020 19:13, Al Viro wrote:
> On Wed, Sep 09, 2020 at 09:19:11AM +0200, Mickaël Salaün wrote:
>>
>> On 08/09/2020 20:50, Al Viro wrote:
>>> On Tue, Sep 08, 2020 at 09:59:53AM +0200, Mickaël Salaün wrote:
>>>> Hi,
>>>>
>>>> This height patch series rework the previous O_MAYEXEC series by not
>>>> adding a new flag to openat2(2) but to faccessat2(2) instead.  As
>>>> suggested, this enables to perform the access check on a file descriptor
>>>> instead of on a file path (while opening it).  This may require two
>>>> checks (one on open and then with faccessat2) but it is a more generic
>>>> approach [8].
>>>
>>> Again, why is that folded into lookup/open/whatnot, rather than being
>>> an operation applied to a file (e.g. O_PATH one)?
>>>
>>
>> I don't understand your question. AT_INTERPRETED can and should be used
>> with AT_EMPTY_PATH. The two checks I wrote about was for IMA.
> 
> Once more, with feeling: don't hide that behind existing syscalls.
> If you want to tell LSM have a look at given fs object in a special
> way, *add* *a* *new* *system* *call* *for* *doing* *just* *that*.
> 

Fine, I'll do it. It will look a lot like this one though.
