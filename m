Return-Path: <SRS0=N11y=BG=lists.openwall.com=kernel-hardening-return-19458-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12407C433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Jul 2020 19:47:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 679A12073E
	for <kernel-hardening@archiver.kernel.org>; Mon, 27 Jul 2020 19:47:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 679A12073E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19458-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1932 invoked by uid 550); 27 Jul 2020 19:47:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1911 invoked from network); 27 Jul 2020 19:47:11 -0000
Subject: Re: [PATCH v7 4/7] fs: Introduce O_MAYEXEC flag for openat2(2)
To: Florian Weimer <fweimer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
 Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski
 <luto@kernel.org>, Christian Brauner <christian.brauner@ubuntu.com>,
 Christian Heimes <christian@python.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>,
 Eric Chiang <ericchiang@google.com>, James Morris <jmorris@namei.org>,
 Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>,
 Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.ibm.com>,
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
 linux-fsdevel@vger.kernel.org,
 Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
References: <20200723171227.446711-1-mic@digikod.net>
 <20200723171227.446711-5-mic@digikod.net>
 <20200727042106.GB794331@ZenIV.linux.org.uk>
 <87y2n55xzv.fsf@oldenburg2.str.redhat.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <eaf5bc42-e086-740b-a90c-93e67c535eee@digikod.net>
Date: Mon, 27 Jul 2020 21:46:55 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <87y2n55xzv.fsf@oldenburg2.str.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 27/07/2020 07:27, Florian Weimer wrote:
> * Al Viro:
> 
>> On Thu, Jul 23, 2020 at 07:12:24PM +0200, MickaÃ«l SalaÃ¼n wrote:
>>> When the O_MAYEXEC flag is passed, openat2(2) may be subject to
>>> additional restrictions depending on a security policy managed by the
>>> kernel through a sysctl or implemented by an LSM thanks to the
>>> inode_permission hook.  This new flag is ignored by open(2) and
>>> openat(2) because of their unspecified flags handling.  When used with
>>> openat2(2), the default behavior is only to forbid to open a directory.
>>
>> Correct me if I'm wrong, but it looks like you are introducing a magical
>> flag that would mean "let the Linux S&M take an extra special whip
>> for this open()".

There is nothing magic, it doesn't only work with the LSM framework, and
there is nothing painful nor humiliating here (except maybe this language).

>>
>> Why is it done during open?  If the caller is passing it deliberately,
>> why not have an explicit request to apply given torture device to an
>> already opened file?  Why not sys_masochism(int fd, char *hurt_flavour),
>> for that matter?
> 
> While I do not think this is appropriate language for a workplace, Al
> has a point: If the auditing event can be generated on an already-open
> descriptor, it would also cover scenarios like this one:
> 
>   perl < /path/to/script
> 
> Where the process that opens the file does not (and cannot) know that it
> will be used for execution purposes.

The check is done during open because the goal of this patch series is
to address the problem of script execution when opening a script in well
controlled systems (e.g. to enforce a "write xor execute" policy, to do
an atomic integrity check [1], to check specific execute/read
permissions, etc.). As discussed multiple times, controlling other means
to interpret commands (stdin, environment variables, etc.) is out of
scope and should be handled by interpreters (in userspace). Someone
could still extend fcntl(2) to enable to check file descriptors, but it
is an independent change not required for now.
Specific audit features are also out of scope for now [2].

[1] https://lore.kernel.org/lkml/1544699060.6703.11.camel@linux.ibm.com/
[2] https://lore.kernel.org/lkml/202007160822.CCDB5478@keescook/
