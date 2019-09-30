Return-Path: <SRS0=HEkr=XZ=lists.openwall.com=kernel-hardening-return-16970-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16E63C32792
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Sep 2019 22:36:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5D08320842
	for <kernel-hardening@archiver.kernel.org>; Mon, 30 Sep 2019 22:36:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="lu0hCMnO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D08320842
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16970-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13728 invoked by uid 550); 30 Sep 2019 22:35:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13689 invoked from network); 30 Sep 2019 22:35:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PSE4WTNSFEvhafwJRvnkaGZ/e6dvvOFQu8CvYaW0xLU=;
        b=lu0hCMnOASpB5ZorpbPt9j1wtmLM2HxtaT+zDE2YS3CqLTWt++eeQS9kXfQPy3gbTg
         5NCdGFldDSa01GTj1juwRfsFoHygG/zMORAfNTdUjB6LVhulFr+udckPj6x3z/MIDi3x
         gmWfPB5cvSm3/FSHu75EcJ1bXVmsB9rexqDpE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PSE4WTNSFEvhafwJRvnkaGZ/e6dvvOFQu8CvYaW0xLU=;
        b=Na2/eOPRicJOzfYf6LKXvh1Lz20+5r8TmYkKgNkOdm2tm5wLHOneRWQbYWx30/1HDw
         /5hp6C2HneLs+zYl5ugELsnjE6j4x7ol/PvsZJdIZ+TauAIDnchx4Kl361wblW3rDBBL
         BlInA0NKj4wFiLw1KxGCMImfLxfHeQo3QRLxmmrs15jPudppe05A5y0bP+Z28kzsXwCt
         +HHWrUyXyQ1Eqfk78ypz3EqEHrTVGSWCMaOvHp0oaUJ9muV8mrqEJoWHS5OArIhWSGup
         s6FOotQrXXv/eXpTpDEIPkrRw9YGPVl/ypo3WaYj4k+ilocpOjZnBQccExA0/5IHFAxK
         2qvA==
X-Gm-Message-State: APjAAAX94ayL6nXc3z0BmDULCdUd//bYhk+cYpXpaCkejYduwQ2/50RF
	Vx29ODEUQxY1Gtlmkldwp7AXsw==
X-Google-Smtp-Source: APXvYqxnsQmSHv1sV32r9cj2tA+ON+/EE/CmFCbxZHipRqZY+88ycmEMUqMoSSLAFjMrorCAijEUpQ==
X-Received: by 2002:a17:902:bd43:: with SMTP id b3mr23013508plx.327.1569882944584;
        Mon, 30 Sep 2019 15:35:44 -0700 (PDT)
Date: Mon, 30 Sep 2019 15:35:42 -0700
From: Kees Cook <keescook@chromium.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: [PRE-REVIEW PATCH 02/16] crypto: ccp - Prepare to use the new
 tasklet API
Message-ID: <201909301535.60601A26@keescook>
References: <20190929163028.9665-1-romain.perier@gmail.com>
 <20190929163028.9665-3-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190929163028.9665-3-romain.perier@gmail.com>

On Sun, Sep 29, 2019 at 06:30:14PM +0200, Romain Perier wrote:
> Currently, the tasklet and its "tdata" has no relationship. The future
> tasklet API, will no longer allow to pass an arbitrary "unsigned long"
> data parameter. The tasklet data structure will need to be embedded into
> a data structure that will be retrieved from the tasklet handler (most
> of the time, it is the driver data structure). This commit prepares the
> driver to this change. For doing so, it embeds "tasklet" into "tdata".
> Then, "tdata" will be recoverable from its "tasklet" field, with the
> tasklet API.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> ---
>  drivers/crypto/ccp/ccp-dev.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
> index 73acf0fdb793..d0d180176f45 100644
> --- a/drivers/crypto/ccp/ccp-dev.c
> +++ b/drivers/crypto/ccp/ccp-dev.c
> @@ -44,6 +44,7 @@ MODULE_PARM_DESC(max_devs, "Maximum number of CCPs to enable (default: all; 0 di
>  struct ccp_tasklet_data {
>  	struct completion completion;
>  	struct ccp_cmd *cmd;
> +	struct tasklet_struct tasklet;
>  };
>  
>  /* Human-readable error strings */
> @@ -436,9 +437,8 @@ int ccp_cmd_queue_thread(void *data)
>  	struct ccp_cmd_queue *cmd_q = (struct ccp_cmd_queue *)data;
>  	struct ccp_cmd *cmd;
>  	struct ccp_tasklet_data tdata;
> -	struct tasklet_struct tasklet;
>  
> -	tasklet_init(&tasklet, ccp_do_cmd_complete, (unsigned long)&tdata);
> +	tasklet_init(&tdata.tasklet, ccp_do_cmd_complete, (unsigned long)&tdata);

Why not switch to tasklet_setup() here to avoid changing this again
later?

-Kees

>  
>  	set_current_state(TASK_INTERRUPTIBLE);
>  	while (!kthread_should_stop()) {
> @@ -458,7 +458,7 @@ int ccp_cmd_queue_thread(void *data)
>  		/* Schedule the completion callback */
>  		tdata.cmd = cmd;
>  		init_completion(&tdata.completion);
> -		tasklet_schedule(&tasklet);
> +		tasklet_schedule(&tdata.tasklet);
>  		wait_for_completion(&tdata.completion);
>  	}
>  
> -- 
> 2.23.0
> 

-- 
Kees Cook
