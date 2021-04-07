Return-Path: <SRS0=OWHe=JE=lists.openwall.com=kernel-hardening-return-21161-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85279C433B4
	for <kernel-hardening@archiver.kernel.org>; Wed,  7 Apr 2021 16:57:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A94B8610E6
	for <kernel-hardening@archiver.kernel.org>; Wed,  7 Apr 2021 16:57:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A94B8610E6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21161-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11350 invoked by uid 550); 7 Apr 2021 16:56:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11324 invoked from network); 7 Apr 2021 16:56:55 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux Containers <containers@lists.linux-foundation.org>,  linux-mm@kvack.org,  Andrew Morton <akpm@linux-foundation.org>,  Christian Brauner <christian.brauner@ubuntu.com>,  Jann Horn <jannh@google.com>,  Jens Axboe <axboe@kernel.dk>,  Kees Cook <keescook@chromium.org>,  Linus Torvalds <torvalds@linux-foundation.org>,  Oleg Nesterov <oleg@redhat.com>
References: <cover.1616533074.git.gladkov.alexey@gmail.com>
	<8f0c2888b4e92d51239e154b82d75972e7e39833.1616533074.git.gladkov.alexey@gmail.com>
	<m1y2dwllfg.fsf@fess.ebiederm.org>
	<20210406154444.icpvezlq3izzxf5t@example.org>
Date: Wed, 07 Apr 2021 11:56:36 -0500
In-Reply-To: <20210406154444.icpvezlq3izzxf5t@example.org> (Alexey Gladkov's
	message of "Tue, 6 Apr 2021 17:44:44 +0200")
Message-ID: <m1eefmjanv.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lUBTs-0007Tf-91;;;mid=<m1eefmjanv.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18gGOagHueeOSvjjB9O1FjohVGYorUmAaY=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v9 4/8] Reimplement RLIMIT_NPROC on top of ucounts
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)

Alexey Gladkov <gladkov.alexey@gmail.com> writes:

> On Mon, Apr 05, 2021 at 11:56:35AM -0500, Eric W. Biederman wrote:
>>
>> Also when setting ns->ucount_max[] in create_user_ns because one value
>> is signed and the other is unsigned.  Care should be taken so that
>> rlimit_infinity is translated into the largest positive value the
>> type can hold.
>
> You mean like that ?
>
> ns->ucount_max[UCOUNT_RLIMIT_NPROC] = rlimit(RLIMIT_NPROC) <= LONG_MAX ?
> 	rlimit(RLIMIT_NPROC) : LONG_MAX;
> ns->ucount_max[UCOUNT_RLIMIT_MSGQUEUE] = rlimit(RLIMIT_MSGQUEUE) <= LONG_MAX ?
> 	rlimit(RLIMIT_MSGQUEUE) : LONG_MAX;
> ns->ucount_max[UCOUNT_RLIMIT_SIGPENDING] = rlimit(RLIMIT_SIGPENDING) <= LONG_MAX ?
> 	rlimit(RLIMIT_SIGPENDING) : LONG_MAX;
> ns->ucount_max[UCOUNT_RLIMIT_MEMLOCK] = rlimit(RLIMIT_MEMLOCK) <= LONG_MAX ?
> 	rlimit(RLIMIT_MEMLOCK) : LONG_MAX;

Yes.

I only got as far as:
if (rlimit(RLIMI_NNN) == RLIM_INFINITY) {
	ns->ucount_max[UCOUNT_LIMIT_NNN] = LONG_MAX;
} else {
	ns->ucount_max[UCOUNT_LMIT_NNN] = rlmit(RLIMIT_NNN);
}
But forcing everything about LONG_MAX to LONG_MAX actually looks better
in practice.  Especially as that is effectively RLIMIT_INFINITY anyway.

Eric
