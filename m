Return-Path: <SRS0=nGEV=V4=lists.openwall.com=kernel-hardening-return-16681-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1D60C433FF
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Jul 2019 19:59:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 367F7214DA
	for <kernel-hardening@archiver.kernel.org>; Wed, 31 Jul 2019 19:59:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="lI/F+evG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 367F7214DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16681-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32284 invoked by uid 550); 31 Jul 2019 19:59:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32249 invoked from network); 31 Jul 2019 19:59:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wj8UI6KcdGWx7+DqBC4UilgyG1YpNkyj7/yhX7S5938=;
        b=lI/F+evGDUwaa/3jWG9s/L6Rki0XodRNIvovJ41k7O3gJBlhooGZWa8zk7zoZxPi3K
         2TLyWEVqGdpi3hnVGLBr1Oc4gUGjDuX/e0ynTnQkvdvYvby6ThNgqwr5+OlxOfckAHXE
         mdPb+Iuv8GNJU7luiqE0KFaafHR7acsFoLCvM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wj8UI6KcdGWx7+DqBC4UilgyG1YpNkyj7/yhX7S5938=;
        b=grNT2CqKddVtgRbxTFXqL3JrRzYFgIk7NrsnTYIRdeuKY6siaHIA6E2sKGoviD9iWN
         KWN9PFZCOlUamZcHT5XhkPhSbiSGO3EX/CNQF10CatpOp7XIa0zNKEaNsU7Wnk0CuvwL
         p6etHf4n28Wf5aqESJhDZ9aVtVCyDj3hWkeP/M20A/oeilU3/3r0x1HMECI2BCnZMy9K
         eJK4PKt/60CHggbg47DMsJPVc1PjUuPAJZR7i0v21IR1W00jrI8ydUq4N1lS0gTthzZA
         fW38/Z5/kU7QxJ/d2eq6QCTGKnfX9Oz7DlgWoaE1zW4KyvNseoEdgBWIB23hsV5t3zPx
         Fe3Q==
X-Gm-Message-State: APjAAAVO+s6dPCjy68Hf2+dLSxujLM22NvLwGjGtRDMN/qCizItSVUkg
	j5H2ML/UEZY4fJ5Et9xoRNXwHA==
X-Google-Smtp-Source: APXvYqyo7YtH0z/PjARx5H0oYP8eGymkvm90XLND0TLR+aFSRTYIsvGT3FPVBy4eGu5XU4G+pWeBtQ==
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr4440377pjb.138.1564603172224;
        Wed, 31 Jul 2019 12:59:32 -0700 (PDT)
Date: Wed, 31 Jul 2019 12:59:30 -0700
From: Kees Cook <keescook@chromium.org>
To: Joonwon Kang <kjw1627@gmail.com>
Cc: re.emese@gmail.com, kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	jinb.park7@gmail.com
Subject: Re: [PATCH 2/2] randstruct: remove dead code in is_pure_ops_struct()
Message-ID: <201907311259.D485EED2B7@keescook>
References: <cover.1564595346.git.kjw1627@gmail.com>
 <281a65cc361512e3dc6c5deffa324f800eb907be.1564595346.git.kjw1627@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <281a65cc361512e3dc6c5deffa324f800eb907be.1564595346.git.kjw1627@gmail.com>

On Thu, Aug 01, 2019 at 03:01:49AM +0900, Joonwon Kang wrote:
> Recursive declaration for struct which has member of the same struct
> type, for example,
> 
> struct foo {
>     struct foo f;
>     ...
> };
> 
> is not allowed. So, it is unnecessary to check if a struct has this
> kind of member.

Is that the only case where this loop could happen? Seems also safe to
just leave it as-is...

-Kees

> 
> Signed-off-by: Joonwon Kang <kjw1627@gmail.com>
> ---
>  scripts/gcc-plugins/randomize_layout_plugin.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
> index bd29e4e7a524..e14efe23e645 100644
> --- a/scripts/gcc-plugins/randomize_layout_plugin.c
> +++ b/scripts/gcc-plugins/randomize_layout_plugin.c
> @@ -440,9 +440,6 @@ static int is_pure_ops_struct(const_tree node)
>  		const_tree fieldtype = get_field_type(field);
>  		enum tree_code code = TREE_CODE(fieldtype);
>  
> -		if (node == fieldtype)
> -			continue;
> -
>  		if (code == RECORD_TYPE || code == UNION_TYPE) {
>  			if (!is_pure_ops_struct(fieldtype))
>  				return 0;
> -- 
> 2.17.1
> 

-- 
Kees Cook
