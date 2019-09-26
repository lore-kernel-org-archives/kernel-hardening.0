Return-Path: <SRS0=POWj=XV=lists.openwall.com=kernel-hardening-return-16947-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5ED9C4360C
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Sep 2019 22:10:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1762C20640
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Sep 2019 22:10:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="F1vtVsaO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1762C20640
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16947-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21845 invoked by uid 550); 26 Sep 2019 22:10:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21811 invoked from network); 26 Sep 2019 22:10:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PNc3FQWs5ve2GC9BQ0Qy5UNIDu+ZgkCg5Eg7XW8Sm7g=;
        b=F1vtVsaOm8n3p9meHteTZoKcuYWokC9j9xTngdIYFWwKAshSYlbqwCe7K7xJnbLaGQ
         aMAx4X1HaqRFo1QP/o0IXS5UVMSZfTghVXN9hmW1Wc1POmXYWcKFgJMT+kDyNh/tGrhY
         4ODJtUa+37f3yT3oizRBV4T2STSFDcl82gWD4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PNc3FQWs5ve2GC9BQ0Qy5UNIDu+ZgkCg5Eg7XW8Sm7g=;
        b=m/xDDXtBD+TQI7tK1HKvqUAMIrAp5J9UBa/2YhaNu1Sb+5yydgFlV2fBhPVBblvv5g
         gEmKO/7nZ2hc/Hg0fW6Vvr5ubEkR2gY71xoCOak1Wkhkpjn9p/ydML+G1AG3JhIH+IVm
         dH/7x2gedCJvYjfZXbPvh7I4puY4JIxxONP61Q7PPSD7OOL0nPEHnR4ZmgVP+NzpMTt/
         wBY7z6wWIl7t0wMTtXynKXqOj/6IQ4ZFO8G5beK4ujSOGH65n4Gu+0Et4pn5kNKoM0oc
         wEiuswC5ETn9Ph/pKoi4tyVSqik0JOQUseZSrWrwDSp5pg7FB8ZoPrk7lr06LPGh0UzA
         TeTQ==
X-Gm-Message-State: APjAAAWO9YsquevmPl7nIHSyXdP0CcJ/pOlK0fJsbTQcnrxKWMCjKwti
	fho9lqxVZxpF4GGy2+c0BVPLCw==
X-Google-Smtp-Source: APXvYqzXerZDMKGIkud8dDJEspd735Wg21P8AYxg5tkjJjzsWyPPeu05Qooby0wOeWp85PvOveWkJg==
X-Received: by 2002:a17:90a:8404:: with SMTP id j4mr6132727pjn.143.1569535807306;
        Thu, 26 Sep 2019 15:10:07 -0700 (PDT)
Date: Thu, 26 Sep 2019 15:10:05 -0700
From: Kees Cook <keescook@chromium.org>
To: Tianlin Li <tli@digitalocean.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: Introduction and get involved
Message-ID: <201909261505.9A58F60D@keescook>
References: <19962016-19D9-40F8-A2A0-B7188614A263@digitalocean.com>
 <201909241604.C4B6686@keescook>
 <7D98C4BB-62FA-4393-B24A-E213FB340A94@digitalocean.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7D98C4BB-62FA-4393-B24A-E213FB340A94@digitalocean.com>

On Thu, Sep 26, 2019 at 09:57:58AM -0500, Tianlin Li wrote:
> > On Sep 24, 2019, at 6:12 PM, Kees Cook <keescook@chromium.org> wrote:
> > I've been keeping a (rather terse) TODO list here:
> > https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Work#Specific_TODO_Items
> > 
> > But I'd like to turn that into an actual bug list on github or the like.

I've (slowly) started this process now:
https://github.com/KSPP/linux/issues/

> > I wonder if working on something like this:
> > - set_memory_*() needs __must_check and/or atomicity
> > would be interesting?
> > 
> > The idea there is that set_memory_*() calls can fail, so callers should
> > likely be handling errors correctly. Adding the "__must_check" attribute
> > and fixing all the callers would be nice (and certainly touches the
> > memory management code!)
> 
> This is a great starting task for me. So for this task, basically I need to add __must_check attribute to set_memory_*() functions and fix all the callers to make sure they check the return values. Do I understand correctly?

Yup, that's right. I've added that issue with some more details now:
https://github.com/KSPP/linux/issues/7

> Also I have some other questions:
> Is there any requirement for the patches? e.g. based on which kernel version? how many individual patches?

I recommend basing your patches on either the last full release (v5.3
currently) or, if you need something newer, on the -rc2 of the next
release (v5.4-rc2). We are, however, in the middle of the merge window,
so -rc2 doesn't exist yet. :)

The general details on submitting patches apply:
https://www.kernel.org/doc/html/latest/process/submitting-patches.html

Feel free to post "RFC" patches here to this list first if you want some
initial feedback. (Though I recommend still including maintainers in Cc
to get their feedback too.)

-- 
Kees Cook
