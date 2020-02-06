Return-Path: <SRS0=JzmC=32=lists.openwall.com=kernel-hardening-return-17705-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05555C2D0B1
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 12:40:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5463520661
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 12:40:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="TQ3RFnoZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5463520661
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17705-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3211 invoked by uid 550); 6 Feb 2020 12:39:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3188 invoked from network); 6 Feb 2020 12:39:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6jPO1T6lQYmXuz/rFgYHrB+x12nlG09wpWY9E0p2rSA=;
        b=TQ3RFnoZKH3ZBv79/bbk5oudQBaraIuvDJKWhIJyFoOHL7MyM3+HGsuy+LmNLyqiA2
         ztAbkuqDdXJjGOIIhGdS3NZksNBPvIxNlp5MK6aPSl+kIA5KyURvm8VAKmNwOAF++5bt
         XLVcwDF+XfS+7sNSFhRkuPEpYItkmNHN3UQrc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6jPO1T6lQYmXuz/rFgYHrB+x12nlG09wpWY9E0p2rSA=;
        b=ELMDRNc5aEL0BCnkUMc3DgVomn/VxxrBOrMd65dSG/VEpQAvYRxKmtPq86u7VLyvkm
         tfJQalOL7ld8jqKPJLTXs2Xt2+Ltt0FG0vW/O+6TZ4Cx0YvOWrTi9u7rSiD3gaa8hjE8
         nFhldBFtRwlM/NiUICa4OUIF/GPEx3tEOwIqHETdeJUW8rOsvRWg8DoWPePS915G3wVi
         X35pwTIes1mv6fSB81bnYOopCqT7FHVGgcxMKS4J4XVR7e+TSv0RPUe/gLLt03yfAwmv
         HHwHfEX4EIWIArQUTgMDKfFUHQqi/ihbJNi6rqoMHU2wozETy4BY/2WkSW9nvwWNc+Qr
         H4Ug==
X-Gm-Message-State: APjAAAWr2zq3PAH/nwKWHz6pc0YkRmxKB0QTPStYbebzcyhhi45m6ubw
	srz6JuIc/KStbxdyN8fW0lKGAg==
X-Google-Smtp-Source: APXvYqyYBNyrz5dJrLJgiE7fGukQlyrxAicKgMaKFnp3VSjEQvph59mI9TJQKtb23axx9NlPf3j0EA==
X-Received: by 2002:aca:3857:: with SMTP id f84mr6389157oia.150.1580992785571;
        Thu, 06 Feb 2020 04:39:45 -0800 (PST)
Date: Thu, 6 Feb 2020 04:39:43 -0800
From: Kees Cook <keescook@chromium.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 02/11] x86: tools/relocs: Support >64K section headers
Message-ID: <202002060438.D30727DA@keescook>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-3-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205223950.1212394-3-kristen@linux.intel.com>

On Wed, Feb 05, 2020 at 02:39:41PM -0800, Kristen Carlson Accardi wrote:
> While it is already supported to find the total number of section
> headers if we exceed 64K sections, we need to support the
> extended symbol table to get section header indexes for symbols
> when there are > 64K sections. Parse the elf file to read
> the extended symbol table info, and then replace all direct references
> to st_shndx with calls to sym_index(), which will determine whether
> we can read the value directly or whether we need to pull it out of
> the extended table.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>

Looks good to me.

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

-- 
Kees Cook
