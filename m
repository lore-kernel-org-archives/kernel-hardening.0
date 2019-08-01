Return-Path: <SRS0=a/Q9=V5=lists.openwall.com=kernel-hardening-return-16684-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B2CC19759
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Aug 2019 13:42:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2558420838
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Aug 2019 13:42:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mAsxTZht"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2558420838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16684-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27771 invoked by uid 550); 1 Aug 2019 13:42:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 27738 invoked from network); 1 Aug 2019 13:42:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=e6SUu+1rvN5NRaEyrhAZRkSrDdvDH6KraBIZ1o6M+y4=;
        b=mAsxTZhtB+USQ2Ez9xEc3x9IB+7NKzCQ0wmUfrBoEVJAW7BDjWvqRdpEs1cumaIi79
         /oa5PVMlYxeA1xzg+ZLMTkckyChE+hoCFWpibwHS4UiKMaK2serQLY+jQt/XNFF7FnCe
         g8TAXHr1k4TGv7Dx32ZFJbA+gzrnQK06gwV4hmMG4bOS3km0JZmUxd/QWEZr/3ZZuBon
         oAw1t/rNPrf6xyQ/XruTB1PrMg21C8s4LOGp91XDYOW3gvPPCJnXqZCwyZTUz3uV6wOd
         5mkEL+r6C20JAay2Kw5hlkLcFvO51KptZ9WyYnT7jTcfZf3SVzjax7VxW2VMMj/E6KAu
         UXlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=e6SUu+1rvN5NRaEyrhAZRkSrDdvDH6KraBIZ1o6M+y4=;
        b=F/hqydB5NutRxv1FKzIZz5mQ48Ii1fbfrMKSbtXXS9lhcKXiTMqsq3kO5IJSRqsBzu
         bB2WHLDQN1npmwjQKxvvS4GEIVnFHI88DtIKpCYPLD9DBTFWtNGc2FZdAaaz86rC6I6Q
         WaMjwbzQV6wi3UobWjtU9+rprRiAfR2IrTNlt/v/hYcCncPzBi6izZufjaxVVfIKeU35
         InzRGTWZxdlJYaYUKWrGXAjAnIH0ipfWoSWPU/9cb26T1DPHMqOUZv3/ew9kFixxSV6v
         BbOkT/JnAKlNf3OmVi72HA6EMKhPQu1AlfHCka2fXNIi1FhsnzMu5TgeiRVSlRdlkwaL
         7phQ==
X-Gm-Message-State: APjAAAUyIF8VOuRfppTvh8KE1ndtRy/W6pi31bP+NtZ0E0VVRjl6ypyO
	0iZBjTOPsW68Rsr6dPOUM4w=
X-Google-Smtp-Source: APXvYqwhPXJVg7ocTv8yFgwqNJVM+vY3pMPSSH6aXTdj0mq5HeKL7QVEMLAYnB/n2hYraWbdUdn2Vg==
X-Received: by 2002:a63:7205:: with SMTP id n5mr64492235pgc.443.1564666919432;
        Thu, 01 Aug 2019 06:41:59 -0700 (PDT)
Date: Thu, 1 Aug 2019 22:41:49 +0900
From: Joonwon Kang <kjw1627@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: re.emese@gmail.com, kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	jinb.park7@gmail.com
Subject: Re: [PATCH 2/2] randstruct: remove dead code in is_pure_ops_struct()
Message-ID: <20190801134149.GA2149@host>
References: <cover.1564595346.git.kjw1627@gmail.com>
 <281a65cc361512e3dc6c5deffa324f800eb907be.1564595346.git.kjw1627@gmail.com>
 <201907311259.D485EED2B7@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201907311259.D485EED2B7@keescook>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Wed, Jul 31, 2019 at 12:59:30PM -0700, Kees Cook wrote:
> On Thu, Aug 01, 2019 at 03:01:49AM +0900, Joonwon Kang wrote:
> > Recursive declaration for struct which has member of the same struct
> > type, for example,
> > 
> > struct foo {
> >     struct foo f;
> >     ...
> > };
> > 
> > is not allowed. So, it is unnecessary to check if a struct has this
> > kind of member.
> 
> Is that the only case where this loop could happen? Seems also safe to
> just leave it as-is...
> 
> -Kees

I think it is pretty obvious that it is the only case. I compiled kernel
with allyesconfig and the condition never hit even once. However, it will
also be no problem to just leave it as-is as you mentioned.

> 
> > 
> > Signed-off-by: Joonwon Kang <kjw1627@gmail.com>
> > ---
> >  scripts/gcc-plugins/randomize_layout_plugin.c | 3 ---
> >  1 file changed, 3 deletions(-)
> > 
> > diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
> > index bd29e4e7a524..e14efe23e645 100644
> > --- a/scripts/gcc-plugins/randomize_layout_plugin.c
> > +++ b/scripts/gcc-plugins/randomize_layout_plugin.c
> > @@ -440,9 +440,6 @@ static int is_pure_ops_struct(const_tree node)
> >  		const_tree fieldtype = get_field_type(field);
> >  		enum tree_code code = TREE_CODE(fieldtype);
> >  
> > -		if (node == fieldtype)
> > -			continue;
> > -
> >  		if (code == RECORD_TYPE || code == UNION_TYPE) {
> >  			if (!is_pure_ops_struct(fieldtype))
> >  				return 0;
> > -- 
> > 2.17.1
> > 
> 
> -- 
> Kees Cook
