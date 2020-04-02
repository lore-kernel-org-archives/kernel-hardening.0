Return-Path: <SRS0=gSbi=5S=lists.openwall.com=kernel-hardening-return-18383-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D36D7C43331
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 14:17:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 31B46206E9
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 14:17:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 31B46206E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18383-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21902 invoked by uid 550); 2 Apr 2020 14:17:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21879 invoked from network); 2 Apr 2020 14:17:39 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,  Adam Zabrocki <pi3@pi3.com.pl>,  kernel list <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Oleg Nesterov <oleg@redhat.com>,  Andy Lutomirski <luto@amacapital.net>,  Bernd Edlinger <bernd.edlinger@hotmail.de>,  Kees Cook <keescook@chromium.org>,  Andrew Morton <akpm@linux-foundation.org>,  stable <stable@vger.kernel.org>
References: <20200324215049.GA3710@pi3.com.pl> <202003291528.730A329@keescook>
	<87zhbvlyq7.fsf_-_@x220.int.ebiederm.org>
	<CAG48ez1dCPw9Dep-+GWn=SnHv1nVv4Npv1FpFxmomk6tmazB-g@mail.gmail.com>
Date: Thu, 02 Apr 2020 09:14:38 -0500
In-Reply-To: <CAG48ez1dCPw9Dep-+GWn=SnHv1nVv4Npv1FpFxmomk6tmazB-g@mail.gmail.com>
	(Jann Horn's message of "Thu, 2 Apr 2020 06:46:49 +0200")
Message-ID: <87y2rekm9d.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jK0en-0002Mh-AX;;;mid=<87y2rekm9d.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19aHVbkFFXhJEzKOhX85KQe0ZY2f9JbahM=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH] signal: Extend exec_id to 64bits
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)

Jann Horn <jannh@google.com> writes:

> On Wed, Apr 1, 2020 at 10:50 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
>> Replace the 32bit exec_id with a 64bit exec_id to make it impossible
>> to wrap the exec_id counter.  With care an attacker can cause exec_id
>> wrap and send arbitrary signals to a newly exec'd parent.  This
>> bypasses the signal sending checks if the parent changes their
>> credentials during exec.
>>
>> The severity of this problem can been seen that in my limited testing
>> of a 32bit exec_id it can take as little as 19s to exec 65536 times.
>> Which means that it can take as little as 14 days to wrap a 32bit
>> exec_id.  Adam Zabrocki has succeeded wrapping the self_exe_id in 7
>> days.  Even my slower timing is in the uptime of a typical server.
>
> FYI, if you actually optimize this, it's more like 12s to exec 1048576
> times according to my test, which means ~14 hours for 2^32 executions
> (on a single core). That's on an i7-4790 (a Haswell desktop processor
> that was launched about six years ago, in 2014).

Half a day.  I am not at all surprised, but it is good to know it can
take so little time.

Eric
