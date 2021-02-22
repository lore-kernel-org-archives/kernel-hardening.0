Return-Path: <SRS0=BT0E=HY=lists.openwall.com=kernel-hardening-return-20804-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE9AC433DB
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 17:23:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2D49E64DE9
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Feb 2021 17:23:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D49E64DE9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20804-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5246 invoked by uid 550); 22 Feb 2021 17:21:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16347 invoked from network); 22 Feb 2021 16:00:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YGAvnzMESkS+Z4+Pab/L4bQLX/w0TQcH3GRn/tc/Ao8=;
        b=t6+RmEOe0FcHDkuCBmi1GLuVNYPmR6YSKQpFB7gaqGDpIt+gI81BaiC1rEbKb7eJ7x
         P84arTt3qW03ijOGcDQBeGh0uLgioBOz4UUkB4ENP3bSIgUmw2QTuWkKFOttZTjlycPo
         ySQdI4AexC7BbWqmNr3tvSRVFhU9kxndhD5nwtpyDfjkkUL+t0V8LrGXHeReTbMdGkpo
         cm9ODgV91GVJ4f8dVCQ9gu2yHvl2nDS9cwVALhWn4xnf0yyRFAiYPkp2tUD8DmRQZ1RB
         2BteB6apH/4nk31r+ALfnyRphPPrg3z/BxEVf7AryNmPApcCaNYS3xZuJ1Yr3DQbZ8mi
         ALtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YGAvnzMESkS+Z4+Pab/L4bQLX/w0TQcH3GRn/tc/Ao8=;
        b=CFFWXGDd+AOLzJs0p1Z4LkeLR8H694wInjkF9aX7OlBcHXtZRzanVcqWI8D1cYEUZ2
         FfUvs1P18F9BuIEC8F+NOjjZXeDkDwESWwCtCWql0IKlfxEtPyUqKVQaWX4tYHRuSXwE
         lvYIF/KuaYcY7M5CkXyi7gIbWxmoq+xfh3nuGj91esh8FyhkQokC7qM0LNVXDCSgbcuh
         4MzMD+MA956lpIg0iHdqw55axHBEx4cJtqZaohazA0WAdIegiC/uuoxjsyI72fKJ7Fok
         IK+Ft18IxTIHoc4gyZoonQdskSYJmd9zVPH7nEOjjlY2+nGL1xfeMt8TvHz1Xen5pg3b
         5fNQ==
X-Gm-Message-State: AOAM532fiJ6GuyKQ82WyOhK9yofRL0s5moVToLgXUpUbaCsDRWjLUFP7
	XEjSY4JB9DybV1tDWYl/IgE=
X-Google-Smtp-Source: ABdhPJxz/wKuipbNFDoAiObiR8UrkysgBqsDub+EMSZUbWYn40+Og5eya8/Tr+lBWKfgZ2ySb0qY+w==
X-Received: by 2002:aa7:dac7:: with SMTP id x7mr6672502eds.44.1614009631775;
        Mon, 22 Feb 2021 08:00:31 -0800 (PST)
Subject: Re: [PATCH 14/20] target: Manual replacement of the deprecated
 strlcpy() with return values
To: Romain Perier <romain.perier@gmail.com>, Kees Cook
 <keescook@chromium.org>, kernel-hardening@lists.openwall.com,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20210222151231.22572-1-romain.perier@gmail.com>
 <20210222151231.22572-15-romain.perier@gmail.com>
From: Bodo Stroesser <bostroesser@gmail.com>
Message-ID: <c296eb89-32e2-0866-34f1-0bdd00d80f82@gmail.com>
Date: Mon, 22 Feb 2021 17:00:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210222151231.22572-15-romain.perier@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 22.02.21 16:12, Romain Perier wrote:
> The strlcpy() reads the entire source buffer first, it is dangerous if
> the source buffer lenght is unbounded or possibility non NULL-terminated.
> It can lead to linear read overflows, crashes, etc...
> 
> As recommended in the deprecated interfaces [1], it should be replaced
> by strscpy.
> 
> This commit replaces all calls to strlcpy that handle the return values
> by the corresponding strscpy calls with new handling of the return
> values (as it is quite different between the two functions).
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> ---
>   drivers/target/target_core_configfs.c |   33 +++++++++------------------------
>   1 file changed, 9 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index f04352285155..676215cd8847 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -1325,16 +1325,11 @@ static ssize_t target_wwn_vendor_id_store(struct config_item *item,
>   	/* +2 to allow for a trailing (stripped) '\n' and null-terminator */
>   	unsigned char buf[INQUIRY_VENDOR_LEN + 2];
>   	char *stripped = NULL;
> -	size_t len;
> +	ssize_t len;
>   	ssize_t ret;
>   
> -	len = strlcpy(buf, page, sizeof(buf));
> -	if (len < sizeof(buf)) {
> -		/* Strip any newline added from userspace. */
> -		stripped = strstrip(buf);
> -		len = strlen(stripped);
> -	}
> -	if (len > INQUIRY_VENDOR_LEN) {
> +	len = strscpy(buf, page, sizeof(buf));
> +	if (len == -E2BIG) {
>   		pr_err("Emulated T10 Vendor Identification exceeds"
>   			" INQUIRY_VENDOR_LEN: " __stringify(INQUIRY_VENDOR_LEN)
>   			"\n");
> @@ -1381,16 +1376,11 @@ static ssize_t target_wwn_product_id_store(struct config_item *item,
>   	/* +2 to allow for a trailing (stripped) '\n' and null-terminator */
>   	unsigned char buf[INQUIRY_MODEL_LEN + 2];
>   	char *stripped = NULL;
> -	size_t len;
> +	ssize_t len;
>   	ssize_t ret;
>   
> -	len = strlcpy(buf, page, sizeof(buf));
> -	if (len < sizeof(buf)) {
> -		/* Strip any newline added from userspace. */
> -		stripped = strstrip(buf);
> -		len = strlen(stripped);
> -	}
> -	if (len > INQUIRY_MODEL_LEN) {
> +	len = strscpy(buf, page, sizeof(buf));
> +	if (len == -E2BIG) {
>   		pr_err("Emulated T10 Vendor exceeds INQUIRY_MODEL_LEN: "
>   			 __stringify(INQUIRY_MODEL_LEN)
>   			"\n");
> @@ -1437,16 +1427,11 @@ static ssize_t target_wwn_revision_store(struct config_item *item,
>   	/* +2 to allow for a trailing (stripped) '\n' and null-terminator */
>   	unsigned char buf[INQUIRY_REVISION_LEN + 2];
>   	char *stripped = NULL;
> -	size_t len;
> +	ssize_t len;
>   	ssize_t ret;
>   
> -	len = strlcpy(buf, page, sizeof(buf));
> -	if (len < sizeof(buf)) {
> -		/* Strip any newline added from userspace. */
> -		stripped = strstrip(buf);
> -		len = strlen(stripped);
> -	}
> -	if (len > INQUIRY_REVISION_LEN) {
> +	len = strscpy(buf, page, sizeof(buf));
> +	if (len == -E2BIG) {
>   		pr_err("Emulated T10 Revision exceeds INQUIRY_REVISION_LEN: "
>   			 __stringify(INQUIRY_REVISION_LEN)
>   			"\n");
> 

AFAICS, you are not only replacing strlcpy with strscpy, but also remove 
stripping of possible trailing '\n', and remove the necessary length
check of the remaining string.

-Bodo
