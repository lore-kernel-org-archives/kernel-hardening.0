Return-Path: <SRS0=gpXx=5R=lists.openwall.com=kernel-hardening-return-18361-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C092DC43331
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 21:06:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 232B220772
	for <kernel-hardening@archiver.kernel.org>; Wed,  1 Apr 2020 21:06:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 232B220772
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18361-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18139 invoked by uid 550); 1 Apr 2020 21:06:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18119 invoked from network); 1 Apr 2020 21:06:15 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adam Zabrocki <pi3@pi3.com.pl>,  Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Jann Horn <jannh@google.com>,  Oleg Nesterov <oleg@redhat.com>,  Andy Lutomirski <luto@amacapital.net>,  Bernd Edlinger <bernd.edlinger@hotmail.de>,  Kees Cook <keescook@chromium.org>,  Andrew Morton <akpm@linux-foundation.org>,  stable <stable@vger.kernel.org>
References: <20200324215049.GA3710@pi3.com.pl> <202003291528.730A329@keescook>
	<87zhbvlyq7.fsf_-_@x220.int.ebiederm.org>
	<CAHk-=wihrtjjSsF6mGc7wjrtVQ-pha9ZAeo1rQAeuO1hr+i1qw@mail.gmail.com>
Date: Wed, 01 Apr 2020 16:03:20 -0500
In-Reply-To: <CAHk-=wihrtjjSsF6mGc7wjrtVQ-pha9ZAeo1rQAeuO1hr+i1qw@mail.gmail.com>
	(Linus Torvalds's message of "Wed, 1 Apr 2020 13:55:11 -0700")
Message-ID: <87sghmnckn.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jJkYk-0006fM-EY;;;mid=<87sghmnckn.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+c7hhxNri2jefkPydPIS+82k6pfB21yV8=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH] signal: Extend exec_id to 64bits
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, Apr 1, 2020 at 1:50 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> I have updated the update of exec_id on exec to use WRITE_ONCE
>> and the read of exec_id in do_notify_parent to use READ_ONCE
>> to make it clear that there is no locking between these two
>> locations.
>
> Ack, makes sense to me.
>
> Just put it in your branch, this doesn't look urgent, considering that
> it's something that has been around forever.

Done

Eric
