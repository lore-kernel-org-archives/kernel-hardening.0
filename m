Return-Path: <SRS0=CrGX=BV=lists.openwall.com=kernel-hardening-return-19600-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAD_ENC_HEADER,BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE0CBC433DF
	for <kernel-hardening@archiver.kernel.org>; Tue, 11 Aug 2020 19:18:40 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3FD5820774
	for <kernel-hardening@archiver.kernel.org>; Tue, 11 Aug 2020 19:18:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3FD5820774
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19600-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1087 invoked by uid 550); 11 Aug 2020 19:18:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1067 invoked from network); 11 Aug 2020 19:18:33 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org,  Aleksa Sarai <cyphar@cyphar.com>,  Alexei
 Starovoitov <ast@kernel.org>,  Al Viro <viro@zeniv.linux.org.uk>,  Andrew
 Morton <akpm@linux-foundation.org>,  Andy Lutomirski <luto@kernel.org>,
  Christian Brauner <christian.brauner@ubuntu.com>,  Christian Heimes
 <christian@python.org>,  Daniel Borkmann <daniel@iogearbox.net>,  Deven
 Bowers <deven.desai@linux.microsoft.com>,  Dmitry Vyukov
 <dvyukov@google.com>,  Eric Biggers <ebiggers@kernel.org>,  Eric Chiang
 <ericchiang@google.com>,  Florian Weimer <fweimer@redhat.com>,  James
 Morris <jmorris@namei.org>,  Jan Kara <jack@suse.cz>,  Jann Horn
 <jannh@google.com>,  Jonathan Corbet <corbet@lwn.net>,  Kees Cook
 <keescook@chromium.org>,  Lakshmi Ramasubramanian
 <nramas@linux.microsoft.com>,  Matthew Garrett <mjg59@google.com>,
  Matthew Wilcox <willy@infradead.org>,  Michael Kerrisk
 <mtk.manpages@gmail.com>,  Mimi Zohar <zohar@linux.ibm.com>,  Philippe
 =?utf-8?Q?Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>,  Scott Shell
 <scottsh@microsoft.com>,  Sean Christopherson
 <sean.j.christopherson@intel.com>,  Shuah Khan <shuah@kernel.org>,  Steve
 Dower <steve.dower@python.org>,  Steve Grubb <sgrubb@redhat.com>,  Tetsuo
 Handa <penguin-kernel@I-love.SAKURA.ne.jp>,  Thibaut Sautereau
 <thibaut.sautereau@clip-os.org>,  Vincent Strubel
 <vincent.strubel@ssi.gouv.fr>,  kernel-hardening@lists.openwall.com,
  linux-api@vger.kernel.org,  linux-integrity@vger.kernel.org,
  linux-security-module@vger.kernel.org,  linux-fsdevel@vger.kernel.org
References: <20200723171227.446711-1-mic@digikod.net>
	<20200723171227.446711-2-mic@digikod.net>
	<87eeodnh3v.fsf@x220.int.ebiederm.org>
Date: Tue, 11 Aug 2020 14:14:43 -0500
In-Reply-To: <87eeodnh3v.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Tue, 11 Aug 2020 13:59:48 -0500")
Message-ID: <874kp9ngf0.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-XM-SPF: eid=1k5Zmj-0008Qv-TU;;;mid=<874kp9ngf0.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19nTKA3mnL/oyWdDp6PD6Bdr/fgnKMbcEc=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v7 1/7] exec: Change uselib(2) IS_SREG() failure to EACCES
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)

ebiederm@xmission.com (Eric W. Biederman) writes:

> Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> writes:
>
>> From: Kees Cook <keescook@chromium.org>
>>
>> Change uselib(2)' S_ISREG() error return to EACCES instead of EINVAL so
>> the behavior matches execve(2), and the seemingly documented value.
>> The "not a regular file" failure mode of execve(2) is explicitly
>> documented[1], but it is not mentioned in uselib(2)[2] which does,
>> however, say that open(2) and mmap(2) errors may apply. The documentation
>> for open(2) does not include a "not a regular file" error[3], but mmap(2)
>> does[4], and it is EACCES.
>
> Do you have enough visibility into uselib to be certain this will change
> will not cause regressions?
>
> My sense of uselib is that it would be easier to remove the system call
> entirely (I think it's last use was in libc5) than to validate that a
> change like this won't cause problems for the users of uselib.
>
> For the kernel what is important are real world users and the manpages
> are only important as far as they suggest what the real world users
> do.

Hmm.

My apologies. After reading the next patch I see that what really makes
this safe is: 73601ea5b7b1 ("fs/open.c: allow opening only regular files
during execve()").

As in practice this change has already been made and uselib simply
can not reach the !S_ISREG test.

It might make sense to drop this patch or include that reference
in the next posting of this patch.

Eric
