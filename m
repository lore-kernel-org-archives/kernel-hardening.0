Return-Path: <SRS0=pw9c=MX=lists.openwall.com=kernel-hardening-return-21338-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F2DC4338F
	for <kernel-hardening@archiver.kernel.org>; Sat, 31 Jul 2021 22:11:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3199260EBC
	for <kernel-hardening@archiver.kernel.org>; Sat, 31 Jul 2021 22:11:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3199260EBC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=johnericson.me
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 32521 invoked by uid 550); 31 Jul 2021 22:11:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32481 invoked from network); 31 Jul 2021 22:11:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=johnericson.me;
	 h=mime-version:message-id:in-reply-to:references:date:from:to
	:cc:subject:content-type; s=fm1; bh=XC4nL5KQf9oBgzHqGFiPmKgib/D5
	J47Vg0BnLI9enIY=; b=bL5ExbfEWWsqoJ4XcjUD5FLVUNVKdOD//nkUMuLJAdk/
	7XMtKanesTRex1WPM12qElqehi9cB4bXz8ar1PgqPLMpge9BiG2xZlbmOorClzaU
	/3/KMYa+ZPzIjAt5aY0lDgip16rxJh+7QnvVKtxgu0dN6Pn/ik5xSE8BjL/+euHq
	IfcoucY8vq42cNtQyKBXCP6/XmNRmYNNks5ZUlYNJhvlXdh3V2hcPeLlrFP7np7o
	BhlmdchkFNAtSh1enXBFRGOzNTgYOZ3PApCw/Xg3eoEra6atk/ATLFiFdk7iXvO5
	dxwnBo8Y3PtkRLrhary0S1PHEUZRJVDa2IT3rZnEoA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=XC4nL5
	KQf9oBgzHqGFiPmKgib/D5J47Vg0BnLI9enIY=; b=ZpFBnchhxcYppH1ibhu2eI
	4uuMM2TZ2K8Li7ANanIM1juGtCKfZXdIzDcSlVrwZb+BI+mNHWnMfweDFI/P2k8f
	povw0hnM6AHAKWrCbaZC4+WJOt+NKfvAy6njL90Zl3WMyqDzN08d5j8gPx31fPmI
	qGJ24vRKlVR+fdxIIr1zYo1roWB3HLQjwmv78Q+E3Md+To3i7MVpQH9I0/i7zjxw
	uFAsw1krT8XKKXzP8GNG8Q071D3BXDByiu1WVy7DhTlSc74kc46y46vjfN4ul6wD
	WYe0BRY6AWYYJGeZOIZ35YFKEswjuHQtDrbv/EPLN50XtZP6XzV3A45j6zNHXrSA
	==
X-ME-Sender: <xms:i8oFYXmcmmquTueCmLV3iXevEIOjdemqKcH3dAPyYryzM8DGKfaG3g>
    <xme:i8oFYa1x68ESmT8hVMxXgSkf6f_OaHs2vBSkpykVQSTgUugcQdwnDqN_yy1HA51kX
    mMSJi5vGfH3YUxspVg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrheekgddtfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsegrtderreerredtnecuhfhrohhmpedflfhohhhn
    ucfgrhhitghsohhnfdcuoehmrghilhesjhhohhhnvghrihgtshhonhdrmhgvqeenucggtf
    frrghtthgvrhhnpeeggeejheeikefhtdduledvffehkeettdelieeghffhhfeifffhvddt
    keekffffheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehmrghilhesjhhohhhnvghrihgtshhonhdrmhgv
X-ME-Proxy: <xmx:i8oFYdosPeJtBGdo8Z4wbz8U4xlSFtmdmWV4cOVF9ULuHT7zbSBy9w>
    <xmx:i8oFYflgM_R_lElH2U_dpW9SrfRw2LvPeyPsR54Z1hKaDLdG7vQYhQ>
    <xmx:i8oFYV3Ez7Ktsl5Nz4ajXr1BsclrIQeFa-TnL-s3NmcjpTO3upcTkw>
    <xmx:jMoFYfoRvDh9fOBgDwH7cBS-In8zukt0Q85AXqMFGoum9ePYwV7zUQ>
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-545-g7a4eea542e-fm-20210727.001-g7a4eea54
Mime-Version: 1.0
Message-Id: <1468d75c-57ae-42aa-85ce-2bee8d403763@www.fastmail.com>
In-Reply-To: <YQNYs+BKenJHBMSP@zeniv-ca.linux.org.uk>
References: 
 <CAHmME9oHBtR4fBBUY8E_Oi7av-=OjOGkSNhQuMJMHhafCjazBw@mail.gmail.com>
 <CALCETrVGLx5yeHo7ExAmJZmPjVjcJiV7p1JOa4iUaW5DRoEvLQ@mail.gmail.com>
 <cf07f0732eb94dbfa67c9d56ceba738e@AcuMS.aculab.com>
 <f8457e20-c3cc-6e56-96a4-3090d7da0cb6@JohnEricson.me>
 <20210729142415.qovpzky537zkg3dp@wittgenstein>
 <YQNYs+BKenJHBMSP@zeniv-ca.linux.org.uk>
Date: Sat, 31 Jul 2021 15:11:03 -0700
From: "John Ericson" <mail@johnericson.me>
To: "Al Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <christian.brauner@ubuntu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
 "David Laight" <David.Laight@aculab.com>,
 "Andy Lutomirski" <luto@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
 "Kernel Hardening" <kernel-hardening@lists.openwall.com>,
 "Jann Horn" <jann@thejh.net>,
 "Christian Brauner" <christian.brauner@canonical.com>
Subject: Re: Leveraging pidfs for process creation without fork
Content-Type: multipart/alternative;
 boundary=aa95bf7a7742405481c723fb8e5473fb

--aa95bf7a7742405481c723fb8e5473fb
Content-Type: text/plain

Do you mind pointing out one of those examples? I'm new to this, but if they follow a pattern I should be able to find the other examples based off it. I'm certainly curious to take a look :).

I hope these issues aren't to deep. Ideally there's a nice decoupling so the creating process is just manipulating "inert" data structures for the embryo that scheduler doesn't even need see, and then after the embryonic process is submitted, when the context switches to it for the first time that's a completely normal process without special cases.

The place complexity is hardest to avoid I think would be cleaning up the yet-unborn embryonic processes orphaned by exitted parent(s), because that will have to handle all the semi-initialized states those could be in (as opposed to real processes).

John

On Thu, Jul 29, 2021, at 6:41 PM, Al Viro wrote:
> On Thu, Jul 29, 2021 at 04:24:15PM +0200, Christian Brauner wrote:
> > On Wed, Jul 28, 2021 at 12:37:57PM -0400, John Cotton Ericson wrote:
> > > Hi,
> > > 
> > > I was excited to learn about about pidfds the other day, precisely in hopes
> > > that it would open the door to such a "sane process creation API". I
> > > searched the LKML, found this thread, and now hope to rekindle the
> > > discussion; my apologies if there has been more discussion since that I
> > 
> > Yeah, I haven't forgotten this discussion. A proposal is on my todo list
> > for this year. So far I've scheduled some time to work on this in the
> > fall.
> 
> Keep in mind that quite a few places in kernel/exit.c very much rely upon the
> lack of anything outside of thread group adding threads into it.  Same for
> fs/exec.c.
> 
--aa95bf7a7742405481c723fb8e5473fb
Content-Type: text/html
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE html><html><head><title></title><style type=3D"text/css">p.Mso=
Normal,p.MsoNoSpacing{margin:0}
p.MsoNormal,p.MsoNoSpacing{margin:0}
p.MsoNormal,p.MsoNoSpacing{margin:0}
p.MsoNormal,p.MsoNoSpacing{margin:0}</style></head><body><div>Do you min=
d pointing out one of those examples? I'm new to this, but if they follo=
w a pattern I should be able to find the other examples based off it. I'=
m certainly curious to take a look :).<br></div><div><br></div><div>I ho=
pe these issues aren't to deep. Ideally there's a nice decoupling so the=
 creating process is just manipulating "inert" data structures for the e=
mbryo that scheduler doesn't even need see, and then after the embryonic=
 process is submitted, when the context switches to it for the first tim=
e that's a completely normal process without special cases.<br></div><di=
v><br></div><div>The place complexity is hardest to avoid I think would =
be cleaning up the yet-unborn embryonic processes orphaned by exitted pa=
rent(s), because that will have to handle all the semi-initialized state=
s those could be in (as opposed to real processes).<br></div><div><br></=
div><div>John<br></div><div><br></div><div>On Thu, Jul 29, 2021, at 6:41=
 PM, Al Viro wrote:<br></div><blockquote type=3D"cite" id=3D"qt" style=3D=
""><div>On Thu, Jul 29, 2021 at 04:24:15PM +0200, Christian Brauner wrot=
e:<br></div><div>&gt; On Wed, Jul 28, 2021 at 12:37:57PM -0400, John Cot=
ton Ericson wrote:<br></div><div>&gt; &gt; Hi,<br></div><div>&gt; &gt;&n=
bsp;<br></div><div>&gt; &gt; I was excited to learn about about pidfds t=
he other day, precisely in hopes<br></div><div>&gt; &gt; that it would o=
pen the door to such a "sane process creation API". I<br></div><div>&gt;=
 &gt; searched the LKML, found this thread, and now hope to rekindle the=
<br></div><div>&gt; &gt; discussion; my apologies if there has been more=
 discussion since that I<br></div><div>&gt;&nbsp;<br></div><div>&gt; Yea=
h, I haven't forgotten this discussion. A proposal is on my todo list<br=
></div><div>&gt; for this year. So far I've scheduled some time to work =
on this in the<br></div><div>&gt; fall.<br></div><div><br></div><div>Kee=
p in mind that quite a few places in kernel/exit.c very much rely upon t=
he<br></div><div>lack of anything outside of thread group adding threads=
 into it.&nbsp; Same for<br></div><div>fs/exec.c.<br></div><div><br></di=
v></blockquote></body></html>
--aa95bf7a7742405481c723fb8e5473fb--
