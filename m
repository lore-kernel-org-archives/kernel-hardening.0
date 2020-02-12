Return-Path: <SRS0=Wrxl=4A=lists.openwall.com=kernel-hardening-return-17808-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4653C352A4
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Feb 2020 21:48:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 07E10206DB
	for <kernel-hardening@archiver.kernel.org>; Wed, 12 Feb 2020 21:48:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 07E10206DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17808-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9824 invoked by uid 550); 12 Feb 2020 21:48:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9784 invoked from network); 12 Feb 2020 21:48:43 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,  LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux API <linux-api@vger.kernel.org>,  Linux FS Devel <linux-fsdevel@vger.kernel.org>,  Linux Security Module <linux-security-module@vger.kernel.org>,  Akinobu Mita <akinobu.mita@gmail.com>,  Alexey Dobriyan <adobriyan@gmail.com>,  Andrew Morton <akpm@linux-foundation.org>,  Andy Lutomirski <luto@kernel.org>,  Daniel Micay <danielmicay@gmail.com>,  Djalal Harouni <tixxdz@gmail.com>,  "Dmitry V . Levin" <ldv@altlinux.org>,  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,  Ingo Molnar <mingo@kernel.org>,  "J . Bruce Fields" <bfields@fieldses.org>,  Jeff Layton <jlayton@poochiereds.net>,  Jonathan Corbet <corbet@lwn.net>,  Kees Cook <keescook@chromium.org>,  Oleg Nesterov <oleg@redhat.com>,  Solar Designer <solar@openwall.com>
References: <20200210150519.538333-8-gladkov.alexey@gmail.com>
	<87v9odlxbr.fsf@x220.int.ebiederm.org>
	<20200212144921.sykucj4mekcziicz@comp-core-i7-2640m-0182e6>
	<87tv3vkg1a.fsf@x220.int.ebiederm.org>
	<CAHk-=wg52stFtUxMOxs3afkwDWmWn1JXC7RJ7dPsTrJbnxpZVg@mail.gmail.com>
	<87v9obipk9.fsf@x220.int.ebiederm.org>
	<CAHk-=wgwmu4jpmOqW0+Lz0dcem1Fub=ThLHvmLobf_WqCq7bwg@mail.gmail.com>
	<20200212200335.GO23230@ZenIV.linux.org.uk>
	<CAHk-=wi+1CPShMFvJNPfnrJ8DD8uVKUOQ5TQzQUNGLUkeoahkg@mail.gmail.com>
	<20200212203833.GQ23230@ZenIV.linux.org.uk>
	<20200212204124.GR23230@ZenIV.linux.org.uk>
	<CAHk-=wi5FOGV_3tALK3n6E2fK3Oa_yCYkYQtCSaXLSEm2DUCKg@mail.gmail.com>
Date: Wed, 12 Feb 2020 15:46:29 -0600
In-Reply-To: <CAHk-=wi5FOGV_3tALK3n6E2fK3Oa_yCYkYQtCSaXLSEm2DUCKg@mail.gmail.com>
	(Linus Torvalds's message of "Wed, 12 Feb 2020 13:02:40 -0800")
Message-ID: <87lfp7h422.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j1zrr-0007IE-Re;;;mid=<87lfp7h422.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19ygjuB60Kb6N9Sok9ZifBaf15XLQkzcfs=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v8 07/11] proc: flush task dcache entries from all procfs instances
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, Feb 12, 2020 at 12:41 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>>
>> On Wed, Feb 12, 2020 at 08:38:33PM +0000, Al Viro wrote:
>> >
>> > Wait, I thought the whole point of that had been to allow multiple
>> > procfs instances for the same userns?  Confused...
>>
>> s/userns/pidns/, sorry
>
> Right, but we still hold the ref to it here...
>
> [ Looks more ]
>
> Oooh. No we don't. Exactly because we don't hold the lock, only the
> rcu lifetime, the ref can go away from under us. I see what your
> concern is.
>
> Ouch, this is more painful than I expected - the code flow looked so
> simple. I really wanted to avoid a new lock during process shutdown,
> because that has always been somewhat painful.

The good news is proc_flush_task isn't exactly called from process exit.
proc_flush_task is called during zombie clean up. AKA release_task.

So proc_flush_task isn't called with any locks held, and it is
called in a context where it can sleep.

Further after proc_flush_task does it's thing the code goes
and does "write_lock_irq(&task_list_lock);"

So the code is definitely serialized to one processor already.

What would be downside of having a mutex for a list of proc superblocks?
A mutex that is taken for both reading and writing the list.

Eric
