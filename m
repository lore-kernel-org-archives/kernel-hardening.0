Return-Path: <SRS0=oDeD=4W=lists.openwall.com=kernel-hardening-return-18079-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2430C3F2D2
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 15:56:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1F5312072D
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 15:56:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L4gEN4fL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F5312072D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18079-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28501 invoked by uid 550); 5 Mar 2020 15:56:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28469 invoked from network); 5 Mar 2020 15:56:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mPwMNk+ywAAOySGwpStasV/rtFlsFxHauenyLwI0dE0=;
        b=L4gEN4fLSHFIN8N2dbXqrF6tp+7Rewco/W77UH+Z5Oze++xHDVAyIZPFBz5ob/RIzk
         VPY+kPGecWT+XCr50BHWwbO+Uu2QkMI0FF3nwltGYDZ+vqIY71waK7HabgWSkcMl1drq
         OjHOwhH0wsGVNG2nisYFY2yqGgG45/nVLslURkTlWyRA+O3Y6HsAP0h/2zpsKjPOnwRy
         O/vRXxOLw087pV89f4hQjZguVPJvyX0yVy8i4SLDT1EHHcka6hrM9uDylYX4ub3q7hZg
         23wvYCsetBQ56/AMuGbF7rCBmBFm+MUB//3X18xct5f6pqrI08rru6mxdEvUh60ISYuu
         tGVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=mPwMNk+ywAAOySGwpStasV/rtFlsFxHauenyLwI0dE0=;
        b=TyR4gAFgtX6n2sr+ZmDLn0ZsHWPApmYcyrZOJLqhlHjaPxM2r0qOwVScf4KvkmdT7l
         EfCH8k/PTRgHY463W8l0GlOwiHzwYJTZQQzRfjhNt8dZWmb/BUtghFhmV7lgAbVXQ6qD
         cEGuQeaulPDACQsDKp00kRbIZvEtU3WZt/6FA7uVPLR9z56iSay8PVyooiQJLhQH7PPl
         6OLjrm5rZltb5svDqZV97Fb56Qanp+5yzl85mrmbMANyI7OnRssZUMLUpEJHFArjp48U
         7tA7zb2mX6V4WjCGrGsO/33HIgS+MFOVYBlZgDve1We6pRbF31szaNg04MS3PaDNxdvi
         121A==
X-Gm-Message-State: ANhLgQ02cHEfusbZESvpi4UVpbZGyehaavX+R1vVDHf8OpdeTYw/PgKU
	Pr/N349WlCxIG1g5UMKjHKw=
X-Google-Smtp-Source: ADFU+vsxfLTudGX5w89SZdUaEJ48x598pdr0PQHinjq1b/mv0xOAvLSlNj6TCU0hcCEpRfTazoX45g==
X-Received: by 2002:ac8:7956:: with SMTP id r22mr7925742qtt.323.1583423791213;
        Thu, 05 Mar 2020 07:56:31 -0800 (PST)
Sender: Arvind Sankar <niveditas98@gmail.com>
From: Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date: Thu, 5 Mar 2020 10:56:29 -0500
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Arvind Sankar <nivedita@alum.mit.edu>, Joe Perches <joe@perches.com>,
	Kees Cook <keescook@chromium.org>,
	"Tobin C . Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>,
	kernel-hardening@lists.openwall.com,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sh: Stop printing the virtual memory layout
Message-ID: <20200305155628.GA857024@rani.riverdale.lan>
References: <202003021038.8F0369D907@keescook>
 <20200305151010.835954-1-nivedita@alum.mit.edu>
 <f672417e-1323-4ef2-58a1-1158c482d569@physik.fu-berlin.de>
 <31d1567c4c195f3bc5c6b610386cf0f559f9094f.camel@perches.com>
 <3c628a5a-35c7-3d92-b94b-23704500f7c4@physik.fu-berlin.de>
 <20200305154657.GA848330@rani.riverdale.lan>
 <456fddd9-c980-b0f2-9dd0-19befee7861e@physik.fu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <456fddd9-c980-b0f2-9dd0-19befee7861e@physik.fu-berlin.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Mar 05, 2020 at 04:49:22PM +0100, John Paul Adrian Glaubitz wrote:
> On 3/5/20 4:46 PM, Arvind Sankar wrote:
> > Not really too late. I can do s/pr_info/pr_devel and resubmit.
> > 
> > parisc for eg actually hides this in #if 0 rather than deleting the
> > code.
> > 
> > Kees, you fine with that?
> 
> But wasn't it removed for all the other architectures already? Or are these
> changes not in Linus' tree yet?
> 
> Adrian

The ones mentioned in the commit message, yes, those are long gone. But
I don't see any reason why the remaining ones (there are 6 left that I
submitted patches just now for) couldn't switch to pr_devel instead.
