Return-Path: <SRS0=DMkc=CV=lists.openwall.com=kernel-hardening-return-19886-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60ED3C43461
	for <kernel-hardening@archiver.kernel.org>; Sat, 12 Sep 2020 07:56:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 952A420796
	for <kernel-hardening@archiver.kernel.org>; Sat, 12 Sep 2020 07:56:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Q9kfaBgC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 952A420796
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19886-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7920 invoked by uid 550); 12 Sep 2020 07:56:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7900 invoked from network); 12 Sep 2020 07:56:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hkQEv8N2/w/dmNjYwzWRoPRR2BMD1Mf3MgOBCOD6/rw=;
        b=Q9kfaBgCkng9JivxtuhaKvmzjWwgFuCsu9/UAxcUobUAoj/9SPC7EtdbYOSRjTOJSc
         Fnr1MUOI8CX0s6DIV8FgquI2A4SjmZo40Wi1doqaY36HoTm2EikFQnPgjDOY0VzHymxD
         ZiEKD4FD9hAvoUJOm1e9BDVFp4AD63ZWGdalU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hkQEv8N2/w/dmNjYwzWRoPRR2BMD1Mf3MgOBCOD6/rw=;
        b=ZLeN0SrtlY4BGSa6L5T9jQqMaO6UtylgV8qECuwKKJLlLsdL5Pm6dx6zhJAqWTBE/L
         KqFrx2dyUddh3vO1vqDrDwgh4W1ik6nHX1kKwJK6Se6BzS5MwnLQRd/ton9oKRh5VKey
         yqFgQIg0DvXX95habJ2uEG4FdcEuzg46lkTI4ZZo4YvxvZ4T82v/WWos/LTQIVOwKZZT
         wI3J8oKqavtmteLpRViGI1L57n3Lh9WblYhops5GH81kdoJBnKQJtH7izzn588EDL3CN
         SPKRGKZOoAFdSZzyy62RitL/7XBCftgqLG/1oIU0gRrqUj2jop/y4o0yOu31++AD8PFc
         A5tg==
X-Gm-Message-State: AOAM5308OqJZmO1OfpcYTaIldOYjTyBclyXyzdMkWZ6C9OXJMNWrZHDL
	HzdzCE4trBEBbW2uEYPzwtLv2w==
X-Google-Smtp-Source: ABdhPJwQevL1YXacLJDW8V7rFiaRpiL0yftWZ/h48xy/1yQZi0+Jij9pWA3ZgVkjnFKvtTVUwsjfUQ==
X-Received: by 2002:a17:902:8c91:b029:d1:9be4:7fe6 with SMTP id t17-20020a1709028c91b02900d19be47fe6mr5905601plo.33.1599897380079;
        Sat, 12 Sep 2020 00:56:20 -0700 (PDT)
Date: Sat, 12 Sep 2020 00:56:18 -0700
From: Kees Cook <keescook@chromium.org>
To: James Morris <jmorris@namei.org>
Cc: kernel-hardening@lists.openwall.com, John Wood <john.wood@gmx.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Iurii Zaikin <yzaikin@google.com>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: Re: [RESEND][RFC PATCH 0/6] Fork brute force attack mitigation
 (fbfam)
Message-ID: <202009120055.F6BF704620@keescook>
References: <20200910202107.3799376-1-keescook@chromium.org>
 <alpine.LRH.2.21.2009121002100.17638@namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.2009121002100.17638@namei.org>

On Sat, Sep 12, 2020 at 10:03:23AM +1000, James Morris wrote:
> On Thu, 10 Sep 2020, Kees Cook wrote:
> 
> > [kees: re-sending this series on behalf of John Wood <john.wood@gmx.com>
> >  also visible at https://github.com/johwood/linux fbfam]
> > 
> > From: John Wood <john.wood@gmx.com>
> 
> Why are you resending this? The author of the code needs to be able to 
> send and receive emails directly as part of development and maintenance.

I wanted to flush it from my "review" TODO list, mainly.

-- 
Kees Cook
