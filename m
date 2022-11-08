Return-Path: <kernel-hardening-return-21583-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id E564CC433FE
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Nov 2022 17:23:12 +0000 (UTC)
Received: (qmail 20038 invoked by uid 550); 8 Nov 2022 17:23:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20001 invoked from network); 8 Nov 2022 17:23:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lMk4PVCi8MpYMDkTe7xjdobh7931rVJKCrHxnRJEZ/s=;
        b=hH8t9+Espo0GrgedJ9kMDPtH/SwZJLvzS42Mpnzj25bSeGNKWC/KhRsX+Bk5RGBoYh
         GS89jcjEhdmZQCZmsXftPjQPRRk67Sp6/5ZHG3Enccq5LOmxhTx1Wil+jM384G6zHYUE
         HEAuY+LA8P/URl4U6jup79JIboPvC9ydZMpHg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lMk4PVCi8MpYMDkTe7xjdobh7931rVJKCrHxnRJEZ/s=;
        b=fYdKYBvdtjQV8jZzu97ViN+8M9uACDE+IukFTrfogBGbIBuI1Y4K+7n7QwzJy3Uumy
         QNx17pA5b/7imYHSLoQ6PlrwgcVRk8OMncbeRW/zOzqzLgnen6A5F8FZWnEyWAaBL7bW
         MtTsjC34v29SHsPaPZNapKOHLJzNs823ZK9GANUnFgJszaPvqhK929/R32nd5G00N+PX
         4sUSI5yCl2WtHr8Ye6q/0bITMNWnvqOz3wqulP860EdDDhhzO8MZ0S6vT7lfNOZ29Fjg
         7F+X+6mHmE8X3FjuYK649hghThyWz+18Xknna4SvUxDg5RUX/RqorQ4XZDxA5TpRC9th
         VGmA==
X-Gm-Message-State: ACrzQf31GTUpAi5EoiQS/iEwKJ0eyr7M3HpEGj3sAL5betWmfrA7wJ/V
	AH5q2PbeU6miTbu4acm8WrVd6w==
X-Google-Smtp-Source: AMsMyM4Ab4Kr0QUaf2x7BxJa/AITAVTNdya0GPA8aZCXQG+csEC+UsBcfir62wN3+d9ly4DUl+wEDQ==
X-Received: by 2002:a05:6a02:282:b0:439:7a97:ccd with SMTP id bk2-20020a056a02028200b004397a970ccdmr49560686pgb.297.1667928168583;
        Tue, 08 Nov 2022 09:22:48 -0800 (PST)
Date: Tue, 8 Nov 2022 09:22:47 -0800
From: Kees Cook <keescook@chromium.org>
To: Jann Horn <jannh@google.com>
Cc: linux-hardening@vger.kernel.org, kernel-hardening@lists.openwall.com,
	Greg KH <gregkh@linuxfoundation.org>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Seth Jenkins <sethjenkins@google.com>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Andy Lutomirski <luto@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] exit: Put an upper limit on how often we can oops
Message-ID: <202211080922.8B4A9A16AA@keescook>
References: <20221107201317.324457-1-jannh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107201317.324457-1-jannh@google.com>

On Mon, Nov 07, 2022 at 09:13:17PM +0100, Jann Horn wrote:
> @Kees should this go through your tree? (After waiting a while for
> the inevitable bikeshedding on whether the default limit should be closer
> to 10000 or 2^31.)

Sure, yeah. I can take it.

-- 
Kees Cook
