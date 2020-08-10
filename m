Return-Path: <SRS0=wqNG=BU=lists.openwall.com=kernel-hardening-return-19583-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6231C433DF
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Aug 2020 22:47:54 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F0A8D20748
	for <kernel-hardening@archiver.kernel.org>; Mon, 10 Aug 2020 22:47:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F0A8D20748
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19583-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5622 invoked by uid 550); 10 Aug 2020 22:47:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5602 invoked from network); 10 Aug 2020 22:47:47 -0000
Subject: Re: [PATCH v7 0/7] Add support for O_MAYEXEC
To: Al Viro <viro@zeniv.linux.org.uk>, David Laight <David.Laight@aculab.com>
Cc: Kees Cook <keescook@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>,
 Andy Lutomirski <luto@kernel.org>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Christian Heimes <christian@python.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>,
 Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>,
 James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
 Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
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
 "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
 "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
 "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
 "linux-security-module@vger.kernel.org"
 <linux-security-module@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <20200723171227.446711-1-mic@digikod.net>
 <202007241205.751EBE7@keescook>
 <0733fbed-cc73-027b-13c7-c368c2d67fb3@digikod.net>
 <20200810202123.GC1236603@ZenIV.linux.org.uk>
 <30b8c003f49d4280be5215f634ca2c06@AcuMS.aculab.com>
 <20200810222838.GF1236603@ZenIV.linux.org.uk>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <2531a0e8-5122-867c-ba06-5d2e623a3834@digikod.net>
Date: Tue, 11 Aug 2020 00:47:32 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <20200810222838.GF1236603@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000



On 11/08/2020 00:28, Al Viro wrote:
> On Mon, Aug 10, 2020 at 10:09:09PM +0000, David Laight wrote:
>>> On Mon, Aug 10, 2020 at 10:11:53PM +0200, Mickaël Salaün wrote:
>>>> It seems that there is no more complains nor questions. Do you want me
>>>> to send another series to fix the order of the S-o-b in patch 7?
>>>
>>> There is a major question regarding the API design and the choice of
>>> hooking that stuff on open().  And I have not heard anything resembling
>>> a coherent answer.
>>
>> To me O_MAYEXEC is just the wrong name.
>> The bit would be (something like) O_INTERPRET to indicate
>> what you want to do with the contents.

The properties is "execute permission". This can then be checked by
interpreters or other applications, then the generic O_MAYEXEC name.

> 
> ... which does not answer the question - name of constant is the least of
> the worries here.  Why the hell is "apply some unspecified checks to
> file" combined with opening it, rather than being an independent primitive
> you apply to an already opened file?  Just in case - "'cuz that's how we'd
> done it" does not make a good answer...
> 

That is not the case, see
https://lore.kernel.org/lkml/917bb071-8b1a-3ba4-dc16-f8d7b4cc849f@digikod.net/
