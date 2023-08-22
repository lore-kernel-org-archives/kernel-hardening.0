Return-Path: <kernel-hardening-return-21675-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id D792CEE4996
	for <kernel-hardening@archiver.kernel.org>; Tue, 22 Aug 2023 13:35:13 +0000 (UTC)
Received: (qmail 26457 invoked by uid 550); 22 Aug 2023 13:35:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26417 invoked from network); 22 Aug 2023 13:35:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692711289;
	bh=Dy9w8wtgXHhaowT8KyYFReRGFqJb+pESHUzXmfSuX4M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=INZAKEAM8chZ6XyF+Fp38Za76fHb30ZewOxqNJdM3PMjPOmJofMN6HOBeTJrgnTl7
	 7fnPwwR/7p1Zc65VwHN1LtH7VysA7F3WAP2v66eAPp9jSUbFs9ljLNW8Uat08W9A03
	 N0Nk9Rn3SyhwE1Ll6Al3igB1Ad5XL1RWNfJs5ZeE=
Date: Tue, 22 Aug 2023 15:34:46 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Boris Lukashev <blukashev@sempervictus.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] Restrict access to TIOCLINUX
Message-ID: <2023082201-armband-unbridle-4893@gregkh>
References: <20230402160815.74760f87.hanno@hboeck.de>
 <2023040232-untainted-duration-daf6@gregkh>
 <20230402191652.747b6acc.hanno@hboeck.de>
 <2023040207-pretender-legislate-2e8b@gregkh>
 <ZN+X6o3cDWcLoviq@google.com>
 <2023082203-slackness-sworn-2c80@gregkh>
 <9B3A6B9B-B8F7-437A-B80B-6FB9746A6F6B@sempervictus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9B3A6B9B-B8F7-437A-B80B-6FB9746A6F6B@sempervictus.com>

On Tue, Aug 22, 2023 at 08:51:03AM -0400, Boris Lukashev wrote:
> See this asked a lot, and as someone who works mostly in languages
> with robust test facilities, I gotta ask: why isn't kernel code
> mandated to be submitted with tests?

Because for most/many of the kernel api, we don't have tests yet.  LTP
covers a lot of this type of thing, so no need to duplicate that.  But
yes, if you want to mandate this for your subsystem, that would be
great!

And many subsystems do mandate that, like drm and bpf.   So if you want
to bring the current LTP tty tests into the kernel test framework, I'll
gladly take those patches.

But I fail to see how this is relevant for this proposed change, which
would restrict access to an ioctl, how would a test help here?

thanks,

greg k-h
