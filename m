Return-Path: <SRS0=VIrZ=IN=lists.openwall.com=kernel-hardening-return-20934-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF3FC433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Mar 2021 17:28:48 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BFB4C64E98
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Mar 2021 17:28:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFB4C64E98
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20934-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28399 invoked by uid 550); 15 Mar 2021 17:28:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28378 invoked from network); 15 Mar 2021 17:28:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5VwZiNoaOawmugGkW3BliGlJHY74MeBZt4r2sMGeVQQ=;
        b=l7HPfSehLhWpD22iEktgmCx0tfo9/0CXqzTE6AuX6c3/5225P6lXKuk1wJ6XO5mJGB
         j9LyL7+uH01vGynQcMUX/DSW3aPwjvKsnHDabzLeL8nPJ7VF7NQPm1XuwiOMzrWuKnoG
         LqkuIan1qCRQ55XWhGn9uzB0DXbKts3oUufc8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5VwZiNoaOawmugGkW3BliGlJHY74MeBZt4r2sMGeVQQ=;
        b=Aj4xnHfRL6eVhHiD9x7IXtbCsL8uxUKvdAjWlGm2xfnGaSQ01915vRoMKguhlnOmD4
         IuyyKdb8Hq3k/TXi/HktkSyVPX1I5Py3uhUGNe1r7PjIRdqcmVvCB25VYO176vL01dm+
         iL+8rNnZlL+DNPmDLpfmUpvKfyQ00wDSTBDqopUewPHIjAgBNyOHjWheyUqQ6QURmU4m
         JxDs4C5tvz4yY4D2wowfcXpm2ni9FvE/b4eIQwSSENOejEzSn16hlzRve2BEgnc3wpqz
         O9KDbZ6SbnaMWBVCZQtXGf6KbzH5CTtIFyIV9JNaeSk8Qxs9F1+J1yOHrIoMMd50+IML
         seAQ==
X-Gm-Message-State: AOAM533Y2HjjdDrFkLaAJH//4gEIlpPl8WyNsYbav98+s33Fl4dhFtVU
	GEmDApjivxjN0+eJUwhUe7jokw==
X-Google-Smtp-Source: ABdhPJxjnHWrPSehNTyXbsunhO6js/f/y7LcLoTrzXtGC7Of1Nx7WsQ3+07t7nraq6yi5lTJdFnVmQ==
X-Received: by 2002:a62:3847:0:b029:202:ad05:4476 with SMTP id f68-20020a6238470000b0290202ad054476mr10941066pfa.67.1615829305471;
        Mon, 15 Mar 2021 10:28:25 -0700 (PDT)
Date: Mon, 15 Mar 2021 10:28:23 -0700
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
	Elena Reshetova <elena.reshetova@intel.com>, x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Alexander Popov <alex.popov@linux.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>, kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@linux.ibm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v5 1/7] mm: Restore init_on_* static branch defaults
Message-ID: <202103151027.88B63D0@keescook>
References: <20210309214301.678739-1-keescook@chromium.org>
 <20210309214301.678739-2-keescook@chromium.org>
 <20210310155602.e005171dbecbc0be442f8aad@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310155602.e005171dbecbc0be442f8aad@linux-foundation.org>

On Wed, Mar 10, 2021 at 03:56:02PM -0800, Andrew Morton wrote:
> On Tue,  9 Mar 2021 13:42:55 -0800 Kees Cook <keescook@chromium.org> wrote:
> 
> > Choosing the initial state of static branches changes the assembly layout
> > (if the condition is expected to be likely, inline, or unlikely, out of
> > line via a jump). The _TRUE/_FALSE defines for CONFIG_INIT_ON_*_DEFAULT_ON
> > were accidentally removed. These need to stay so that the CONFIG controls
> > the pessimization of the resulting static branch NOP/JMP locations.
> 
> Changelog doesn't really explain why anyone would want to apply this
> patch.  This is especially important for -stable patches.
> 
> IOW, what is the user visible effect of the bug?

Yeah, that's a good point, and in writing more details I decided this
wasn't actually worth a stable patch, and should just get folded into
later patches.

Thanks for the sanity-check!

-- 
Kees Cook
