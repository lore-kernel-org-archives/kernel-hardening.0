Return-Path: <SRS0=12Ye=5X=lists.openwall.com=kernel-hardening-return-18459-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5705EC2BA1A
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Apr 2020 16:33:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A7D6A2072A
	for <kernel-hardening@archiver.kernel.org>; Tue,  7 Apr 2020 16:33:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="HXd2UwNS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A7D6A2072A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18459-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 4005 invoked by uid 550); 7 Apr 2020 16:33:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3971 invoked from network); 7 Apr 2020 16:33:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=AlcwjOm+1Oh931lo1HzGT/5VUetrnzxIQ7HJJpMAkSA=;
        b=HXd2UwNSpZv1U6uiJdGL+SA6oIP70AZXhiqqbtCpORm55myGT6F8YoYz1KcqrXBzpQ
         6PhnHzrI/1egYgCS4yivmIhASptb/TJE+LdK4qoo7Avb8yNPjTxfipFQpfqNBtoTtKOS
         IPLiKFb99PyptFPWiEJPD71sdfoIvojaqEh0A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=AlcwjOm+1Oh931lo1HzGT/5VUetrnzxIQ7HJJpMAkSA=;
        b=Sx3ilQED+g+tbOKLr6QzSfFsQi+qh/fZJa5cF8HmuSa9xCJ/rOL4joe2AelsGMSsV5
         pMj2lsKJruY495qsEAcPOqFhnYhsPy5+glLpbxnnGzxG9QdmkuPO2tvvZU4N4CYGtW1w
         ena7QrJdRUjAeK+E5SdQ66a9X2fjmNxUIpYgzrwJsrChz0J1PtMxTZfXlL+qUemxh0Zs
         M6VoK5pMtgVpcaB0KTwPZt1FEBtRk4Q/zeY304ktGkgZ6FJsHoDCqXCn9MMAApWn8ZWW
         AWm1/q/X1ikpG4l0fIB33C2h7f4Qh0Cpaji/UVRcb80wrHcxZYHDRPGB+FBfbuuOrQNz
         HZrg==
X-Gm-Message-State: AGi0PuaDxAVkRDI99JZQP7qaUzXGfX6z+YwRo3Gg/qj4O87UrM5Zh6h8
	u3KHCZauB/+ZaHhCgL7BWLs7ow==
X-Google-Smtp-Source: APiQypKeLFLniNnmBEATU0CRT1p7cx8eVojEZZ/MBtMP+nCynVZQytfYdqaR6xyI5TtllI5gK89mGg==
X-Received: by 2002:a63:be09:: with SMTP id l9mr2829851pgf.439.1586277198229;
        Tue, 07 Apr 2020 09:33:18 -0700 (PDT)
Date: Tue, 7 Apr 2020 09:33:16 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Popov <alex.popov@linux.com>
Cc: kernel-hardening@lists.openwall.com, Emese Revfy <re.emese@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gcc-plugins/stackleak: Avoid assignment for unused macro
 argument
Message-ID: <202004070933.5112AA6@keescook>
References: <202004020103.731F201@keescook>
 <13c90df4-a422-bb73-a119-b8ccd11fc4f1@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <13c90df4-a422-bb73-a119-b8ccd11fc4f1@linux.com>

On Tue, Apr 07, 2020 at 06:30:18PM +0300, Alexander Popov wrote:
> Hello Kees,
> 
> On 02.04.2020 11:10, Kees Cook wrote:
> > With GCC version >= 8, the cgraph_create_edge() macro argument using
> > "frequency" goes unused. Instead of assigning a temporary variable for
> > the argument, pass the compute_call_stmt_bb_frequency() call directly
> > as the macro argument so that it will just not be uncalled when it is
> > not wanted by the macros.
> 
> Do you mean "it will just not be called"?

I really did. ;) Thanks, I'll adjust this.

-Kees

> 
> Thanks!
> 
> > Silences the warning:
> > 
> > scripts/gcc-plugins/stackleak_plugin.c:54:6: warning: variable ‘frequency’ set but not used [-Wunused-but-set-variable]
> > 
> > Now builds cleanly with gcc-7 and gcc-9. Both boot and pass
> > STACKLEAK_ERASING LKDTM test.
> > 
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  scripts/gcc-plugins/stackleak_plugin.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/scripts/gcc-plugins/stackleak_plugin.c b/scripts/gcc-plugins/stackleak_plugin.c
> > index dbd37460c573..cc75eeba0be1 100644
> > --- a/scripts/gcc-plugins/stackleak_plugin.c
> > +++ b/scripts/gcc-plugins/stackleak_plugin.c
> > @@ -51,7 +51,6 @@ static void stackleak_add_track_stack(gimple_stmt_iterator *gsi, bool after)
> >  	gimple stmt;
> >  	gcall *stackleak_track_stack;
> >  	cgraph_node_ptr node;
> > -	int frequency;
> >  	basic_block bb;
> >  
> >  	/* Insert call to void stackleak_track_stack(void) */
> > @@ -68,9 +67,9 @@ static void stackleak_add_track_stack(gimple_stmt_iterator *gsi, bool after)
> >  	bb = gimple_bb(stackleak_track_stack);
> >  	node = cgraph_get_create_node(track_function_decl);
> >  	gcc_assert(node);
> > -	frequency = compute_call_stmt_bb_frequency(current_function_decl, bb);
> >  	cgraph_create_edge(cgraph_get_node(current_function_decl), node,
> > -			stackleak_track_stack, bb->count, frequency);
> > +			stackleak_track_stack, bb->count,
> > +			compute_call_stmt_bb_frequency(current_function_decl, bb));
> >  }
> >  
> >  static bool is_alloca(gimple stmt)
> > 
> 

-- 
Kees Cook
