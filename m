Return-Path: <SRS0=tNjH=KS=lists.openwall.com=kernel-hardening-return-21272-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94441C4707A
	for <kernel-hardening@archiver.kernel.org>; Sun, 23 May 2021 14:43:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8DC8861139
	for <kernel-hardening@archiver.kernel.org>; Sun, 23 May 2021 14:43:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8DC8861139
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21272-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16200 invoked by uid 550); 23 May 2021 14:43:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16161 invoked from network); 23 May 2021 14:43:30 -0000
IronPort-SDR: o1aUBIfY9uQQ8xbspjn/LarhaV5gJCOsp7vfm5eISOgGRWkzVPz8LPQJZIMWZ040bXwCPWaDeq
 YGef9SIiToGw==
X-IronPort-AV: E=McAfee;i="6200,9189,9993"; a="222922196"
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="222922196"
IronPort-SDR: bfbTjY++YiuW1i/hCo9WvS45EoK6nkaGMtHPqopj5Sn8M4xVAdmJRzzA8WZN2lrgwLabxiTnlf
 q4zxKzbNOtFg==
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="613834401"
Subject: Re: [PATCH v7 0/7] Fork brute force attack mitigation
To: John Wood <john.wood@gmx.com>
Cc: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>,
 Jonathan Corbet <corbet@lwn.net>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
 valdis.kletnieks@vt.edu, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-hardening@vger.kernel.org,
 kernel-hardening@lists.openwall.com
References: <20210521172414.69456-1-john.wood@gmx.com>
 <19903478-52e0-3829-0515-3e17669108f7@linux.intel.com>
 <20210523073124.GA3762@ubuntu>
From: Andi Kleen <ak@linux.intel.com>
Message-ID: <3d4ddd55-4f42-3ef7-dd68-a9f2bc33ba4b@linux.intel.com>
Date: Sun, 23 May 2021 07:43:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210523073124.GA3762@ubuntu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US


On 5/23/2021 12:31 AM, John Wood wrote:
> Hi,
>
> On Fri, May 21, 2021 at 11:02:14AM -0700, Andi Kleen wrote:
>>> Moreover, I think this solves another problem pointed out by Andi Kleen
>>> during the v5 review [2] related to the possibility that a supervisor
>>> respawns processes killed by the Brute LSM. He suggested adding some way so
>>> a supervisor can know that a process has been killed by Brute and then
>>> decide to respawn or not. So, now, the supervisor can read the brute xattr
>>> of one executable and know if it is blocked by Brute and why (using the
>>> statistical data).
>> It looks better now, Thank.
>>
>> One potential problem is that the supervisor might see the executable
>> directly, but run it through some wrapper. In fact I suspect that will be
>> fairly common with complex daemons. So it couldn't directly look at the
>> xattr. Might be useful to also pass this information through the wait*
>> chain, so that the supervisor can directly collect it. That would need some
>> extension to these system calls.
>>
> Could something like this help? (not tested)

This works even when someone further down the chain died? Assuming it 
does, for SIGCHLD it seems reasonable.

I'm not fully sure how it will interact with cgroup release tracking 
though, that might need more research (my understanding is that modern 
supervisors often use cgroups)

-Andi


