Return-Path: <SRS0=xBBS=5S=lists.openwall.com=kernel-hardening-return-18381-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8434C43331
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 13:14:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2F63220719
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 13:14:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2F63220719
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18381-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27877 invoked by uid 550); 2 Apr 2020 13:14:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27854 invoked from network); 2 Apr 2020 13:14:39 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jann Horn <jannh@google.com>,  Alan Stern <stern@rowland.harvard.edu>,  Andrea Parri <parri.andrea@gmail.com>,  Will Deacon <will@kernel.org>,  Peter Zijlstra <peterz@infradead.org>,  Boqun Feng <boqun.feng@gmail.com>,  Nicholas Piggin <npiggin@gmail.com>,  David Howells <dhowells@redhat.com>,  Jade Alglave <j.alglave@ucl.ac.uk>,  Luc Maranget <luc.maranget@inria.fr>,  "Paul E. McKenney" <paulmck@kernel.org>,  Akira Yokosawa <akiyks@gmail.com>,  Daniel Lustig <dlustig@nvidia.com>,  Adam Zabrocki <pi3@pi3.com.pl>,  kernel list <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Oleg Nesterov <oleg@redhat.com>,  Andy Lutomirski <luto@amacapital.net>,  Bernd Edlinger <bernd.edlinger@hotmail.de>,  Kees Cook <keescook@chromium.org>,  Andrew Morton <akpm@linux-foundation.org>,  stable <stable@vger.kernel.org>,  Marco Elver <elver@google.com>,  Dmitry Vyukov <dvyukov@google.com>,  kasan-dev <kasan-dev@googlegroups.com>
References: <20200324215049.GA3710@pi3.com.pl> <202003291528.730A329@keescook>
	<87zhbvlyq7.fsf_-_@x220.int.ebiederm.org>
	<CAG48ez3nYr7dj340Rk5-QbzhsFq0JTKPf2MvVJ1-oi1Zug1ftQ@mail.gmail.com>
	<CAHk-=wjz0LEi68oGJSQzZ--3JTFF+dX2yDaXDRKUpYxtBB=Zfw@mail.gmail.com>
	<CAHk-=wgM3qZeChs_1yFt8p8ye1pOaM_cX57BZ_0+qdEPcAiaCQ@mail.gmail.com>
	<CAG48ez1f82re_V=DzQuRHpy7wOWs1iixrah4GYYxngF1v-moZw@mail.gmail.com>
	<CAHk-=whks0iE1f=Ka0_vo2PYg774P7FA8Y30YrOdUBGRH-ch9A@mail.gmail.com>
Date: Thu, 02 Apr 2020 08:11:31 -0500
In-Reply-To: <CAHk-=whks0iE1f=Ka0_vo2PYg774P7FA8Y30YrOdUBGRH-ch9A@mail.gmail.com>
	(Linus Torvalds's message of "Wed, 1 Apr 2020 19:05:59 -0700")
Message-ID: <877dyym3r0.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jJzfj-00021V-6R;;;mid=<877dyym3r0.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/aAgD/0VF7hya1cN9dZdOTpz/w8uomdK0=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH] signal: Extend exec_id to 64bits
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)

Linus Torvalds <torvalds@linux-foundation.org> writes:

> tasklist_lock is aboue the hottest lock there is in all of the kernel.

Do you know code paths you see tasklist_lock being hot?

I am looking at some of the exec/signal/ptrace code paths because they
get subtle corner case wrong like a threaded exec deadlocking when
straced.

If the performance problems are in the same neighbourhood I might be
able to fix those problems while I am in the code.

Eric



