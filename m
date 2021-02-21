Return-Path: <SRS0=S/tx=HX=lists.openwall.com=kernel-hardening-return-20768-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC98FC433E0
	for <kernel-hardening@archiver.kernel.org>; Sun, 21 Feb 2021 23:38:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1F7B96148E
	for <kernel-hardening@archiver.kernel.org>; Sun, 21 Feb 2021 23:38:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F7B96148E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20768-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32232 invoked by uid 550); 21 Feb 2021 23:38:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32203 invoked from network); 21 Feb 2021 23:38:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ewxqEQFZCqRPZepFJZrArWqJzNzRyrMy8DlI7kZWdbY=;
        b=tBabDsQM88C48+TrDFasmGxRf9lo5KwLdwTxTlg6mOAIgYZzAu1QYqLxKOml6fQOpU
         sRCdc7uSzDIWN6ysldM0C5UOcR78C8eihFm52FXeZeU+HQ4csvIauJLeaLgfzaUJ8Qnr
         5JJNoaB/g4w2yfmgFyCLRE7Ps4aKp6JA1lhrUFiAc2A2JIjLe+3z1R0c/lJrPe9Ll3N/
         J2mJXNLavJiiqF/v9E+t0MVLpwv3xigXA33nIZlLGhFCGxR2J11FiNfdpT0diMrfrxQE
         imsmjKZfRkFo6vfVn41CuIorDhu+QEmQ3y9hFxktPLlCaY0wJ8AWWG96mxJpPBkj7MRL
         K8wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ewxqEQFZCqRPZepFJZrArWqJzNzRyrMy8DlI7kZWdbY=;
        b=t7/dPx1oNmoq46n0zlk1wsG0j5JrpZY4lSNtzvX122OLC1xvwYZDZDCdncVly9P6Kb
         IYDQod4JdBxMrJesyNAOkfjFg5w3ztpKOiT/Rmy/P8fzr+L0EqKZ/8XpqcW9PPY036IO
         /g2wvMOniT39Xntfs3hL0o6u827zEpoY+aYxvuQ20Au1AqI4cuo9mXcLYsjeNXA56L9+
         PvKO/TXyb1Ymj7PNGqjtiVXzLAJgJOehmZWUsvMYErqDOJSCuF6ZqEuOl9JhO0xsbkyp
         faGiyN+WvuxCL7ovUiHuus+mCkBzTofYjmgHOT+oeY4VmPLa5LrVh2DdmD+AWbHuVjvd
         O6qQ==
X-Gm-Message-State: AOAM5313r5dde4iU2nRzcfP2dB6ABJWshnsRldbw5niWxyh+Md3iVWsw
	sKa8uUiKTAA2XyB1teXlaiMzzw==
X-Google-Smtp-Source: ABdhPJzdBl7iEW57AktQz1trvZZaWXb2g0jBAcCa1BGnJzyovv2hB07dcYLx+z1UHy8R8jqqeRueQA==
X-Received: by 2002:a63:c042:: with SMTP id z2mr17881788pgi.201.1613950692408;
        Sun, 21 Feb 2021 15:38:12 -0800 (PST)
Subject: Re: [PATCH v6 3/7] Reimplement RLIMIT_NPROC on top of ucounts
To: Alexey Gladkov <gladkov.alexey@gmail.com>,
 LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Linux Containers <containers@lists.linux-foundation.org>, linux-mm@kvack.org
Cc: Alexey Gladkov <legion@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 "Eric W . Biederman" <ebiederm@xmission.com>, Jann Horn <jannh@google.com>,
 Kees Cook <keescook@chromium.org>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Oleg Nesterov <oleg@redhat.com>
References: <cover.1613392826.git.gladkov.alexey@gmail.com>
 <72fdcd154bec7e0dfad090f1af65ddac1e767451.1613392826.git.gladkov.alexey@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <72214339-57fc-e47f-bb57-d1b39c69e38e@kernel.dk>
Date: Sun, 21 Feb 2021 16:38:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <72fdcd154bec7e0dfad090f1af65ddac1e767451.1613392826.git.gladkov.alexey@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 2/15/21 5:41 AM, Alexey Gladkov wrote:
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index a564f36e260c..5b6940c90c61 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -1090,10 +1091,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
>  		wqe->node = alloc_node;
>  		wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
>  		atomic_set(&wqe->acct[IO_WQ_ACCT_BOUND].nr_running, 0);
> -		if (wq->user) {
> -			wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers =
> -					task_rlimit(current, RLIMIT_NPROC);
> -		}
> +		wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers = task_rlimit(current, RLIMIT_NPROC);

This doesn't look like an equivalent transformation. But that may be
moot if we merge the io_uring-worker.v3 series, as then you would not
have to touch io-wq at all.

-- 
Jens Axboe

