Return-Path: <SRS0=MZHi=HZ=lists.openwall.com=kernel-hardening-return-20811-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC4BEC433E0
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Feb 2021 05:31:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1667F64E4D
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Feb 2021 05:31:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1667F64E4D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20811-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14026 invoked by uid 550); 23 Feb 2021 05:31:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14004 invoked from network); 23 Feb 2021 05:31:02 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>,  LKML <linux-kernel@vger.kernel.org>,  io-uring <io-uring@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux Containers <containers@lists.linux-foundation.org>,  Linux-MM <linux-mm@kvack.org>,  Alexey Gladkov <legion@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Christian Brauner <christian.brauner@ubuntu.com>,  Jann Horn <jannh@google.com>,  Jens Axboe <axboe@kernel.dk>,  Kees Cook <keescook@chromium.org>,  Oleg Nesterov <oleg@redhat.com>
References: <cover.1613392826.git.gladkov.alexey@gmail.com>
	<CAHk-=wjsmAXyYZs+QQFQtY=w-pOOSWoi-ukvoBVVjBnb+v3q7A@mail.gmail.com>
Date: Mon, 22 Feb 2021 23:30:26 -0600
In-Reply-To: <CAHk-=wjsmAXyYZs+QQFQtY=w-pOOSWoi-ukvoBVVjBnb+v3q7A@mail.gmail.com>
	(Linus Torvalds's message of "Sun, 21 Feb 2021 14:20:00 -0800")
Message-ID: <m1im6jl5al.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lEQHU-0002ip-7f;;;mid=<m1im6jl5al.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/DYsNs7fzMb4RYxpfKS0P+rI9c6VJVdTw=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v6 0/7] Count rlimits in each user namespace
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, Feb 15, 2021 at 4:42 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
>>
>> These patches are for binding the rlimit counters to a user in user namespace.
>
> So this is now version 6, but I think the kernel test robot keeps
> complaining about them causing KASAN issues.
>
> The complaints seem to change, so I'm hoping they get fixed, but it
> does seem like every version there's a new one. Hmm?

I have been keeping an eye on this as well, and yes the issues are
getting fixed.

My current plan is to aim at getting v7 rebased onto -rc1 into a branch.
Review the changes very closely.  Get some performance testing and some
other testing against it.  Then to get this code into linux-next.

If everything goes smoothly I will send you a pull request next merge
window.  I have no intention of shipping this (or sending you a pull
request) before it is ready.

Eric
