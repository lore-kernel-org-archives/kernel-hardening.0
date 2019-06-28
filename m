Return-Path: <SRS0=BZHJ=U3=lists.openwall.com=kernel-hardening-return-16321-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11DE7C4321A
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Jun 2019 14:46:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 60B072064A
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Jun 2019 14:46:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="QlRPuPJt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 60B072064A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16321-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24260 invoked by uid 550); 28 Jun 2019 14:46:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24225 invoked from network); 28 Jun 2019 14:46:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=is4WiP1lJHrRFjqOSsK7jpc9Px/jxqtzGbIQLbmyYkk=;
        b=QlRPuPJtPAG9W2P0VeG5a//+47BGzbIxZRNSB8soEF55KIM573T5/7DdR3WfRHbcB4
         DR46cjOWws3VHGLlBS3Kgv4muQoM50rnzh9xwLkgE8ZLvPGjd3noVkgU23EsJKUVtIS7
         y6XlrAsiaYNjRPz3TkbTzYaJsTOUb2i2IuwSo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=is4WiP1lJHrRFjqOSsK7jpc9Px/jxqtzGbIQLbmyYkk=;
        b=fUxjAr9GFsb71SXVCHe20XX6MKb17TBYMiM0cX506gDTcOSVUttD7VqLx4IYaw+32N
         t5+EHLeVvTnh03l8WB7MJo3heOlT7V8k1EtxVzbhE4zF9THzz4CIxYb+PEYIcHEqNmOv
         Qg9ISl/zUt6qzHbKle6s1WYyShsROoRKIe1fDeUlhsSGQ6h5+UOUM1gC8RfkgReZJp4E
         1ck0MXz/FYqBwa2VTAmU7D3H+1ZnFCR3xNMOdB9pRMYCkOVEQYq9zdtx+gXc1hoRjMzH
         OnXdy4csrZQFCr0Ye2+ZkPoLYZKOc6E5V+xarDIMUbFqu6zDwXTUzSm59PwCelmFtjVg
         /HAg==
X-Gm-Message-State: APjAAAVdY/gg8g5L2Hgwa/SHXohQATikAo7paehfsHHYUxSsY++4UW2t
	e/EPt6EPaefyNWvEWlaBGHwCVw==
X-Google-Smtp-Source: APXvYqyBauYFiWSFU8y14/msek49MuOCzD/ESJ5SmUaDoMSQWbolZn5w5sqBTZD0bSneceSlgaTRmw==
X-Received: by 2002:a65:518d:: with SMTP id h13mr9551508pgq.22.1561733184881;
        Fri, 28 Jun 2019 07:46:24 -0700 (PDT)
Date: Fri, 28 Jun 2019 07:46:23 -0700
From: Kees Cook <keescook@chromium.org>
To: Nitin Gote <nitin.r.gote@intel.com>
Cc: jannh@google.com, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] checkpatch: Added warnings in favor of strscpy().
Message-ID: <201906280739.9CD1E4B@keescook>
References: <1561722948-28289-1-git-send-email-nitin.r.gote@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561722948-28289-1-git-send-email-nitin.r.gote@intel.com>

On Fri, Jun 28, 2019 at 05:25:48PM +0530, Nitin Gote wrote:
> Added warnings in checkpatch.pl script to :
> 
> 1. Deprecate strcpy() in favor of strscpy().
> 2. Deprecate strlcpy() in favor of strscpy().
> 3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().
> 
> Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>

Excellent, yes. Can you also add a bit to the strncpy() section in
Documentation/process/deprecated.rst so that all three cases of strncpy()
are explained:

- strncpy() into NUL-terminated target should use strscpy()
- strncpy() into NUL-terminated target needing trailing NUL: strscpy_pad()
- strncpy() into non-NUL-terminated target should have target marked
  with __nonstring.

(and probably mention the __nonstring case in checkpatch too)

-Kees

> ---
>  scripts/checkpatch.pl | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 342c7c7..bb0fa11 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -595,6 +595,9 @@ our %deprecated_apis = (
>  	"rcu_barrier_sched"			=> "rcu_barrier",
>  	"get_state_synchronize_sched"		=> "get_state_synchronize_rcu",
>  	"cond_synchronize_sched"		=> "cond_synchronize_rcu",
> +	"strcpy"				=> "strscpy",
> +	"strlcpy"				=> "strscpy",
> +	"strncpy"				=> "strscpy or strscpy_pad",
>  );
> 
>  #Create a search pattern for all these strings to speed up a loop below
> --
> 2.7.4
> 

-- 
Kees Cook
