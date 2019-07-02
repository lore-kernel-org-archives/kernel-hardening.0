Return-Path: <SRS0=pCPw=U7=lists.openwall.com=kernel-hardening-return-16338-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DATE_IN_PAST_03_06,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B7FC5B57D
	for <kernel-hardening@archiver.kernel.org>; Tue,  2 Jul 2019 21:04:59 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 38AFB218B6
	for <kernel-hardening@archiver.kernel.org>; Tue,  2 Jul 2019 21:04:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mNIyPmcI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38AFB218B6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16338-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 23708 invoked by uid 550); 2 Jul 2019 21:04:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23552 invoked from network); 2 Jul 2019 21:04:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3oRQP6OyMncZqs1P2VDPYtUqP4kfvHXKeERBXGzurro=;
        b=mNIyPmcIdfUYVXLezp0+aCAemf+uXroBOQ7Cufglx9hU40ZFaUpveEvWqmi8xDnx5A
         CHBhRgeLck8qjLoQK2k1xNr2ATAPiS2nFkjvhhgn3v8lqYRTmDCHtrvteC51W2zH8lZ9
         LVx8tHM7hGV7yGgzkj1yX/s+G8rG2Y7W1RZH0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3oRQP6OyMncZqs1P2VDPYtUqP4kfvHXKeERBXGzurro=;
        b=sT1BRTJIlOXOktBH0YEd3t7Czez68WTA6EYWPZj6jVv9jVYoveDOxECMY4U9qeAehe
         FTfUUMCl04Bj7EOUjnZ5zqusTbXwKy8fbIbmvCD2nSGlEKK8ZDfLwnLEBXVqv6oIFuje
         ETIPk9NtIO2zPtqKsypYccL0nUERKRp5B5z7XEDB9gjwvtH/PgZlZVt/h/feZLpPzu44
         sm+avsSAUogb3jDaaw8l1ilwy+MoTHQtD9IRRo4/jLWSAtLjzq0d0gLC1J32j4JBlUmN
         bNz0Yvke+EWnXEIu7+Vy1KioYuH4zo/bCOa3juVdJbxlg8zuXfe2zT6P2hQS5F9VZwKY
         UdoQ==
X-Gm-Message-State: APjAAAXgRObHgnIkbrRV3IiCN/l4dYIluuDx/wdoJ/c0czrcEOC7YXAI
	JcOktcQBHKB6LgQ0tjkx2aSDzg==
X-Google-Smtp-Source: APXvYqw6TMrYI/EiBfGv58xQZ/jM2louHdBlwjxy3r/WX6tidkdzXiq+sLNP3aejulYCRpK2ZFhEGQ==
X-Received: by 2002:a17:90a:384d:: with SMTP id l13mr8061002pjf.86.1562101459754;
        Tue, 02 Jul 2019 14:04:19 -0700 (PDT)
Date: Tue, 2 Jul 2019 10:31:33 -0700
From: Kees Cook <keescook@chromium.org>
To: "Gote, Nitin R" <nitin.r.gote@intel.com>
Cc: "jannh@google.com" <jannh@google.com>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH] checkpatch: Added warnings in favor of strscpy().
Message-ID: <201907021025.C798E540@keescook>
References: <1561722948-28289-1-git-send-email-nitin.r.gote@intel.com>
 <201906280739.9CD1E4B@keescook>
 <12356C813DFF6F479B608F81178A561586C2AC@BGSMSX101.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12356C813DFF6F479B608F81178A561586C2AC@BGSMSX101.gar.corp.intel.com>

On Mon, Jul 01, 2019 at 08:42:39AM +0000, Gote, Nitin R wrote:
> Hi Kees,
> 
> As per my understanding, I have updated strncpy() section in Documentation/process/deprecated.rst for strscpy_pad() case. Other two cases of strncpy() are already explained. 
> 
> Also updated checkpatch for __nonstring case.
> 
> Could you please give your inputs on below diff changes ? If this looks good, I will send the patch.
> 
> Diff changes :
> 
> diff --git a/Documentation/process/deprecated.rst b/Documentation/process/deprecated.rst
> index 49e0f64..6ab05ac 100644
> --- a/Documentation/process/deprecated.rst
> +++ b/Documentation/process/deprecated.rst
> @@ -102,6 +102,9 @@ still be used, but destinations should be marked with the `__nonstring
>  <https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html>`_
>  attribute to avoid future compiler warnings.
> 
> +If a caller is using NUL-terminated strings, and destination needing
> +trailing NUL, then the safe replace is :c:func:`strscpy_pad()`.

I'd move this above the __nonstring discussion and remove the memset
mention. How about doing this?

diff --git a/Documentation/process/deprecated.rst b/Documentation/process/deprecated.rst
index 49e0f64a3427..f564de3caf76 100644
--- a/Documentation/process/deprecated.rst
+++ b/Documentation/process/deprecated.rst
@@ -93,9 +93,9 @@ will be NUL terminated. This can lead to various linear read overflows
 and other misbehavior due to the missing termination. It also NUL-pads the
 destination buffer if the source contents are shorter than the destination
 buffer size, which may be a needless performance penalty for callers using
-only NUL-terminated strings. The safe replacement is :c:func:`strscpy`.
-(Users of :c:func:`strscpy` still needing NUL-padding will need an
-explicit :c:func:`memset` added.)
+only NUL-terminated strings. In this case, the safe replacement is
+:c:func:`strscpy`. If, however, the destination buffer still needs
+NUL-padding, the safe replacement is :c:func:`strscpy_pad`.
 
 If a caller is using non-NUL-terminated strings, :c:func:`strncpy()` can
 still be used, but destinations should be marked with the `__nonstring

> +
>  strlcpy()
>  ---------
>  :c:func:`strlcpy` reads the entire source buffer first, possibly exceeding
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 342c7c7..d3c0587 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -595,6 +595,10 @@ our %deprecated_apis = (
>         "rcu_barrier_sched"                     => "rcu_barrier",
>         "get_state_synchronize_sched"           => "get_state_synchronize_rcu",
>         "cond_synchronize_sched"                => "cond_synchronize_rcu",
> +       "strcpy"                                => "strscpy",
> +       "strlcpy"                               => "strscpy",
> +       "strncpy"                               => "strscpy, strscpy_pad Or for non-NUL-terminated strings,
> +        strncpy() can still be used, but destinations should be marked with the __nonstring",

I found the "Or" strange here; I think just "or" is fine.

-Kees

>  );
> 
> Thanks and Regards,
> Nitin Gote
> 
> -----Original Message-----
> From: Kees Cook [mailto:keescook@chromium.org] 
> Sent: Friday, June 28, 2019 8:16 PM
> To: Gote, Nitin R <nitin.r.gote@intel.com>
> Cc: jannh@google.com; kernel-hardening@lists.openwall.com
> Subject: Re: [PATCH] checkpatch: Added warnings in favor of strscpy().
> 
> On Fri, Jun 28, 2019 at 05:25:48PM +0530, Nitin Gote wrote:
> > Added warnings in checkpatch.pl script to :
> > 
> > 1. Deprecate strcpy() in favor of strscpy().
> > 2. Deprecate strlcpy() in favor of strscpy().
> > 3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().
> > 
> > Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>
> 
> Excellent, yes. Can you also add a bit to the strncpy() section in Documentation/process/deprecated.rst so that all three cases of strncpy() are explained:
> 
> - strncpy() into NUL-terminated target should use strscpy()
> - strncpy() into NUL-terminated target needing trailing NUL: strscpy_pad()
> - strncpy() into non-NUL-terminated target should have target marked
>   with __nonstring.
> 
> (and probably mention the __nonstring case in checkpatch too)
> 
> -Kees
> 
> > ---
> >  scripts/checkpatch.pl | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl index 
> > 342c7c7..bb0fa11 100755
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -595,6 +595,9 @@ our %deprecated_apis = (
> >  	"rcu_barrier_sched"			=> "rcu_barrier",
> >  	"get_state_synchronize_sched"		=> "get_state_synchronize_rcu",
> >  	"cond_synchronize_sched"		=> "cond_synchronize_rcu",
> > +	"strcpy"				=> "strscpy",
> > +	"strlcpy"				=> "strscpy",
> > +	"strncpy"				=> "strscpy or strscpy_pad",
> >  );
> > 
> >  #Create a search pattern for all these strings to speed up a loop 
> > below
> > --
> > 2.7.4
> > 
> 
> --
> Kees Cook

-- 
Kees Cook
