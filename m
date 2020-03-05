Return-Path: <SRS0=m/t4=4W=lists.openwall.com=kernel-hardening-return-18090-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8077AC3F2D2
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 20:52:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CAF0920732
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 20:52:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho-ws.20150623.gappssmtp.com header.i=@tycho-ws.20150623.gappssmtp.com header.b="uRFzyUvB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CAF0920732
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=tycho.ws
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18090-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28456 invoked by uid 550); 5 Mar 2020 20:52:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28424 invoked from network); 5 Mar 2020 20:52:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tycho-ws.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rH1kRgRamv58/PWKnkrnSTZWeEPtKbW21oLiW57uMY8=;
        b=uRFzyUvBwn6/q/kY0ilgjuzyuH6Z4OE1w9PzgdiwYLKHPiHjGNAxLmJn8z/C6zuJ82
         zyhdRkdrYTsRXXCr/XScXu6ZjFv8YDd24ruOvHuzRTFfKOTrqxmOZ+TofbRvReGhN8ZG
         /sKtSunD8xqVXLbEg4PnvoVVJ0pYcnUVQ/l7VbxiYC2Q03oTO9zWuVxrY77WGSr/U/lx
         Z9aYehlB4+OtaZ9UTnS34vvEZV9vOhNnoS6i6PtqW4AIKUzuwyyg4RBrlq6ky4QExcce
         MqAbBx7AF6/E3ekKGZTx54gf1FOP9huiNGf87bhRm3quItdUYVh9+Wk/AbYCOtZStlR/
         L9Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rH1kRgRamv58/PWKnkrnSTZWeEPtKbW21oLiW57uMY8=;
        b=eROluf9v0h85mRNrQqC8pMTPYFodJaDMZUgD/+x9rWM/uOP8EBuqGwWrx8uj9wuhQM
         cE1QHugvLeWwpNK+NxBlPmBLafjSUUqtyPBu3YFk01DAvD2zsB32YvLIIM9ROI8U9CoD
         xeuEO9zaXnFXtjJrIhIVzxA8cvsMZlRsCZrsFATwzNZWxpC4C27TBPFIfFqv3wk2nPZH
         dT5ex2df5sRAi9BRgdy4cUfjOqaOBQy/BHBoD5D9XGIRZCmHX6+Ee196H49BudYzkpsd
         DDyl3GWsyou40L/+sKbvH+ibUNMgvk37/fknCQ2bWxUAncxBBsbhYXp9OsT3gt+VGSpp
         uWAg==
X-Gm-Message-State: ANhLgQ0zBTM6MEQ/ukAnzufq/6VLLhRaliFkrsQdZYdUwgjp44nB79aq
	9N4RrwsOtAZRzhfMzlLJ1KXahg==
X-Google-Smtp-Source: ADFU+vuUrQamPRTnwCtkAj507QoOwrXbHzBwwWDHh1EiihLsrBz1jv619SOn66N1Nsiie+NG8gSp+w==
X-Received: by 2002:a25:4843:: with SMTP id v64mr101146yba.315.1583441524439;
        Thu, 05 Mar 2020 12:52:04 -0800 (PST)
Date: Thu, 5 Mar 2020 13:51:58 -0700
From: Tycho Andersen <tycho@tycho.ws>
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Joe Perches <joe@perches.com>, Kees Cook <keescook@chromium.org>,
	"Tobin C . Harding" <me@tobin.cc>,
	kernel-hardening@lists.openwall.com,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sh: Stop printing the virtual memory layout
Message-ID: <20200305205158.GF6506@cisco>
References: <202003021038.8F0369D907@keescook>
 <20200305151010.835954-1-nivedita@alum.mit.edu>
 <f672417e-1323-4ef2-58a1-1158c482d569@physik.fu-berlin.de>
 <31d1567c4c195f3bc5c6b610386cf0f559f9094f.camel@perches.com>
 <3c628a5a-35c7-3d92-b94b-23704500f7c4@physik.fu-berlin.de>
 <20200305154657.GA848330@rani.riverdale.lan>
 <456fddd9-c980-b0f2-9dd0-19befee7861e@physik.fu-berlin.de>
 <20200305155628.GA857024@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305155628.GA857024@rani.riverdale.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Mar 05, 2020 at 10:56:29AM -0500, Arvind Sankar wrote:
> On Thu, Mar 05, 2020 at 04:49:22PM +0100, John Paul Adrian Glaubitz wrote:
> > On 3/5/20 4:46 PM, Arvind Sankar wrote:
> > > Not really too late. I can do s/pr_info/pr_devel and resubmit.
> > > 
> > > parisc for eg actually hides this in #if 0 rather than deleting the
> > > code.
> > > 
> > > Kees, you fine with that?
> > 
> > But wasn't it removed for all the other architectures already? Or are these
> > changes not in Linus' tree yet?
> > 
> > Adrian
> 
> The ones mentioned in the commit message, yes, those are long gone. But
> I don't see any reason why the remaining ones (there are 6 left that I
> submitted patches just now for) couldn't switch to pr_devel instead.

If you do happen to re-send with pr_debug() instead, feel free to add
my ack to that series as well. But in any case, this one is also:

Acked-by: Tycho Andersen <tycho@tycho.ws>
