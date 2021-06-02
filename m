Return-Path: <SRS0=sYeh=K4=lists.openwall.com=kernel-hardening-return-21275-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96398C4708F
	for <kernel-hardening@archiver.kernel.org>; Wed,  2 Jun 2021 20:38:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9E7D361008
	for <kernel-hardening@archiver.kernel.org>; Wed,  2 Jun 2021 20:38:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E7D361008
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21275-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1057 invoked by uid 550); 2 Jun 2021 20:37:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1037 invoked from network); 2 Jun 2021 20:37:55 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: legion@kernel.org,  LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux Containers <containers@lists.linux-foundation.org>,  linux-mm@kvack.org,  Christian Brauner <christian.brauner@ubuntu.com>,  Jann Horn <jannh@google.com>,  Jens Axboe <axboe@kernel.dk>,  Kees Cook <keescook@chromium.org>,  Linus Torvalds <torvalds@linux-foundation.org>,  Oleg Nesterov <oleg@redhat.com>
References: <cover.1619094428.git.legion@kernel.org>
	<20210509181205.f0ce806919858efa0e0e0d20@linux-foundation.org>
Date: Wed, 02 Jun 2021 15:37:32 -0500
In-Reply-To: <20210509181205.f0ce806919858efa0e0e0d20@linux-foundation.org>
	(Andrew Morton's message of "Sun, 9 May 2021 18:12:05 -0700")
Message-ID: <87o8coq9yr.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1loXcR-00Efry-DT;;;mid=<87o8coq9yr.fsf@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX181tofntvStz1+pRqA2mAhl7FTynzngIXM=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v11 0/9] Count rlimits in each user namespace
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 22 Apr 2021 14:27:07 +0200 legion@kernel.org wrote:
>
>> These patches are for binding the rlimit counters to a user in user namespace.
>
> It's at v11 and no there has been no acking or reviewing activity?  Or
> have you not been tracking these?

Most of the reviews were noticing things that needed to be changed.

For the ack/review by tags I am the one reviewing it and merging the
change so I guess I didn't give Alex any Acked-by or Reviewed-by
tags.

Regardless the changes are sitting in linux-next now and seem to be
doing fine.

Eric
