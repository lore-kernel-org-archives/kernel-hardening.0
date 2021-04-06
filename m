Return-Path: <SRS0=9mUs=JD=lists.openwall.com=kernel-hardening-return-21147-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95D04C433ED
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Apr 2021 15:45:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8D147613B8
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Apr 2021 15:45:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D147613B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21147-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20281 invoked by uid 550); 6 Apr 2021 15:44:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20260 invoked from network); 6 Apr 2021 15:44:59 -0000
Date: Tue, 6 Apr 2021 17:44:44 +0200
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux Containers <containers@lists.linux-foundation.org>,
	linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
	Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v9 4/8] Reimplement RLIMIT_NPROC on top of ucounts
Message-ID: <20210406154444.icpvezlq3izzxf5t@example.org>
References: <cover.1616533074.git.gladkov.alexey@gmail.com>
 <8f0c2888b4e92d51239e154b82d75972e7e39833.1616533074.git.gladkov.alexey@gmail.com>
 <m1y2dwllfg.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y2dwllfg.fsf@fess.ebiederm.org>

On Mon, Apr 05, 2021 at 11:56:35AM -0500, Eric W. Biederman wrote:
>
> Also when setting ns->ucount_max[] in create_user_ns because one value
> is signed and the other is unsigned.  Care should be taken so that
> rlimit_infinity is translated into the largest positive value the
> type can hold.

You mean like that ?

ns->ucount_max[UCOUNT_RLIMIT_NPROC] = rlimit(RLIMIT_NPROC) <= LONG_MAX ?
	rlimit(RLIMIT_NPROC) : LONG_MAX;
ns->ucount_max[UCOUNT_RLIMIT_MSGQUEUE] = rlimit(RLIMIT_MSGQUEUE) <= LONG_MAX ?
	rlimit(RLIMIT_MSGQUEUE) : LONG_MAX;
ns->ucount_max[UCOUNT_RLIMIT_SIGPENDING] = rlimit(RLIMIT_SIGPENDING) <= LONG_MAX ?
	rlimit(RLIMIT_SIGPENDING) : LONG_MAX;
ns->ucount_max[UCOUNT_RLIMIT_MEMLOCK] = rlimit(RLIMIT_MEMLOCK) <= LONG_MAX ?
	rlimit(RLIMIT_MEMLOCK) : LONG_MAX;

-- 
Rgrds, legion

