Return-Path: <SRS0=p8kR=LB=lists.openwall.com=kernel-hardening-return-21289-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 731CDC47094
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Jun 2021 19:26:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3CB4060200
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Jun 2021 19:26:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3CB4060200
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21289-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16142 invoked by uid 550); 7 Jun 2021 19:26:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30250 invoked from network); 7 Jun 2021 18:26:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=+prxwIPLyH+3qfUxR26q6/ynXr5WzZBCORfLDri/oCA=;
        b=SjHRTXyAlplogG5SrJqfUYuwNMuf+r7f2igxHisESwyrmz+9AsIE8TuW0h0ZfIi5PA
         wzYNhfU6TFe/+MKE4xy+YFTAvSSeUaQt4QA4+fdMAvhSjWlUagxsuSS90sFcB4dDBrka
         ofXHKCfDLJyC6eHUqinIuMzTyzUB8wbjRNFZE4BdFK76WyYV2Yz72X7FBPGovILqVeiw
         flDzGAEDvOV3k2nShRAFHPHtp33QftM6w9NFXXWYpbbwRKrxtOUQJT1z2Eo5OJs3cga/
         2Ds46CbpJyjD9woGfnnmEaYXoRmagSjD1YOWKXzlgZHZFoQZQ7zv7xEsyJIFix1opJBE
         JdKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=+prxwIPLyH+3qfUxR26q6/ynXr5WzZBCORfLDri/oCA=;
        b=Nc6O14zxsWOoRercVVixPY9Noc1QOQTP+wUwTPa0jbuWlql+Y5fs2WUah4ZN9ZB/Wp
         dMa/kP98lMh6uNICdCNeJmCUZOWVsOMFXHL/vX5/dyP/hDw73wnYluV+2ezoI6Zx+25E
         LpTfZeYmH7aidgkGzfTEOvSN6IZPFKXB7utnYfTJXuGkaXsFaWYhwPjjpZN7S8yHk9GX
         NAF7hR2A6taOm8HRS3DV0ISOVfgZ1n1JtUGD3qhfsRse1dTZC8LiOKAPPA8m2wO9anF6
         9m+vP4mFoQeClS79akrf/9RC0CUlwbMQuE85Htz1fpRfaE1Pen5ymae/nAyKxXGXvR9I
         9BCw==
X-Gm-Message-State: AOAM531EYP/7yZJoBAklyDkWMNFAe5yufgR/9UfXb0gv14hjyUeojZt+
	Tkipv8DOkQlWuTYCheZEAqLqIYG1VZnr0Q==
X-Google-Smtp-Source: ABdhPJzD0DrRCiMj7ZmuFP2rBT5d2xzi46pGPp4NHRWQStyA/70o3PZ+/dPElOEhLdO60oWH4FBaBQ==
X-Received: by 2002:a17:902:c942:b029:10f:b651:4fa9 with SMTP id i2-20020a170902c942b029010fb6514fa9mr16424048pla.83.1623090389454;
        Mon, 07 Jun 2021 11:26:29 -0700 (PDT)
Subject: Re: KASAN: use-after-free Read in hci_chan_del
To: Greg KH <greg@kroah.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: syzbot <syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com>,
 davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
 linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
 marcel@holtmann.org, netdev@vger.kernel.org,
 syzkaller-bugs@googlegroups.com, kernel-hardening@lists.openwall.com
References: <000000000000adea7f05abeb19cf@google.com>
 <2fb47714-551c-f44b-efe2-c6708749d03f@gmail.com> <YL3zGGMRwmD7fNK+@zx2c4.com>
 <YL4BAKHPZqH6iPdP@kroah.com>
From: SyzScope <syzscope@gmail.com>
Message-ID: <dd3094fa-9cb8-91c2-7631-a69c34eac387@gmail.com>
Date: Mon, 7 Jun 2021 11:26:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YL4BAKHPZqH6iPdP@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US

Hi all,
We are really thankful for all the suggestions and concerns. We are 
definitely interested in continuing this line of research.

Just to clarify:  SyzScope is an ongoing research project that is 
currently under submission, which has an anonymity requirement. 
Therefore we chose to use a gmail address initially in the public 
channel. Since Greg asked, we did reveal our university affiliation and 
email address, as well as cross-referenced a private email (again using 
university address) to security@kernel.org. We are sorry for the chaos 
of using several different email addresses. In the future, we will try 
to use our university address directly (we checked with other 
researchers and it seems to be okay).

On 6/7/2021 4:20 AM, Greg KH wrote:
> On Mon, Jun 07, 2021 at 12:21:12PM +0200, Jason A. Donenfeld wrote:
>> Hi SyzScope,
>>
>> On Fri, May 28, 2021 at 02:12:01PM -0700, SyzScope wrote:
>>   
>>> The bug was reported by syzbot first in Aug 2020. Since it remains
>>> unpatched to this date, we have conducted some analysis to determine its
>>> security impact and root causes, which hopefully can help with the
>>> patching decisions.
>>> Specifically, we find that even though it is labeled as "UAF read" by
>>> syzbot, it can in fact lead to double free and control flow hijacking as
>>> well. Here is our analysis below (on this kernel version:
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/?id=af5043c89a8ef6b6949a245fff355a552eaed240)
>>>
>>> ----------------------------- Root cause analysis:
>>> --------------------------
>>> The use-after-free bug happened because the object has two different
>>> references. But when it was freed, only one reference was removed,
>>> allowing the other reference to be used incorrectly.
>>> [...]
>> Thank you very much for your detailed analysis. I think this is very
>> valuable work, and I appreciate you doing it. I wanted to jump in to
>> this thread here so as not to discourage you, following Greg's hasty
>> dismissal. The bad arguments made I've seen have been something like:
>>
>> - Who cares about the impact? Bugs are bugs and these should be fixed
>>    regardless. Severity ratings are a waste of time.
>> - Spend your time writing patches, not writing tools to discover
>>    security issues.
>> - This doesn't help my interns.
>> - "research project" scare quotes.
>>
>> I think this entire set of argumentation is entirely bogus, and I really
>> hope it doesn't dissuade you from continuing to conduct useful research
>> on the kernel.
> Ok, I'd like to apologize if that was the attitude that came across
> here, as I did not mean it that way.
>
> What I saw here was an anonymous email, saying "here is a whole bunch of
> information about a random syzbot report that means you should fix this
> sooner!"  When there's a dump this big of "information", but no patch,
> that's almost always a bad sign that the information really isn't all
> that good, otherwise the author would have just sent a patch to fix it.
>
> We are drowning in syzbot bugs at the moment, with almost no one helping
> to fix them.  So much so that the only people I know of working on this
> are the interns with with the LF has funded because no other company
> seems willing to help out with this task.
>
> That's not the syzbot author's fault, it's the fault of every other
> company that relies on Linux at the moment.  By not providing time for
> their engineers to fix these found bugs, and only add new features, it's
> not going to get any better.
>
> So this combined two things I'm really annoyed at, anonymous
> contributions combined with "why are you not fixing this" type of
> a report.  Neither of which were, in the end, actually helpful to us.
>
> I'm not asking for any help for my interns, nor am I telling anyone what
> to work on.  I am saying please don't annoy the maintainers who are
> currently overwhelmed at the moment with additional reports of this type
> when they obviously can not handle the ones that we have.
>
> Working with the syzbot people to provide a more indepth analysis of the
> problem is wonderful, and will go a long way toward helping being able
> to do semi-automatic fixing of problems like this, which would be
> wonderful.  But how were we supposed to know this anonymous gmail
> account, with a half-completed google pages web site was not just a
> troll trying to waste our time?
>
> What proof did we have that this really was a correct report if a real
> person didn't even provide their name to it?
>
> thanks,
>
> greg k-h
