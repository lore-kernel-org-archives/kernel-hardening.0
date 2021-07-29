Return-Path: <SRS0=KUTq=MV=lists.openwall.com=kernel-hardening-return-21336-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C03E3C4338F
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Jul 2021 15:21:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DA56E601FF
	for <kernel-hardening@archiver.kernel.org>; Thu, 29 Jul 2021 15:21:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DA56E601FF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=johnericson.me
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 21913 invoked by uid 550); 29 Jul 2021 15:21:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13999 invoked from network); 29 Jul 2021 14:54:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=johnericson.me;
	 h=mime-version:message-id:in-reply-to:references:date:from:to
	:cc:subject:content-type; s=fm3; bh=k76RUZpT+yXq9JfoZ3nl1UjqDvth
	+gVcjMm7CyMdORc=; b=OkSINz24DReO2X8KmP7INsQgu9fu3HV80Q+ubVZ++qYd
	NPi6YmOf+rk0m8f9HkHdOAhsV9/zd8m8pWcsL4Tdehh7wQqbb+jL3Ms0P7FSK005
	A8qdPJjalSWSybrlxEjtxJ2xhphlzjFkQJHETKV0DZrgzWIP48m60Gqz4m2ruG/1
	rzJas31a15CWEjP1NSNNYo/SjIMws19kBBcGZOYrpNXA9bz2Cn/Yfko1CfqBeC5M
	9WBXOzy7FdnnK70GintxZEKq0bUydpAw4V3BsYOhjjpyWTW4n8gwNd3LD+iMfr6J
	eKzBA6yotdjynd4uFFM495rlZGQTdxbvitT6dBumVw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=k76RUZ
	pT+yXq9JfoZ3nl1UjqDvth+gVcjMm7CyMdORc=; b=Ea/YojnyJCFCk1RAHynM3s
	gqBC1hSQp3HTeiL/Hoauv1wSyx+JLS+Peaodmxsl8SGD+OFqxy9vzMw7f0y4c/bx
	Z0zHizatOCEotFVw8ht3vELUf56sZn9ydmKJuYtAqaYm2ZjRuGE8D0VCxh9jmF1a
	vZI0GWoR72FX3TMV7EPdAi3RruRix5sHLZBjEBmxuMAFwH9n/6MHUMZKc2qRwpl6
	hi3M48A0X9+TTF+Nm90qDYlMa6Y9utXs7p3Y3BoTSXhahqA4DE6hKXdoQaB5VQ06
	MStU0C68pyysZybZy5ikEy7YPbnUwvJ2FqbWwg6qCTZ/llH+ea+Meq9921Yc72UA
	==
X-ME-Sender: <xms:J8ECYYObVXxefpjb2_tNOzHCyGRy97CpQIVK5jJkGSC1gpNNHMLuAw>
    <xme:J8ECYe8E5RiYQNgi4MRjrpmH-TD0NLP_D0w-K3wnvQrcO3str08M4OjLF3DWJ6jid
    F9OrJ5VFotJtOwhf1g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrheefgdegudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedflfhohhhn
    ucfgrhhitghsohhnfdcuoehlihhsthesjhhohhhnvghrihgtshhonhdrmhgvqeenucggtf
    frrghtthgvrhhnpedvhedtvedtiefhieefleelteehgfduveehteevveelieetheektdei
    keeiheejjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehlihhsthesjhhohhhnvghrihgtshhonhdrmhgv
X-ME-Proxy: <xmx:J8ECYfQrpiHHfBnPANec00KpFXN7OkXs1t5KoLFSLVvJoVyjVH2DAg>
    <xmx:J8ECYQtbEQEHQhJDdHTrodNIeqY8--WgE6D5Ac4x9Tq8VJAfxxnh0w>
    <xmx:J8ECYQdql8AvZWonkeYwV_3tXGZY2clgMV3eHm3Gc_cN09DXP2cNxg>
    <xmx:KMECYVHOSpoz8M28r1kAtjf1ZmsLg9OTwfM9olgaPtRMYY_Yu5NCHmfG5Ow>
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-545-g7a4eea542e-fm-20210727.001-g7a4eea54
Mime-Version: 1.0
Message-Id: <e048b871-55db-4e7f-96c9-40aabdd076c5@www.fastmail.com>
In-Reply-To: <20210729142415.qovpzky537zkg3dp@wittgenstein>
References: 
 <CAHmME9oHBtR4fBBUY8E_Oi7av-=OjOGkSNhQuMJMHhafCjazBw@mail.gmail.com>
 <CALCETrVGLx5yeHo7ExAmJZmPjVjcJiV7p1JOa4iUaW5DRoEvLQ@mail.gmail.com>
 <cf07f0732eb94dbfa67c9d56ceba738e@AcuMS.aculab.com>
 <f8457e20-c3cc-6e56-96a4-3090d7da0cb6@JohnEricson.me>
 <20210729142415.qovpzky537zkg3dp@wittgenstein>
Date: Thu, 29 Jul 2021 10:54:08 -0400
From: "John Ericson" <list@johnericson.me>
To: "Christian Brauner" <christian.brauner@ubuntu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
 "David Laight" <David.Laight@ACULAB.COM>,
 "Andy Lutomirski" <luto@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
 "Kernel Hardening" <kernel-hardening@lists.openwall.com>,
 "Jann Horn" <jann@thejh.net>,
 "Christian Brauner" <christian.brauner@canonical.com>
Subject: Re: Leveraging pidfs for process creation without fork
Content-Type: text/plain

Wonderful, looking forward to it reading it then!

John

On Thu, Jul 29, 2021, at 10:24 AM, Christian Brauner wrote:
> On Wed, Jul 28, 2021 at 12:37:57PM -0400, John Cotton Ericson wrote:
> > Hi,
> > 
> > I was excited to learn about about pidfds the other day, precisely in hopes
> > that it would open the door to such a "sane process creation API". I
> > searched the LKML, found this thread, and now hope to rekindle the
> > discussion; my apologies if there has been more discussion since that I
> 
> Yeah, I haven't forgotten this discussion. A proposal is on my todo list
> for this year. So far I've scheduled some time to work on this in the
> fall.
> 
> Thanks!
> Christian
