Return-Path: <SRS0=mepS=5Z=lists.openwall.com=kernel-hardening-return-18478-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5003AC2BA2B
	for <kernel-hardening@archiver.kernel.org>; Thu,  9 Apr 2020 14:17:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A471520771
	for <kernel-hardening@archiver.kernel.org>; Thu,  9 Apr 2020 14:17:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A471520771
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18478-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23671 invoked by uid 550); 9 Apr 2020 14:17:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23637 invoked from network); 9 Apr 2020 14:17:02 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux API <linux-api@vger.kernel.org>,  Linux FS Devel <linux-fsdevel@vger.kernel.org>,  Linux Security Module <linux-security-module@vger.kernel.org>,  Akinobu Mita <akinobu.mita@gmail.com>,  Alexander Viro <viro@zeniv.linux.org.uk>,  Alexey Dobriyan <adobriyan@gmail.com>,  Andrew Morton <akpm@linux-foundation.org>,  Andy Lutomirski <luto@kernel.org>,  Daniel Micay <danielmicay@gmail.com>,  Djalal Harouni <tixxdz@gmail.com>,  "Dmitry V . Levin" <ldv@altlinux.org>,  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,  Ingo Molnar <mingo@kernel.org>,  "J . Bruce Fields" <bfields@fieldses.org>,  Jeff Layton <jlayton@poochiereds.net>,  Jonathan Corbet <corbet@lwn.net>,  Kees Cook <keescook@chromium.org>,  Linus Torvalds <torvalds@linux-foundation.org>,  Oleg Nesterov <oleg@redhat.com>,  David Howells <dhowells@redhat.com>
References: <20200409123752.1070597-1-gladkov.alexey@gmail.com>
	<87y2r4vmpo.fsf@x220.int.ebiederm.org>
	<20200409134236.mksvudaucp3jawf6@comp-core-i7-2640m-0182e6>
Date: Thu, 09 Apr 2020 09:13:55 -0500
In-Reply-To: <20200409134236.mksvudaucp3jawf6@comp-core-i7-2640m-0182e6>
	(Alexey Gladkov's message of "Thu, 9 Apr 2020 15:42:36 +0200")
Message-ID: <87r1wwvja4.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jMXz6-0008S7-HG;;;mid=<87r1wwvja4.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX194Q5MsMFzZbdx4uJwnCGkLXvKZWMd2p1E=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH RESEND v11 0/8] proc: modernize proc to support multiple private instances
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)

Alexey Gladkov <gladkov.alexey@gmail.com> writes:

> On Thu, Apr 09, 2020 at 07:59:47AM -0500, Eric W. Biederman wrote:
>> Alexey Gladkov <gladkov.alexey@gmail.com> writes:
>> 
>> > Preface:
>> > --------
>> > This is patchset v11 to modernize procfs and make it able to support multiple
>> > private instances per the same pid namespace.
>> >
>> > This patchset can be applied on top of:
>> >
>> > git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.git
>> > 4b871ce26ab2
>> 
>> 
>> 
>> Why the resend?
>> 
>> Nothing happens until the merge window closes with the release of -rc1
>> (almost certainly on this coming Sunday).  I goofed and did not act on
>> this faster, and so it is my fault this did not make it into linux-next
>> before the merge window.  But I am not going to rush this forward.
>> 
>> 
>> 
>> You also ignored my review and have not even descibed why it is safe
>> to change the type of a filesystem parameter.
>> 
>> -	fsparam_u32("hidepid",	Opt_hidepid),
>> +	fsparam_string("hidepid",	Opt_hidepid),
>> 
>> 
>> Especially in light of people using fsconfig(fd, FSCONFIG_SET_...);
>> 
>> All I need is someone to point out that fsparam_u32 does not use
>> FSCONFIG_SET_BINARY, but FSCONFIG_SET_STRING.
>
> I decided to resend again because I was not sure that the previous
> patchset was not lost. I also wanted to ask David to review and explain
> about the new API. I in any case did not ignore your question about
> changing the type of the parameter.
>
> I guess I was wrong when I sent the whole patchset again. Sorry.
>
>> My apologies for being grumpy but this feels like you are asking me to
>> go faster when it is totally inappropriate to do so, while busily
>> ignoring my feedback.
>> 
>> I think this should happen.  But I can't do anything until after -rc1.
>
> I think you misunderstood me. I didn't mean to rush you.

It looks like.  My apologies for the misunderstanding then.

Eric



