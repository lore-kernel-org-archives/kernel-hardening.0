Return-Path: <SRS0=vuQn=NP=lists.openwall.com=kernel-hardening-return-21350-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB23DC4338F
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Aug 2021 03:25:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 05B8C611F0
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Aug 2021 03:25:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 05B8C611F0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 23732 invoked by uid 550); 24 Aug 2021 03:25:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23709 invoked from network); 24 Aug 2021 03:25:34 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Ma\, XinjianX" <xinjianx.ma@intel.com>
Cc: Alexey Gladkov <legion@kernel.org>,  "linux-kselftest\@vger.kernel.org" <linux-kselftest@vger.kernel.org>,  lkp <lkp@intel.com>,  "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,  "axboe\@kernel.dk" <axboe@kernel.dk>,  "christian.brauner\@ubuntu.com" <christian.brauner@ubuntu.com>,  "containers\@lists.linux-foundation.org" <containers@lists.linux-foundation.org>,  "jannh\@google.com" <jannh@google.com>,  "keescook\@chromium.org" <keescook@chromium.org>,  "kernel-hardening\@lists.openwall.com" <kernel-hardening@lists.openwall.com>,  "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,  "linux-mm\@kvack.org" <linux-mm@kvack.org>,  "oleg\@redhat.com" <oleg@redhat.com>,  "torvalds\@linux-foundation.org" <torvalds@linux-foundation.org>
In-Reply-To: <06bb27f1d79243febf9ddc4633c4e084@intel.com> (XinjianX Ma's
	message of "Tue, 24 Aug 2021 01:19:52 +0000")
References: <d650b7794e264d5f8aa107644cc9784f@intel.com>
	<87a6lgysxp.fsf@disp2133>
	<20210818131117.x7omzb2wkjq7le3s@example.org>
	<87o89ttqql.fsf@disp2133>
	<20210819172618.qwrrw4m7wt33wfmz@example.org>
	<87eeajswfc.fsf_-_@disp2133>
	<06bb27f1d79243febf9ddc4633c4e084@intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date: Mon, 23 Aug 2021 22:24:17 -0500
Message-ID: <87lf4rplsu.fsf@disp2133>
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mIN3h-008tKu-MV;;;mid=<87lf4rplsu.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1++AiEZW5KIHsfe2U3AKqShPsf05OHNwZw=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH] ucounts: Fix regression preventing increasing of rlimits in init_user_ns
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)

"Ma, XinjianX" <xinjianx.ma@intel.com> writes:

>> -----Original Message-----
>> From: Eric W. Biederman <ebiederm@xmission.com>
>> ...
>> Reported-by: kernel test robot lkp@intel.com
> Sorry, but <> around email address is needed 
> Reported-by: kernel test robot <lkp@intel.com>

The change is already tested and pushed out so I really don't want to
mess with it.  Especially as I am aiming to send it to Linus on
Wednesday after it has had a chance to pass through linux-next and
whatever automated tests are there.

What does copying and pasting the Reported-by: tag as included in
your original report cause to break?

At this point I suspect that the danger of fat fingering something
far outweighs whatever benefits might be gained by surrounding the
email address with <> marks.

Eric
