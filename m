Return-Path: <SRS0=a0dU=4T=lists.openwall.com=kernel-hardening-return-18041-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66DF8C3F2D7
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Mar 2020 19:08:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B990920842
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Mar 2020 19:08:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="jGUWW+rr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B990920842
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18041-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15675 invoked by uid 550); 2 Mar 2020 19:08:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15654 invoked from network); 2 Mar 2020 19:08:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XbS5Oui71TzDSP82zad1HNkPWeQrHZfwLOAk3ttkqPM=;
        b=jGUWW+rrTuCc++AiLH0Jj9vkPATEZ//4C63+YRSjlqzn0c9jqq4hDPQi9tXbitIv1u
         VqLGvPBomCXeewRdCAdzEyMMfvVOASIDci+cn6Mwmiy7QcN2kn9HshsT7n6CqANjidbX
         SjMtuzQjlBNN7ykH6uerE16g6C1o2QAx56ymw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XbS5Oui71TzDSP82zad1HNkPWeQrHZfwLOAk3ttkqPM=;
        b=ohLvlfGWpUeHrbAJQoL6pbrkhsjy4z8BYADKDX+2tbekHRreIY/BHz7CfbhrqUwXfR
         MYk+TFq/pV1+AnIxKmLw+gYgMGBTy8HUM3mwAE3Bw3fLIYNlSoF/KFwOkRl15R6LlOXp
         TfekT5HEa0PdlAXX34VIbq2GPsBN0w/dT6wuLnFVLHwS4HnmrPK8e/w6UaIwBQ2NXKkm
         048F1GW9/lAeseLN5+Kj5Oqf3SyGeW8WnKYghkmv82cLS1ItHXlUebcmNtVS+jKU+eaa
         A77vN1WJiBOJYASCaPwrH3dMlopiTBotynUfwylpb7ntQCFIULU31ATi/No8i+XalMBV
         y2gw==
X-Gm-Message-State: ANhLgQ0j7FLQkPP0rUSkiDxHmKrZrE1p4x22ETIRDQ9AjDxo66FriYe0
	SnfqbUXZ9klSN1VwqbqBZ1xVjQ==
X-Google-Smtp-Source: ADFU+vs45YCE/A4RV+RfdPn7aH+3QF9x3z2I7E6FgPpDlVlxqDee5DDZoCBVOcK9O/y13IEDwk7Adg==
X-Received: by 2002:a17:902:b7c2:: with SMTP id v2mr572385plz.54.1583176084467;
        Mon, 02 Mar 2020 11:08:04 -0800 (PST)
Date: Mon, 2 Mar 2020 11:08:02 -0800
From: Kees Cook <keescook@chromium.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: Jann Horn <jannh@google.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [RFC PATCH 09/11] kallsyms: hide layout and expose seed
Message-ID: <202003021107.38017F90@keescook>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-10-kristen@linux.intel.com>
 <202002060428.08B14F1@keescook>
 <a915e1eb131551aa766fde4c14de5a3e825af667.camel@linux.intel.com>
 <CAG48ez2SucOZORUhHNxt-9juzqcWjTZRD9E_PhP51LpH1UqeLg@mail.gmail.com>
 <41d7049cb704007b3cd30a3f48198eebb8a31783.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41d7049cb704007b3cd30a3f48198eebb8a31783.camel@linux.intel.com>

On Mon, Mar 02, 2020 at 11:01:56AM -0800, Kristen Carlson Accardi wrote:
> On Thu, 2020-02-06 at 20:27 +0100, Jann Horn wrote:
> > https://codesearch.debian.net/search?q=%2Fproc%2Fkallsyms&literal=1
> 
> I looked through some of these packages as Jann suggested, and it seems
> like there are several that are using /proc/kallsyms to look for
> specific symbol names to determine whether some feature has been
> compiled into the kernel. This practice seems dubious to me, knowing
> that many kernel symbol names can be changed at any time, but
> regardless seems to be fairly common.

Cool, so a sorted censored list is fine for non-root. Would root users
break on a symbol-name-sorted view? (i.e. are two lists needed or can we
stick to one?)

-- 
Kees Cook
