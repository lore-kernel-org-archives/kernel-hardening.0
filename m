Return-Path: <SRS0=P5kV=MU=lists.openwall.com=kernel-hardening-return-21334-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0FE0C432BE
	for <kernel-hardening@archiver.kernel.org>; Wed, 28 Jul 2021 17:08:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C8DC26103A
	for <kernel-hardening@archiver.kernel.org>; Wed, 28 Jul 2021 17:08:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C8DC26103A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=JohnEricson.me
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 30543 invoked by uid 550); 28 Jul 2021 17:08:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20411 invoked from network); 28 Jul 2021 16:38:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=johnericson.me;
	 h=from:subject:to:cc:references:message-id:date:mime-version
	:in-reply-to:content-type:content-transfer-encoding; s=fm3; bh=W
	eZ1VfTAR/GouUZZYyqzUoo9gOgKkWa6M2LiAzcfwNc=; b=IMjUtivKkvM+MsKuo
	mFKOu0SC8VryiwJqhXk+yJxAupVSrfyFdT4fXTV9dCOXDPGyUtzxF9FgPkfmA2TT
	6nFdXonEz1tsEyTC6nvdSEs+r/9GAiEWbk3MSfMrxWKuvJmGtH1CyqtP0fa3qKDS
	AiB31w9SUJ58dDdXPgvWkK20PJb6mGA+HRNaCP07WutLl4y+t7cb+63j1Y834ihd
	kkaAlaAEKNiobhllvmNru/RuFUbK6rztugQvmxRlIw7GBachdQoBCrlE3ewh7SrU
	i0mREBV0/8beq0xg2N4yVTNdIKA+4k60ajzaq/ZzBDPK+89VEhH70Xfaroskc5tc
	RsDFQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:from:in-reply-to:message-id:mime-version:references
	:subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; bh=WeZ1VfTAR/GouUZZYyqzUoo9gOgKkWa6M2LiAzcfw
	Nc=; b=uy/wcm573W94oCqnUsD5OZYrlzZXuprdgk+RdEHcCpWnybK+uX+Q0wwRT
	zkuG2UkTjk20tz6ZYcNPithkZvEaVDlMUY2jC+McIBQWwgG/5WRdXCTVyaz4isFN
	+u+a0oBiDYIK6jWDXY3ImkFrAJ6gxhWgr5hg8fRgwey7/4EZW669S84GMZA0kpVq
	qYL3pY2yHEVYuHNvDglHsCqE6OmTDciHtemJWWfOSUQo6YzJFL2e1i5+wPWpxkmZ
	X1ayJDmRaVz+XAEVNaDIz0krd9WslkzShKRYFALuemrL9FZNGTocsn3ICWPfAWql
	wu4z65UQ5WCdryjbiHRAiVkyLiJ0A==
X-ME-Sender: <xms:54cBYZM1Xc4Mjgrth6n0yfcnQ0GWcH9kvXdHL65tyd-G8G19u_cqgw>
    <xme:54cBYb_9S8HqjNRab7_he6f3qMasVhovZ_uIf2O2JcWkcUVDFY_zRxjN_uB5zC3Ia
    aEeZQmyJFI1ueLGaxY>
X-ME-Received: <xmr:54cBYYT8yBhYovCFTqcikeSMt9_vfcOZYFT3KMaT5CB5Ii4iS8rKqYKFDGItIL5eDnzM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrgeelgdekkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhuffvfhfkffgfgggjtgfgsehtjeertddtfeehnecuhfhrohhmpeflohhhnhcu
    vehothhtohhnucfgrhhitghsohhnuceomhgrihhlseflohhhnhfgrhhitghsohhnrdhmvg
    eqnecuggftrfgrthhtvghrnhepteelveettdeuhfeuhfffkeevieejfffgvdffhfefvdeg
    vefgfffgfffggfevffeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepmhgrihhlseflohhhnhfgrhhitghsohhnrdhmvg
X-ME-Proxy: <xmx:54cBYVuIBafFkXj2kXTmn2kVbL-AEVZ_PnBdSHBRd_IzJa8g0kreKQ>
    <xmx:54cBYReVBPC5BjCzg2GbAd3Sypx-exG5Le9ZfjpTAjy38Qp_ESujGw>
    <xmx:54cBYR3BADQRASnJa8suXcHEAnEiESr9nnEChuttp2Kc1OBpcJLtvQ>
    <xmx:6IcBYaF6WCzRnuzApfkOJERq8RLPP_KyaquB9sVvG9eZGQr-bIut5A_cGdY>
From: John Cotton Ericson <mail@JohnEricson.me>
Subject: Leveraging pidfs for process creation without fork
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Laight <David.Laight@ACULAB.COM>, Andy Lutomirski
 <luto@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Jann Horn <jann@thejh.net>,
 Christian Brauner <christian.brauner@canonical.com>
References: <CAHmME9oHBtR4fBBUY8E_Oi7av-=OjOGkSNhQuMJMHhafCjazBw@mail.gmail.com>
 <CALCETrVGLx5yeHo7ExAmJZmPjVjcJiV7p1JOa4iUaW5DRoEvLQ@mail.gmail.com>
 <cf07f0732eb94dbfa67c9d56ceba738e@AcuMS.aculab.com>
Message-ID: <f8457e20-c3cc-6e56-96a4-3090d7da0cb6@JohnEricson.me>
Date: Wed, 28 Jul 2021 12:37:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cf07f0732eb94dbfa67c9d56ceba738e@AcuMS.aculab.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

Hi,

I was excited to learn about about pidfds the other day, precisely in 
hopes that it would open the door to such a "sane process creation API". 
I searched the LKML, found this thread, and now hope to rekindle the 
discussion; my apologies if there has been more discussion since that I 
missed and I am making redundant noise.

----

On Tue, Feb 2, 2021, at 4:23 AM, David Laight wrote:
> From: Andy Lutomirski
> > Sent: 01 February 2021 18:30
> ...
> > 2. A sane process creation API.  It would be delightful to be able to
> > create a fully-specified process without forking.  This might end up
> > being a fairly complicated project, though -- there are a lot of
> > inherited process properties to be enumerated.
> 
> Since you are going to (eventually) load in a program image
> have to do several system calls to create the process isn't
> likely to be a problem.
> So using separate calls for each property isn't really an issue
> and solves the horrid problem of the API structure.

I definitely concur creating an embryonic process and then setting the 
properties sounds separately like the right approach. I'm no expert, but 
I gather from afar that between BPF and io_uring, plenty of people are 
investigating general methods of batched/pipelined communication with 
the kernel, and so there's little reason to go around making more ad-hoc 
mammoth syscalls for specific sets of tasks.

----

> So you could create an embryonic process that inherits a lot
> of stuff from the current process, the do actions that
> sort out the fds, argv, namespace etc.
> Finally running the new program.

All that sounds good, but I wonder if it would be possible to have a 
flag such that inheritance (where practical) would *not* be the default 
for new processes. I'm convinced that better security will always be an 
uphill battle until privileges/capabilities/resources are *not* shared 
by default. Only when more sharing requires monotonically more 
programmer effort will productivity/laziness align with the principle of 
least privilege.

With fork/exec, there's no good way to achieve this, I think it's safe 
to say. But with the embryonic processes method, where one has the 
ability to e.g. set/unset file descriptors on the embryo under 
construction, it seems quite natural.

This is one wrinkle of interface evolution --- as new sandboxing 
mechanisms / namespaces are created, we would either need to create 
yet-new "no really, default no-share" flags, or arguably be causing API 
breakage as previously "leaking" privileges are patched up. I am hopeful 
that either having versioned flags, or thoroughly documenting up-front 
that the exact behavior is subject to change as "leaks are plugged" is 
OK, but I recognize that the former might be too much complexity and the 
latter to weasel-wordy, and therefore the whole idea of "opt-in sharing 
only" will have to wait.

----

The security <-> ergonomics aspect is the main point of interest for me, 
but there a few random ideas:

1. I originally thought an fd to an embryonic process should in fact 
point to the task_struct rather than pid, since there is no risk of the 
data becoming useless asynchronously --- an embryonic process is never 
scheduled and cannot do anything like exiting on it's own. But there is 
no reason an embryonic process need start with just one thread, so 
allowing entire embryonic thread groups might actually be virtuous. I 
don't know for sure, but I figure in that case it is simpler to just 
stick with the pid indirection.

2. Embryonic processes can be "forked at rest" (i.e. just duplicated), 
which would allow a regime where they are used as templates for process 
creation, duplicated ("forked at rest"), and sent around for other tasks 
to spawn processes themselves. If my idea for "opt-in sharing only" 
fails per the above, sending around an "as isolated as possible" embryo 
template could be a decent fallback.

That's all I got. I hope continuing this design process is of interest 
to others.

Cheers,

John
