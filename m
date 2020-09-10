Return-Path: <SRS0=rmEJ=CT=lists.openwall.com=kernel-hardening-return-19876-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 765DFC433E2
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 23:58:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ADA192065E
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Sep 2020 23:58:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="gfDQq0ZQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADA192065E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19876-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13405 invoked by uid 550); 10 Sep 2020 23:58:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13385 invoked from network); 10 Sep 2020 23:58:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TiD2LqrFMgU68bxi0s2xnUciJbQ2K0M9nK4+d+t39K8=;
        b=gfDQq0ZQqLUJ2DXD4GeetN5kOqP51hwBhKIkS41DxfjESdBN19BG5x+kfviKP/yh9X
         NBzaEVawSvptQ7Q4030RuEKgEvrEhYDi7bTC89bB7xG03X9rvK14W6PkRUtnT9UOr0Zn
         w2FsE0kcZLviYstxkTuTgVRezP064DYBbisLc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TiD2LqrFMgU68bxi0s2xnUciJbQ2K0M9nK4+d+t39K8=;
        b=gcIVZq5OnTTqgtKAGQH+7ET4yukZ3Moh47Pfmy5ZqKKkOdzLHVafAbM7z0l2Gz1IEi
         rXNwPvl/4PissC1aMCkq2dHDQ3lHEWRnCL92J51rxh2ecC02wDjEaTVkAyuKudFaAkwb
         R9mZU0YDmrmT1GzlwFF6NrFahABIe1d2dD85J0RnFlA4YvqMAfcPlbenfwTLT/65dLlB
         K5iX+8nUV6F2hmPhLJhKXQaUmyNTafieDj8/4uI/eh4eNCGBIoMO5l5137K+HkSckNPc
         EMlh9zMtr1colpoGQer1LtoIqlcb7e+KZ7V5DsH4BhfHakA3RgrHEV3ZHGj3zbSClzSr
         2K4g==
X-Gm-Message-State: AOAM5337Z1DDeMOsK8kgi/9xTd/ld2vTz1jy9Mr2WHzXljxQ/su2Cv4S
	7zruOB8IIk9ruITcleoxycP/VQ==
X-Google-Smtp-Source: ABdhPJx7/8vv2eB24dRiaLxWkU+dxFBXMvFoW+hNl5OQ5bHZLnmTBQqdIzH3CPNupiTU/enKTlQaQg==
X-Received: by 2002:a17:902:b216:: with SMTP id t22mr8241168plr.35.1599782311659;
        Thu, 10 Sep 2020 16:58:31 -0700 (PDT)
Date: Thu, 10 Sep 2020 16:58:29 -0700
From: Kees Cook <keescook@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: John Wood <john.wood@gmx.com>, Matthew Wilcox <willy@infradead.org>,
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
	Iurii Zaikin <yzaikin@google.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: Re: [RESEND][RFC PATCH 0/6] Fork brute force attack mitigation
 (fbfam)
Message-ID: <202009101656.FB68C6A@keescook>
References: <20200910202107.3799376-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910202107.3799376-1-keescook@chromium.org>

On Thu, Sep 10, 2020 at 01:21:01PM -0700, Kees Cook wrote:
> From: John Wood <john.wood@gmx.com>
> 
> The goal of this patch serie is to detect and mitigate a fork brute force
> attack.

Thanks for this RFC! I'm excited to get this problem finally handled in
the kernel. Hopefully the feedback is useful. :)

-- 
Kees Cook
