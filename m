Return-Path: <SRS0=TJeP=4W=lists.openwall.com=kernel-hardening-return-18078-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7606AC3F2CD
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 15:47:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C8B5F2073D
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 15:47:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LucVZ0Ih"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C8B5F2073D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18078-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24394 invoked by uid 550); 5 Mar 2020 15:47:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24362 invoked from network); 5 Mar 2020 15:47:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2+6yZWLzWungFxfinpVR8DrsNx/2sba2y67ZFb8NhxY=;
        b=LucVZ0IhRZuskZG477RZ59HOO2HEwkbxzbAF+WksjcG6JkEBMfrYnSJ6kIoJaxpe8U
         D0H8In8ybFuNvyAKewp5CAtAdPuZ/7TMg4nCYtBQpggejWGCFQsIRdABK8dtz6mL+BeU
         XuNCfqUDVbuMdbNxe7vJ4AzlSKD0qGCMcHM2302Xs1thPjBf1F40AbaQUxRK/9vs72R8
         6FNXwtKbiWWvcIGLKKNt38De2MsTYv9jS1zWvICVa9OUWpkTu9iKq0OLx3Io8ko5LlW7
         DOn81PctlHb5LVX3hralVTU0scu3W1+7e3gbfxIO+97njwh04F9Y0j9jzFLomBneRT9r
         0uGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=2+6yZWLzWungFxfinpVR8DrsNx/2sba2y67ZFb8NhxY=;
        b=Xo+hCe+cDBvgg2Rwfe1/dsD8FglR/THsK64vLfHdcoE6hRcOenfNwM6MkMEY6wKm7C
         Atjc4ntHa1LK4MVamF4qKG1GCoUpD40mX2rnl/nO0hNWOrbUYbMUqrDGcztIhsyOmRzW
         njsNbRmK+IRhAsQ+rtvdO1SxoZby0hdr29D/4r9zPgHica2VzOZ8TtH+iT9gi+6ySxg7
         41feEZOuKxQfhnBdxQrR/DLGg1eIMqLQh79YEYnONVd1Na1jPwX2xAZQj44HzA0OjPpy
         Ke8XQBCr4+N8pW8J3bdLwNigwaxs17tDYvvqo3aVqARxkYGzVfp7bd+RBM2OL2+hKjRg
         UQIA==
X-Gm-Message-State: ANhLgQ3JTuQLZpet66dUy4DjmzblEb6mvxxJSfGg8IUWHsod3HP+4Z3t
	GLZc/92Ec3fnxVcQPo9r9Q8=
X-Google-Smtp-Source: ADFU+vuDA7FZoPkQdDlfKUwDun6qmuJOcx4Ams7CpNGOdN41KFGO46LtijTZrAIP5HBnR1VjHAKw/A==
X-Received: by 2002:a0c:c389:: with SMTP id o9mr7182654qvi.232.1583423220640;
        Thu, 05 Mar 2020 07:47:00 -0800 (PST)
Sender: Arvind Sankar <niveditas98@gmail.com>
From: Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date: Thu, 5 Mar 2020 10:46:58 -0500
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Joe Perches <joe@perches.com>, Arvind Sankar <nivedita@alum.mit.edu>,
	Kees Cook <keescook@chromium.org>,
	"Tobin C . Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>,
	kernel-hardening@lists.openwall.com,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sh: Stop printing the virtual memory layout
Message-ID: <20200305154657.GA848330@rani.riverdale.lan>
References: <202003021038.8F0369D907@keescook>
 <20200305151010.835954-1-nivedita@alum.mit.edu>
 <f672417e-1323-4ef2-58a1-1158c482d569@physik.fu-berlin.de>
 <31d1567c4c195f3bc5c6b610386cf0f559f9094f.camel@perches.com>
 <3c628a5a-35c7-3d92-b94b-23704500f7c4@physik.fu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3c628a5a-35c7-3d92-b94b-23704500f7c4@physik.fu-berlin.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Mar 05, 2020 at 04:41:05PM +0100, John Paul Adrian Glaubitz wrote:
> On 3/5/20 4:38 PM, Joe Perches wrote:
> >> Aww, why wasn't this made configurable? I found these memory map printouts
> >> very useful for development.
> > 
> > It could be changed from pr_info to pr_devel.
> > 
> > A #define DEBUG would have to be added to emit it.
> 
> Well, from the discussion it seems the decision to cut it out has already been
> made, so I guess it's too late :(.
> 
> Adrian
> 
> -- 
>  .''`.  John Paul Adrian Glaubitz
> : :' :  Debian Developer - glaubitz@debian.org
> `. `'   Freie Universitaet Berlin - glaubitz@physik.fu-berlin.de
>   `-    GPG: 62FF 8A75 84E0 2956 9546  0006 7426 3B37 F5B5 F913

Not really too late. I can do s/pr_info/pr_devel and resubmit.

parisc for eg actually hides this in #if 0 rather than deleting the
code.

Kees, you fine with that?
