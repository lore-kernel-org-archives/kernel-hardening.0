Return-Path: <SRS0=tP8a=74=lists.openwall.com=kernel-hardening-return-18975-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FEDCC433E0
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jun 2020 09:35:33 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 047532065F
	for <kernel-hardening@archiver.kernel.org>; Mon, 15 Jun 2020 09:35:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 047532065F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18975-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 27849 invoked by uid 550); 15 Jun 2020 09:35:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17994 invoked from network); 15 Jun 2020 08:26:47 -0000
Subject: Re: [f2fs-dev] [PATCH] f2fs: Eliminate usage of uninitialized_var()
 macro
To: Jason Yan <yanaijie@huawei.com>, <jaegeuk@kernel.org>, <chao@kernel.org>,
	<linux-f2fs-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
CC: Kees Cook <keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
References: <20200615040212.3681503-1-yanaijie@huawei.com>
From: Chao Yu <yuchao0@huawei.com>
Message-ID: <d1562b04-125f-c112-7272-d99ed1e38549@huawei.com>
Date: Mon, 15 Jun 2020 16:26:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20200615040212.3681503-1-yanaijie@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.134.22.195]
X-CFilter-Loop: Reflected

On 2020/6/15 12:02, Jason Yan wrote:
> This is an effort to eliminate the uninitialized_var() macro[1].
> 
> The use of this macro is the wrong solution because it forces off ANY
> analysis by the compiler for a given variable. It even masks "unused
> variable" warnings.
> 
> Quoted from Linus[2]:
> 
> "It's a horrible thing to use, in that it adds extra cruft to the
> source code, and then shuts up a compiler warning (even the _reliable_
> warnings from gcc)."
> 
> The gcc option "-Wmaybe-uninitialized" has been disabled and this change
> will not produce any warnnings even with "make W=1".
> 
> [1] https://github.com/KSPP/linux/issues/81
> [2] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
> 
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>  fs/f2fs/data.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 326c63879ddc..e6ec61274d76 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -2856,7 +2856,7 @@ static int f2fs_write_cache_pages(struct address_space *mapping,
>  	};
>  #endif
>  	int nr_pages;
> -	pgoff_t uninitialized_var(writeback_index);
> +	pgoff_t writeback_index;

I suggest to delete this variable directly, as we did for mm in
commit 28659cc8cc87 (mm/page-writeback.c: remove unused variable).

Thanks,

>  	pgoff_t index;
>  	pgoff_t end;		/* Inclusive */
>  	pgoff_t done_index;
> 
