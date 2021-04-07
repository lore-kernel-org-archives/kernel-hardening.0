Return-Path: <SRS0=pAga=JE=lists.openwall.com=kernel-hardening-return-21172-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E22B4C433ED
	for <kernel-hardening@archiver.kernel.org>; Wed,  7 Apr 2021 17:52:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 32CA06124C
	for <kernel-hardening@archiver.kernel.org>; Wed,  7 Apr 2021 17:52:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32CA06124C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21172-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1095 invoked by uid 550); 7 Apr 2021 17:52:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1054 invoked from network); 7 Apr 2021 17:52:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1617817925;
	bh=JNUl256bZO4yI7cE8PAyUgBJtI44T1AdfYI6Z98gSBk=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T9ML85GI1L7YQC4VHKeio4GRF1R5R3YV1s7o70CcBv7VJBw5zG9M/BqACTJTG+GOi
	 j5YPXvhwLvDYNvNYY9HFuwG7g9Q0utNtAWrDzBagxtuYgK0ioJRGJErA+u4pJV/cuO
	 gqCNTsLpFVE1buhO4BCb3FMcQKyLH5OHicGySRKc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Wed, 7 Apr 2021 19:51:51 +0200
From: John Wood <john.wood@gmx.com>
To: Valdis =?utf-8?Q?Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>
Cc: John Wood <john.wood@gmx.com>, kernelnewbies@kernelnewbies.org,
	Andi Kleen <ak@linux.intel.com>, Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com
Subject: Re: Notify special task kill using wait* functions
Message-ID: <20210407175151.GA3301@ubuntu>
References: <20210330173459.GA3163@ubuntu>
 <79804.1617129638@turing-police>
 <20210402124932.GA3012@ubuntu>
 <106842.1617421818@turing-police>
 <20210403070226.GA3002@ubuntu>
 <145687.1617485641@turing-police>
 <20210404094837.GA3263@ubuntu>
 <193167.1617570625@turing-police>
 <20210405073147.GA3053@ubuntu>
 <115437.1617753336@turing-police>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <115437.1617753336@turing-police>
X-Provags-ID: V03:K1:v/VcOJD8giTK4SOOYiv4l2zyGZek/KIHV5GZkQB83vj/gzCEt1O
 MUY2HmTvoThU5KnqI5IaSCHXpDE/xhfeHVs8GieoOMuN4XjCCHX71L+6WphKJY2jRVSmEOy
 1HRADOEIzN+tEcXUfKIJw0xfBNM2q4IuYUvyxNNdkCga+vgik9aN3UjZ7RBxVOJZTHF9BlY
 UMLnlSXqoga78B9jt6i4A==
X-UI-Out-Filterresults: notjunk:1;V03:K0:jgSvonDoLS4=:digItYxn1ixNM8nDlPzSEy
 t1dY0XAJJxEGJlozooo/s5KNem+w/V/UnKub18BFlgmmZgKtQBLvwGZB3G+nb5I1OGc3NZ1W7
 7z4pq+z7BO8nam0dU42PqfXGkcbFy83lY61KR+RPGPZJTHaVcrrSr/nJPZ15bvEVb4PFxoE/i
 MVDsDGJ5I45UMMWyH3PvYYcmG4uG3y5f5jDZYvRNoFOU6CqECrYySCx3sNHg2VGFQZyQ+PjRn
 ff2st6xGBd/ilJ6mKXy3rxM6N3v7oewA/RWJZyM8OCSG660AG/c1UGegy96nA7uT8pdJmQoCp
 foY8P9t7TyGkYNqlPeSg8Wlyu7WkTpV5qIU/s+Sw1ZpELCKvtJKXMWV5iviMacq/HgMJYCXrA
 hgTMWmrpw65J82o5esN1m3q7JdOVG32EixaE7pHDm9Ty2sxj8uo07cLB+EoEfpbeY/ttXtNou
 mr8YydnylYpgvE+pWjJQTcjP98GnV/FDogBCvJN+iQu/WyyZT3xuJqUPC5kHs3dtvokZXEkmG
 ISfjjrIRDedFLcSvb9L12I1tscixzL+osGjjW1hkrthurFQJL+Koq1Mw07cFREM/zYUYSDVDc
 0lk1ValQKs95wPICJvwrNv6KYRJMWvVdErp6BkhlE3wgUY0nl3UnXmMImVF9Y1vEf4TU4rEZa
 00L3PZSM6X102p70Aj0H81Hm6OTia1MNniImtc0bBJa+bRRiWYlFHk843BTluOMve6TyaHwkw
 ehHw3a7GQj7sNwFaOq/BQ4NOL7+doTqk+OSmxpG5TLibirPOBsgt02+HewCjHiHzgRb66nJFn
 iQrTOBdWazWp5WYE5Pfs4lfiWw0u1rqxkQpWIc7puk/EHsWRAsvfaMNZ5j+PnICmJeunLcVFl
 5MoTD+oZxEu4QLcCc1WeB+FRkxb42G56OH/aG2z8uJzaQA3HKOAzNipJtsKNoZmcqFYlSJzuk
 dZBruLT8TlWx7KNZN5mRg6afwI8zksDc2dZHptMdWceHCtC2vngSGSeZ1pD1EKgGlAEIQy5Bp
 gL1G/8v+nk/A7PNnlmJi+W2clyi0gajLk6PPCq/IPwh3Er8J6oVS1sUGIesJ6i93M2l23r7Ce
 5CWjcfVo7GycdB0yj2wvOiBBTGTTqkwSEvTUGQ4L/jXOylRl+7yuVsWGPEKU4XdaCGIQI8BEy
 G6+CRrsW0wgYK26KHeWlig6DcBP+RFFS6xse0TV4Q9iS1DP2f+J5XBfzmEOsfPZnIoz8E=

Hi Valdis,

On Tue, Apr 06, 2021 at 07:55:36PM -0400, Valdis Kl=C4=93tnieks wrote:
> On Mon, 05 Apr 2021 09:31:47 +0200, John Wood said:
>
> > > And how does the kernel know that it's notifying a "real" supervisor=
 process,
> > > and not a process started by the bad guy, who can receive the notifi=
cation
> > > and decide to respawn?
> > >
> > Well, I think this is not possible to know. Anyway, I believe that the=
 "bad
> > guy" not rely on the wait* notification to decide to respawn or not. H=
e
> > will do the attack without waiting any notification.
>
> You believe wrong. After my 4 decades of interacting with the computer s=
ecurity
> community, the only thing that remains a constant is that if you say "I =
believe
> that...", there will be *somebody* who will say "Challenge accepted" and=
 try to
> do the opposite just for the lulz. Then there will be a second guy sayin=
g "Hmm..
> I wonder how much I could sell a 0-day for..."

Ok, lesson learned. I agree.

> [Great explanation and information]

Wow, I'm impressed. Thank you very much for this great explanation and inf=
o.

Thanks a lot for do that (insist about this subject). During the discussio=
n [1]
you made me realize that I'm totally wrong (and you are totally right :) )=
.
The detection of brute force attacks that happen through the execve system
call can be easily bypassed -> Well, I bypass it during the tests using a
double exec. So, this part needs more work.

[1] https://lore.kernel.org/kernelnewbies/20210330173459.GA3163@ubuntu/

A first thought:

Scenario:
A process [p1] execs. The child [p2] execs again. The child [p3] crashes.

Problem:
The brute LSM kills p3 if it forks and crashes with a fast crash rate (for=
k
brute force attack). But the p2 process can start again the p3. Then brute
kills p2 (exec brute force attack). Now, if p1 starts p2 the attack can
follow without mitigation.

New proposal:
When brute detects a brute force attack through the fork system call
(killing p3) it will mark the binary file executed by p3 as "not allowed".
=46rom now on, any execve that try to run this binary will fail. This way =
it
is not necessary to notify nothing to userspace and also we avoid an exec
brute force attack due to the respawn of processes [2] by a supervisor
(abused or not by a bad guy).

[2] https://lore.kernel.org/kernel-hardening/878s78dnrm.fsf@linux.intel.co=
m/

This would imply remove the update (walking up in the processes tree) of
the exec stats and add a list of not allowed binaries.

What do you think? Any ideas are welcome. I'm open minded :)

Regards,
John Wood
