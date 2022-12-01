Return-Path: <kernel-hardening-return-21592-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id B204CC4332F
	for <kernel-hardening@archiver.kernel.org>; Thu,  1 Dec 2022 23:22:02 +0000 (UTC)
Received: (qmail 15821 invoked by uid 550); 1 Dec 2022 23:21:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15775 invoked from network); 1 Dec 2022 23:21:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l8fV0JLFD2/Rj3gFozDpPt6akgqe3c/uNAz9i68e/Ns=;
        b=irGAoFAzu0KV2LWJLDt6khSgbUR9v1U0syF34+yTJCoS8bB/v3VBjQ4vn8GiJ/NImP
         SpQH4mGgKrrwElMOUJlTEvfsU+eqlA4zUXh0I2g6U3bmEpiqLQv77Bd0VkzpRdlzoydh
         xw9kHifI4gaIMAmxfe2lEWbQFhfZriZ0KgKRw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l8fV0JLFD2/Rj3gFozDpPt6akgqe3c/uNAz9i68e/Ns=;
        b=FooukmeKiXmTzqN7IMuLXd9jVoLVABw+QsYhUBGwZ0a5+hTbO5tVgkWb89ICha5Fwk
         /YQcydXXjhZTGKW85C4+ZbsIOZbhKNMhaAySzWtOHNYvN6+V4bbEm3lgHWy7tpdTthLQ
         1JULOWd2ts9zBVIXjOaqfg5++XENXFvDhLFuJjEGypoNtfLFXEC/IvH3sU30qQvPlPim
         Tf7fjCMn7ZcnhoLVIyiGfMYMPMXYrMwsztOT8LoWQ5Kcir+Nm72PZg1mWHT8iDV0RuxK
         mNg1yi0e/Je7SY81Zprur4vUSXcGxZPHOc0QYcv6+5WZ8bVDWZfKJrByhiVHZiGznttq
         jjDw==
X-Gm-Message-State: ANoB5pk6VYIL5AJMDNoWqfz0fu19wEeugv3iYSThjLHUQlY4vchhBzEz
	nLquVc7C6zAauCN7vbezjhhtlEhItOmfig==
X-Google-Smtp-Source: AA0mqf7Cx5IGen6d2/oau4vpJ7GD2N1BTLjfZZxHShOWSrBCuScbfeKEMudxRcgY1ZxyX9tKrwPFQg==
X-Received: by 2002:a17:902:e949:b0:189:7a15:1336 with SMTP id b9-20020a170902e94900b001897a151336mr28155708pll.122.1669936898649;
        Thu, 01 Dec 2022 15:21:38 -0800 (PST)
Date: Thu, 1 Dec 2022 15:21:37 -0800
From: Kees Cook <keescook@chromium.org>
To: Stefan Bavendiek <stefan.bavendiek@mailbox.org>
Cc: kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org
Subject: Re: Reducing runtime complexity
Message-ID: <202212011520.F7FE481@keescook>
References: <Y4kJ4Hw0DVfy7S37@mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4kJ4Hw0DVfy7S37@mailbox.org>

On Thu, Dec 01, 2022 at 09:09:04PM +0100, Stefan Bavendiek wrote:
> Some time ago I wrote a thesis about complexity in the Linux kernel and how to reduce it in order to limit the attack surface[1].
> While the results are unlikely to bring news to the audience here, it did indicate some possible ways to avoid exposing optional kernel features when they are not needed.
> The basic idea would be to either build or configure parts of the kernel after or during the installation on a specific host.
> 
> Distributions are commonly shipping the kernel as one large binary that includes support for nearly every hardware driver and optional feature, but the end user will normally use very little of this.
> In comparison, a custom kernel build for a particular device and use case, would be significantly smaller. While the reduced complexity won't be directly linked with reduction in attack surface, from my understanding the difference would make a relevant impact.
> 
> The question I keep wondering about is how feasible this is for general purpose distributions to have the kernel "rebuild" in this way when it is installed on a particular machine.

Much of the functionality is modules, so once a system is booted and
running the expected workloads, one can set the modules_disabled sysctl
and block everything else from being loaded.

-Kees

-- 
Kees Cook
