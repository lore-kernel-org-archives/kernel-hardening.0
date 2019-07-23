Return-Path: <SRS0=1abo=VU=lists.openwall.com=kernel-hardening-return-16562-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03067C76186
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 21:28:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 532FE218D4
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 21:28:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="SDygoRUs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 532FE218D4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16562-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20364 invoked by uid 550); 23 Jul 2019 21:28:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20326 invoked from network); 23 Jul 2019 21:28:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KE15xa18tTRocyVLkAyTsFK/CogeXePSTfih4gTWWqE=;
        b=SDygoRUsTxW6TTuRaBj1iYCmOY2pEXsrRSkgpjtWINcS2KHYINYnEh3sSHGXM/Z9Z0
         0UyPSL9FtaaX+eeg83GXipQUkmsgtEgfQewcrGVaqRRdVJdawtWqHD6+XrBoSfVPlUOT
         VyahDnFtfgqFF5DeeFH4Q+q4WnnGIpZ9zjvdM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KE15xa18tTRocyVLkAyTsFK/CogeXePSTfih4gTWWqE=;
        b=uH3fhnwjKlCHCivQkCzdMrhxIh4jeGUrE6RTJ4NUzPPxZG4pYvHGIQalJtrmZl3dDY
         Gfptb0GN0of4hUWG08EPwiIMEugU5QAFrcr4JV+eYsUctNhOoBCRsfEOsCE+xvdhb4i2
         8aGgX+8w0QGo/MI4RsiKtPni170AYVq1VFK8PwfnA4P4ti9upE+PK9coPP71v8y72rdv
         kxhKRhhd9jjWh5Ru1OdcyI3hLmXS7o4WPSljek/gve1Fd+Cleh7Jb3xK42ISD39xWI92
         NSo4AcOPBZi6ZjRYB1WT3pIRqCMcMnNuWjb+Nhw6LfMy5GAdmxxipi+FHZZTcHMfqirw
         tzQw==
X-Gm-Message-State: APjAAAUAxOY1zH5NwixGBUOnmPxUeh0xP7daqA4lIue28O3dxbovzB3A
	Yy7tLfdJ5H3gQ22uDp6NjfJr5Q==
X-Google-Smtp-Source: APXvYqz47GoGURJ0taiC0XhIJxWtE1YOy/l5OZWV402tGZ0JRjtYHPc39Jdba1gAyo/qTxfnfJeItA==
X-Received: by 2002:a17:90a:1a45:: with SMTP id 5mr85961043pjl.43.1563917297050;
        Tue, 23 Jul 2019 14:28:17 -0700 (PDT)
Date: Tue, 23 Jul 2019 14:28:15 -0700
From: Kees Cook <keescook@chromium.org>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Stephen Kitt <steve@sk2.org>, Nitin Gote <nitin.r.gote@intel.com>,
	jannh@google.com, kernel-hardening@lists.openwall.com,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/2] kernel-doc: core-api: Include string.h into core-api
Message-ID: <201907231428.6154FA6E04@keescook>
References: <cover.1563841972.git.joe@perches.com>
 <224a6ebf39955f4107c0c376d66155d970e46733.1563841972.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <224a6ebf39955f4107c0c376d66155d970e46733.1563841972.git.joe@perches.com>

On Mon, Jul 22, 2019 at 05:38:16PM -0700, Joe Perches wrote:
> core-api should show all the various string functions including the
> newly added stracpy and stracpy_pad.
> 
> Miscellanea:
> 
> o Update the Returns: value for strscpy
> o fix a defect with %NUL)
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  Documentation/core-api/kernel-api.rst |  3 +++
>  include/linux/string.h                |  5 +++--
>  lib/string.c                          | 10 ++++++----
>  3 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/core-api/kernel-api.rst b/Documentation/core-api/kernel-api.rst
> index 08af5caf036d..f77de49b1d51 100644
> --- a/Documentation/core-api/kernel-api.rst
> +++ b/Documentation/core-api/kernel-api.rst
> @@ -42,6 +42,9 @@ String Manipulation
>  .. kernel-doc:: lib/string.c
>     :export:
>  
> +.. kernel-doc:: include/linux/string.h
> +   :internal:
> +
>  .. kernel-doc:: mm/util.c
>     :functions: kstrdup kstrdup_const kstrndup kmemdup kmemdup_nul memdup_user
>                 vmemdup_user strndup_user memdup_user_nul
> diff --git a/include/linux/string.h b/include/linux/string.h
> index f80b0973f0e5..329188fffc11 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -515,8 +515,9 @@ static inline void memcpy_and_pad(void *dest, size_t dest_len,
>   * But this can lead to bugs due to typos, or if prefix is a pointer
>   * and not a constant. Instead use str_has_prefix().
>   *
> - * Returns: 0 if @str does not start with @prefix
> -         strlen(@prefix) if @str does start with @prefix
> + * Returns:
> + * * strlen(@prefix) if @str starts with @prefix
> + * * 0 if @str does not start with @prefix
>   */
>  static __always_inline size_t str_has_prefix(const char *str, const char *prefix)
>  {
> diff --git a/lib/string.c b/lib/string.c
> index 461fb620f85f..53582b6dce2a 100644
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -173,8 +173,9 @@ EXPORT_SYMBOL(strlcpy);
>   * doesn't unnecessarily force the tail of the destination buffer to be
>   * zeroed.  If zeroing is desired please use strscpy_pad().
>   *
> - * Return: The number of characters copied (not including the trailing
> - *         %NUL) or -E2BIG if the destination buffer wasn't big enough.
> + * Returns:
> + * * The number of characters copied (not including the trailing %NUL)
> + * * -E2BIG if count is 0.
>   */
>  ssize_t strscpy(char *dest, const char *src, size_t count)
>  {
> @@ -253,8 +254,9 @@ EXPORT_SYMBOL(strscpy);
>   * For full explanation of why you may want to consider using the
>   * 'strscpy' functions please see the function docstring for strscpy().
>   *
> - * Return: The number of characters copied (not including the trailing
> - *         %NUL) or -E2BIG if the destination buffer wasn't big enough.
> + * Returns:
> + * * The number of characters copied (not including the trailing %NUL)
> + * * -E2BIG if count is 0.
>   */
>  ssize_t strscpy_pad(char *dest, const char *src, size_t count)
>  {
> -- 
> 2.15.0
> 

-- 
Kees Cook
