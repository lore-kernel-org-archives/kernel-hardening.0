Return-Path: <SRS0=QDS4=M2=lists.openwall.com=kernel-hardening-return-21341-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE3CDC4338F
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Aug 2021 06:01:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 960BC60524
	for <kernel-hardening@archiver.kernel.org>; Tue,  3 Aug 2021 06:01:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 960BC60524
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=JohnEricson.me
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 13375 invoked by uid 550); 3 Aug 2021 06:01:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13343 invoked from network); 3 Aug 2021 06:01:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=johnericson.me;
	 h=from:subject:to:cc:references:message-id:date:mime-version
	:in-reply-to:content-type:content-transfer-encoding; s=fm1; bh=1
	t6DwB38Ya6t7Tu/rVm9U8PBSU3BOMT1sByp+5Idu5I=; b=J+HlGiCYm0yMRxz7e
	vpYUQmVQ047hXM//JDP+47cq1vopYq99mq4xn0vzIIcOPjJ9XT5mvnQZbhHIfXYO
	QoHKnY1ARruZ7kkgYGLbk4cEPYTs54RJLLi7Ok/WsLgG65eoM3SKUgADuJ/ZB1x6
	QhwLlL5a8g+dhh3n6JWgj6xUE7/pg8Q163ObAZ3BwwVoV8okpi9VAmcsbtLf8NKq
	07Tyn/E8bqg6dn+sebouIU9ooBlNBbB5HtTwb+EAPPkbIOEtghTADbTn9Z678fNk
	1lYPQdSPE5NDqkzXAKf4gsfKEchg70TfvO/m/sYIJoACeTDrnC7Lm9Qb9zECWDpg
	ajjxg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:content-type
	:date:from:in-reply-to:message-id:mime-version:references
	:subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; bh=1t6DwB38Ya6t7Tu/rVm9U8PBSU3BOMT1sByp+5Idu
	5I=; b=QPMN3YMOT9ijdsl5WznkgQ//2o/aibY1ZiVaNMsxDheJZUu0mDvCteSAl
	9bRpVk8UFe3L1HtrdW9H+wVH2qe9s4wvx56b6q5mFbe6+SeXnlkWY0xAqxVkgwb1
	70/oGtXTw8xRU90e3Z9+wPSiunHJ0j3BKpiimtEU2wO+ayvHaMYMJOWb96Iwnc8/
	oZ9pFiUEAM4VzUJrJ2XSBN82gHAmyj3qHhNYqWMcXfFB/tyuENDIybwfIz6olMoK
	uPulHqINWNYMtQVxcc7zOLXum6xrDwQj3/MxFOsp3qmm1x1iaF2QZFZRlBDa+J8s
	qHxwqwRUgvjCZJ+BIXsfPv+N8Gdjg==
X-ME-Sender: <xms:m9sIYfOCiMSR7BjqQnqF3e-CXwuuHGkGb5-2qWgrJNfVd04aCBvMpQ>
    <xme:m9sIYZ8vwA2Fq2KygbNUjFcM0yx_VItZcjpyRcxClfZMOEPM8MHtOqWytVtg60lVr
    CsuzhBCG9saLBt2-nU>
X-ME-Received: <xmr:m9sIYeR4kUXZla-H0LMJPCWOFpLp7Uoq7UFv0iAarfzB0YKRFgcDfzgFe1pCr3ZHwNgZGh3C6fZd3kFHIKM24CBTM4iluR991rHY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrieefgdelvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhuffvfhfkffgfgggjtgfgsehtjeertddtfeehnecuhfhrohhmpeflohhhnhcu
    vehothhtohhnucfgrhhitghsohhnuceomhgrihhlseflohhhnhfgrhhitghsohhnrdhmvg
    eqnecuggftrfgrthhtvghrnhepteelveettdeuhfeuhfffkeevieejfffgvdffhfefvdeg
    vefgfffgfffggfevffeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepmhgrihhlseflohhhnhfgrhhitghsohhnrdhmvg
X-ME-Proxy: <xmx:m9sIYTu9oMAdw4RG7RzZX1avsJSgwzVkIN-666OEOAPsK52YQJ_Uww>
    <xmx:m9sIYXdYG0cdT5I54Na_wqI3ad9blPLQWVXe7mQinsEy5Olb7Zg0-w>
    <xmx:m9sIYf0wuhhTkiON84wi8XN2oVNUoe_5IIhVnxm0NaoCXFv8EeFCtA>
    <xmx:nNsIYZvfoCTnHAgb3pt5RHcLJ39basyzFdYyrXnQfMw7-Ke7FvLb1Q>
From: John Cotton Ericson <mail@JohnEricson.me>
Subject: Re: Leveraging pidfs for process creation without fork
To: Christian Brauner <christian.brauner@ubuntu.com>,
 Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
 David Laight <David.Laight@aculab.com>, Andy Lutomirski <luto@kernel.org>,
 "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Jann Horn <jann@thejh.net>,
 Christian Brauner <christian.brauner@canonical.com>
References: <CAHmME9oHBtR4fBBUY8E_Oi7av-=OjOGkSNhQuMJMHhafCjazBw@mail.gmail.com>
 <CALCETrVGLx5yeHo7ExAmJZmPjVjcJiV7p1JOa4iUaW5DRoEvLQ@mail.gmail.com>
 <cf07f0732eb94dbfa67c9d56ceba738e@AcuMS.aculab.com>
 <f8457e20-c3cc-6e56-96a4-3090d7da0cb6@JohnEricson.me>
 <20210729142415.qovpzky537zkg3dp@wittgenstein>
 <YQNYs+BKenJHBMSP@zeniv-ca.linux.org.uk>
 <1468d75c-57ae-42aa-85ce-2bee8d403763@www.fastmail.com>
 <YQXRyMUGS5cDSbzu@zeniv-ca.linux.org.uk>
 <20210802121935.dkiw627twcrxbh54@wittgenstein>
Message-ID: <01e72780-e328-23b5-c114-9c35125da7c6@JohnEricson.me>
Date: Tue, 3 Aug 2021 02:00:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210802121935.dkiw627twcrxbh54@wittgenstein>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On Mon, Aug 2, 2021, at 8:19 AM, Christian Brauner wrote:
> On Sat, Jul 31, 2021 at 10:42:16PM +0000, Al Viro wrote:
> > 
> > It's more on the exit/exec/coredump side, actually.  For
> > exit we want to be sure that no new live threads will appear in a
> > group once the last live thread has entered do_exit().  For
> > exec (de_thread(), for starters) you want to have all threads
> > except for the one that does execve() to be killed and your
> > thread to take over as group leader.  Look for the machinery there
> > and in do_exit()/release_task() involved into that.  For coredump
> > you want all threads except for dumper to be brought into do_exit()
> > and stopped there, for dumping one to be able to access their state.
> > 
> > Then there's fun with ->sighand treatment - the whole thing
> > critically relies upon ->sighand being shared for the entire thread
> > group; look at the ->sighand->siglock uses.
> > 
> > The whole area is full of rather subtle places.  Again, the
> > real headache comes from the exit and execve.  Embryonic threads are
> > passive; it's the ones already running that can (and do) cause PITA.

I took a look at de_thread and begin_new_exec. It does seems whatever 
trouble there is stems from a bit of mixing concerns as I thought.

Most of begin_new_exec seems about wiping clean the current process's 
state, including the de_thread, unsharing various things. But then 
operations like that first bprm_creds_from_file call (of perhaps more 
recent vintage [1]) is about initializing new state from binprm argument.

It is interesting to me to note that some of the "unsharing" happens at 
clone time (the namespaces), and some happens (also) at exec time (file 
table, signal handlers). This to me is more good concrete evidence fork 
+ exec is awkward and strews concerns.

There perhaps will be some subtleties about in which order state can be 
set up on the embryonic process, but I don't think any de_thread will be 
needed because there will never be threads from a "previous" state lying 
around. Indeed there is no "previous" anything, just the current 
everything-inert embryonic process.

I would propose trying to rip up begin_new_exec so the unsharing, 
de_thread-ing etc. is just done in the traditional exec path, and just 
the bprm bits with a non-current fresh embryonic task_sched are done in 
the new one.

[1]: 56305aa9b6fab91a5555a45796b79c1b0a6353d1

 > Iiuc, you're talking about adding a thread into a thread-group tg1 from
 > a thread in another thread-group tg2. I don't think that's a very
 > pressing use-case and I agree that that sounds rather nasty right now.
 > Unless I'm missing something, a simple api to create something like a
 > processes configuration context doesn't require this.

Agreed.

I did mention embryonic processes with multiple threads, but was just a 
shower thought and not something I really care about. Also, since that 
would entail adding a thread to an inert thread group the creator has 
full powers over (it's "on the operating table") I don't think it would 
be so bad.

(To keep this new servery metaphor going, exec would be self-surgery, 
and adding a thread to *live* thread group would be surgery without 
anesthesia.)

 > a processes configuration context

This phrase stuck to me, Christian. Not to rush you on your concrete 
proposal, but sounds like you are envisioning building up a separate 
struct with instructions on how to produce a process, rather than 
mutating unscheduled but otherwise genuine `task_struct`s?

 > > What do you want that for, BTW?

Those security + ergonomic things I mentioned in my original email are 
the main goal.

I have a personal *long*-term goal to see something like CloudABI 
resurrected. I think it got most of the interfaces right, but not 
process management, and now that there are pidfds, we have a chance to 
better.

I'm in no rush, so happy to just see very linux-specific interfaces 
evolve in a good direction for now. Writing a personality or some other 
shim is not the interesting part, to say the least, so I'm happy to wait 
ages before doing that while the internals marinate.

John
