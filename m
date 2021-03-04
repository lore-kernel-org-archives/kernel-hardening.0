Return-Path: <SRS0=KtzW=IC=lists.openwall.com=kernel-hardening-return-20872-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E68D6C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Mar 2021 04:37:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9AD0164EF6
	for <kernel-hardening@archiver.kernel.org>; Thu,  4 Mar 2021 04:37:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9AD0164EF6
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20872-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1301 invoked by uid 550); 4 Mar 2021 04:37:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1269 invoked from network); 4 Mar 2021 04:37:29 -0000
Date: Thu, 4 Mar 2021 15:37:11 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Romain Perier <romain.perier@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/20] crypto: Manual replacement of the deprecated
 strlcpy() with return values
Message-ID: <20210304043711.GA25928@gondor.apana.org.au>
References: <20210222151231.22572-1-romain.perier@gmail.com>
 <20210222151231.22572-3-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222151231.22572-3-romain.perier@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Feb 22, 2021 at 04:12:13PM +0100, Romain Perier wrote:
>
> diff --git a/crypto/lrw.c b/crypto/lrw.c
> index bcf09fbc750a..4d35f4439012 100644
> --- a/crypto/lrw.c
> +++ b/crypto/lrw.c
> @@ -357,10 +357,10 @@ static int lrw_create(struct crypto_template *tmpl, struct rtattr **tb)
>  	 * cipher name.
>  	 */
>  	if (!strncmp(cipher_name, "ecb(", 4)) {
> -		unsigned len;
> +		ssize_t len;
>  
> -		len = strlcpy(ecb_name, cipher_name + 4, sizeof(ecb_name));
> -		if (len < 2 || len >= sizeof(ecb_name))
> +		len = strscpy(ecb_name, cipher_name + 4, sizeof(ecb_name));
> +		if (len == -E2BIG || len < 2)

len == -E2BIG is superfluous as len < 2 will catch it anyway.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
