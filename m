Return-Path: <SRS0=CuVy=V4=lists.openwall.com=kernel-hardening-return-16672-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69684C433FF
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Jul 2019 16:26:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B7033206B8
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Jul 2019 16:26:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="liCpB+jW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7033206B8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16672-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21505 invoked by uid 550); 31 Jul 2019 16:26:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20449 invoked from network); 31 Jul 2019 16:25:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HfzyoXraaWAQfxsJbxCgGGQbWu65hE2VfQFlsfk64AI=;
        b=liCpB+jWGUj6AJh/qQp5WSnFQt4+jRBFldNsFR7pAVkiEuDAOXYz3mL542vsI8duy9
         +J33MzLHkCEtUkrux6BnCfUobDaBB7N7eBbqtanpLBG+YTZb5jMjlCUdtAB0plmrsC0g
         cbacoMrGglNBmFKHNiRxTzilXSLAF7NdbmEs9VCsBT5bIGVxZlRXWLmgU5Xo5s725SAk
         i7rVNLKg+ogkL9gCIIDvPiY327B/NwDFS75eZAxZuSksGNsdM3/Pw2XYqdl+7ScYqo1B
         xlZVmi7W1t3o7srtQSyiGd4+JRtF6QS+1Jbq1LFV7qkyV/w+YET0WXZ+Xq0T7Aybo2Yv
         92bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HfzyoXraaWAQfxsJbxCgGGQbWu65hE2VfQFlsfk64AI=;
        b=PSTX9WW0Y1GVrmMhFvNYm+uVfEVoQ4r6Sb9xvtvOm8xue6Cd1Ma5BmFjn1Y5dQG43w
         fx0lwQYK8kTGasVEmZXD2LRgSKOhGuE5i2Eip47gpXQhS3cG1gYeJTdkgRPSenRlNiw7
         A730Iaq1yaxAw4xw20X1LWavbfiKuxKctxyR6zruHjrUWn2uzCW4PCqZ9/BmX2WC8jvQ
         MrUBuqCEDMnOP4NgTwl28EdoUHt1NtDbR1XxjWmLeK0pg6rEnjiJKOu0ODCAzbvAy4d8
         ZBD7nhvbMOdUV3qYI6KSQ6bKwClPxNPUxDil52qTOjSk0JvtO8hAkBMkD4e8m2SRjMX/
         6nMg==
X-Gm-Message-State: APjAAAUFHEna/tKYr4DyBDBZ4K9DwilZfWfpm3vad3KfJYDq3r1sLdf6
	Zc2AJZmflwjmyrz/zuMrx5Oyq5G2ZKc=
X-Google-Smtp-Source: APXvYqyFUsIpvTGwvUqrZXOPYF7Qtnqh9Ca+5hAMUC4yGz8HZaole0+Y4bjNzsEIsKcHmMcrY+3FRg==
X-Received: by 2002:a63:b10f:: with SMTP id r15mr44689474pgf.230.1564590347688;
        Wed, 31 Jul 2019 09:25:47 -0700 (PDT)
Date: Thu, 1 Aug 2019 01:25:37 +0900
From: Joonwon Kang <kjw1627@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: re.emese@gmail.com, kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	jinb.park7@gmail.com
Subject: Re: [PATCH] randstruct: fix a bug in is_pure_ops_struct()
Message-ID: <20190731162537.GA23152@host>
References: <20190727155841.GA13586@host>
 <201907301008.622218EE5@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201907301008.622218EE5@keescook>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Tue, Jul 30, 2019 at 10:11:19AM -0700, Kees Cook wrote:
> On Sun, Jul 28, 2019 at 12:58:41AM +0900, Joonwon Kang wrote:
> > Before this, there were false negatives in the case where a struct
> > contains other structs which contain only function pointers because
> > of unreachable code in is_pure_ops_struct().
> 
> Ah, very true. Something like:
> 
> struct internal {
> 	void (*callback)(void);
> };
> 
> struct wrapper {
> 	struct internal foo;
> 	void (*other_callback)(void);
> };
> 
> would have not been detected as is_pure_ops_struct()?
> 
> How did you notice this? (Are there cases of this in the kernel?)

When I compiled kernel with allyesconfig, there seemed to be no such cases,
but I found the bug just by code review and test.
However, I would like to slightly modify this patch and add one more patch.
I will send the patch set soon.

> 
> > Signed-off-by: Joonwon Kang <kjw1627@gmail.com>
> 
> Applied; thanks!
> 
> -Kees
> 
> > ---
> >  scripts/gcc-plugins/randomize_layout_plugin.c | 11 +++++------
> >  1 file changed, 5 insertions(+), 6 deletions(-)
> > 
> > diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
> > index 6d5bbd31db7f..a123282a4fcd 100644
> > --- a/scripts/gcc-plugins/randomize_layout_plugin.c
> > +++ b/scripts/gcc-plugins/randomize_layout_plugin.c
> > @@ -443,13 +443,12 @@ static int is_pure_ops_struct(const_tree node)
> >  		if (node == fieldtype)
> >  			continue;
> >  
> > -		if (!is_fptr(fieldtype))
> > -			return 0;
> > -
> > -		if (code != RECORD_TYPE && code != UNION_TYPE)
> > -			continue;
> > +		if (code == RECORD_TYPE || code == UNION_TYPE) {
> > +			if (!is_pure_ops_struct(fieldtype))
> > +				return 0;
> > +		}
> >  
> > -		if (!is_pure_ops_struct(fieldtype))
> > +		if (!is_fptr(fieldtype))
> >  			return 0;
> >  	}
> >  
> > -- 
> > 2.17.1
> > 
> 
> -- 
> Kees Cook
