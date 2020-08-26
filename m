Return-Path: <SRS0=+d7C=CE=lists.openwall.com=kernel-hardening-return-19668-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D6DCC433E1
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Aug 2020 19:43:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 71FCC2076C
	for <kernel-hardening@archiver.kernel.org>; Wed, 26 Aug 2020 19:43:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="c0wPYmSc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 71FCC2076C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19668-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1052 invoked by uid 550); 26 Aug 2020 19:43:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1026 invoked from network); 26 Aug 2020 19:43:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sSiqGYhL6mx7GdlZDbkT4CADd/LuyDj2qvehSXEkfFs=;
        b=c0wPYmScaFMOZj7JWatRYkrF0jD6jFzMN0Md0N1TNOWQ9Ph4qv2dl5i7bl2XuK/2g8
         QKQ+2ztblAFVz0LXeFtgAblEZtefFyuhCfkrAiGsrXjmDzeryGjhlqYD71z0uo1vnxHD
         Gt8H/Qw2aAnM1D6yPctfoHqtXYkRpOmyeWoJQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sSiqGYhL6mx7GdlZDbkT4CADd/LuyDj2qvehSXEkfFs=;
        b=Q2OkaIuO4tr0SvCetR7L/+TqMvV1tlQePPwmnWNX7o8GgO8UcRG9eYinSndMN8uIwd
         8BU2VYX5xhIh4mBQCk/zE5liK1vSk2A5ieYPF2/g6DcQ8zXTY9w7wjBMkxjwXU7vcfTn
         Qt/XZuhgEmhb9+YRNY553pJFrtVr+K2ic7NCdddWqgij9Xoq2xXNRwkQ8leMA+CYEFgD
         wS5QiBFpgYJHw82lf3OObDblJegNgaeeyOhRA2rc4wSw3h6gx9PjBV3IzKTNPpiQDmOC
         0GyOdkAw1IVwK9oahVmRK/BBh8ERgCJz62qkBm1akCjTayq9LWnsfnJOLv6I+0fn1TUt
         GXDw==
X-Gm-Message-State: AOAM531g3OT8dcRhEaNv2EIBSCKoSBu9k99Yg3HSZIiUMcXb9WWSGqiZ
	uRXLNYu3wmNY8SAh8HBHUHLJoQ==
X-Google-Smtp-Source: ABdhPJyQnpR7N2xazFbp7J7MUFKkTkxsUr7ZQgxByGJ39DlvvIGGA/PzpplC4Eu0qakGcWY/M93Ulg==
X-Received: by 2002:a63:4450:: with SMTP id t16mr11747991pgk.3.1598470989316;
        Wed, 26 Aug 2020 12:43:09 -0700 (PDT)
Date: Wed, 26 Aug 2020 12:43:07 -0700
From: Kees Cook <keescook@chromium.org>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
	linux-fsdevel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Stefan Hajnoczi <stefanha@redhat.com>, linux-kernel@vger.kernel.org,
	Aleksa Sarai <asarai@suse.de>, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 1/3] io_uring: use an enumeration for
 io_uring_register(2) opcodes
Message-ID: <202008261241.074D8765@keescook>
References: <20200813153254.93731-1-sgarzare@redhat.com>
 <20200813153254.93731-2-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200813153254.93731-2-sgarzare@redhat.com>

On Thu, Aug 13, 2020 at 05:32:52PM +0200, Stefano Garzarella wrote:
> The enumeration allows us to keep track of the last
> io_uring_register(2) opcode available.
> 
> Behaviour and opcodes names don't change.
> 
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  include/uapi/linux/io_uring.h | 27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index d65fde732518..cdc98afbacc3 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -255,17 +255,22 @@ struct io_uring_params {
>  /*
>   * io_uring_register(2) opcodes and arguments
>   */
> -#define IORING_REGISTER_BUFFERS		0
> -#define IORING_UNREGISTER_BUFFERS	1
> -#define IORING_REGISTER_FILES		2
> -#define IORING_UNREGISTER_FILES		3
> -#define IORING_REGISTER_EVENTFD		4
> -#define IORING_UNREGISTER_EVENTFD	5
> -#define IORING_REGISTER_FILES_UPDATE	6
> -#define IORING_REGISTER_EVENTFD_ASYNC	7
> -#define IORING_REGISTER_PROBE		8
> -#define IORING_REGISTER_PERSONALITY	9
> -#define IORING_UNREGISTER_PERSONALITY	10
> +enum {
> +	IORING_REGISTER_BUFFERS,

Actually, one *tiny* thought. Since this is UAPI, do we want to be extra
careful here and explicitly assign values? We can't change the meaning
of a number (UAPI) but we can add new ones, etc? This would help if an
OP were removed (to stop from triggering a cascade of changed values)...

for example:

enum {
	IORING_REGISTER_BUFFERS = 0,
	IORING_UNREGISTER_BUFFERS = 1,
	...


-- 
Kees Cook
